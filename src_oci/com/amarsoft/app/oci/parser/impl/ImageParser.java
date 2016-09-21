package com.amarsoft.app.oci.parser.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.OMGenerator;
import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.parser.IParser;

public class ImageParser implements IParser{

	@Override
	public void compositeTransData(OCITransaction trans) throws Exception {
		OMElement transDate = null;
		//定义命名空间
		HashMap<String, String> namespaces = trans.getNamespaces();
		HashMap<String,OMNamespace> OMNamespaces = new HashMap<String,OMNamespace>();
		for(String key:namespaces.keySet()){
			OMNamespaces.put(key, OMGenerator.createNameSpace(namespaces.get(key), key));
		}
		
		for(String key:trans.getIMessages().keySet()){
			Message header = trans.getIMessage(key);
			transDate = createOMElementFromMessage(trans, header, OMNamespaces , null);
		}
		trans.setRequestData(transDate);
	}

	@Override
	public void decomposeTransData(OCITransaction trans) throws Exception {	
		String temp = (String) trans.getResponseData();
		OMElement element = OMGenerator.parseStringtoOM(temp , trans.getProperty("XMLENOCDING"));
		String key = (String) (trans.getOMessages().keySet().toArray())[0];
		Message message = trans.getOMessage(key);
		createMessageFromOMElement(trans, element, message);
	}
	
	private OMElement createOMElementFromMessage(OCITransaction transaction,Message message,HashMap<String,OMNamespace> namespaces , OMElement o) throws Exception{
		if(o == null)
			o = OMGenerator.createOMElement(message.getTag(), namespaces.get(message.getNamespace()));
		Field[] msgFields = message.getFields();
		for(Field field:msgFields){
			if(field.getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
				//解析数组数据
				List<Message> fieldArray = field.getFieldArrayValue();
				for(Message subMessage:fieldArray){
					createOMElementFromMessage(transaction,subMessage,namespaces , o);
				}
			}else if(field.getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
				OMElement oo = createOMElementFromMessage(transaction,field.getObjectMessage(),namespaces , null);
				for(Field attr : field.getAttributes()){
					oo.addAttribute(OMGenerator.createOMAttribute(attr.getFieldTag(), null, attr.getFieldValue()));
				}
				o.addChild(oo);
			}else if(field.getDataType().equals(MessageConstants.DATA_TYPE_OMELEMENT)){
				OMElement temp = OMGenerator.parseStringtoOM(field.getFieldValue() , transaction.getProperty("XMLENOCDING"));
				o.addChild(temp);
			}else{
				OMElement oo = OMGenerator.createOMElement(field.getFieldTag(), namespaces.get(field.getNamespace()));
				oo.setText(new QName(field.getFieldValue()));
				for(Field attr : field.getAttributes()){
					oo.addAttribute(OMGenerator.createOMAttribute(attr.getFieldTag(), null, attr.getFieldValue()));
				}
				o.addChild(oo);
			}
		}
		return o;
	}
	
	private void createMessageFromOMElement(OCITransaction transaction,OMElement o,Message message) throws Exception{
		if(o.getLocalName().equalsIgnoreCase(message.getTag())){
			Field[] msgFields = message.getFields();
			for(Field field:msgFields){
				 Iterator itc = o.getChildrenWithLocalName(field.getFieldTag());
				 if(itc == null || !itc.hasNext()) continue;
				 if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
					ArrayList<Message> fieldArray = new ArrayList<Message>();
					while(itc.hasNext()){
						OMElement ooo = (OMElement)itc.next();
						Message subMessage = (Message)OCIConfig.getMessageByID(field.getArrayName()).copyMessage();
						fieldArray.add(subMessage);
						createArrayMessage(ooo,subMessage);
					}
					field.setFieldArrayValue(fieldArray);
				}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
					OMElement oo = (OMElement)itc.next();
					Message objectMessage = (Message)OCIConfig.getMessageByID(field.getObjectName()).copyMessage();
					field.setObjectMessage(objectMessage);
					createMessageFromOMElement(transaction,oo,objectMessage);
				}else{
					OMElement oo = (OMElement)itc.next();
					field.setFieldValue(oo.getText());
				}
			}
		}else{
			throw new OCIException("OME对象标签与Message标签不相符，不能相互转换。");
		}
	}
	
	private void createArrayMessage(OMElement o,Message message){
		Field field = message.getFields()[0];
		field.setFieldValue(o.getText());
		List<Field> list = field.getAttributes();
		for(Field temp : list){
			temp.setFieldValue(o.getAttributeValue(new QName(temp.getFieldTag())));
		}
	}
}
