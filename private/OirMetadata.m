function Metadata = OirMetadata(OirPath,MapPath)
arguments
	OirPath(1,1)string
	MapPath(1,1)string=""
end
persistent DocumentBuilder IpEt
if isempty(DocumentBuilder)
	DocumentBuilder=javax.xml.parsers.DocumentBuilderFactory.newInstance.newDocumentBuilder;
end
if isempty(IpEt)
	IpEt="</lsmimage:imageProperties>";
end
FileId=fopen(OirPath);
Buffer=fread(FileId,10^7,"uint8=>char")';
MetaStart=strfind(Buffer,"<lsmimage:imageProperties");
Buffer=Buffer(MetaStart(1):end);
MetaEnd=strfind(Buffer,IpEt);
fclose(FileId);
Dom=GetXmlDom(Buffer(1:MetaEnd(1)+strlength(IpEt)-1));
ScannerType=string(Dom.getElementsByTagName("lsmimage:scannerType").item(0).getTextContent);
Metadata.ScannerType=ScannerType;
ElementCollection=Dom.getElementsByTagName("commonparam:axis");
for a=0:ElementCollection.getLength-1
	CpAxis=ElementCollection.item(a);
	if string(CpAxis.getAttribute("enable"))=="true"&&string(CpAxis.getElementsByTagName("commonparam:axis").item(0).getTextContent)=="ZSTACK"&&string(CpAxis.getAttribute("paramEnable"))=="true"
		if string(CpAxis.getElementsByTagName("commonparam:axis").item(0).getTextContent)=="ZSTACK"&&string(CpAxis.getAttribute("paramEnable"))=="true"
			Metadata.ZStack=string(CpAxis.getElementsByTagName("commonparam:paramName").item(0).getTextContent);
			break;
		end
	end
end
ElementCollection=Dom.getElementsByTagName("commonimage:acquisition").item(0).getElementsByTagName("commonphase:channel");
NumberOfDevices=ElementCollection.getLength;
DeviceNames=strings(NumberOfDevices,1);
DeviceEnables=false(NumberOfDevices,1);
for a=0:NumberOfDevices-1
	Channel=ElementCollection.item(a);
    Order=str2double(Channel.getAttribute("order"));
	DeviceNames(Order)=Channel.getElementsByTagName("commonphase:deviceName").item(0).getTextContent;
    DeviceEnables(Order)=strcmp(Channel.getAttribute("enable"),"true");
end
DeviceNames=DeviceNames(DeviceEnables);
Metadata.DeviceNames=DeviceNames;
ElementCollection=Dom.getElementsByTagName("lsmimage:scannerSettings");
for a=0:ElementCollection.getLength-1
	ScannerSetting=ElementCollection.item(a);
	if strcmp(ScannerSetting.getAttribute("type"),ScannerType)
		Metadata.Fps=1000/str2double(ScannerSetting.getElementsByTagName("commonparam:seriesInterval").item(0).getTextContent);
	end
end
import loci.formats.*
OirReader=Memoizer(ChannelSeparator(ChannelFiller));
OmePS=ome.OMEPyramidStore;
OirReader.setMetadataStore(OmePS);
if MapPath==""
	OirReader.setId(OirPath);
else
	OirReader.setId(MapPath);
end
Metadata.SizeX=OirReader.getSizeX;
Metadata.SizeY=OirReader.getSizeY;
Metadata.SizeZ=OirReader.getSizeZ;
SizeC=OirReader.getSizeC;
Metadata.SizeC=SizeC;
Metadata.SizeT=OirReader.getSizeT;
Metadata.DimensionOrder=string(OmePS.getPixelsDimensionOrder(0));
Metadata.OmeXml=string(OmePS.dumpXML);
ChannelColors=table('Size',[SizeC,4],'VariableTypes',["uint8" "uint8" "uint8" "uint8"],'VariableNames',["Red" "Green" "Blue" "Alpha"],'RowNames',DeviceNames);
for a=1:SizeC
	Color=OmePS.getChannelColor(0,a-1);
	ChannelColors.Red(a)=Color.getRed;
	ChannelColors.Green(a)=Color.getGreen;
	ChannelColors.Blue(a)=Color.getBlue;
	ChannelColors.Alpha(a)=Color.getAlpha;
end
Metadata.ChannelColors=ChannelColors;
OirReader.close;
end