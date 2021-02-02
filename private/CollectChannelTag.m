function Tag = CollectChannelTag(SizeC,SizeZ,SizeT,TIndex,TDelta,OirReader,TagPixelsNo)
Tag=zeros(SizeT,1);
for T=1:SizeT
	ReaderZIndex=TIndex;
	Sum=0;
	for Z=1:SizeZ
		Sum=Sum+sum(typecast(OirReader.openBytes(ReaderZIndex),"uint16"));
		ReaderZIndex=ReaderZIndex+SizeC;
	end
	Tag(T)=Sum/TagPixelsNo;
	TIndex=TIndex+TDelta;
end