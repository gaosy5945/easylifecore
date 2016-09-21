package com.amarsoft.app.oci.bean;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.jdom.Element;

import com.amarsoft.app.base.businessobject.BusinessObjectKeyFactory;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.comm.ClientBean;
import com.amarsoft.app.oci.comm.Communicator;
import com.amarsoft.app.oci.comm.ServerBean;
import com.amarsoft.are.lang.DateX;
/**
 * <p>实时接口交易对象</p>
 * @author ycliu
 *
 */
public class OCITransaction {
	private String clientID; //接口客户端编号，唯一键
	private String serverID; //接口服务端编号，唯一键
	private String description; //接口描述
	private String connectionID; //关联连接编号
	private String type; //接口类型 Client、Server
	private HashMap<String,String> properties = new HashMap<String,String>(); //接口定义其他可变化属性
	private LinkedHashMap<String,Message> iMessages = new LinkedHashMap<String,Message>(); //接口需要的输入Message定义
	private LinkedHashMap<String,Message> oMessages = new LinkedHashMap<String,Message>(); //接口需要的输出Message定义
	private HashMap<String,String> namespaces = new HashMap<String,String>(); //XML中定义的命名空间
	private Communicator communicator;// 通讯控制对象，控制所有交易过程的进行
	private Connection dbconnection;//数据库连接
	private Object requestData;//请求对象
	private Object responseData;//返回对象
	
	/**
	 * 加载Transaction对象
	 * @param xData
	 * @param allMessage
	 * @return
	 * @throws Exception
	 */
	public static OCITransaction buildOCITransaction(Element xData,Map<String, Message> allMessage) throws Exception{
		OCITransaction transaction = new OCITransaction();
		String clientID = OCIXMLTool.getValue(xData, "clientid");
		String serverID = OCIXMLTool.getValue(xData, "serverid");
		if(clientID == null && serverID == null) throw new Exception(MessageConstants.ERROR_XML_DEFINE_TRANSACTION_ID);
		transaction.clientID = clientID;
		transaction.serverID = serverID;
		transaction.description = OCIXMLTool.getValueWithException(xData, "description" , MessageConstants.ERROR_XML_DEFINE_TRANSACTION_DESCRIPTION);
		transaction.connectionID = OCIXMLTool.getValueWithException(xData, "connectionid", MessageConstants.ERROR_XML_DEFINE_TRANSACTION_CONNECTION);
		OCIConnection connection = OCIConfig.getConnection(transaction.connectionID); 
		if(connection == null) throw new Exception(MessageConstants.ERROR_XML_DEFINE_TRANSACTION_CONNECTION);
		transaction.properties.putAll(connection.getProperties());
		transaction.namespaces.putAll(connection.getNamespaces());
		transaction.type =OCIXMLTool.getValueWithException(xData, "type", MessageConstants.ERROR_XML_DEFINE_TRANSACTION_TYPE) ;
        for(String key:connection.getIMessages().keySet()){
        	transaction.iMessages.put(key,  allMessage.get(connection.getIMessage(key)));
        }
        for(String key:connection.getOMessages().keySet()){
        	transaction.oMessages.put(key,  allMessage.get(connection.getOMessage(key)));
        }
        loadChildElement(xData , transaction , allMessage);
        loadCommunicator(transaction);
		return transaction;
	}
	
	/**
	 * 加载项下信息
	 * @param xData
	 * @param transaction
	 * @param allMessage
	 */
	private static void loadChildElement(Element xData, OCITransaction transaction, Map<String, Message> allMessage){
		@SuppressWarnings("unchecked")
		List<Element> list = xData.getChildren();
		if(list == null )return;
		for(Element element : list){
			if("iMessages".equalsIgnoreCase(element.getName())){
				loadMessage(element , transaction.iMessages , allMessage );
			}else if("oMessages".equalsIgnoreCase(element.getName())){
				loadMessage(element, transaction.oMessages, allMessage);
			}else if("namespaces".equalsIgnoreCase(element.getName())){
				loadNamespace(element, transaction.namespaces);
			}else{
				loadProperty(element, transaction.properties);
			}	
		}
	}
	

