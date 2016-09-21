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
 * <p>抽象类GenericParser，通常情况下是所有报文解析类的基类<br>
 * 	  如果报文格式想要统一一种特有的格式，也可直接实现DataParser，绕过该基类</p>
 * <p>这个类提供了3种常用的报文格式的解析器，<br>
 *    用于解析消息（这些方法只是解析消息，如消息头，消息体。集成的实现类中用这些解析的方法来拼装完整的报文体）</p>
 * <p>
 *   compositeFixSize  decomposeFixSize 解析定长报文的消息。
 *   compositeUnFixSize  decomposeUnFixSize 解析变长并且分隔符为 "|" 的报文的消息。
 *   compositeXML  decomposeXML 解析XML格式的报文的消息。
 * </p>
 */
public abstract class BasicParser implements IParser {

	public abstract void compositeTransData(OCITransaction trans) throws Exception;
	
	public abstract void decomposeTransData(OCITransaction trans) throws Exception;
	
	
	/**
	 * 将Message对象转换为OMElement对象（包含命名空间）
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
				//解析数组数据
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChild(createOMElementFromMessage(transaction,subMessage,namespaces));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//解析对象数据
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
	 * 将Message对象转换为OMElement对象（包含命名空间），为空的字段不体现在报文中。
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
				//解析数组数据
				List<Message> fieldArray = field.getFieldArrayValue();
				if(fieldArray!=null)
				{
					for(Message subMessage:fieldArray){
						o.addChild(createOMElementFromMessage2(transaction,subMessage,namespaces));
					}
				}
			}else if(field.getDataType().equalsIgnoreCase(MessageConstants.DATA_TYPE_OBJECT)){
				//解析对象数据
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
	 * 将OMElement对象转换为Message对象（包含命名空间）
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
					//解析数组数据
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
					//解析对象数据
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
			throw new OCIException("OME对象标签与Message标签不相符，不能相互转换。");
		}
	}
	
	/**
	 * 解析定长格式
	 * @param message
	 * @param parserInfo 目前包含了 charSet, decimalPoint
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
					//解析数组数据
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append(compositeFixSize(fieldArray.get(j), parserInfo));
					}
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//解析对象数据
					messageStr.append(compositeFixSize(msgFileds[i].getObjectMessage(), parserInfo));
				}else{
					messageStr.append(Tools.formatFixSize(msgFileds[i],charSet, dataUnit, decimalPoint));		
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "组包定长格式报文 messageId = " + message.getId());
		}
		return messageStr;
	}
	
	/**
	 * <p>根据接收到报文数据来填充指定所有Message的值（基于字节来解析）。<br> 
	 *  如一个收到的报文数据包含了报文头和报文体数据，该方法会将指定的值填充到报文头和报文体中</p>
	 * @param messageData 接受的部分或全部的字节报文数据，和messageList中Message中的Field Value 一一对应
	 * @param messageList 需要解析的对应的所有Message，其中Message的排列顺序要和报文的顺序一致
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
			ExceptionFactory.parse(e, "报文解析");
		}
		
	}
	
	/**
	 * 解析基于字符传输的定长字符流
	 * @param messageData
	 * @param messageList
	 * @param parserInfo
	 * @return
	 * @throws OCIException
	 */
	private String decomposeFixSizeString(String messageData, List<Message> messageList, Map<String, String> parserInfo) throws OCIException{
		
		String itString = messageData; //itStr迭代字符数组，程序会逐个截取一定长度字符对Message填充
		try{
			String decimalPoint = parserInfo.get("decimalPoint");
			String tempStr = "";
			int strCutLength = 0;
			Map<String, String> arrLengthMap = new HashMap<String, String>();	//数组的长度
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
						if(decimalPoint.equals(MessageConstants.DECIMAL_POINT_YES)){	//带小数点
							strCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength() + 1;		
							tempStr = itString.substring(0, strCutLength);
							msgFileds[j].setFieldValue(String.valueOf(Double.parseDouble(tempStr.trim())));
						}else{		//不带小数点
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
						int arrayLength = 0;	//数组长度
						//得到数组长度，定长 或者从收到的报文中解析获得
						if (msgFileds[j].getArrayFixedSize()>0){	// 定长的数组
							arrayLength = msgFileds[j].getArrayFixedSize();
						}else if(arrLengthMap.get(msgFileds[j].getArrayName()) != null){
							arrayLength = Integer.parseInt(arrLengthMap.get(msgFileds[j].getArrayName()));
						}
						//解析数组类型部分的报文
						ArrayList<Message> arrayMessage = new ArrayList<Message>();
//						if(arrayLength == 0){	//用于解析报文长度未定，但是数组报文数据部分在报文最后部分
//							while(itString.length() > 0){
//								ArrayList<Message> tempMessList = new ArrayList<Message>();
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								tempMessList.add(fieldMessage);
//								itString = decomposeFixSizeString(itString,tempMessList, parserInfo);
//								arrayMessage.add(tempMessList.get(0));
//							}
//						}else{			//用于解析长度固定的报文，报文的长度来自定长或者报文数据中获得
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
					//从报文中获得数组的长度
					if(msgFileds[j].getValueSource().equals(MessageConstants.DATA_TYPE_ARRAY)){
						arrLengthMap.put(msgFileds[j].getDefaultValue(), msgFileds[j].getFieldValue());
					}
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "解包定长字符格式报文");
		}
		return itString;
	}
	
