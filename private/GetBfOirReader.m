function BfOirReader = GetBfOirReader(OirHeaderPath)
import loci.formats.*;
BfOirReader=Memoizer(ChannelSeparator(ChannelFiller));
BfOirReader.setMetadataStore(ome.OMEPyramidStore);
BfOirReader.setId(OirHeaderPath);
end