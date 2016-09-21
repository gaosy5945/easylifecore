package com.amarsoft.app.oci.bean;


import java.util.Arrays;
import java.util.List;

import org.jdom.Element;

import com.amarsoft.app.oci.MessageConstants;


/**
 * <p>ʵʱ�ӿ���Ϣ����</p>
 * @author ycliu
 *
 */
public class Message implements Cloneable {
	private String id;				//��ϢMeta��ID ��ͬһ��ϢMeta���ɵĶ��ʵ����id����ͬ��
	private String tag;		//XML��ǩ
	private String namespace; //�����ռ�
	private String description;		//��ϢMeta����
	private String selectSQL = "";	//��ϢMeta���õ�SQL���
	private Field[] fields;			//��Ϣ�����������ֶ�
	
	/**
	 * ����xml��ʼ��
	 * @param xData
	 * @return
	 * @throws Exception
	 */
	public static Message buildMessage(Element xData) throws Exception {
		Message message = new Message();
		message.id = OCIXMLTool.getValueWithException(xData, "id", MessageConstants.ERROR_XML_DEFINE_MESSAGE_ID);
		message.description = OCIXMLTool.getValue(xData, "description", "");
		message.selectSQL = OCIXMLTool.getValue(xData, "selectsql", "");
		message.tag = OCIXMLTool.getValue(xData, "tag", "");
		message.namespace = OCIXMLTool.getValue(xData, "namespace", "");
		buildField(xData, message);
		return message;
	}
	/**
	 * ����
	 * @return
	 */
	public Message copyMessage(){
		Message message = new Message();
		message.id = id;
		message.tag = tag;
		message.namespace = namespace;
		message.description = description;
		message.selectSQL = selectSQL;
		message.fields = new  Field[fields.length];
		for(int i = 0 ; i < fields.length ; i ++ ){
			message.fields[i] = fields[i].copyField();
		}
		return message;
	}
	
	/**
	 * ���� Message�µ� Field
	 * @param xData
	 * @param message
	 * @return
	 */
	private static boolean buildField(Element xData , Message message){
		@SuppressWarnings("unchecked")
		List<Element> fList = xData.getChildren();
		message.fields = new Field[fList.size()];
		for (int i = 0; i < fList.size(); i++) {
			try {
				Element xField = fList.get(i);
				message.fields[i] = Field.buildField(xField);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	public Field getFieldByTag(String fieldTag){
		for(Field field: this.fields){
			if(field.getFieldTag().equals(fieldTag))
				return field;
		}
		return null;
	}
	
	
	public String getFieldValue(String fieldTag){
		for (int i = 0; i < this.fields.length; i++) {
			if (fields[i].getFieldTag().equals(fieldTag)) 
				return fields[i].getFieldValue();
		}
		return null;
	}
	
	@Override
	public String toString() {
		return "Message [id=" + id + ", tag=" + tag + ", namespace="
				+ namespace + ", description=" + description + ", selectSQL="
				+ selectSQL + ", fields=" + Arrays.toString(fields) + "]";
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getNamespace() {
		return namespace;
	}
	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getSelectSQL() {
		return selectSQL;
	}
	public void setSelectSQL(String selectSQL) {
		this.selectSQL = selectSQL;
	}
	public Field[] getFields() {
		return fields;
	}
	public void setFields(Field[] fields) {
		this.fields = fields;
	}
}