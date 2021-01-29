function Output = OCOF(OirReader,C,Metadata,TiffPaths,Cds2Tiff,OneZOneFile)
ReaderSizeC=Metadata.SizeC;
SizeZ=Metadata.SizeZ;
SizeT=Metadata.SizeT;
ReaderTDelta=ReaderSizeC*SizeZ;
if Cds2Tiff||~startsWith(Metadata.DeviceNames(C),"CD")
	if OneZOneFile
		Output=TiffPaths+"."+Metadata.DeviceNames(C)+".Z"+string(1:SizeZ)+".tif";
		ReaderZIndex=C-1;
% 		SizeX=Metadata.SizeX;
% 		SizeY=Metadata.SizeY;
		for Z=1:SizeZ
% 			TiffWriter=Tiff(Output(Z),"w");
% 			TagStruct=struct("ImageWidth",double(SizeX),"ImageLength",double(SizeY),"Photometric",Tiff.Photometric.MinIsBlack,"Compression",Tiff.Compression.None,"PlanarConfiguration",Tiff.PlanarConfiguration.Chunky,"BitsPerSample",16,"SamplesPerPixel",1);
 			TiffWriter=GetTiffSubWriter(OirReader,Output(Z),Cs=C,Zs=Z);
			ReaderTIndex=ReaderZIndex;
			for T=0:SizeT-1
% 				TiffWriter.setTag(TagStruct);
% 				TiffWriter.write(reshape(typecast(OirReader.openBytes(ReaderTIndex),"uint16"),SizeX,SizeY)');
% 				TiffWriter.writeDirectory;
				TiffWriter.saveBytes(T,OirReader.openBytes(ReaderTIndex));
				ReaderTIndex=ReaderTIndex+ReaderTDelta;
			end
			ReaderZIndex=ReaderZIndex+ReaderSizeC;
			TiffWriter.close;
		end
	else
		Output=TiffPaths+"."+Metadata.DeviceNames(C)+".tif";
		TiffWriter=GetTiffSubWriter(OirReader,Output,Cs=C);
		ReaderTIndex=C-1;
		WriterTIndex=0;
		for T=1:SizeT
			ReaderZIndex=ReaderTIndex;
			WriterZIndex=WriterTIndex-1;
			for Z=1:SizeZ
				TiffWriter.saveBytes(WriterZIndex+Z,OirReader.openBytes(ReaderZIndex));
				ReaderZIndex=ReaderZIndex+ReaderSizeC;
			end
			WriterTIndex=WriterTIndex+SizeZ;
			ReaderTIndex=ReaderTIndex+ReaderTDelta;
		end
		TiffWriter.close;
	end
else
	TagPixelsNo=Metadata.SizeX*Metadata.SizeY*SizeZ;
	Output=CollectChannelTag(ReaderSizeC,SizeZ,SizeT,C-1,ReaderTDelta,OirReader,TagPixelsNo);
end