	private static void loadMessage(Element xData, Map<String, Message> messageList, Map<String, Message> allMessage){
		@SuppressWarnings("unchecked")
		List<Element> messages = xData.getChildren();
		if(messages == null) return;
		for(Element message:messages){
			messageList.put(message.getAttributeValue("name"), allMessage.get(message.getAttributeValue("value")));
		}
	}
	
	private static void loadNamespace(Element xData, Map<String, String> namespaces){
		@SuppressWarnings("unchecked")
		List<Element> messages = xData.getChildren();
		if(messages == null) return;
		for(Element message:messages){
			namespaces.put(message.getAttributeValue("name"), message.getAttributeValue("value"));
		}
	}
	
	private static void loadProperty(Element xData, Map<String, String> property){
		property.put(xData.getAttributeValue("name"), xData.getAttributeValue("value"));
	}	
		
	private static void loadCommunicator(OCITransaction transaction) throws Exception{
        if(transaction.type.equalsIgnoreCase(MessageConstants.TYPE_CLIENT))
        	transaction.communicator = new ClientBean(transaction);
        else if(transaction.getType().equalsIgnoreCase(MessageConstants.TYPE_SERVER))
        	transaction.communicator = new ServerBean(transaction);
        else
        	throw new Exception(MessageConstants.ERROR_XML_DEFINE_TRANSACTION_TYPE);
	}
	
	/**
	 * 复制对象
	 * @return
	 * @throws Exception
	 */
	public OCITransaction copyTransaction() throws Exception{
		OCITransaction transaction = new OCITransaction();
		transaction.clientID = this.clientID;
		transaction.serverID = this.serverID;
		transaction.connectionID = this.connectionID;
		transaction.description = this.description;
		transaction.type = this.type;
		transaction.iMessages = copyLMap(this.iMessages);
		transaction.oMessages = copyLMap(this.oMessages);
		transaction.properties = (HashMap<String, String>)this.properties.clone();
		transaction.namespaces = (HashMap<String, String>)this.namespaces.clone();
		loadCommunicator(transaction);
		return transaction;
	}
	
	private LinkedHashMap<String, Message> copyLMap(LinkedHashMap<String, Message> source){
		LinkedHashMap<String, Message> result = new LinkedHashMap<String, Message>();
		for(String s : source.keySet())
			result.put(s, source.get(s).copyMessage());
		return result;
	}
	
	/**
	 * 填充传入值
	 * @param paraHashMap
	 * @param dataMap
	 * @param connnection
	 * @throws SQLException
	 * @throws Exception
	 */
	public void fillMessage(Map<String, String> paraHashMap, Map<String, Object> dataMap, Connection connnection) throws SQLException, Exception{
		if(paraHashMap!=null){
			String datasource = OCIConfig.getProperty("DataSource", "als");
			String transSeqNo = "";//BusinessObjectKeyFactory.getSerialNo(datasource,"INTF_TRANSACTION","TRANSEQNO","yyyyMMdd","00000000",new DateX(),5000);
			properties.put("MsgId", UUID.randomUUID().toString());
			properties.put("TranDate", DateHelper.getBusinessDate().replaceAll("/", ""));
			properties.put("TranTime",DateX.format(new Date(), "HHmmssSSS"));
			properties.put("TranSeqNo", this.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+transSeqNo);
			properties.put("GlobalSeqNo", this.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+transSeqNo);
			properties.putAll(paraHashMap);
		}
		for(String key:iMessages.keySet()){
			Message iMessage = iMessages.get(key);
			setAllValue(paraHashMap,dataMap, iMessage, connnection);
		}
	}
	
