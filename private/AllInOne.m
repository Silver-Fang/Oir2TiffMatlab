function Tags = AllInOne(Metadata,TiffPath,OirPath,Verbose)
ReaderSizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
OirReader=GetBfOirReader(OirPath);
WriterCIndex=0;
DeviceNames=Metadata.DeviceNames;
ImageLogical=~startsWith(DeviceNames,"CD");
TiffWriter=GetTiffSubWriter(OirReader,TiffPath,Cs=find(ImageLogical));
ReaderTDelta=SizeZ*ReaderSizeC;
WriterSizeC=sum(ImageLogical);
WriterTDelta=SizeZ*WriterSizeC;
TagPixelsNo=Metadata.SizeX*Metadata.SizeY*SizeZ;
for C=1:ReaderSizeC
	DN=DeviceNames(C);
	ReaderTIndex=C-1;
	if ImageLogical(C)
		WriterTIndex=WriterCIndex;
		for T=1:SizeT
			ReaderZIndex=ReaderTIndex;
			WriterZIndex=WriterTIndex;
			for Z=1:SizeZ
				TiffWriter.saveBytes(WriterZIndex,OirReader.openBytes(ReaderZIndex));
				ReaderZIndex=ReaderZIndex+ReaderSizeC;
				WriterZIndex=WriterZIndex+WriterSizeC;
			end
			ReaderTIndex=ReaderTIndex+ReaderTDelta;
			WriterTIndex=WriterTIndex+WriterTDelta;
		end
		WriterCIndex=WriterCIndex+1;
	else
		Tags.(DN)=CollectChannelTag(ReaderSizeC,SizeZ,SizeT,ReaderTIndex,ReaderTDelta,OirReader,TagPixelsNo);
	end
	if Verbose
		disp("通道"+DN+"("+string(C)+"/"+string(ReaderSizeC)+")已完成");
	end
end
OirReader.close;
TiffWriter.close;