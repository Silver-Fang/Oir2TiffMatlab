function BfOirReader = GetBfOirReader(OirHeaderPath,MapPath)
arguments
	OirHeaderPath(1,1)string
	MapPath(1,1)string=""
end
import loci.formats.*;
BfOirReader=Memoizer(ChannelSeparator(ChannelFiller));
BfOirReader.setMetadataStore(ome.OMEPyramidStore);
if MapPath==""
	BfOirReader.setId(OirHeaderPath);
else
	BfOirReader.setId(MapPath);
end