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
 * 本类用于转换javax.xml.soap.SOAPEnvelope和com.amarsoft.app.oci.bean.Message
 * */
public class TransSOAPMessage {
	/**
	 * @throws SOAPException 
	 * @param flag 标记字符，用于区分是SOAPBody还是SOAPHeader需要添加节点，在接口中SOAPBody的添加样式类似于：<gateway:field name="Province">上海</gateway:field>
	 * @param Message 读取Message,将Message的数据对象的值添加到Envlope中,根据XML文件中的Message信息创建SOAPElement,并返回初始节点SOAPElement
	 * */
	public static SOAPElement createSOAPElementFromMessage(Message message,SOAPEnvelope soapEnv,SOAPFactory soapFactory,String flag) throws SOAPException{
		String uri = soapEnv.getNamespaceURI(message.getNamespace());
		SOAPElement o = soapFactory.createElement(message.getTag(), message.getNamespace(), uri);
		Field[] msgFields = message.getFields();//获取所有的字段
		for(Field field:msgFields)
		{
			if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
				//解析数组数据--如果遇到数组数据，还需要自己斟酌
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChildElement(createSOAPElementFromMessage(subMessage,soapEnv,soapFactory,flag));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//解析对象数据--如果遇到对象数据，还需要自己斟酌
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
	 * @param Message 将Message的数据对象的值添加到Envlope中,根据XML文件中的Message信息创建SOAPElement,并返回初始节点SOAPElement
	 * */
	public static void createMessageFromSOAPElement(SOAPElement soapElement,Message message,SOAPFactory soapFactory) throws Exception{
		String localname = soapElement.getLocalName();
		if(localname.equalsIgnoreCase("field")||localname.equalsIgnoreCase("fie"))
			localname = soapElement.getAttributes().item(0).getNodeValue();//防止Object出现获取name的值 
		//取出SOAPElement元素和Message的元素进行逐一对比
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
						ooName = oo.getAttribute("name");//获取name的值
					if(ooName.equalsIgnoreCase(field.getFieldTag())){//如果field和SOAPElement的name值一致接下来进行对比,并在对比之后跳出循环
						if (field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY))// 解析数组数据
						{//这里对数组的处理有些问题
							ArrayList<Message> fieldArray = new ArrayList<Message>();
							Message subMessage = (Message) OCIConfig.getMessageByID(field.getArrayName()).copyMessage();
							fieldArray.add(subMessage);
							createMessageFromSOAPElement(oo, subMessage,soapFactory);
							field.setFieldArrayValue(fieldArray);
						} else if (field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)) {// 解析对象数据
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
			throw new OCIException("SOAP对象标签与Message标签不相符，不能相互转换。");
		}
	}
}