	private List<Message> setAllValue(Map<String, String> para,Map<String, Object> dataMap,Message message,Connection connnection) throws SQLException, Exception {
		Object data = null;
		List<Message> result = null;
		String sqlRowClause = "";
		if(dataMap!=null&&dataMap.size()>0){
			data = dataMap.get(message.getId());//取得 where 条件
		}
		//支持传入数组
		if(data instanceof String || data == null){
			if(data != null){
				sqlRowClause = dataMap.get(message.getId() + "_ROWNUM") != null?(String)dataMap.get(message.getId() + "_ROWNUM"):"";
			}
			result=setAllValueByMessage(para,(String)data,sqlRowClause,message,connnection);
		}else if(data instanceof List){
			result=setAllValueByMessage((ArrayList)data,message,connnection);
		}else throw new Exception("系统接口暂时不支持此数据类型，请检查！");
		fillStructedField(result , para, dataMap , connnection);
		return result;
    }
	
	/**
	 * 普通类填充值
	 * @param sqlWhereClause
	 * @param sqlRowClause
	 * @param message
	 * @param connnection
	 * @return
	 * @throws Exception
	 */
	private List<Message> setAllValueByMessage(Map<String, String> para,String sqlWhereClause, String sqlRowClause,Message message,Connection connnection) throws  Exception {
		List<Message> messageArray = new ArrayList<Message>();
		if(null==sqlWhereClause||"".equals(sqlWhereClause)){
			if(null==message.getSelectSQL()||"".equals(message.getSelectSQL())){
				setAllValueByDefault(message , null , null);
				messageArray.add(message);
			}	
			return messageArray;
		}
		//拼Sql查询语句
		String selectSql = " select * from (select rownum as row_id, t.* from(" + message.getSelectSQL()+" "+sqlWhereClause + ") t) t ";
		if(!sqlRowClause.equals("")) selectSql += sqlRowClause;
		selectSql = replaceSelectSql(selectSql,para);
		executeSQL(connnection, message , selectSql , messageArray);
		return messageArray;
	}
	
	/**
	 * 数组类填充值
	 * @param ListData
	 * @param message
	 * @param connnection
	 * @return
	 * @throws Exception
	 */
	private ArrayList<Message> setAllValueByMessage(List<Map<String,String>> ListData,Message message,Connection connnection) throws  Exception {
		ArrayList<Message> messageArray = new ArrayList<Message>();
		Message messageTemp=(Message)message.copyMessage();
		if(null==ListData||ListData.size()==0) {
			setAllValueByDefault(messageTemp , null , null);
			messageArray.add(messageTemp);
			return messageArray;
		}
		for(int j = 0; j < ListData.size(); j ++){
			setAllValueByDefault(messageTemp , null ,ListData.get(j));
			messageArray.add(messageTemp);
			messageTemp=(Message)message.copyMessage();
		}
		return messageArray;
	}
	
	private void executeSQL(Connection conn , Message message , String selectSql , List<Message> messageArray) throws Exception{
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(selectSql);
		while(rs.next()){
			setAllValueByDefault(message , rs , null);
			messageArray.add(message);
			message = message.copyMessage();
		}
	    rs.close();
	    stmt.close();
	}
	
	//先填充默认值 再填充sql值 最后填充字段属性
	private void setAllValueByDefault(Message message , ResultSet rs, Map<String, String> map) throws Exception{
		Field[]  msgFileds = message.getFields();
		for (int i = 0; i < msgFileds.length; i++){
			setFieldValue(msgFileds[i] , this.properties);
			if(rs != null) setFieldValueBySQL(msgFileds[i], rs);
			if(map != null) setFieldByArray(msgFileds[i], map);
		}
	}
	//填充普通值
	private void setFieldValue(Field field , Map<String,String> map){
	    if(field.getValueSource() == null || !field.getValueSource().equals("Default") || field.getFieldValue() == null || !field.getFieldValue().equals(""))
			return;
       	String defualtValue = field.getDefaultValue();
       	if(defualtValue.startsWith("#Constants.")){
       		String fieldValue = map.get(defualtValue.substring("#Constants.".length()));
       		fillFieldValue(field, fieldValue);
       	}else
       		field.setFieldValue(defualtValue);
       	fillFiedlAttribute(field , map);
	}
	//填充SQL值
	private void setFieldValueBySQL(Field field , ResultSet rs) throws SQLException{
    	if(field.getValueSource().equals("SelectSQL")){
    		String s = rs.getString(field.getTableField());
    		fillFieldValue(field, s);
    	}
	}
	//填充数组值
	private void setFieldByArray(Field field , Map<String,String> data){
		if(field.getValueSource().equals("Default")){
    		String s=String.valueOf(data.get(field.getFieldTag()));
    		fillFieldValue(field, s);
    	}
		fillFiedlAttribute(field , data);
	}
	
