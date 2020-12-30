function [TiffPaths,Tags]=ReadWriteOirSeries(OirPath,TagLogicals,MetaData,TiffPath,Compression,OneChannelOneFile,ValidChannels,TimeStart,TimeEnd)
arguments
	OirPath(1,1)string
	TagLogicals(:,1)logical
	MetaData(1,1)struct
	TiffPath(1,1)string
	Compression(1,1)double
	OneChannelOneFile(1,1)logical
	ValidChannels(:,1)double=NaN
	TimeStart(1,1)uint16=1
	TimeEnd(1,1)uint16=uint16.empty
end
SizeZ=MetaData.SizeZ;
DeviceNames=MetaData.DeviceNames;
SizeY=MetaData.SizeY;
SizeX=MetaData.SizeX;
SizeC=MetaData.SizeC;
TagStruct=struct("ImageWidth",double(SizeX),"ImageLength",double(SizeY),"Photometric",Tiff.Photometric.MinIsBlack,"Compression",Compression,"PlanarConfiguration",Tiff.PlanarConfiguration.Chunky,"BitsPerSample",16,"SamplesPerPixel",1);
TagChannels=DeviceNames(TagLogicals);
if isempty(TimeEnd)
	TimeEnd=MetaData.SizeT;
end
if isnan(ValidChannels)
	ValidChannels=1:SizeC;
end
NoTimes=TimeEnd-TimeStart+1;
NoTC=numel(TagChannels);
for a=1:NoTC
	Tags.(TagChannels(a))=zeros(NoTimes,1);
end
NontagLogicals=~TagLogicals;
TcProject=cumsum(NontagLogicals);
TiffPaths=TiffPath+".Z"+string(1:SizeZ)';
if OneChannelOneFile
	TiffPaths=TiffPaths+DeviceNames(NontagLogicals);
end
TiffClients=arrayfun(@(TiffPath)Tiff(TiffPath,"w8"),TiffPaths);
BfOirReader=GetBfOirReader(OirPath);
Image=zeros(SizeY*SizeX,SizeC,SizeZ,"uint16");
for a=1:NoTimes
	for b=1:SizeZ
		for c=1:SizeC
			Image(:,c,b)=typecast(BfOirReader.openBytes(BfOirReader.getIndex(b-1,ValidChannels(c)-1,a+TimeStart-2)),"uint16");
		end
	end
	if OneChannelOneFile
		for c=1:SizeC
			if TagLogicals(c)
				Tags.(DeviceNames(c))(a)=mean(Image(:,c,:),"all");
			else
				TcIndex=TcProject(c);
				for b=1:SizeZ
					TC=TiffClients(TcIndex,b);
					TC.setTag(TagStruct);
					TC.write(reshape(Image(:,c,b),SizeX,SizeY)');
					TC.writeDirectory;
				end
			end
		end
	else
		TagValue=mean(Image(:,TagLogicals,:),[1 3]);
		for b=1:NoTC
			Tags.(TagChannels(b))(a)=TagValue(b);
		end
		Image=Image(:,~TagLogicals,:);
		for b=1:SizeZ
			TC=TiffClients(b);
			TC.setTag(TagStruct);
			TC.write(permute(reshape(Image(:,:,b),SizeX,SizeY,SizeC),[2 1 3]));
			TC.writeDirectory;
		end
	end
end
if ~exist("Tags","var")
	Tags=struct([]);
end
arrayfun(@close,TiffClients);
BfOirReader.close;
end