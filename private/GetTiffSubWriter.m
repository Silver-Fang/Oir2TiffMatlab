function [TiffClient,TagStruct] = GetTiffSubWriter(OirReader,TiffPath,ZCSelection)
arguments
	OirReader(1,1)
	TiffPath(1,1)string
	ZCSelection.Zs(1,:)uint8=[]
	ZCSelection.Cs(1,:)uint8=[]
end
import ome.xml.model.primitives.PositiveInteger
import java.lang.Integer
SelectedZs=ZCSelection.Zs;
SelectedCs=ZCSelection.Cs;
OmePS=OirReader.getMetadataStore;
CsUnset=isempty(SelectedCs);
ZsUnset=isempty(SelectedZs);
NewOmePS=loci.formats.ome.OMEPyramidStore;
for a=0:OmePS.getInstrumentCount-1
	NewOmePS.setInstrumentID(OmePS.getInstrumentID(a),a);
	for b=0:OmePS.getLightSourceCount(a)-1
		NewOmePS.setLaserID(OmePS.getLaserID(a,b),a,b);
		NewOmePS.setLaserModel(OmePS.getLaserModel(a,b),a,b);
		NewOmePS.setLaserWavelength(OmePS.getLaserWavelength(a,b),a,b);
	end
	if CsUnset
		for b=0:OmePS.getDetectorCount(a)-1
			NewOmePS.setDetectorID(OmePS.getDetectorID(a,b),a,b);
			NewOmePS.setDetectorGain(OmePS.getDetectorGain(a,b),a,b);
			NewOmePS.setDetectorOffset(OmePS.getDetectorOffset(a,b),a,b);
			NewOmePS.setDetectorVoltage(OmePS.getDetectorVoltage(a,b),a,b);
		end
	else
		for b=0:numel(SelectedCs)-1
			ChannelIndex=SelectedCs(b+1)-1;
			NewOmePS.setDetectorID(OmePS.getDetectorID(a,ChannelIndex),a,b);
			NewOmePS.setDetectorGain(OmePS.getDetectorGain(a,ChannelIndex),a,b);
			NewOmePS.setDetectorOffset(OmePS.getDetectorOffset(a,ChannelIndex),a,b);
			NewOmePS.setDetectorVoltage(OmePS.getDetectorVoltage(a,ChannelIndex),a,b);
		end
	end
	for b=0:OmePS.getObjectiveCount(a)-1
		NewOmePS.setObjectiveID(OmePS.getObjectiveID(a,b),a,b);
		NewOmePS.setObjectiveImmersion(OmePS.getObjectiveImmersion(a,b),a,b);
		NewOmePS.setObjectiveLensNA(OmePS.getObjectiveLensNA(a,b),a,b);
		NewOmePS.setObjectiveModel(OmePS.getObjectiveModel(a,b),a,b);
		NewOmePS.setObjectiveNominalMagnification(OmePS.getObjectiveNominalMagnification(a,b),a,b);
		NewOmePS.setObjectiveWorkingDistance(OmePS.getObjectiveWorkingDistance(a,b),a,b);
	end
