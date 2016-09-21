package com.amarsoft.app.oci.parser.impl;

import java.util.HashMap;
import java.util.Iterator;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConstants;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.soap.SOAPFactory;

import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.parser.BasicParser;
/**
 * <p>修改之后的报文解析类，用于组装和拆分报文</p>
 */
public class DataClientParser  extends BasicParser {

	/**
	 * <p>组包处理</p>
	 * @throws Exception 
	 */
	public void compositeTransData(OCITransaction trans) throws Exception {
		//获取所有的命名空间
		HashMap<String, String> namespaces = trans.getNamespaces();
		//创建Message
		MessageFactory messageFactory = MessageFactory.newInstance(SOAPConstants.DEFAULT_SOAP_PROTOCOL);  
		SOAPMessage sm = messageFactory.createMessage();
		SOAPFactory soapFactory = SOAPFactory.newInstance();
		//获取SOAP报文的头和各个部分
		SOAPPart soapPart = sm.getSOAPPart();
		SOAPEnvelope soapEnv =  soapPart.getEnvelope();
		//接下来开始对SOAP进行组装,首先是命名空间的组装
		soapEnv.addNamespaceDeclaration("soap", "http://schemas.xmlsoap.org/soap/envelope/");
		for(String key:namespaces.keySet()){
			soapEnv.setAttribute("xmlns:"+key,namespaces.get(key));
		}
		//报文头,下面有一个HeaderType
		SOAPHeader soapHeader = soapEnv.getHeader();
		//报文体,下面有一个NoAS400
		SOAPBody soapBody = soapEnv.getBody();
		for(String key:trans.getIMessages().keySet()){
			if(key.indexOf("SysHeader") > -1){//设置Header
				Message header = trans.getIMessage(key);
				SOAPElement qName = TransSOAPMessage.createSOAPElementFromMessage(header,soapEnv,soapFactory,"H");
				soapHeader.addChildElement(qName);
			}else if(key.indexOf("SysBody") > -1){//设置Body
				Message body = trans.getIMessage(key);
				SOAPElement qName = TransSOAPMessage.createSOAPElementFromMessage(body,soapEnv,soapFactory,"B");
				soapBody.addChildElement(qName);
			}
		}
		sm.saveChanges();
		trans.setRequestData(sm);
	}
	/**
	 * <p>拆包处理</p>
	 * @throws Exception 
	 */
	public void decomposeTransData(OCITransaction trans) throws Exception {
		SOAPFactory soapFactory = SOAPFactory.newInstance();
		SOAPMessage sm = (SOAPMessage)trans.getResponseData();//获取响应数据
		SOAPEnvelope env = sm.getSOAPPart().getEnvelope();
		SOAPHeader soapHeader = env.getHeader();//获取响应头
		SOAPBody soapBody = env.getBody();//获取响应的数据
		for(String key:trans.getOMessages().keySet()){
			if(key.indexOf("SysHeader") > -1){
				Message message = trans.getOMessage(key);//XML文件中的相关数据
				@SuppressWarnings("unchecked")
				Iterator<SOAPElement> it = soapHeader.getChildElements();
				while(it.hasNext())
				{
					TransSOAPMessage.createMessageFromSOAPElement(it.next(),message,soapFactory);
				}
			}else if(key.indexOf("SysBody") > -1){
				Message message = trans.getOMessage(key);
				@SuppressWarnings("unchecked")
				Iterator<SOAPElement> it = soapBody.getChildElements();
				while(it.hasNext())
				{
					TransSOAPMessage.createMessageFromSOAPElement(it.next(),message,soapFactory);
				}
			}
		}
	}
}
