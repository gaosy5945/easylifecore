package com.amarsoft.app.oci;


import java.util.HashMap;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCIConnection;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;
import java.sql.Connection;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

/**
 * <p>读取配置文件《OCIConfig。xml》并初始化实时接口模块环境</p>
 * @author xjzhao 2014/10/13
 *
 */
public class OCIConfig extends AbstractCache{
	
	 //OCI配置文件
	 private static final String DEFAULT_MESSAGE_CONCFIG = "OCIConfig.xml";
	 
	 //定义返回正常Code
	 public static final String RETURN_CODE_NORMAL = "000000000000";
	 
	 //OCI配置定义的属性信息
	 private static HashMap<String,Object> properties = new HashMap<String,Object>();
	 
	 //定义外围系统id、名称、接入方式 ：WebService、Socket等，开发人员可以根据不同的接入方式定义传输需要的参数信息。
	 private static HashMap<String,OCIConnection> connections = new HashMap<String,OCIConnection>();
	 
	 //所有的交易定义，建立每一个Transaction的ClientID，与一个Transaction对应关系
	 private static HashMap<String, OCITransaction> allClientTransaction=new HashMap<String, OCITransaction>();
	 
	 //所有的交易定义，建立每一个Transaction的ServerID，与一个Transaction对应关系
	 private static HashMap<String, OCITransaction> allServerTransaction=new HashMap<String, OCITransaction>();
	 
	 //所有的message的定义,建立每一个MESSAGE的ID，与一个MESSAGE对应关系
	 private static HashMap<String, Message> allMessage = new HashMap<String, Message>();
	 
	 //是否已经读取配置信息
	 private static boolean haveReadConfigFile = false;
	 
	 /**
	  * 已字符串方式获取配置的属性信息
	  * @param key
	  * @param defaultValue
	  * @return
	  */
	 public static String getProperty(String key,String defaultValue)
	 {
		 if(key == null) return defaultValue;
		 if(properties.containsKey(key))
			 return String.valueOf(properties.get(key));
		 else
			 return defaultValue;
	 }
	 
	 /**
	  * 已布尔值方式获取配置的属性信息
	  * @param key
	  * @param defaultValue
	  * @return
	  */
	 public static boolean getProperty(String key,boolean defaultValue)
	 {
		 if(key == null) return defaultValue;
		 if(properties.containsKey(key.toLowerCase()))
			 return Boolean.valueOf(String.valueOf(properties.get(key.toLowerCase())));
		 else
			 return defaultValue;
	 }
	 
	 /**
	  * 已字符串方式获取外围系统连接
	  * @param id
	  * @param key
	  * @param defaultValue
	  * @return
	  */
	 public static OCIConnection getConnection(String id)
	 {
		 if(id == null) return null;
		 if(connections.containsKey(id.toLowerCase()))
			 return connections.get(id.toLowerCase());
		 else
			 return null;
	 }
	 
	 /**
	  * <p>根据交易ID获得交易对象OCITransaction</p>
	  * @param ID	交易ID
	  * @return		OCITransaction
	  * @throws Exception
	  */
	 public static OCITransaction getTransactionByClientID(String ID,Connection dbconn) throws Exception {
		 OCITransaction transaction = (OCITransaction)allClientTransaction.get(ID).copyTransaction();
		 transaction.setDbconnection(dbconn);
	     return transaction;
	 }
	 
	 /**
	  * <p>根据MessageID获得消息对象Message</p>
	  * @param ID	MessageID
	  * @return		Message
	  * @throws Exception
	  */
	 public static Message getMessageByID(String ID) throws Exception {
	        return (Message)(allMessage.get(ID)).copyMessage();
	 }

	 /**
	  * <p>根据serviceCode 得到指定的OCITransaction</p>
	  * @param serviceCode 
	  * @param deployID
	  * @return
	 * @throws Exception
	  */
	 public static OCITransaction getTransactionByServerID(String ID,Connection dbconn) throws Exception {
		 OCITransaction transaction = (OCITransaction)allServerTransaction.get(ID).copyTransaction();
		 transaction.setDbconnection(dbconn);
		 return transaction;
	 }
	 
	/**
	 * 本函数是获取交易集合的入口方法，<br>用于从一个xml文件中获取交易报文结构定义，并用此构在报文集合和他下属的报文结构
	 * 
	 * @param defineFile
	 *            XML格式的定义文件
	 * @return 交易集合
	 * @throws OCIException
	 */
	public static boolean loadOCIConfig(boolean reload) throws Exception {
        if ((!haveReadConfigFile) || reload){
            haveReadConfigFile = true;
            createTransactionListFromXml(ARE.getProperty("OCIConfig", DEFAULT_MESSAGE_CONCFIG));
        }
        return true;
	}
	
