package com.amarsoft.app.oci.parser.impl;

import java.util.HashMap;
import java.util.Iterator;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAPBody;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axiom.soap.SOAPHeader;

import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.parser.BasicParser;

/**
 * @author xjzhao
 * <p>ESB组包拆包处理</p>
 */
public class ESBParser extends BasicParser {

	/**
	 * @author xjzhao
	 * <p>组包处理</p>
	 * @throws OCIException 
	 */
	public void compositeTransData(OCITransaction trans) throws Exception {
		
		
		SOAPFactory sf = OMAbstractFactory.getSOAP11Factory();
		//SOAPEnvelope envelope = sf.getDefaultEnvelope();
		
		OMNamespace q1Space=sf.createOMNamespace("http://schemas.xmlsoap.org/soap/envelope/", "soap");
		SOAPEnvelope envelope = sf.createSOAPEnvelope(q1Space);
		
		//定义命名空间
		HashMap<String, String> namespaces = trans.getNamespaces();
		HashMap<String,OMNamespace> OMNamespaces = new HashMap<String,OMNamespace>();
		
		for(String key:namespaces.keySet())
		{
			OMNamespaces.put(key, sf.createOMNamespace(namespaces.get(key), key));
			envelope.declareNamespace(OMNamespaces.get(key));
		}
		
		
		for(String key:trans.getIMessages().keySet())
		{
			if(key.indexOf("SysHeader") > -1)
			{
				//设置Header
				Message header = trans.getIMessage(key);
				OMElement OMEHeader = super.createOMElementFromMessage(trans, header, OMNamespaces);
				SOAPHeader soapHeader = sf.createSOAPHeader(envelope);
				soapHeader.addChild(OMEHeader);
			}else if(key.indexOf("SysBody") > -1){
				//设置Body
				Message body = trans.getIMessage(key);
				OMElement OMEBody = super.createOMElementFromMessage(trans, body, OMNamespaces);
				SOAPBody SoapBody = sf.createSOAPBody(envelope);
				SoapBody.addChild(OMEBody);
			}
		}
		
		trans.setRequestData(envelope);
	}

	/**
	 * @author xjzhao
	 * <p>拆包处理</p>
	 * @throws OCIException 
	 */
	public void decomposeTransData(OCITransaction trans) throws Exception {
		SOAPEnvelope envelope = (SOAPEnvelope)trans.getResponseData();
		OMElement header = envelope.getHeader();
		OMElement body = envelope.getBody();
		for(String key:trans.getOMessages().keySet())
		{
			if(key.indexOf("SysHeader") > -1)
			{
				//设置Header
				Message message = trans.getOMessage(key);
				Iterator it = header.getChildrenWithLocalName(message.getTag());
				while(it.hasNext())
				{
					super.createMessageFromOMElement(trans, (OMElement)it.next(), message);
				}
			}else if(key.indexOf("SysBody") > -1){
				//设置Body
				Message message = trans.getOMessage(key);
				Iterator it = body.getChildrenWithLocalName(message.getTag());
				while(it.hasNext())
				{
					super.createMessageFromOMElement(trans, (OMElement)it.next(), message);
				}
			}
		}
	}
}
