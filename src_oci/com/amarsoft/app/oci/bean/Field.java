package com.amarsoft.app.oci.bean;

import java.util.LinkedList;
import java.util.List;
import java.util.regex.Pattern;

import org.jdom.Attribute;
import org.jdom.Element;

import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;


/**
 * <p>ʵʱ�ӿ��ֶζ���</p>
 * @author ycliu
 *
 */
public class Field implements java.lang.Cloneable {
    private int no = 0;
    private String fieldTag;
    private String namespace;
    private String valueSource;
    private String tableField;
    private String defaultValue="";
    private String description;
    private String  dataType;
    private String arrayName="";
    private String objectName ="";
    private int length = 0;
    private int dlength = 0 ;
    private String fieldValue="";
    private List<Message> fieldArrayValue;
    private Message objectMessage;
    private String isRequire;//�Ƿ����
    private String parsedValue;//�����е�ֵ��������־��¼
    private int arrayFixedSize;	//���鳤�ȹ̶�
    private String replaceSQL ="";//��field��ֵ����ӳ��	��ѡ����
    private boolean trimIfExceed; //����������Զ��ض�
    private List<Field> attributes = new LinkedList<Field>();//xml����
    
    /**
     * ���ƶ���
     * @return
     */
    public Field copyField(){
    	Field field = new Field();
    	field.no = no;
    	field.fieldTag = fieldTag;
    	field.namespace = namespace;
    	field.valueSource = valueSource;
    	field.tableField = tableField;
    	field.defaultValue = defaultValue;
    	field.description = description;
    	field.dataType = dataType;
    	field.arrayName = arrayName;
    	field.objectName = objectName;
    	field.length = length;
    	field.dlength = dlength;
    	field.fieldValue = fieldValue;
    	if(objectMessage != null)
    		field.objectMessage = objectMessage.copyMessage();
    	field.isRequire = isRequire;
    	field.parsedValue = parsedValue;
    	field.arrayFixedSize= arrayFixedSize;
    	field.replaceSQL= replaceSQL;
    	field.trimIfExceed=trimIfExceed;
    	List<Field> newAttr = new LinkedList<Field>();
    	for(Field temp : attributes)
    		newAttr.add(temp.copyField());
    	field.attributes = newAttr;
    	return field;
    }
    
    
    
    /**
	 * ����һ��Field
	 * @param xData
	 * @return
	 * @throws OCIException
	 */
    public static Field buildField(Element xData) throws OCIException {
        Field field = new Field();
		try {
			field.no = OCIXMLTool.getIntVale(xData, "no");
			field.fieldTag = OCIXMLTool.getValueWithException(xData, "fieldtag", MessageConstants.ERROR_XML_DEFINE_FILED_FIELD_NAME);
	        field.namespace = OCIXMLTool.getValue(xData, "namespace" , "");
	        field.tableField = OCIXMLTool.getValue(xData, "tablefield" , null);	        
	        field.defaultValue = OCIXMLTool.getValue(xData, "defaultvalue" , "");
	        field.description = OCIXMLTool.getValue(xData, "description" , "");
	        field.arrayName = OCIXMLTool.getValue(xData, "arrayname" , "");
	        field.arrayFixedSize = OCIXMLTool.getIntVale(xData, "arrayfixedsize");
	        field.objectName = OCIXMLTool.getValue(xData, "objectname" , "");
	        field.replaceSQL = OCIXMLTool.getValue(xData, "replacesql" , "");
	        field.isRequire = OCIXMLTool.getValue(xData, "isrequire" , "N");
	        field.trimIfExceed = OCIXMLTool.getBooleanValue(xData, "trimifexceed");
	        field.dataType = OCIXMLTool.getValueWithException(xData, "datatype", " @" + field.fieldTag + " " + field.description+ MessageConstants.ERROR_XML_DEFINE_FILED_DATA_TYPE);
	        getAttributeFiled(xData , field);
	        getFiledValueSource(xData , field);
	        getFieldValueLength(xData , field);
		} catch (Exception e) {
			ExceptionFactory.parse(e);
		}
		return field;
    }
    
    
    /**
     * �����ֶεĳ���
     * @param xData
     * @param field
     * @return
     */
    private static boolean getFieldValueLength(Element xData ,Field field){
    	Attribute attribute = xData.getAttribute("Length".toLowerCase());
    	if (attribute == null) {
    		field.length = 0;
        }else {
        	String value = attribute.getValue().trim();
            if (value.equals("")){
            	field.length=0;
            }else {
	            String[] slength = value.split(",");
		   		for(int i=0;i<slength.length;i++){
		   			 boolean result = Pattern.matches("[0-9]*,?[0-9]*", slength[i]);
		   			 if(result&&i==0)
		   				field.length = Integer.parseInt(slength[i]);
		   			 else if(result&&i==1)
		   				field.dlength = Integer.parseInt(slength[i]);
		   			 else
		   				field.length = 0;
		   		}
	   		}		            
        }
		return true;
    }
    
