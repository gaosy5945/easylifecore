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
 * <p>�޸�֮��ı��Ľ����࣬������װ�Ͳ�ֱ���</p>
 */
public class DataClientParser  extends BasicParser {

	/**
	 * <p>�������</p>
	 * @throws Exception 
	 */
	public void compositeTransData(OCITransaction trans) throws Exception {
		//��ȡ���е������ռ�
		HashMap<String, String> namespaces = trans.getNamespaces();
		//����Message
		MessageFactory messageFactory = MessageFactory.newInstance(SOAPConstants.DEFAULT_SOAP_PROTOCOL);  
		SOAPMessage sm = messageFactory.createMessage();
		SOAPFactory soapFactory = SOAPFactory.newInstance();
		//��ȡSOAP���ĵ�ͷ�͸�������
		SOAPPart soapPart = sm.getSOAPPart();
		SOAPEnvelope soapEnv =  soapPart.getEnvelope();
		//��������ʼ��SOAP������װ,�����������ռ����װ
		soapEnv.addNamespaceDeclaration("soap", "http://schemas.xmlsoap.org/soap/envelope/");
		for(String key:namespaces.keySet()){
			soapEnv.setAttribute("xmlns:"+key,namespaces.get(key));
		}
		//����ͷ,������һ��HeaderType
		SOAPHeader soapHeader = soapEnv.getHeader();
		//������,������һ��NoAS400
		SOAPBody soapBody = soapEnv.getBody();
		for(String key:trans.getIMessages().keySet()){
			if(key.indexOf("SysHeader") > -1){//����Header
				Message header = trans.getIMessage(key);
				SOAPElement qName = TransSOAPMessage.createSOAPElementFromMessage(header,soapEnv,soapFactory,"H");
				soapHeader.addChildElement(qName);
			}else if(key.indexOf("SysBody") > -1){//����Body
				Message body = trans.getIMessage(key);
				SOAPElement qName = TransSOAPMessage.createSOAPElementFromMessage(body,soapEnv,soapFactory,"B");
				soapBody.addChildElement(qName);
			}
		}
		sm.saveChanges();
		trans.setRequestData(sm);
	}
	/**
	 * <p>�������</p>
	 * @throws Exception 
	 */
	public void decomposeTransData(OCITransaction trans) throws Exception {
		SOAPFactory soapFactory = SOAPFactory.newInstance();
		SOAPMessage sm = (SOAPMessage)trans.getResponseData();//��ȡ��Ӧ����
		SOAPEnvelope env = sm.getSOAPPart().getEnvelope();
		SOAPHeader soapHeader = env.getHeader();//��ȡ��Ӧͷ
		SOAPBody soapBody = env.getBody();//��ȡ��Ӧ������
		for(String key:trans.getOMessages().keySet()){
			if(key.indexOf("SysHeader") > -1){
				Message message = trans.getOMessage(key);//XML�ļ��е��������
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
