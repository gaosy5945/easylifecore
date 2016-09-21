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
 * <p>��ȡ�����ļ���OCIConfig��xml������ʼ��ʵʱ�ӿ�ģ�黷��</p>
 * @author xjzhao 2014/10/13
 *
 */
public class OCIConfig extends AbstractCache{
	
	 //OCI�����ļ�
	 private static final String DEFAULT_MESSAGE_CONCFIG = "OCIConfig.xml";
	 
	 //���巵������Code
	 public static final String RETURN_CODE_NORMAL = "000000000000";
	 
	 //OCI���ö����������Ϣ
	 private static HashMap<String,Object> properties = new HashMap<String,Object>();
	 
	 //������Χϵͳid�����ơ����뷽ʽ ��WebService��Socket�ȣ�������Ա���Ը��ݲ�ͬ�Ľ��뷽ʽ���崫����Ҫ�Ĳ�����Ϣ��
	 private static HashMap<String,OCIConnection> connections = new HashMap<String,OCIConnection>();
	 
	 //���еĽ��׶��壬����ÿһ��Transaction��ClientID����һ��Transaction��Ӧ��ϵ
	 private static HashMap<String, OCITransaction> allClientTransaction=new HashMap<String, OCITransaction>();
	 
	 //���еĽ��׶��壬����ÿһ��Transaction��ServerID����һ��Transaction��Ӧ��ϵ
	 private static HashMap<String, OCITransaction> allServerTransaction=new HashMap<String, OCITransaction>();
	 
	 //���е�message�Ķ���,����ÿһ��MESSAGE��ID����һ��MESSAGE��Ӧ��ϵ
	 private static HashMap<String, Message> allMessage = new HashMap<String, Message>();
	 
	 //�Ƿ��Ѿ���ȡ������Ϣ
	 private static boolean haveReadConfigFile = false;
	 
	 /**
	  * ���ַ�����ʽ��ȡ���õ�������Ϣ
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
	  * �Ѳ���ֵ��ʽ��ȡ���õ�������Ϣ
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
	  * ���ַ�����ʽ��ȡ��Χϵͳ����
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
	  * <p>���ݽ���ID��ý��׶���OCITransaction</p>
	  * @param ID	����ID
	  * @return		OCITransaction
	  * @throws Exception
	  */
	 public static OCITransaction getTransactionByClientID(String ID,Connection dbconn) throws Exception {
		 OCITransaction transaction = (OCITransaction)allClientTransaction.get(ID).copyTransaction();
		 transaction.setDbconnection(dbconn);
	     return transaction;
	 }
	 
	 /**
	  * <p>����MessageID�����Ϣ����Message</p>
	  * @param ID	MessageID
	  * @return		Message
	  * @throws Exception
	  */
	 public static Message getMessageByID(String ID) throws Exception {
	        return (Message)(allMessage.get(ID)).copyMessage();
	 }

	 /**
	  * <p>����serviceCode �õ�ָ����OCITransaction</p>
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
	 * �������ǻ�ȡ���׼��ϵ���ڷ�����<br>���ڴ�һ��xml�ļ��л�ȡ���ױ��Ľṹ���壬���ô˹��ڱ��ļ��Ϻ��������ı��Ľṹ
	 * 
	 * @param defineFile
	 *            XML��ʽ�Ķ����ļ�
	 * @return ���׼���
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
	 * �������ǻ�ȡ���׼��ϵ���ڷ��������ڴ�һ��xml�ļ��л�ȡ���ױ��Ľṹ���壬���ô˹��ڱ��ļ��Ϻ��������ı��Ľṹ
	 * 
	 * @param defineFile
	 *            XML��ʽ�Ķ����ļ�
	 * @return ���׼���
	 * @throws OCIException
	 */
	public static void createTransactionListFromXml(String defineFile)
			throws Exception {
		String rootPath = ARE.getProperty("ConfigPath");
		if(rootPath == null) throw new Exception("ϵͳ�����ļ�·��δ��ʼ��������ϵ����Ա���¼��أ�");
		
		//���建���ڲ�����
		//OCI���ö����������Ϣ
		HashMap<String,Object> properties = new HashMap<String,Object>();
		 
		//������Χϵͳid�����ơ����뷽ʽ ��WebService��Socket�ȣ�������Ա���Ը��ݲ�ͬ�Ľ��뷽ʽ���崫����Ҫ�Ĳ�����Ϣ��
		HashMap<String,OCIConnection> connections = new HashMap<String,OCIConnection>();
		
		//����message����
		HashMap<String, Message> allMessage = new HashMap<String, Message>();
		
		//���Խ��׻���
		HashMap<String, OCITransaction> allClientTransaction = new HashMap<String, OCITransaction>();
		HashMap<String, OCITransaction> allServerTransaction = new HashMap<String, OCITransaction>();
		
		//�����ļ�����·��
		String absCfgfile= ARE.getProperty("ConfigPath")+defineFile;
		
		SAXBuilder b = new SAXBuilder(); 
		Document doc = b.build(absCfgfile);
		
		ARE.getLog().info("=========================��ʼ����OCI�ӿڶ�����Ϣ========================");
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
				if(connections.containsKey(connection.getAttributeValue("id"))) throw new Exception("OCI�нӿ�connection���ó��ֳ�ͻ�����飡");
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
		
		//���þ�̬����
		OCIConfig.properties = properties;
		OCIConfig.connections = connections;
		
		Element OCIDefines= xRoot.getChild("OCIDefines".toLowerCase());
		List<Element> definelist= OCIDefines.getChildren("OCIDefine".toLowerCase());
		
		for(Element define :definelist){	//��������Message
			String configxml= define.getAttributeValue("filename");
			boolean enable= Boolean.valueOf(define.getAttributeValue("enable")) ;
			if(enable){	//Ӧ�ÿ���
				Document subapp= b.build(rootPath+"/"+configxml);				
				Element subappRoot= subapp.getRootElement();	//ÿ��Ӧ�����õĸ�
				Tools.xmlTagToLower(subappRoot);
				//ȡ��message��Ϣ
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
		ARE.getLog().info("=========================�������OCI�ӿڶ�����Ϣ========================");
		
		//���þ�̬����
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
