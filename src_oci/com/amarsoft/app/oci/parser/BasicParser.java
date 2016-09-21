package com.amarsoft.app.oci.parser;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.om.OMText;
import org.apache.axiom.soap.SOAPFactory;
import org.jdom.Element;

import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.Tools;
import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;

/**
 * 
 * @author xjzhao
 * <p>������GenericParser��ͨ������������б��Ľ�����Ļ���<br>
 * 	  ������ĸ�ʽ��Ҫͳһһ�����еĸ�ʽ��Ҳ��ֱ��ʵ��DataParser���ƹ��û���</p>
 * <p>������ṩ��3�ֳ��õı��ĸ�ʽ�Ľ�������<br>
 *    ���ڽ�����Ϣ����Щ����ֻ�ǽ�����Ϣ������Ϣͷ����Ϣ�塣���ɵ�ʵ����������Щ�����ķ�����ƴװ�����ı����壩</p>
 * <p>
 *   compositeFixSize  decomposeFixSize �����������ĵ���Ϣ��
 *   compositeUnFixSize  decomposeUnFixSize �����䳤���ҷָ���Ϊ "|" �ı��ĵ���Ϣ��
 *   compositeXML  decomposeXML ����XML��ʽ�ı��ĵ���Ϣ��
 * </p>
 */
public abstract class BasicParser implements IParser {

	public abstract void compositeTransData(OCITransaction trans) throws Exception;
	