	private void fillFieldValue(Field field , String value){
		if(value == null)
			fillFieldDefalutValue(field);
		else
			field.setFieldValue(value.trim());
	}
	
	private void fillFieldDefalutValue(Field field){
		if(field.getDataType().equals(MessageConstants.DATA_TYPE_INT)){
			field.setFieldValue("0");
   		}else if(field.getDataType().equals(MessageConstants.DATA_TYPE_DOUBLE)){
   			field.setFieldValue("0.0");
   		}else if(field.getDataType().equals(MessageConstants.DATA_TYPE_STRING) || 
   				field.getDataType().equals(MessageConstants.DATA_VAR_LLL)){
   			field.setFieldValue("");
   		}
	}
	
	//填充xml的属性
	private void fillFiedlAttribute(Field field, Map<String, String> data){
		List<Field> attributes = field.getAttributes();
		for(Field temp : attributes)
			setFieldValue(temp , data);
	}
	
	/**
	 * 查看Message下的Object或者Array类型的Filed进行加载
	 * @param list
	 * @param dataMap
	 * @param connnection
	 * @throws Exception
	 */
	private void fillStructedField(List<Message> list, Map<String, String> para, Map<String, Object> dataMap, Connection connnection) throws Exception{
		for(int n=0;n<list.size();n++){
			Field[]  msgFileds = list.get(n).getFields();
			for (int i = 0; i < msgFileds.length; i++) {
		        if(MessageConstants.DATA_TYPE_ARRAY.equals(msgFileds[i].getDataType())){
		        	Message fieldMessage = OCIConfig.getMessageByID(msgFileds[i].getArrayName());
		        	List<Message> fieldArrayValue=setAllValue(para,dataMap,fieldMessage,connnection);
		        	msgFileds[i].setFieldArrayValue(fieldArrayValue);
		        	//设置数组长度值
		        	for (int j = 0; j < msgFileds.length; j++) {
		        		if(msgFileds[j].getValueSource().equals(MessageConstants.DATA_TYPE_ARRAY)&&msgFileds[j].getDefaultValue().equals(msgFileds[i].getArrayName())){
		        			msgFileds[j].setFieldValue(String.valueOf(msgFileds[i].getFieldArrayValue().size()));
		        		}
		        	}
		        }
		        if(MessageConstants.DATA_TYPE_OBJECT.equals(msgFileds[i].getDataType())){
		        	Message objectMessage = OCIConfig.getMessageByID(msgFileds[i].getObjectName());
		        	String messidxx = objectMessage.getId();
		        	
		        	List<Message> objects = setAllValue(para,dataMap,objectMessage,connnection);
		        	if(objects != null && objects.size() > 0)
		        	{
		        		msgFileds[i].setObjectMessage((Message)objects.get(0));
		        	}
		        	else
		        	{
		        		msgFileds[i].setObjectMessage(objectMessage);
		        	}
		        }
		     }
		}
	}
	