	/**
	 * 解析基于字节传输的定长字节流
	 * @param messageData
	 * @param messageList
	 * @param parserInfo
	 * @return
	 * @throws OCIException
	 */
	private byte[] decomposeFixSizeByte(byte[] messageData, List<Message> messageList, Map<String, String> parserInfo) throws OCIException{
		
		byte[] itBytes = messageData; //itStr迭代字节数组，程序会逐个截取一定长度字节对Message填充
		try{
			String charSet = parserInfo.get("charSet");
			String decimalPoint = parserInfo.get("decimalPoint");
			String tempStr = "";
			int byteCutLength = 0;
			Map<String, String> arrLengthMap = new HashMap<String, String>();	//数组的长度
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
						//对于类型为二进制数，按照每个字节转化为相应的十进制数字来存储，中间用逗号分割
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
						if(decimalPoint.equals(MessageConstants.DECIMAL_POINT_YES)){	//带小数点
							byteCutLength = msgFileds[j].getLength()+msgFileds[j].getDlength() + 1;		
							tempStr = new String(itBytes, 0, byteCutLength, charSet );
							msgFileds[j].setFieldValue(String.valueOf(Double.parseDouble(tempStr.trim())));
						}else{		//不带小数点
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
					}else{				//数组
						int arrayLength = 0;	//数组长度
						//得到数组长度，定长 或者从收到的报文中解析获得
						if (msgFileds[j].getArrayFixedSize()>0){	// 定长的数组
							arrayLength = msgFileds[j].getArrayFixedSize();
						}else if(arrLengthMap.get(msgFileds[j].getArrayName()) != null){
							arrayLength = Integer.parseInt(arrLengthMap.get(msgFileds[j].getArrayName()));
						}
						//解析数组类型部分的报文
						ArrayList<Message> arrayMessage = new ArrayList<Message>();
//						if(arrayLength == 0){	//用于解析报文长度未定，但是数组报文数据部分在报文最后部分
//							while(itBytes.length > 0){
//								ArrayList<Message> tempMessList = new ArrayList<Message>();
//								Message fieldMessage = OCIConfig.getMessageByID(msgFileds[j].getArrayName());
//								tempMessList.add(fieldMessage);
//								itBytes = decomposeFixSizeByte(itBytes,tempMessList, parserInfo);
//								arrayMessage.add(tempMessList.get(0));
//							}
//						}else{				//用于解析长度固定的报文，报文的长度来自定长或者报文数据中获得
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
					//从报文中获得数组的长度
					if(msgFileds[j].getValueSource().equals(MessageConstants.DATA_TYPE_ARRAY)){
						arrLengthMap.put(msgFileds[j].getDefaultValue(), msgFileds[j].getFieldValue());
					}
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "解包定长字节格式报文");
		}
		return itBytes;
	}
	
