function String = Dom2String(XmlDom)
import javax.xml.transform.*;
persistent Transformer
if isempty(Transformer)
	Transformer=TransformerFactory.newInstance().newTransformer;
end
StringWriter=java.io.StringWriter;
Transformer.transform(dom.DOMSource(XmlDom),stream.StreamResult(StringWriter));
String=StringWriter.toString;
end