	/**
	 * 填充transfaction中对象的值
	 * @param paraHashMap 交易的设置的缺省参数
	 * @param connnection
	 */
	public void createResponseMessage(Map<String, String> paraHashMap, Map<String,Object> dataMap, Connection connnection) throws SQLException, Exception{
		if(paraHashMap!=null){
			String datasource = OCIConfig.getProperty("DataSource", "als");
			String transSeqNo = "";//BusinessObjectKeyFactory.getSerialNo(datasource,"INTF_TRANSACTION","TRANSEQNO","yyyyMMdd","00000000",new DateX(),5000);
			properties.put("MsgId", this.iMessages.get("SysHeader").getFieldValue("MsgId"));
			properties.put("TargetSysId", this.iMessages.get("SysHeader").getFieldValue("ConsumerId"));
			properties.put("GlobalSeqNo", this.iMessages.get("SysHeader").getFieldValue("GlobalSeqNo"));
			properties.put("TranSeqNo", this.iMessages.get("SysBody").getFieldByTag("ReqSvcHeader").getObjectMessage().getFieldValue("TranSeqNo"));
			properties.put("TranDate", DateHelper.getBusinessDate().replaceAll("/", ""));
			properties.put("TranTime",DateX.format(new Date(), "HHmmssSSS"));
			properties.put("BackendSeqNo", this.getProperty("ConsumerId")+DateHelper.getBusinessDate().replaceAll("/", "").substring(0, 6)+transSeqNo);
			properties.putAll(paraHashMap);
		}
		for(String key:this.oMessages.keySet()){
			Message oMessage = this.oMessages.get(key);
			setAllValue(paraHashMap,dataMap, oMessage, connnection);
		}
	}

	public String replaceSelectSql(String sql,Map<String,String> para){
		String newSql = sql;
		if(para == null) return newSql;
		Iterator it = para.keySet().iterator();
		while(it.hasNext()){
			String key = (String)it.next();
				newSql = StringHelper.replaceAllIgnoreCase(newSql,":"+key, para.get(key));
		}
		return newSql;
	}
	
	@Override
	public String toString() {
		return "OCITransaction [clientID=" + clientID + ", serverID="
				+ serverID + ", description=" + description + ", connectionID="
				+ connectionID + ", type=" + type + ", properties="
				+ properties + ", iMessages=" + iMessages + ", oMessages="
				+ oMessages + ", namespaces=" + namespaces + ", communicator="
				+ communicator + ", dbconnection=" + dbconnection
				+ ", requestData=" + requestData + ", responseData="
				+ responseData + "]";
	}

	public String getProperty(String key) {
		return properties.get(key);
	}
	public String getClientID() {
		return clientID;
	}
	public void setClientID(String clientID) {
		this.clientID = clientID;
	}
	public String getServerID() {
		return serverID;
	}
	public void setServerID(String serverID) {
		this.serverID = serverID;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getConnectionID() {
		return connectionID;
	}
	public void setConnectionID(String connectionID) {
		this.connectionID = connectionID;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public HashMap<String, String> getProperties() {
		return properties;
	}
	public void setProperties(HashMap<String, String> properties) {
		this.properties = properties;
	}
	public Map<String, Message> getIMessages() {
		return iMessages;
	}
	public void setiMessages(LinkedHashMap<String, Message> iMessages) {
		this.iMessages = iMessages;
	}
	public Map<String, Message> getOMessages() {
		return oMessages;
	}
	public void setoMessages(LinkedHashMap<String, Message> oMessages) {
		this.oMessages = oMessages;
	}
	public HashMap<String, String> getNamespaces() {
		return namespaces;
	}
	public void setNamespaces(HashMap<String, String> namespaces) {
		this.namespaces = namespaces;
	}
	public Communicator getCommunicator() {
		return communicator;
	}
	public void setCommunicator(Communicator communicator) {
		this.communicator = communicator;
	}
	public Connection getDbconnection() {
		return dbconnection;
	}
	public void setDbconnection(Connection dbconnection) {
		this.dbconnection = dbconnection;
	}
	public Object getRequestData() {
		return requestData;
	}
	public void setRequestData(Object requestData) {
		this.requestData = requestData;
	}
	public Object getResponseData() {
		return responseData;
	}
	public void setResponseData(Object responseData) {
		this.responseData = responseData;
	}
	
	public Message getIMessage(String key){
		return this.iMessages.get(key);
	}
	
	public Message getOMessage(String key){
		return this.oMessages.get(key);
	}
	
	
	public static String formatNumber(double d,int w) throws Exception{
		NumberFormat localNumberFormat = NumberFormat.getInstance();
		localNumberFormat.setMinimumFractionDigits(w);
		localNumberFormat.setMaximumFractionDigits(w);
		return localNumberFormat.format(d).replaceAll(",", "");
	}
}