	/**
	 * 本函数是获取交易集合的入口方法，用于从一个xml文件中获取交易报文结构定义，并用此构在报文集合和他下属的报文结构
	 * 
	 * @param defineFile
	 *            XML格式的定义文件
	 * @return 交易集合
	 * @throws OCIException
	 */
	public static void createTransactionListFromXml(String defineFile)
			throws Exception {
		String rootPath = ARE.getProperty("ConfigPath");
		if(rootPath == null) throw new Exception("系统配置文件路径未初始化，请联系管理员重新加载！");
		
		//定义缓存内部变量
		//OCI配置定义的属性信息
		HashMap<String,Object> properties = new HashMap<String,Object>();
		 
		//定义外围系统id、名称、接入方式 ：WebService、Socket等，开发人员可以根据不同的接入方式定义传输需要的参数信息。
		HashMap<String,OCIConnection> connections = new HashMap<String,OCIConnection>();
		
		//所以message缓存
		HashMap<String, Message> allMessage = new HashMap<String, Message>();
		
		//所以交易缓存
		HashMap<String, OCITransaction> allClientTransaction = new HashMap<String, OCITransaction>();
		HashMap<String, OCITransaction> allServerTransaction = new HashMap<String, OCITransaction>();
		
		//配置文件绝对路径
		String absCfgfile= ARE.getProperty("ConfigPath")+defineFile;
		
		SAXBuilder b = new SAXBuilder(); 
		Document doc = b.build(absCfgfile);
		
		ARE.getLog().info("=========================开始载入OCI接口定义信息========================");
		Element xRoot = doc.getRootElement();
		Tools.xmlTagToLower(xRoot);
		Element el_properties = xRoot.getChild("properties");
		if(el_properties.getChildren()!=null)
		{
			for(Object o:el_properties.getChildren())
			{
				Element property = (Element)o;
				properties.put(property.getAttributeValue("name"),property.getAttributeValue("value"));
				ARE.getLog().debug("[OCI] Property[ "+property.getAttributeValue("name")+" = "+property.getAttributeValue("value")+" ]");
			}
		}
		
		Element el_connections = xRoot.getChild("connections");
		if(el_connections.getChildren()!=null)
		{
			for(Object o:el_connections.getChildren())
			{
				Element connection = (Element)o;
				if(connections.containsKey(connection.getAttributeValue("id"))) throw new Exception("OCI中接口connection配置出现冲突，请检查！");
				OCIConnection conn = new OCIConnection();
				connections.put(connection.getAttributeValue("id").toLowerCase(), conn);
				conn.setProperty("id", connection.getAttributeValue("id"));
				conn.setProperty("name", connection.getAttributeValue("name"));
				conn.setProperty("type", connection.getAttributeValue("type"));
				ARE.getLog().debug("[OCI] Connection[ sysid = "+connection.getAttributeValue("id")+" ] [ sysname = "+connection.getAttributeValue("name")+" ] [ type = "+connection.getAttributeValue("type")+" ]");
				
				if(connection.getChildren()!=null)
				{
					for(Object oo:connection.getChildren())
					{
						Element e = (Element)oo;
						
						if("iMessages".equalsIgnoreCase(e.getName()))
		        		{
		        			List<Element> messages = e.getChildren();
		        			if(messages!=null)
		        			{
		        				for(Element message:messages)
		        				{
		        					conn.setIMessage(message.getAttributeValue("name"), message.getAttributeValue("value"));
		        				}
		        			}
		        		}
		        		else if("oMessages".equalsIgnoreCase(e.getName()))
		        		{
		        			List<Element> messages = e.getChildren();
		        			if(messages!=null)
		        			{
		        				for(Element message:messages)
		        				{
		        					conn.setOMessage(message.getAttributeValue("name"), message.getAttributeValue("value"));
		        				}
		        			}
		        		}else if("namespaces".equalsIgnoreCase(e.getName()))
		        		{
		        			List<Element> messages = e.getChildren();
		        			if(messages!=null)
		        			{
		        				for(Element message:messages)
		        				{
		        					conn.setNameSpace(message.getAttributeValue("name"), message.getAttributeValue("value"));
		        				}
		        			}
		        		}
						else
						{	
							conn.setProperty(e.getAttributeValue("name"),e.getAttributeValue("value"));
						}
					}
				}
				
			}
		}
		
		//设置静态变量
		OCIConfig.properties = properties;
		OCIConfig.connections = connections;
		
		Element OCIDefines= xRoot.getChild("OCIDefines".toLowerCase());
		List<Element> definelist= OCIDefines.getChildren("OCIDefine".toLowerCase());
		
		for(Element define :definelist){	//遍历所有Message
			String configxml= define.getAttributeValue("filename");
			boolean enable= Boolean.valueOf(define.getAttributeValue("enable")) ;
			if(enable){	//应用可用
				Document subapp= b.build(rootPath+"/"+configxml);				
				Element subappRoot= subapp.getRootElement();	//每个应用配置的根
				Tools.xmlTagToLower(subappRoot);
				//取得message信息
				Element xMessageList = subappRoot.getChild("Messages".toLowerCase());					
				List<Element> mList = xMessageList.getChildren("Message".toLowerCase());
				if(mList!=null){
					for(Element xMessage:mList){
						Message messageMeta=Message.buildMessage(xMessage);
						allMessage.put(messageMeta.getId(), messageMeta);
					}	
				}
				
				Element xTransactionList = subappRoot.getChild("Transactions".toLowerCase());
				List<Element> tList = xTransactionList.getChildren("Transaction".toLowerCase());
				if(tList!=null){
					for (Element xTransaction :tList ) {
						OCITransaction transaction = OCITransaction.buildOCITransaction(xTransaction,allMessage);
						if(transaction.getClientID() != null && !"".equals(transaction.getClientID()))
						{
							allClientTransaction.put(transaction.getClientID(),transaction);
						}
						
						if(transaction.getServerID() != null && !"".equals(transaction.getServerID()))
						{
							allServerTransaction.put(transaction.getServerID(),transaction);
						}
					}	
				}
			}
		}	
		ARE.getLog().info("=========================完成载入OCI接口定义信息========================");
		
		//设置静态变量
		OCIConfig.allMessage = allMessage;
		OCIConfig.allClientTransaction = allClientTransaction;
		OCIConfig.allServerTransaction = allServerTransaction;
	}

	@Override
	public void clear() throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public boolean load(Transaction arg0) throws Exception {
		// TODO Auto-generated method stub
		loadOCIConfig(true);
		return true;
	}
	
	
}