end
for a=0:OmePS.getImageCount-1
	NewOmePS.setImageID(OmePS.getImageID(a),a);
	NewOmePS.setImageName(OmePS.getImageName(a),a);
	NewOmePS.setImageAcquisitionDate(OmePS.getImageAcquisitionDate(a),a);
	NewOmePS.setObjectiveSettingsID(OmePS.getObjectiveSettingsID(a),a);
	NewOmePS.setObjectiveSettingsRefractiveIndex(OmePS.getObjectiveSettingsRefractiveIndex(a),a);
	NewOmePS.setPixelsID(OmePS.getPixelsID(a),a);
	NewOmePS.setPixelsBigEndian(OmePS.getPixelsBigEndian(a),a);
	NewOmePS.setPixelsDimensionOrder(OmePS.getPixelsDimensionOrder(a),a);
	NewOmePS.setPixelsInterleaved(OmePS.getPixelsInterleaved(a),a);
	NewOmePS.setPixelsPhysicalSizeX(OmePS.getPixelsPhysicalSizeX(a),a);
	NewOmePS.setPixelsPhysicalSizeY(OmePS.getPixelsPhysicalSizeY(a),a);
	NewOmePS.setPixelsPhysicalSizeZ(OmePS.getPixelsPhysicalSizeZ(a),a);
	NewOmePS.setPixelsSignificantBits(OmePS.getPixelsSignificantBits(a),a);
	NewOmePS.setPixelsSizeX(OmePS.getPixelsSizeX(a),a);
	NewOmePS.setPixelsSizeY(OmePS.getPixelsSizeY(a),a);
	if CsUnset
		NewOmePS.setPixelsSizeC(OmePS.getPixelsSizeC(a),a);
	else
		NewOmePS.setPixelsSizeC(PositiveInteger(Integer(numel(SelectedCs))),a);
	end
	if ZsUnset
		NewOmePS.setPixelsSizeZ(OmePS.getPixelsSizeZ(a),a);
	else
		NewOmePS.setPixelsSizeZ(PositiveInteger(Integer(numel(SelectedZs))),a);
	end
	NewOmePS.setPixelsSizeT(OmePS.getPixelsSizeT(a),a);
	NewOmePS.setPixelsType(OmePS.getPixelsType(a),a);
	if CsUnset
		for b=0:OmePS.getChannelCount(a)-1
			NewOmePS.setChannelID(OmePS.getChannelID(a,b),a,b);
			NewOmePS.setChannelColor(OmePS.getChannelColor(a,b),a,b);
			NewOmePS.setChannelName(OmePS.getChannelName(a,b),a,b);
			NewOmePS.setChannelSamplesPerPixel(OmePS.getChannelSamplesPerPixel(a,b),a,b);
			try
				NewOmePS.setChannelLightSourceSettingsID(OmePS.getChannelLightSourceSettingsID(a,b),a,b);
			catch
			end
			NewOmePS.setDetectorSettingsID(OmePS.getDetectorSettingsID(a,b),a,b);
		end
	else
		for b=0:numel(SelectedCs)-1
			ChannelIndex=SelectedCs(b+1)-1;
			NewOmePS.setChannelID(OmePS.getChannelID(a,ChannelIndex),a,b);
			NewOmePS.setChannelColor(OmePS.getChannelColor(a,ChannelIndex),a,b);
			NewOmePS.setChannelName(OmePS.getChannelName(a,ChannelIndex),a,b);
			NewOmePS.setChannelSamplesPerPixel(OmePS.getChannelSamplesPerPixel(a,ChannelIndex),a,b);
			try
				NewOmePS.setChannelLightSourceSettingsID(OmePS.getChannelLightSourceSettingsID(a,ChannelIndex),a,b);
			catch
			end
			NewOmePS.setDetectorSettingsID(OmePS.getDetectorSettingsID(a,ChannelIndex),a,b);
		end
	end
end
TiffClient=loci.formats.out.OMETiffWriter;
TiffClient.setMetadataRetrieve(NewOmePS);
TempPath=fullfile(fileparts(mfilename("fullpath")),string(java.util.UUID.randomUUID)+".tif");
TiffClient.setId(TempPath);
TiffClient.saveBytes(0,OirReader.openBytes(0));
TiffClient.close;
TiffClient=Tiff(TempPath);
HeaderDescription=TiffClient.getTag(Tiff.TagID.ImageDescription);
TiffClient.close;
delete(TempPath);
HeaderDescription=GetXmlDom(HeaderDescription);
Pixels=HeaderDescription.getElementsByTagName("Pixels").item(0);
TDTemplate=Pixels.getElementsByTagName("TiffData").item(0);
Pixels.removeChild(TDTemplate);
[~,TiffName,Extension]=fileparts(TiffPath);
UUID=TDTemplate.getElementsByTagName("UUID").item(0);
UUID.setAttribute("FileName",TiffName+Extension);
SizeC=NewOmePS.getPixelsSizeC(0).getValue;
SizeZ=NewOmePS.getPixelsSizeZ(0).getValue;
SizeT=NewOmePS.getPixelsSizeT(0).getValue;
IFD=0;
for T=0:SizeT-1
	TemplateT=TDTemplate.cloneNode(true);
	TemplateT.setAttribute("FirstT",string(T));
	for Z=0:SizeZ-1
		TemplateZ=TemplateT.cloneNode(true);
		TemplateZ.setAttribute("FirstZ",string(Z));
		for C=0:SizeC-1
			TiffData=TemplateZ.cloneNode(true);
			TiffData.setAttribute("FirstC",string(C));
			TiffData.setAttribute("IFD",string(IFD));
			IFD=IFD+1;
			Pixels.appendChild(TiffData);
		end
	end
end
HeaderDescription=Dom2String(HeaderDescription);
TiffClient=Tiff(TiffPath,"w8");
TagStruct=struct("ImageWidth",OirReader.getSizeX,"ImageLength",OirReader.getSizeY,"Photometric",Tiff.Photometric.MinIsBlack,"Compression",Tiff.Compression.None,"PlanarConfiguration",Tiff.PlanarConfiguration.Chunky,"BitsPerSample",16,"SamplesPerPixel",1);
Tag=TagStruct;
Tag.ImageDescription=char(HeaderDescription);
TiffClient.setTag(Tag);