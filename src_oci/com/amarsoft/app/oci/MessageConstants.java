package com.amarsoft.app.oci;


/**
 * <p>��̬�����࣬������ʵʱ�ӿ���ʹ�õĳ���<p>
 * @author xjzhao
 */
public class MessageConstants {
	/**
	 * Data Structure
	 */
	public static final String DATA_TYPE_STRING = "string";	//�ַ�������
	
	public static final String DATA_TYPE_INT = "int";	//��������
	
	public static final String DATA_TYPE_DOUBLE = "double"; //��ֵ������

	public static final String DATA_TYPE_ARRAY = "array";	//����������
	
	public static final String DATA_TYPE_OBJECT = "object";	//����������
	
	public static final String DATA_TYPE_XML = "xml";	//xml������
	
	public static final String DATA_TYPE_OMELEMENT = "omelement";
	
	public static final String DATA_TYPE_BYTE = "byte";	//������������
	
	public static final String DATA_VAR_LL = "LLVAR";	//�䳤�ַ�����,�ַ�����С��100
	
	public static final String DATA_VAR_LLL = "LLLVAR";	//�䳤�ַ�����,�ַ�����С��1000

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
	 * ����������
	 */
	public static final String BUILD_CLASS_NDS = "com.amarsoft.oci.parser.impl.OPFParser";
	public static final String BUILD_CLASS_CBC = "com.amarsoft.oci.parser.impl.CBCParser";
	
	/**
	 * �Ƿ��б���ͷ Y ��ʾ��  N ��ʾû��
	 */
	public static final String SYS_HEAD_YES = "Y";
	
	public static final String SYS_HEAD_NO = "N";
	
	/**
	 * �Ƿ���С���� Y ��ʾ��  N ��ʾû��
	 */
	public static final String DECIMAL_POINT_YES = "Y";
	
	public static final String DECIMAL_POINT_NO = "N";
	
	
	
	/**
	 * <p>���Ĵ�������Ԫ�����������ĵ���С��λ�� 
	 *  B ��������ֽ�������
	 *  S ��������ַ�������</p>
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
	
	public static final String ERROR_XML_DEFINE_FILED_ISREQUIRE = "�ֶβ���Ϊ�գ�";

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
	

	public static final String ERROR_XML_DEFINE_TRANSACTION_APPHEADREQ_MESSAGER = "No Application head request message definition or error in Transaction's attributes ";//OPF��ʽר��

	public static final String ERROR_XML_DEFINE_TRANSACTION_APPHEADRES_MESSAGE = "No Application head response definition or error in Transaction's attributes ";//OPF��ʽר��

	public static final String ERROR_XML_DEFINE_TRANSACTION_OPFHEADREQ_MESSAGER = "No OPF head request message definition or error in Transaction's attributes ";//OPF��ʽר��

	public static final String ERROR_XML_DEFINE_TRANSACTION_OPFHEADRES_MESSAGER = "No OPF head response definition or error in Transaction's attributes ";//OPF��ʽר��
	
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
