package com.amarsoft.app.oci;


/**
 * <p>静态常量类，描述了实时接口中使用的常量<p>
 * @author xjzhao
 */
public class MessageConstants {
	/**
	 * Data Structure
	 */
	public static final String DATA_TYPE_STRING = "string";	//字符型数据
	
	public static final String DATA_TYPE_INT = "int";	//整型数据
	
	public static final String DATA_TYPE_DOUBLE = "double"; //数值型数据

	public static final String DATA_TYPE_ARRAY = "array";	//数组型数据
	
	public static final String DATA_TYPE_OBJECT = "object";	//对象型数据
	
	public static final String DATA_TYPE_XML = "xml";	//xml型数据
	
	public static final String DATA_TYPE_OMELEMENT = "omelement";
	
	public static final String DATA_TYPE_BYTE = "byte";	//二进制型数据
	
	public static final String DATA_VAR_LL = "LLVAR";	//变长字符数据,字符长度小于100
	
	public static final String DATA_VAR_LLL = "LLLVAR";	//变长字符数据,字符长度小于1000

	/**
	 * Transaction Role  client/Server
	 */
	public static final String TYPE_CLIENT = "CLIENT";
	
	public static final String TYPE_SERVER = "SERVER";
	
	/**
	 * Transaction Type  client/Server
	 */
	public static final String TRANS_TYPE_WEBSERVICE = "WEBSERVICE";
	
	public static final String TRANS_TYPE_SOCKET = "SOCKET";
	
	public static final String TRANS_TYPE_MQ = "MQ";

	/**
	 * 组包解包类名
	 */
	public static final String BUILD_CLASS_NDS = "com.amarsoft.oci.parser.impl.OPFParser";
	public static final String BUILD_CLASS_CBC = "com.amarsoft.oci.parser.impl.CBCParser";
	
	/**
	 * 是否有报文头 Y 表示有  N 表示没有
	 */
	public static final String SYS_HEAD_YES = "Y";
	
	public static final String SYS_HEAD_NO = "N";
	
	/**
	 * 是否有小数点 Y 表示有  N 表示没有
	 */
	public static final String DECIMAL_POINT_YES = "Y";
	
	public static final String DECIMAL_POINT_NO = "N";
	
	
	
	/**
	 * <p>报文传输数据元，即解析报文的最小单位， 
	 *  B 代表基于字节来解析
	 *  S 代表基于字符来解析</p>
	 */
	public static final String DATA_UNIT_BYTE = "B";
	public static final String DATA_UNIT_STRING = "S";
	
	/**
	 * Server 
	 */
	public static final String SERVER_STOP_ORDER = "SERVER STOP";
	
	/**
	 * error message field
	 */
	public static final String ERROR_XML_DEFINE_FILED_FIELD_NAME = "No fieldname   definition or error in field's attributes ";

	public static final String ERROR_XML_DEFINE_FILED_DATA_TYPE = "No data type   definition or error in field's attributes ";

	public static final String ERROR_XML_DEFINE_FILED_LENGTH = "No length   definition or error in field's attributes ";
	
	public static final String ERROR_XML_DEFINE_FILED_ISREQUIRE = "字段不能为空！";

	public static final String ERROR_XML_DEFINE_FILED_FIELD_VALUESOURCE = "No valueSource   definition or error in field's attributes ";
	public static final String ERROR_XML_DEFINE_FILED_FIELD_FIELDTYPE = "No FieldType  definition or error in field's attributes ";

	/**
	 * error transaction
	 */
	public static final String ERROR_XML_DEFINE_TRANSACTION_ID = "No transaction id definition or error in Transaction's attributes ";
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_DESCRIPTION = "No connection ID definition or error in Transaction's attributes ";

	public static final String ERROR_XML_DEFINE_TRANSACTION_CONNECTION = "No connection ID definition or error in Transaction's attributes ";
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_TYPE = "No transaction type definition or error in Transaction's attributes ";

	public static final String ERROR_XML_DEFINE_TRANSACTION_INPUT_MESSAGER = "No input message definition or error in Transaction's attributes ";

	public static final String ERROR_XML_DEFINE_TRANSACTION_RESPONSE_MESSAGE = "No resopnse message definition or error in Transaction's attributes ";

	public static final String ERROR_XML_DEFINE_TRANSACTION_SYSHEADREQ_MESSAGER = "No system head request message definition or error in Transaction's attributes ";
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_SYSHEADRES_MESSAGER = "No system head response definition or error in Transaction's attributes ";
	

	public static final String ERROR_XML_DEFINE_TRANSACTION_APPHEADREQ_MESSAGER = "No Application head request message definition or error in Transaction's attributes ";//OPF方式专有

	public static final String ERROR_XML_DEFINE_TRANSACTION_APPHEADRES_MESSAGE = "No Application head response definition or error in Transaction's attributes ";//OPF方式专有

	public static final String ERROR_XML_DEFINE_TRANSACTION_OPFHEADREQ_MESSAGER = "No OPF head request message definition or error in Transaction's attributes ";//OPF方式专有

	public static final String ERROR_XML_DEFINE_TRANSACTION_OPFHEADRES_MESSAGER = "No OPF head response definition or error in Transaction's attributes ";//OPF方式专有
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_BULID_CLASS = "No build class definition or error in Transaction's attributes ";
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_BUSI_CLASS = "No business class definition or error in Transaction's attributes ";
	
	public static final String ERROR_XML_DEFINE_TRANSACTION_RESPONSE_OCCURENCE = "response occurence error in Transaction's attributes ";

	public static final String ERROR_XML_DEFINE_TRANSACTION_CHANNEL_INVOLVED = "No Channel Involved definition or error in Transaction's attributes ";
	
	public static final String ERROR_FIELD_CHECK = " Field value not match Field Atttribute definition error or Constants not set error";

	/**
	 * error message
	 */
	public static final String ERROR_XML_DEFINE_MESSAGE_ID = "No 	id   definition or error in Message's attributes ";

	public static final String ERROR_XML_DEFINE_MESSAGE_TRANSACTIONTYPE = "No transaction type definition or error in Message's attributes ";

	public static final String	CACHE_REFRESH = "LOAD_CONFIG";
	
}
