function StructuredMeta = ReadOirImageProperties(OirFilePath)
persistent DocumentBuilder IpEt
if isempty(DocumentBuilder)
	DocumentBuilder=javax.xml.parsers.DocumentBuilderFactory.newInstance.newDocumentBuilder;
end
if isempty(IpEt)
	IpEt="</lsmimage:imageProperties>";
end
FileId=fopen(OirFilePath);
Buffer=fread(FileId,10^7,"uint8=>char")';
MetaStart=strfind(Buffer,"<lsmimage:imageProperties");
Buffer=Buffer(MetaStart(1):end);
MetaEnd=strfind(Buffer,IpEt);
fclose(FileId);
Dom=DocumentBuilder.parse(org.xml.sax.InputSource(java.io.StringReader(Buffer(1:MetaEnd(1)+strlength(IpEt)-1))));
StructuredMeta.ScannerType=string(Dom.getElementsByTagName("lsmimage:scannerType").item(0).getTextContent);
ElementCollection=Dom.getElementsByTagName("commonparam:axis");
for a=0:ElementCollection.getLength-1
	CpAxis=ElementCollection.item(a);
	if string(CpAxis.getAttribute("enable"))=="true"
		MaxSize=uint16(str2double(CpAxis.getElementsByTagName("commonparam:maxSize").item(0).getTextContent));
		if string(CpAxis.getElementsByTagName("commonparam:axis").item(0).getTextContent)=="ZSTACK"&&string(CpAxis.getAttribute("paramEnable"))=="true"
			switch string(CpAxis.getElementsByTagName("commonparam:paramName").item(0).getTextContent)
				case "Start End"
					StructuredMeta.StartEnd=MaxSize;
				case "Range"
					StructuredMeta.Range=MaxSize;
				case "Piezo"
					StructuredMeta.Piezo=MaxSize;
			end
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
    DeviceEnables(Order)=string(Channel.getAttribute("enable"))=="true";
end
StructuredMeta.DeviceNames=DeviceNames(DeviceEnables);
end