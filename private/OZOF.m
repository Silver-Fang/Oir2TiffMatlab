function Output = OZOF(OirReader,Z,Metadata,TiffPaths,Cds2Tiff)
SizeX=Metadata.SizeX;
SizeY=Metadata.SizeY;
SizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
TDelta=SizeC*SizeZ;
DeviceNames=Metadata.DeviceNames;
if Z>0
	FirstPlane=true;
	Output=TiffPaths+".Z"+string(Z)+".tif";
	ReaderTIndex=(Z-1)*SizeC;
	if Cds2Tiff
		ImageLogical=true(SizeC,1);
	else
		ImageLogical=~startsWith(DeviceNames,"CD");
	end
	[TiffWriter,TagStruct]=GetTiffSubWriter(OirReader,Output,Cs=find(ImageLogical),Zs=Z);
	for T=1:SizeT
		ReaderCIndex=ReaderTIndex-1;
		for C=1:SizeC
			if ImageLogical(C)
				if FirstPlane
					FirstPlane=false;
				else
					TiffWriter.setTag(TagStruct);
				end
				TiffWriter.write(reshape(typecast(OirReader.openBytes(ReaderCIndex+C),"uint16"),SizeX,SizeY)');
				TiffWriter.writeDirectory;
			end
		end
		ReaderTIndex=ReaderTIndex+TDelta;
	end
	TiffWriter.close;
else
	TagPixelsNo=SizeX*SizeY*SizeZ;
	TagLogical=startsWith(DeviceNames,"CD");
	for C=1:SizeC
		if TagLogical(C)
			Output.(DeviceNames(C))=CollectChannelTag(SizeC,SizeZ,SizeT,C-1,TDelta,OirReader,TagPixelsNo);
		end
	end
end