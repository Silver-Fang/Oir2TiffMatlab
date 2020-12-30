function [TagLogicals,MetaData,ValidChannels] = OirReadHeader(OirHeaderPath,Cds2Tiff,CdsOnly)
persistent PossibleZStacks
if isempty(PossibleZStacks)
	PossibleZStacks=["StartEnd";"Range";"Piezo"];
end
MetaData=ReadOirImageProperties(OirHeaderPath);
OirReader=GetBfOirReader(OirHeaderPath);
MetaData.SizeX=OirReader.getSizeX;
MetaData.SizeY=OirReader.getSizeY;
MetaData.SizeZ=OirReader.getSizeZ;
MetaData.SizeT=OirReader.getSizeT;
DeviceNames=MetaData.DeviceNames;
CdLogicals=startsWith(DeviceNames,"CD");
if CdsOnly
	DeviceNames=DeviceNames(CdLogicals);
	MetaData.DeviceNames=DeviceNames;
	ValidChannels=find(CdLogicals);
	CdLogicals=CdLogicals(CdLogicals);
	MetaData.SizeC=length(ValidChannels);
else
	ValidChannels=(1:length(DeviceNames))';
	MetaData.SizeC=OirReader.getSizeC;
end
OirReader.close;
if Cds2Tiff
	TagLogicals=false(size(DeviceNames));
else
	TagLogicals=CdLogicals;
end
end