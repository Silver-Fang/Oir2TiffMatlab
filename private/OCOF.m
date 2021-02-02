function Output = OCOF(OirReader,C,Metadata,TiffPaths,Cds2Tiff,OneZOneFile)
SizeX=Metadata.SizeX;
SizeY=Metadata.SizeY;
SizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
TDelta=SizeC*SizeZ;
if Cds2Tiff||~startsWith(Metadata.DeviceNames(C),"CD")
	ZIndex=C-1;
	if OneZOneFile
		Output=TiffPaths+"."+Metadata.DeviceNames(C)+".Z"+string(1:SizeZ)+".tif";
		for Z=1:SizeZ
 			[TiffWriter,TagStruct]=GetTiffSubWriter(OirReader,Output(Z),Cs=C,Zs=Z);
			TIndex=ZIndex;
			FirstPlane=true;
			for T=1:SizeT
				if FirstPlane
					FirstPlane=false;
				else
					TiffWriter.setTag(TagStruct);
				end
				TiffWriter.write(reshape(typecast(OirReader.openBytes(TIndex),"uint16"),SizeX,SizeY)');
				TiffWriter.writeDirectory;
				TIndex=TIndex+TDelta;
			end
			ZIndex=ZIndex+SizeC;
			TiffWriter.close;
		end
	else
		Output=TiffPaths+"."+Metadata.DeviceNames(C)+".tif";
		[TiffWriter,TagStruct]=GetTiffSubWriter(OirReader,Output,Cs=C);
		FirstPlane=true;
		for T=1:SizeT
			for Z=1:SizeZ
				if FirstPlane
					FirstPlane=false;
				else
					TiffWriter.setTag(TagStruct);
				end
				TiffWriter.write(reshape(typecast(OirReader.openBytes(ZIndex),"uint16"),SizeX,SizeY)');
				TiffWriter.writeDirectory;
				ZIndex=ZIndex+SizeC;
			end
		end
		TiffWriter.close;
	end
else
	TagPixelsNo=SizeX*SizeY*SizeZ;
	Output=CollectChannelTag(SizeC,SizeZ,SizeT,C-1,TDelta,OirReader,TagPixelsNo);
end