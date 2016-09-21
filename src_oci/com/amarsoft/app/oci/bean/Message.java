package com.amarsoft.app.oci.bean;


import java.util.Arrays;
import java.util.List;

import org.jdom.Element;

import com.amarsoft.app.oci.MessageConstants;


/**
 * <p>实时接口消息对象</p>
 * @author ycliu
 *
 */
public class Message implements Cloneable {
	private String id;				//消息Meta的ID ，同一消息Meta生成的多个实例的id是相同的
	private String tag;		//XML标签
	private String namespace; //命名空间
	private String description;		//消息Meta描述
	private String selectSQL = "";	//消息Meta配置的SQL语句
	private Field[] fields;			//消息包含的所有字段
	
	/**
	 * 根据xml初始化
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
	 * 复制
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
	 * 构造 Message下的 Field
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