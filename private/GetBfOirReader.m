function BfOirReader = GetBfOirReader(OirHeaderPath)
BfOirReader=loci.formats.Memoizer(loci.formats.ChannelSeparator(loci.formats.ChannelFiller));
BfOirReader.setMetadataStore(loci.formats.services.OMEXMLServiceImpl().createOMEXMLMetadata);
BfOirReader.setId(OirHeaderPath);
end

