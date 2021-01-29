function Output = OZOF(OirReader,Z,Metadata,TiffPaths,Cds2Tiff)
ReaderSizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
ReaderTDelta=ReaderSizeC*SizeZ;
if Z>0
	Output=TiffPaths+".Z"+string(Z)+".tif";
	if Cds2Tiff
		ReaderTIndex=(Z-1)*ReaderSizeC;
		WriterTIndex=0;
		TiffWriter=GetTiffSubWriter(OirReader,Output,Zs=Z);
		for T=1:SizeT
			ReaderCIndex=ReaderTIndex-1;
			WriterCIndex=WriterTIndex-1;
			for C=1:ReaderSizeC
				TiffWriter.saveBytes(WriterCIndex+C,OirReader.openBytes(ReaderCIndex+C));
			end
			ReaderTIndex=ReaderTIndex+ReaderTDelta;
			WriterTIndex=WriterTIndex+ReaderSizeC;
		end
		TiffWriter.close;
	else
		ImageLogical=~startsWith(Metadata.DeviceNames,"CD");
		WriterSizeC=sum(ImageLogical);
		TiffWriter=GetTiffSubWriter(OirReader,Output,Cs=find(ImageLogical),Zs=Z);
		ReaderCIndex=(Z-1)*ReaderSizeC-1;
		WriterCIndex=0;
		for C=1:ReaderSizeC
			ReaderTIndex=ReaderCIndex+C;
			if ImageLogical(C)
				WriterTIndex=WriterCIndex;
				for T=1:SizeT
					TiffWriter.saveBytes(WriterTIndex,OirReader.openBytes(ReaderTIndex));
					ReaderTIndex=ReaderTIndex+ReaderTDelta;
					WriterTIndex=WriterTIndex+WriterSizeC;
				end
				WriterCIndex=WriterCIndex+1;
			end
		end
		TiffWriter.close;
	end
else
	TagPixelsNo=Metadata.SizeX*Metadata.SizeY*SizeZ;
	DeviceNames=Metadata.DeviceNames;
	TagLogical=startsWith(DeviceNames,"CD");
	for C=1:ReaderSizeC
		if TagLogical(C)
			Output.(DeviceNames(C))=CollectChannelTag(ReaderSizeC,SizeZ,SizeT,C-1,ReaderTDelta,OirReader,TagPixelsNo);
		end
	end
end