	/**
	 * 解析不定长格式
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
	 * <p>解析Message成Xml数据</p>
	 * <p>将一个Message转化为成Xml数据</p>
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
					//解析数组数据
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append("<" + fieldArray.get(j).getTag() + ">");
						messageStr.append(compositeXML(fieldArray.get(j)));
						messageStr.append("</" + fieldArray.get(j).getTag() + ">");
					}
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">");
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//解析对象数据
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
			ExceptionFactory.parse(e, "组包XML格式报文 messageId = " + message.getId());
		}
		return messageStr;
	}
	/**
	 * <p>解析XMl数据到Message</p>
	 * <p>一个message对应的XML的Element数据，如<head>...</head>就作为一个xData，对应的Message为一个报文头消息</p>
	 * @param xData	
	 * @param message
	 * @throws Exception
	 */
	protected void decomposeXML(Element xData, Message message) throws OCIException{
	
		Field[] msgFileds = message.getFields();
		for(int i = 0; i<msgFileds.length; i++){
			try{
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//解析数组数据
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
					//解析对象数据
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
				ARE.getLog().error("解包Xml格式报文:"+message.getId()+":"+msgFileds[i]);
				ExceptionFactory.parse(e, "解包Xml格式报文:"+message.getId()+":"+msgFileds[i]);
			}
		}
		//Tools.checkMessage(message, ARE.getProperty("CharSet","GBK"), MessageConstants.DATA_UNIT_STRING);
	}
	
	/**
	 * 解析OPF XML定长格式
	 * @param message
	 * @param parserInfo 目前包含了 charSet, decimalPoint
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
					//解析数组数据
					List<Message> fieldArray = msgFileds[i].getFieldArrayValue();
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					for(int j = 0; j<fieldArray.size(); j++ ){
						messageStr.append("<" + fieldArray.get(j).getTag() + ">");
						messageStr.append(compositeXMLFixSize(fieldArray.get(j), parserInfo));
						messageStr.append("</" + fieldArray.get(j).getTag() + ">").append("&#xD;");
					}
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");
				}else if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)){
					//解析对象数据
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">");
					messageStr.append(compositeXMLFixSize(msgFileds[i].getObjectMessage(), parserInfo));
					messageStr.append("</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");
				}else{
					messageStr.append("<" + msgFileds[i].getFieldTag() + ">" +
							//此处这样处理，实属无奈, OPF格式不统一
							(message.getId().startsWith("CBC")? msgFileds[i].getFieldValue():Tools.formatFixSize(msgFileds[i],charSet, dataUnit, decimalPoint)) 
									
							+ "</" + msgFileds[i].getFieldTag() + ">").append("&#xD;");		
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e, "组包OPF XML定长格式报文 messageId = " + message.getId());
		}
		return messageStr;
	}
	
	/**
	 * <p>解析定长XMl数据到Message</p>
	 * <p>一个message对应的XML的Element数据，如<head>...</head>就作为一个xData，对应的Message为一个报文头消息</p>
	 * @param xData	
	 * @param message
	 * @throws Exception
	 */
	protected void decomposeXMLFixSize(Element xData, Message message) throws OCIException{
	
		Field[] msgFileds = message.getFields();
		for(int i = 0; i<msgFileds.length; i++){
			try{
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)){
					//解析数组数据
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
					//解析对象数据
					Element xMessage = xData.getChild(msgFileds[i].getFieldTag());
					Message objectMessage = OCIConfig.getMessageByID(msgFileds[i].getObjectName());
					decomposeXMLFixSize(xMessage, objectMessage);
					msgFileds[i].setObjectMessage(objectMessage);
				}else{
					String value = xData.getChild(msgFileds[i].getFieldTag()).getValue();
					if(value != null&&!value.trim().equals("")){
						msgFileds[i].setParsedValue(value);
						//不判断是否有小数点，默认就NDS用当无小数点来用，默认后两位之前省略小数点
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
						}else{	//其他都赋原值
							msgFileds[i].setFieldValue(value.trim());
						}
					}
				}		
			}catch(Exception e){
				ARE.getLog().error("解包定长OPF Xml格式报文:"+message.getId()+":"+msgFileds[i]);
				ExceptionFactory.parse(e, "解包定长OPF Xml格式报文:"+message.getId()+":"+msgFileds[i]);
			}
		}

	}
	
	
}
