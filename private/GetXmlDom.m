function XmlDom = GetXmlDom(XmlString)
persistent DocumentBuilder
if isempty(DocumentBuilder)
	DocumentBuilder=javax.xml.parsers.DocumentBuilderFactory.newInstance.newDocumentBuilder;
end
XmlDom=DocumentBuilder.parse(org.xml.sax.InputSource(java.io.StringReader(XmlString)));
end