    /**
     * ����field��ȡֵ��Դ
     * @param xData
     * @param field
     * @return
     * @throws Exception
     */
    private static boolean getFiledValueSource(Element xData ,Field field) throws Exception{
    	 Attribute attribute = xData.getAttribute("ValueSource".toLowerCase());
         if (attribute == null) {
        	//����Ϊ�û����÷�����޸ĵĴ��룬������߼��ϵ�©�����øĳ�ֱ�ӱ���
        	if (!field.defaultValue.equals("")){	//������DefaultValue��ValueSource���Բ���ΪDefault
        		field.valueSource="SelectSQL";
        	} else if (!(field.tableField==null?"":"*").equals("")){//������tablefield��ValueSource���Բ���Ϊselectsql
        		field.valueSource="SelectSQL";	
        	}else if(!field.arrayName.equals("") && !field.objectName.equals("")){	//ʲô��û�䱨��
	        	throw new Exception(" @" + field.fieldTag + " " + field.description
                + MessageConstants.ERROR_XML_DEFINE_FILED_FIELD_VALUESOURCE);       		
        	}
         } else
        	field.valueSource = attribute.getValue();
	     return true;   
    }
    
    /**
     * ��ȡfiled������
     * @param xData
     * @param field
     * @return
     * @throws OCIException
     */
    private static boolean getAttributeFiled(Element xData ,Field field) throws OCIException{
        Element eAttr  = xData.getChild("Attribute".toLowerCase());
        if(eAttr != null){
	        @SuppressWarnings("unchecked")
			List<Element> attrList = eAttr.getChildren("field");
			for (int i = 0; i < attrList.size(); i++) {
				Element xField = attrList.get(i);
				field.attributes.add(Field.buildField(xField));
			}
        }
        return true;
    }
    
  
    
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getFieldTag() {
		return fieldTag;
	}
	public void setFieldTag(String fieldTag) {
		this.fieldTag = fieldTag;
	}
	public String getNamespace() {
		return namespace;
	}
	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}
	public String getValueSource() {
		return valueSource;
	}
	public void setValueSource(String valueSource) {
		this.valueSource = valueSource;
	}
	public String getTableField() {
		return tableField;
	}
	public void setTableField(String tableField) {
		this.tableField = tableField;
	}
	public String getDefaultValue() {
		return defaultValue;
	}
	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getArrayName() {
		return arrayName;
	}
	public void setArrayName(String arrayName) {
		this.arrayName = arrayName;
	}
	public String getObjectName() {
		return objectName;
	}
	public void setObjectName(String objectName) {
		this.objectName = objectName;
	}
	public int getLength() {
		return length;
	}
	public void setLength(int length) {
		this.length = length;
	}
	public int getDlength() {
		return dlength;
	}
	public void setDlength(int dlength) {
		this.dlength = dlength;
	}
	public String getFieldValue() {
		return fieldValue;
	}
	public void setFieldValue(String fieldValue) {
		this.fieldValue = fieldValue;
	}
	public List<Message> getFieldArrayValue() {
		return fieldArrayValue;
	}
	public void setFieldArrayValue(List<Message> fieldArrayValue) {
		this.fieldArrayValue = fieldArrayValue;
	}
	public Message getObjectMessage() {
		return objectMessage;
	}
	public void setObjectMessage(Message objectMessage) {
		this.objectMessage = objectMessage;
	}
	public String getIsRequire() {
		return isRequire;
	}
	public void setIsRequire(String isRequire) {
		this.isRequire = isRequire;
	}
	public String getParsedValue() {
		return parsedValue;
	}
	public void setParsedValue(String parsedValue) {
		this.parsedValue = parsedValue;
	}
	public int getArrayFixedSize() {
		return arrayFixedSize;
	}
	public void setArrayFixedSize(int arrayFixedSize) {
		this.arrayFixedSize = arrayFixedSize;
	}
	public String getReplaceSQL() {
		return replaceSQL;
	}
	public void setReplaceSQL(String replaceSQL) {
		this.replaceSQL = replaceSQL;
	}
	public boolean isTrimIfExceed() {
		return trimIfExceed;
	}
	public void setTrimIfExceed(boolean trimIfExceed) {
		this.trimIfExceed = trimIfExceed;
	}
	public List<Field> getAttributes() {
		return attributes;
	}
	public void setAttributes(List<Field> attributes) {
		this.attributes = attributes;
	}
	@Override
	public String toString() {
		return "Field [no=" + no + ", fieldTag=" + fieldTag + ", namespace="
				+ namespace + ", valueSource=" + valueSource + ", tableField="
				+ tableField + ", defaultValue=" + defaultValue
				+ ", description=" + description + ", dataType=" + dataType
				+ ", arrayName=" + arrayName + ", objectName=" + objectName
				+ ", length=" + length + ", dlength=" + dlength
				+ ", fieldValue=" + fieldValue + ", fieldArrayValue="
				+ fieldArrayValue + ", objectMessage=" + objectMessage
				+ ", isRequire=" + isRequire + ", parsedValue=" + parsedValue
				+ ", arrayFixedSize=" + arrayFixedSize + ", replaceSQL="
				+ replaceSQL + ", trimIfExceed=" + trimIfExceed
				+ ", attributes=" + attributes + "]";
	}
}