function Tags = AllInOne(Metadata,TiffPath,OirPath,Verbose,Parallel,MapPath)
arguments
	Metadata(1,1)struct
	TiffPath(1,1)string
	OirPath(1,1)string
	Verbose(1,1)logical
	Parallel(1,1)logical
	MapPath(1,1)string=""
end
SizeX=Metadata.SizeX;
SizeY=Metadata.SizeY;
SizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
OirReader=GetBfOirReader(OirPath,MapPath);
DeviceNames=Metadata.DeviceNames;
TagLogical=startsWith(DeviceNames,"CD");
[TiffWriter,TagStruct]=GetTiffSubWriter(OirReader,TiffPath,Cs=find(~TagLogical));
TagPixelsNo=SizeX*SizeY*SizeZ;
ReaderIndex=0;
FirstPlane=true;
if Verbose
	NextVerbose=1;
	Suffix="/"+string(SizeT);
	Threshold=SizeT/2;
	Prefix=OirPath+"：";
end
TDelta=SizeC*SizeZ;
if Parallel
	for C=1:SizeC
		if TagLogical(C)
			if MapPath==""
				Tags.(DeviceNames(C))=parfeval(@CCTNewReader,1,SizeC,SizeZ,SizeT,C-1,TDelta,OirPath,TagPixelsNo);
			else
				Tags.(DeviceNames(C))=parfeval(@CCTNewReader,1,SizeC,SizeZ,SizeT,C-1,TDelta,MapPath,TagPixelsNo);
			end
		end
	end
else
	for C=1:SizeC
		if TagLogical(C)
			Tags.(DeviceNames(C))=CollectChannelTag(SizeC,SizeZ,SizeT,C-1,TDelta,OirReader,TagPixelsNo);
		end
	end
end
for T=1:SizeT
	for Z=1:SizeZ
		for C=1:SizeC
			if ~TagLogical(C)
				if FirstPlane
					FirstPlane=false;
				else
					TiffWriter.setTag(TagStruct);
				end
				TiffWriter.write(reshape(typecast(OirReader.openBytes(ReaderIndex),"uint16"),SizeX,SizeY)');
				TiffWriter.writeDirectory;
			end
			ReaderIndex=ReaderIndex+1;
		end
	end
	if Verbose&&T>=NextVerbose
		disp(Prefix+string(T)+Suffix);
		if T<Threshold
			NextVerbose=max(T+1,SizeT/(SizeT/T-1));
		else
			NextVerbose=max(T+1,SizeT-SizeT/(SizeT/(SizeT-T)+1));
		end
	end
end
OirReader.close;
TiffWriter.close;
if Parallel
	for C=1:SizeC
		if TagLogical(C)
			Tags.(DeviceNames(C))=fetchOutputs(Tags.(DeviceNames(C)));
		end
	end
end
if ~exist("Tags","var")
    Tag=struct([]);
end
end
function Tag=CCTNewReader(SizeC,SizeZ,SizeT,TIndex,TDelta,OirPath,TagPixelsNo)
OirReader=GetBfOirReader(OirPath);
	Tag = CollectChannelTag(SizeC,SizeZ,SizeT,TIndex,TDelta,OirReader,TagPixelsNo);
	OirReader.close;
end