	public abstract void decomposeTransData(OCITransaction trans) throws Exception;
	
	
	/**
	 * ��Message����ת��ΪOMElement���󣨰��������ռ䣩
	 * @param transaction
	 * @param message
	 * @param namespaces
	 * @return
	 * @throws OCIException
	 */
	protected OMElement createOMElementFromMessage(OCITransaction transaction,Message message,HashMap<String,OMNamespace> namespaces) throws Exception{
		SOAPFactory sf = OMAbstractFactory.getSOAP11Factory();
		OMElement o = sf.createOMElement(message.getTag(), namespaces.get(message.getNamespace()));
		Field[] msgFields = message.getFields();
		for(Field field:msgFields)
		{
			if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
				//������������
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChild(createOMElementFromMessage(transaction,subMessage,namespaces));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//������������
				o.addChild(createOMElementFromMessage(transaction,field.getObjectMessage(),namespaces));
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_XML)){
				OMElement oo = sf.createOMElement(field.getFieldTag(), namespaces.get(field.getNamespace()));
				OMText cdata = sf.createOMText(oo, field.getFieldValue(), OMElement.CDATA_SECTION_NODE);
				o.addChild(oo);
			}
			else{
				OMElement oo = sf.createOMElement(field.getFieldTag(), namespaces.get(field.getNamespace()));
				oo.setText(new QName(field.getFieldValue()));
				o.addChild(oo);
			}
		}
		return o;
	}
	
	/**
	 * ��Message����ת��ΪOMElement���󣨰��������ռ䣩��Ϊ�յ��ֶβ������ڱ����С�
	 * @param transaction
	 * @param message
	 * @param namespaces
	 * @return
	 * @throws OCIException
	 */
	protected OMElement createOMElementFromMessage2(OCITransaction transaction,Message message,HashMap<String,OMNamespace> namespaces) throws Exception{
		SOAPFactory sf = OMAbstractFactory.getSOAP11Factory();
		OMElement o = sf.createOMElement(message.getTag(), namespaces.get(message.getNamespace()));
		Field[] msgFields = message.getFields();
		for(Field field:msgFields)
		{
			if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
				//������������
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChild(createOMElementFromMessage2(transaction,subMessage,namespaces));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//������������
				o.addChild(createOMElementFromMessage2(transaction,field.getObjectMessage(),namespaces));
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_XML)){
				OMElement oo = sf.createOMElement(field.getFieldTag(), namespaces.get(field.getNamespace()));
				OMText cdata = sf.createOMText(oo, field.getFieldValue(), OMElement.CDATA_SECTION_NODE);
				o.addChild(oo);
			}
			else{
				if(field.getFieldValue() != null && !"".equals(field.getFieldValue()))
				{
					OMElement oo = sf.createOMElement(field.getFieldTag(), namespaces.get(field.getNamespace()));
					oo.setText(new QName(field.getFieldValue()));
					o.addChild(oo);
				}
			}
		}
		return o;
	}
	
	/**
	 * ��OMElement����ת��ΪMessage���󣨰��������ռ䣩
	 * @param transaction
	 * @param message
	 * @param namespaces
	 * @return
	 * @throws OCIException
	 */
	protected void createMessageFromOMElement(OCITransaction transaction,OMElement o,Message message) throws Exception{
		if(o.getLocalName().equalsIgnoreCase(message.getTag()))
		{
			
			Field[] msgFields = message.getFields();
			for(Field field:msgFields)
			{
				 Iterator itc = o.getChildrenWithLocalName(field.getFieldTag());
				 if(itc == null || !itc.hasNext()) continue;
				
				if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					ArrayList<Message> fieldArray = new ArrayList<Message>();
					
					while(itc.hasNext())
					{
						OMElement ooo = (OMElement)itc.next();
						Message subMessage = (Message)OCIConfig.getMessageByID(field.getArrayName()).copyMessage();
						fieldArray.add(subMessage);
						createMessageFromOMElement(transaction,ooo,subMessage);
					}
					field.setFieldArrayValue(fieldArray);
				}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
					OMElement oo = (OMElement)itc.next();
					//������������
					Message objectMessage = (Message)OCIConfig.getMessageByID(field.getObjectName()).copyMessage();
					field.setObjectMessage(objectMessage);
					createMessageFromOMElement(transaction,oo,objectMessage);
				}else{
					OMElement oo = (OMElement)itc.next();
					field.setFieldValue(oo.getText());
				}
			}
		}else
		{
			throw new OCIException("OME�����ǩ��Message��ǩ������������໥ת����");
		}
	}
	
	/**
	 * ����������ʽ
	 * @param message
	 * @param parserInfo Ŀǰ������ charSet, decimalPoint
	 * @return
	 */
	protected StringBuffer compositeFixSize(Message message, Map<String, String> parserInfo) throws OCIException{
		StringBuffer messageStr = new StringBuffer("");
		try{
			String charSet = parserInfo.get("charSet");
			String decimalPoint = parserInfo.get("decimalPoint");
			String dataUnit = parserInfo.get("dataUnit");
			
			Tools.checkMessage(message, charSet, dataUnit);
			Field[] msgFileds = message.getFields();
			
			for(int i = 0; i<msgFileds.length; i++){
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append(compositeFixSize(fieldArray.get(j), parserInfo));
					}
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//������������
					messageStr.append(compositeFixSize(msgFileds[i].getObjectMessage(), parserInfo));
				}else{
					messageStr.append(Tools.formatFixSize(msgFileds[i],charSet, dataUnit, decimalPoint));		
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "���������ʽ���� messageId = " + message.getId());
		}
		return messageStr;
	}
	
	/**
	 * <p>���ݽ��յ��������������ָ������Message��ֵ�������ֽ�����������<br> 
	 *  ��һ���յ��ı������ݰ����˱���ͷ�ͱ��������ݣ��÷����Ὣָ����ֵ��䵽����ͷ�ͱ�������</p>
	 * @param messageData ���ܵĲ��ֻ�ȫ�����ֽڱ������ݣ���messageList��Message�е�Field Value һһ��Ӧ
	 * @param messageList ��Ҫ�����Ķ�Ӧ������Message������Message������˳��Ҫ�ͱ��ĵ�˳��һ��
	 * @param parserInfo
	 * @throws OCIException
	 */
	public void decomposeFixSize(byte[] messageData, List<Message> messageList, Map<String, String> parserInfo) throws OCIException{
		try{
			if(parserInfo.get("dataUnit").equals(MessageConstants.DATA_UNIT_STRING)){
				decomposeFixSizeString(new String(messageData, parserInfo.get("charSet")), messageList, parserInfo);
			}else{
				decomposeFixSizeByte(messageData, messageList, parserInfo);
			}
			
		}catch(Exception e){
			ExceptionFactory.parse(e, "���Ľ���");
		}
		
	}
	
	/**
	 * ���������ַ�����Ķ����ַ���
	 * @param messageData
	 * @param messageList
	 * @param parserInfo
	 * @return
	 * @throws OCIException
	 */
	private String decomposeFixSizeString(String messageData, List<Message> messageList, Map<String, String> parserInfo) throws OCIException{
		
		String itString = messageData; //itStr�����ַ����飬����������ȡһ�������ַ���Message���
		try{
			String decimalPoint = parserInfo.get("decimalPoint");
			String tempStr = "";
			int strCutLength = 0;
			Map<String, String> arrLengthMap = new HashMap<String, String>();	//����ĳ���
			for(int i = 0; i<messageList.size(); i++){
				Message message = messageList.get(i);
				Field[] msgFileds = message.getFields();
				for(int j = 0; j<msgFileds.length; j++){
					if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_STRING)){
						strCutLength = msgFileds[j].getLength();
						tempStr = itString.substring(0, strCutLength);
						msgFileds[j].setFieldValue(tempStr.trim());
						msgFileds[j].setParsedValue(tempStr);
						itString = itString.substring(strCutLength);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_INT)){
						strCutLength = msgFileds[j].getLength();
						tempStr = itString.substring(0, strCutLength);
						msgFileds[j].setFieldValue(new BigInteger(tempStr.trim()).toString());
						msgFileds[j].setParsedValue(tempStr);
						itString = itString.substring(strCutLength);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_DOUBLE)){
						if(decimalPoint.equals(MessageConstants.DECIMAL_POINT_YES)){	//��С����
							strCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength() + 1;		
							tempStr = itString.substring(0, strCutLength);
							msgFileds[j].setFieldValue(String.valueOf(Double.parseDouble(tempStr.trim())));
						}else{		//����С����
							strCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength();		
							tempStr = itString.substring(0, strCutLength);
							msgFileds[j].setFieldValue(Double.toString(Double.parseDouble(tempStr)/(Math.pow(10, msgFileds[j].getDlength()))));	
						}
						msgFileds[j].setParsedValue(tempStr);
						itString = itString.substring(strCutLength);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
						Message objectMessage = OCIConfig.getMessageByID(msgFileds[j].getObjectName());
						ArrayList<Message> lObjectMessage = new ArrayList<Message>();
						lObjectMessage.add(objectMessage);
						itString = decomposeFixSizeString(itString, lObjectMessage, parserInfo);
						msgFileds[j].setObjectMessage(objectMessage);
					}else{
						int arrayLength = 0;	//���鳤��
						//�õ����鳤�ȣ����� ���ߴ��յ��ı����н������
						if (msgFileds[j].getArrayFixedSize()>0){	// ����������
							arrayLength = msgFileds[j].getArrayFixedSize();
						}else if(arrLengthMap.get(msgFileds[j].getArrayName()) != null){
							arrayLength = Integer.parseInt(arrLengthMap.get(msgFileds[j].getArrayName()));
						}
						//�����������Ͳ��ֵı���
						ArrayList<Message> arrayMessage = new ArrayList<Message>();
//						if(arrayLength == 0){	//���ڽ������ĳ���δ�����������鱨�����ݲ����ڱ�����󲿷�
//							while(itString.length() > 0){
//								ArrayList<Message> tempMessList = new ArrayList<Message>();
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								tempMessList.add(fieldMessage);
//								itString = decomposeFixSizeString(itString,tempMessList, parserInfo);
//								arrayMessage.add(tempMessList.get(0));
//							}
//						}else{			//���ڽ������ȹ̶��ı��ģ����ĵĳ������Զ������߱��������л��
//							for(int k = 0; k<arrayLength; k++){
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								arrayMessage.add(fieldMessage);								
//							}
//							itString = decomposeFixSizeString(itString,arrayMessage, parserInfo);
//						}
						for(int k = 0; k<arrayLength; k++){
							Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
							arrayMessage.add(fieldMessage);								
						}
						itString = decomposeFixSizeString(itString,arrayMessage, parserInfo);
						msgFileds[j].setFieldArrayValue(arrayMessage);
					}
					strCutLength = 0;
					//�ӱ����л������ĳ���
					if(msgFileds[j].getValueSource().equals(MessageConstants.DATA_TYPE_ARRAY)){
						arrLengthMap.put(msgFileds[j].getDefaultValue(), msgFileds[j].getFieldValue());
					}
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "��������ַ���ʽ����");
		}
		return itString;
	}
	
	/**
	 * ���������ֽڴ���Ķ����ֽ���
	 * @param messageData
	 * @param messageList
	 * @param parserInfo
	 * @return
	 * @throws OCIException
	 */
	private byte[] decomposeFixSizeByte(byte[] messageData, List<Message> messageList, Map<String, String> parserInfo) throws OCIException{
		
		byte[] itBytes = messageData; //itStr�����ֽ����飬����������ȡһ�������ֽڶ�Message���
		try{
			String charSet = parserInfo.get("charSet");
			String decimalPoint = parserInfo.get("decimalPoint");
			String tempStr = "";
			int byteCutLength = 0;
			Map<String, String> arrLengthMap = new HashMap<String, String>();	//����ĳ���
			for(int i = 0; i<messageList.size(); i++){
				Message message = messageList.get(i);
				Field[] msgFileds = message.getFields();
				for(int j = 0; j<msgFileds.length; j++){
					if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_STRING)){
						byteCutLength = msgFileds[j].getLength();
						tempStr = new String(itBytes, 0, byteCutLength, charSet );
						msgFileds[j].setFieldValue(tempStr.trim());
						msgFileds[j].setParsedValue(tempStr);
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_BYTE)){
						//��������Ϊ��������������ÿ���ֽ�ת��Ϊ��Ӧ��ʮ�����������洢���м��ö��ŷָ�
						byteCutLength = msgFileds[j].getLength();
						String byteString = "";
						for(int k = 0; k < byteCutLength; k++){
							int a = itBytes[k];
							byteString += "," + Integer.valueOf(a);
						}
						msgFileds[j].setFieldValue(byteString.substring(1));
						msgFileds[j].setParsedValue(byteString.substring(1));
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_INT)){
						byteCutLength = msgFileds[j].getLength();
						tempStr = new String(itBytes, 0, byteCutLength, charSet );
						msgFileds[j].setFieldValue(new BigInteger(tempStr.trim()).toString());
						msgFileds[j].setParsedValue(tempStr);
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_DOUBLE)){
						if(decimalPoint.equals(MessageConstants.DECIMAL_POINT_YES)){	//��С����
							byteCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength() + 1;		
							tempStr = new String(itBytes, 0, byteCutLength, charSet );
							msgFileds[j].setFieldValue(String.valueOf(Double.parseDouble(tempStr.trim())));
						}else{		//����С����
							byteCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength();		
							tempStr = new String(itBytes, 0, byteCutLength, charSet );
							msgFileds[j].setFieldValue(Double.toString(Double.parseDouble(tempStr)/(Math.pow(10, msgFileds[j].getDlength()))));	
						}
						msgFileds[j].setParsedValue(tempStr);
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
						Message objectMessage = OCIConfig.getMessageByID(msgFileds[j].getObjectName());
						ArrayList<Message> lObjectMessage = new ArrayList<Message>();
						lObjectMessage.add(objectMessage);
						itBytes = decomposeFixSizeByte(itBytes, lObjectMessage, parserInfo);
						msgFileds[j].setObjectMessage(objectMessage);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_VAR_LL)){
						int llLength = Integer.parseInt(new String(itBytes, 0, 2, charSet ));
						tempStr = new String(itBytes, 2, llLength, charSet );
						msgFileds[j].setFieldValue(tempStr.trim());
						msgFileds[j].setParsedValue(new String(itBytes, 0, 2, charSet ) + tempStr);
						byteCutLength = llLength + 2;
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else if(msgFileds[j].getDataType().equals(MessageConstants.DATA_VAR_LLL)){
						int lllLength = Integer.parseInt(new String(itBytes, 0, 3, charSet ));
						tempStr = new String(itBytes, 3, lllLength, charSet );
						msgFileds[j].setFieldValue(tempStr.trim());
						msgFileds[j].setParsedValue(new String(itBytes, 0, 3, charSet ) + tempStr);
						byteCutLength = lllLength + 3;
						itBytes = Tools.getCutBytes(itBytes, byteCutLength, itBytes.length-1);
					}else{				//����
						int arrayLength = 0;	//���鳤��
						//�õ����鳤�ȣ����� ���ߴ��յ��ı����н������
						if (msgFileds[j].getArrayFixedSize()>0){	// ����������
							arrayLength = msgFileds[j].getArrayFixedSize();
						}else if(arrLengthMap.get(msgFileds[j].getArrayName()) != null){
							arrayLength = Integer.parseInt(arrLengthMap.get(msgFileds[j].getArrayName()));
						}
						//�����������Ͳ��ֵı���
						ArrayList<Message> arrayMessage = new ArrayList<Message>();
//						if(arrayLength == 0){	//���ڽ������ĳ���δ�����������鱨�����ݲ����ڱ�����󲿷�
//							while(itBytes.length > 0){
//								ArrayList<Message> tempMessList = new ArrayList<Message>();
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								tempMessList.add(fieldMessage);
//								itBytes = decomposeFixSizeByte(itBytes,tempMessList, parserInfo);
//								arrayMessage.add(tempMessList.get(0));
//							}
//						}else{				//���ڽ������ȹ̶��ı��ģ����ĵĳ������Զ������߱��������л��
//							for(int k = 0; k<arrayLength; k++){
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								arrayMessage.add(fieldMessage);
//							}
//							itBytes = decomposeFixSizeByte(itBytes,arrayMessage, parserInfo);
//						}
						for(int k = 0; k<arrayLength; k++){
							Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
							arrayMessage.add(fieldMessage);
						}
						itBytes = decomposeFixSizeByte(itBytes,arrayMessage, parserInfo);
						
						msgFileds[j].setFieldArrayValue(arrayMessage);
					}
					byteCutLength = 0;
					//�ӱ����л������ĳ���
					if(msgFileds[j].getValueSource().equals(MessageConstants.DATA_TYPE_ARRAY)){
						arrLengthMap.put(msgFileds[j].getDefaultValue(), msgFileds[j].getFieldValue());
					}
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "��������ֽڸ�ʽ����");
		}
		return itBytes;
	}
	
	/**
	 * ������������ʽ
	 * @param message
	 * @return
	 */
	protected String compositeUnFixSize(Message message){
		
		return null;
	}
	
	protected Message decomposeUnFixSize(String messageData){
		
		return null;
	}
	
	/**
	 * <p>����Message��Xml����</p>
	 * <p>��һ��Messageת��Ϊ��Xml����</p>
	 * @param message
	 * @return
	 * @throws Exception 
	 */
	protected StringBuffer compositeXML(Message message) throws OCIException{
		StringBuffer messageStr = new StringBuffer("");
		try{
			Tools.checkMessage(message, ARE.getProperty("CharSet","GBK"), MessageConstants.DATA_UNIT_STRING);
			Field[] msgFileds = message.getFields();
			
			for(int i = 0; i<msgFileds.length; i++){
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append("<" + fieldArray.get(j).getTag() + ">");
						messageStr.append(compositeXML(fieldArray.get(j)));
						messageStr.append("</" + fieldArray.get(j).getTag() + ">");
					}
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">");
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//������������
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					messageStr.append(compositeXML(msgFileds[i].getObjectMessage()));
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">");
				}else{
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">" +
							msgFileds[i].getFieldValue()		
						+ "</" + msgFileds[i].getFieldTag() + ">");		
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "���XML��ʽ���� messageId = " + message.getId());
		}
		return messageStr;
	}
	/**
	 * <p>����XMl���ݵ�Message</p>
	 * <p>һ��message��Ӧ��XML��Element���ݣ���<head>...</head>����Ϊһ��xData����Ӧ��MessageΪһ������ͷ��Ϣ</p>
	 * @param xData	
	 * @param message
	 * @throws Exception
	 */
	protected void decomposeXML(Element xData, Message message) throws OCIException{
	
		Field[] msgFileds = message.getFields();
		for(int i = 0; i<msgFileds.length; i++){
			try{
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					ArrayList<Message> meesageList = new ArrayList<Message>();
					if(xData.getChild(msgFileds[i].getFieldTag()) != null){
						List<Element> xList = xData.getChild(msgFileds[i].getFieldTag()).getChildren(OCIConfig.getMessageByID(msgFileds[i].getArrayName()).getTag());
						
						for(int j = 0; j<xList.size(); j++ ){
							Message fieldMessage = OCIConfig.getMessageByID(msgFileds[i].getArrayName());
							decomposeXML(xList.get(j), fieldMessage);
							meesageList.add(fieldMessage);
						}
					}	
					msgFileds[i].setFieldArrayValue(meesageList);
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//������������
					Element xMessage = xData.getChild(msgFileds[i].getFieldTag());
					Message objectMessage = OCIConfig.getMessageByID(msgFileds[i].getObjectName());
					decomposeXML(xMessage, objectMessage);
					msgFileds[i].setObjectMessage(objectMessage);
				}else{
					if(xData.getChild(msgFileds[i].getFieldTag()) != null){
						String value = xData.getChild(msgFileds[i].getFieldTag()).getValue();
						if(value != null&&!value.trim().equals("")){
							msgFileds[i].setParsedValue(value);
							msgFileds[i].setFieldValue(value.trim());
						}
					}
				}		
			}catch(Exception e){
				ARE.getLog().error("���Xml��ʽ����:"+message.getId()+":"+msgFileds[i]);
				ExceptionFactory.parse(e, "���Xml��ʽ����:"+message.getId()+":"+msgFileds[i]);
			}
		}
		//Tools.checkMessage(message, ARE.getProperty("CharSet","GBK"), MessageConstants.DATA_UNIT_STRING);
	}
	
	/**
	 * ����OPF XML������ʽ
	 * @param message
	 * @param parserInfo Ŀǰ������ charSet, decimalPoint
	 * @return
	 */
	protected StringBuffer compositeXMLFixSize(Message message, Map<String, String> parserInfo) throws OCIException{
		StringBuffer messageStr = new StringBuffer("");
		try{
			String charSet = parserInfo.get("charSet");
			String decimalPoint = parserInfo.get("decimalPoint");
			String dataUnit = parserInfo.get("dataUnit");
			
			Tools.checkMessage(message, charSet, dataUnit);
			Field[] msgFileds = message.getFields();
			
			for(int i = 0; i<msgFileds.length; i++){
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append("<" + fieldArray.get(j).getTag() + ">");
						messageStr.append(compositeXMLFixSize(fieldArray.get(j), parserInfo));
						messageStr.append("</" + fieldArray.get(j).getTag() + ">").append("&#xD;");
					}
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//������������
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					messageStr.append(compositeXMLFixSize(msgFileds[i].getObjectMessage(), parserInfo));
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");
				}else{
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">" +
							//�˴���������ʵ������, OPF��ʽ��ͳһ
							(message.getId().startsWith("CBC")? msgFileds[i].getFieldValue():Tools.formatFixSize(msgFileds[i],charSet, dataUnit, decimalPoint)) 
									
							+ "</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");		
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "���OPF XML������ʽ���� messageId = " + message.getId());
		}
		return messageStr;
	}
	
	/**
	 * <p>��������XMl���ݵ�Message</p>
	 * <p>һ��message��Ӧ��XML��Element���ݣ���<head>...</head>����Ϊһ��xData����Ӧ��MessageΪһ������ͷ��Ϣ</p>
	 * @param xData	
	 * @param message
	 * @throws Exception
	 */
	protected void decomposeXMLFixSize(Element xData, Message message) throws OCIException{
	
		Field[] msgFileds = message.getFields();
		for(int i = 0; i<msgFileds.length; i++){
			try{
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//������������
					ArrayList<Message> meesageList = new ArrayList<Message>();
					List<Element> xList = xData.getChild(msgFileds[i].getFieldTag()).getChildren(OCIConfig.getMessageByID(msgFileds[i].getArrayName()).getTag());
					for(int j = 0; j<xList.size(); j++ ){
						Message fieldMessage = OCIConfig.getMessageByID(msgFileds[i].getArrayName());
						decomposeXMLFixSize(xList.get(j), fieldMessage);
						meesageList.add(fieldMessage);
					}
//					if(meesageList.size() > 0){
						msgFileds[i].setFieldArrayValue(meesageList);
//					}
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//������������
					Element xMessage = xData.getChild(msgFileds[i].getFieldTag());
					Message objectMessage = OCIConfig.getMessageByID(msgFileds[i].getObjectName());
					decomposeXMLFixSize(xMessage, objectMessage);
					msgFileds[i].setObjectMessage(objectMessage);
				}else{
					String value = xData.getChild(msgFileds[i].getFieldTag()).getValue();
					if(value != null&&!value.trim().equals("")){
						msgFileds[i].setParsedValue(value);
						//���ж��Ƿ���С���㣬Ĭ�Ͼ�NDS�õ���С�������ã�Ĭ�Ϻ���λ֮ǰʡ��С����
						if(MessageConstants.DATA_TYPE_DOUBLE.equalsIgnoreCase(msgFileds[i].getDataType())){
//							Double dvalue= Double.valueOf(msgFileds[i].getFieldValue());
							
//							if(dvalue!=null){
//								String svalue=String.valueOf(dvalue/100.0) ;
//								msgFileds[i].setFieldValue(svalue);
//							}else{
//								ARE.getLog().warn(message.getId()+" "+msgFileds[i]+" is null ");
//							}		
							value = String.valueOf(Double.parseDouble(value)/Math.pow(10, msgFileds[i].getDlength() ));
							msgFileds[i].setFieldValue(value);
						}else{	//��������ԭֵ
							msgFileds[i].setFieldValue(value.trim());
						}
					}
				}		
			}catch(Exception e){
				ARE.getLog().error("�������OPF Xml��ʽ����:"+message.getId()+":"+msgFileds[i]);
				ExceptionFactory.parse(e, "�������OPF Xml��ʽ����:"+message.getId()+":"+msgFileds[i]);
			}
		}

	}
	
	
}
