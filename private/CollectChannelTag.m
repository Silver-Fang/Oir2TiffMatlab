function Tag = CollectChannelTag(ReaderSizeC,SizeZ,SizeT,ReaderTIndex,ReaderTDelta,OirReader,TagPixelsNo)
Tag=zeros(SizeT,1);
for T=1:SizeT
	ReaderZIndex=ReaderTIndex;
	Sum=0;
	for Z=1:SizeZ
		Sum=Sum+sum(typecast(OirReader.openBytes(ReaderZIndex),"uint16"));
		ReaderZIndex=ReaderZIndex+ReaderSizeC;
	end
	Tag(T)=Sum/TagPixelsNo;
	ReaderTIndex=ReaderTIndex+ReaderTDelta;
end