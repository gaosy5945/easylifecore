package com.amarsoft.app.oci.parser.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.namespace.QName;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPFactory;

import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * @author ckxu
 * ��������ת��javax.xml.soap.SOAPEnvelope��com.amarsoft.app.oci.bean.Message
 * */
public class TransSOAPMessage {
	/**
	 * @throws SOAPException 
	 * @param flag ����ַ�������������SOAPBody����SOAPHeader��Ҫ��ӽڵ㣬�ڽӿ���SOAPBody�������ʽ�����ڣ�<gateway:field name="Province">�Ϻ�</gateway:field>
	 * @param Message ��ȡMessage,��Message�����ݶ����ֵ��ӵ�Envlope��,����XML�ļ��е�Message��Ϣ����SOAPElement,�����س�ʼ�ڵ�SOAPElement
	 * */
	public static SOAPElement createSOAPElementFromMessage(Message message,SOAPEnvelope soapEnv,SOAPFactory soapFactory,String flag) throws SOAPException{
		String uri = soapEnv.getNamespaceURI(message.getNamespace());
		SOAPElement o = soapFactory.createElement(message.getTag(), message.getNamespace(), uri);
		Field[] msgFields = message.getFields();//��ȡ���е��ֶ�
		for(Field field:msgFields)
		{
			if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
				//������������--��������������ݣ�����Ҫ�Լ�����
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChildElement(createSOAPElementFromMessage(subMessage,soapEnv,soapFactory,flag));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//������������--��������������ݣ�����Ҫ�Լ�����
				o.addChildElement(createSOAPElementFromMessage(field.getObjectMessage(),soapEnv,soapFactory,flag));
			}else{
				if(flag.equals("B")){
					SOAPElement e = o.addChildElement(new QName(soapEnv.getNamespaceURI(field.getNamespace()),"field",field.getNamespace()));
					e.setAttribute("name", field.getFieldTag());
					e.setTextContent(field.getFieldValue());
				}else{
					SOAPElement e = o.addChildElement(new QName(soapEnv.getNamespaceURI(field.getNamespace()),field.getFieldTag(),field.getNamespace()));
					e.setTextContent(field.getFieldValue());
				}
			}
		}
		return o;
	}
	/**
	 * @throws Exception 
	 * @param Message ��Message�����ݶ����ֵ��ӵ�Envlope��,����XML�ļ��е�Message��Ϣ����SOAPElement,�����س�ʼ�ڵ�SOAPElement
	 * */
	public static void createMessageFromSOAPElement(SOAPElement soapElement,Message message,SOAPFactory soapFactory) throws Exception{
		String localname = soapElement.getLocalName();
		if(localname.equalsIgnoreCase("field")||localname.equalsIgnoreCase("fie"))
			localname = soapElement.getAttributes().item(0).getNodeValue();//��ֹObject���ֻ�ȡname��ֵ 
		//ȡ��SOAPElementԪ�غ�Message��Ԫ�ؽ�����һ�Ա�
		if(localname.equalsIgnoreCase(message.getTag()))
		{
			Field[] msgFields = message.getFields();
			for (Field field : msgFields)
			{
				@SuppressWarnings("unchecked")
				Iterator<SOAPElement> itc = soapElement.getChildElements();
				OK:while (itc.hasNext()) {
					SOAPElement oo = itc.next();
					String ooName = oo.getLocalName();
					if(ooName.equalsIgnoreCase("field")||ooName.equalsIgnoreCase("fie"))
						ooName = oo.getAttribute("name");//��ȡname��ֵ
					if(ooName.equalsIgnoreCase(field.getFieldTag())){//���field��SOAPElement��nameֵһ�½��������жԱ�,���ڶԱ�֮������ѭ��
						if (field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY))// ������������
						{//���������Ĵ�����Щ����
							ArrayList<Message> fieldArray = new ArrayList<Message>();
							Message subMessage = (Message) OCIConfig.getMessageByID(field.getArrayName()).copyMessage();
							fieldArray.add(subMessage);
							createMessageFromSOAPElement(oo, subMessage,soapFactory);
							field.setFieldArrayValue(fieldArray);
						} else if (field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)) {// ������������
							Message objectMessage = (Message) OCIConfig.getMessageByID(field.getObjectName()).copyMessage();
							field.setObjectMessage(objectMessage);
							createMessageFromSOAPElement(oo, objectMessage,soapFactory);
						} else {
							field.setFieldValue(oo.getTextContent());
						}
						break OK;
					}
				}
			}
		}else
		{
			throw new OCIException("SOAP�����ǩ��Message��ǩ������������໥ת����");
		}
	}
}
