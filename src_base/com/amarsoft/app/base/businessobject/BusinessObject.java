/**
 * Class <code>BusinessObject</code> �����к������Ļ���
 * ���������ÿһ����������Լ��������Ĺ����Ӷ���. 
 * <li> cjyu 2014��5��12��13:48:03 ���ӹ��캯�������δ����jboclass ʱ������resultSet����һ������  
 * @author  xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.BizObject
 * @see com.amarsoft.are.jbo.BizObjectClass
 * @since   JDK1.6
 */
package com.amarsoft.app.base.businessobject;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.antlr.v4.runtime.tree.ParseTree;
import org.jdom.output.XMLOutputter;

import com.amarsoft.app.base.config.impl.XMLConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.Element;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONException;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.are.util.xml.Attribute;

public class BusinessObject extends StateBizObject{
	
	private static final long serialVersionUID = 1L;
	
	/**
	 * Ĭ�ϵĶ�������
	 */
	public static final String OBJECT_TYPE_DEFAULT_NAME = "SYS_GEN_OBJECTTYPE";
	
	/**
	 * ��ҵ�������ڶ��ֶ�������������ObjectNoʱ���ֶ�ֵ֮��ķָ���
	 */
	public static final String OBJECT_KEY_DEFAULT_SPLIT_CHARACTOR = ",";
	
	/**
	 * Ĭ������ID������ʹ��JBOFacotory����������δָ������ʱ���Զ�ʹ�ô��ֶ���Ϊ����
	 */
	public static final String OBJECT_KEY_DEFAULT_ATTRIBUTEID = "SYS_SERIALNO";
	
	/**
	 * ��չ���Լ���
	 */
	private Map<String,Object> ex_attributes = new HashMap<String,Object>();
	private Map<String,String> attributeIDMap = new HashMap<String,String>();//Ϊ�˲����ִ�Сд��ex_attributes�е�Keyȫ��תΪ��д����

	/**
	 * ����BizObjectClass����һ���µ�ҵ�����
	 * @param bizObjectClass
	 */
	protected BusinessObject(BizObjectClass bizObjectClass) {
		super(bizObjectClass);
	}

	/**
	 * ���ö�����
	 * @param objectNo
	 * @throws JBOException
	 */
	public void setKey(Object... objectNo) throws JBOException{
		String[] keyAttributeArray = this.getBizObjectClass().getKeyAttributes();
		if(keyAttributeArray==null||keyAttributeArray.length==0) return ;
		if(keyAttributeArray.length!=objectNo.length) throw new JBOException("��������ʱ���������������ƥ�䣡");
		for(int i=0;i<keyAttributeArray.length;i++){
			String keyAttribute=keyAttributeArray[i];
			this.setAttributeValue(keyAttribute, objectNo[i]);
		}
	}
	
	/**
	 * ��ǰ�������Ƿ����ָ������
	 * @param attributeID
	 * @return
	 */
	public boolean containsAttribute(String attributeID){
		if(ex_attributes.containsKey(attributeID.toUpperCase()))
			return true;
		else{
			if(this.indexOfAttribute(attributeID)>=0) return true;
			else return false;
		}
	}
	
	/**
	 * ��ö������������ID
	 * @return
	 */
	public String[] getAttributeIDArray(){
		List<String> list = new ArrayList<String>();
		
		Element[] dataElements = this.getAttributes();
		for(int i=0;i<dataElements.length;i++){
			if(dataElements[i].getName().equals(BusinessObject.OBJECT_KEY_DEFAULT_ATTRIBUTEID)) continue;
			list.add(dataElements[i].getName());
		}
		
		Set<String> ex_attributesID = ex_attributes.keySet();
		for(String attributeID:ex_attributesID){
			list.add(this.attributeIDMap.get(attributeID));
		}
		String[] s = new String[list.size()];
		list.toArray(s);
		return s;
	}
	
	/**
	 * ��ȡ��ӦObject
	 * @param attributeID
	 * @return long
	 * @throws JBOException 
	 */
	public Object getObject(String attributeID) throws JBOException{
		if(this.indexOfAttribute(attributeID)>=0){
			DataElement value = this.getAttribute(attributeID);
			return value.getValue();
		}
		else{
			return this.ex_attributes.get(attributeID.toUpperCase());
		}
	}

	/**
	 * ��ȡ��Ӧ���Ե��ַ���ֵ
	 * @param attributeID
	 * @return String
	 * @throws JBOException 
	 */
	public String  getString(String attributeID) throws JBOException{
		Object value = this.getObject(attributeID);
		if(value==null) return "";
		if (value instanceof String) {
			return (String)value;
		}
		else {
			return value.toString();
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ�����
	 * @param attributeID
	 * @return double
	 * @throws JBOException
	 */
	public double getDouble(String attributeID) throws JBOException{
		Object value = this.getObject(attributeID);
		if(value==null) return 0d;
		if (value instanceof Number) {
			return ((Number)value).doubleValue();
		}
		else if (value instanceof String){
			String stringValue= (String)value;
			if(StringX.isEmpty(stringValue)) return 0d;
			return Double.valueOf(stringValue.replaceAll(",", ""));
		}
		else {// ��������ֶδ���
			throw new JBOException(this.getBizClassName()+"."+attributeID+"��ֵ�������֣�");
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ������ݣ�����С�����2λ����ϵͳ��ֻ�����ս��ʹ�ã������м���ֵ�������������ⶪʧ���ȣ�
	 * @param attributeID
	 * @return double
	 * @throws JBOException
	 */
	public double getDouble(String attributeID,int precision) throws JBOException{
		double d=this.getDouble(attributeID);
		return Arith.round(d, precision);
	}
	
	/**
	 * ��ȡ��Ӧ���Եĸ�����������С�����8λ����ϵͳ��ֻ�����ʲ�ʹ�ã�
	 * @param attributeID
	 * @return double
	 * @throws JBOException
	 */
	public double getRate(String attributeID) throws JBOException{
		return this.getDouble(attributeID,ACCOUNT_CONSTANTS.Number_Precision_Rate);
	}
	
	/**
	 * ��ȡ��Ӧ���Ե�����
	 * @param attributeID
	 * @return int
	 * @throws JBOException
	 */
	public int getInt(String attributeID) throws JBOException{
		Object value = this.getObject(attributeID);
		if(value==null) return 0;
		if (value instanceof Number) {
			return ((Number)value).intValue();
		}
		else if (value instanceof String){
			String stringValue= (String)value;
			if(StringX.isEmpty(stringValue)) return 0;
			return Integer.valueOf(stringValue.replaceAll(",", ""));
		}
		else {// ��������ֶδ���
			throw new JBOException(this.getBizClassName()+"."+attributeID+"��ֵ�������֣�");
		}
	}
	
	/**
	 * ��ȡ��Ӧ���Եĳ�������ֵ
	 * @param attributeID
	 * @return long
	 * @throws JBOException
	 */
	public long getLong(String attributeID) throws JBOException{
		Object value = this.getObject(attributeID);
		if(value==null) return 0l;
		if (value instanceof Number) {
			return ((Number)value).intValue();
		}
		else if (value instanceof String){
			String stringValue= (String)value;
			if(StringX.isEmpty(stringValue)) return 0l;
			return Long.valueOf(stringValue.replaceAll(",", ""));
		}
		else {// ��������ֶδ���
			throw new JBOException(this.getBizClassName()+"."+attributeID+"��ֵ�������֣�");
		}
	}
	
	/**
	 * ��ȡ�ö���ı�ţ�Ψһ��ʾ�ö�����ַ�������JBO�ж��������Զ��ŷָ���ƴ�ӣ�
	 * @param void
	 * @return String    Key1Value,Key2Value,Key3Value,����
	 * @throws Exception
	 */
	public String getKeyString() throws JBOException{
		return getKeyString(BusinessObject.OBJECT_KEY_DEFAULT_SPLIT_CHARACTOR);
	}
	
	/**
	 * ��ȡ�ö���ı�ţ�Ψһ��ʾ�ö�����ַ�������JBO�ж���������ָ���ַ��ָ���ƴ�ӣ�
	 * @param void
	 * @return String    Key1Value,Key2Value,Key3Value,����
	 * @throws JBOException 
	 */
	public String getKeyString(String split) throws JBOException{
		String[] keyAttributeArray = this.getBizObjectClass().getKeyAttributes();
		if(keyAttributeArray==null||keyAttributeArray.length==0){
			return "";
		}
		String keyString = "";
		for(int i=0;i<keyAttributeArray.length;i++){
			if(i==0) keyString =this.getString(keyAttributeArray[i]);
			else keyString +=split+ this.getString(keyAttributeArray[i]);
		}
		return keyString;
	}
	
	/**
	 * ��ȡ�ö�������ͣ���jbo������
	 * @param void
	 * @return String
	 */
	public String getBizClassName(){
		return this.getBizObjectClass().getRoot().getAbsoluteName();
	}
	
	/**
	 * ���Ƚ���ǰ���������ֵ��գ�Ȼ��Map���ϵ��������Թ鲢����ǰ���󣬶��ڵ�ǰ���󲻾��е����ԣ��Զ���Ϊ��չ���Դ�����������
	 * BizObject�е�setAttributeValue���Զ����Ա�ʡ��ӵ�е����ԣ����Ҳ����׳��쳣������޸Ĵ˷���������
	 * @param businessObject
	 * @throws JBOException
	 */
	public void setAttributes(Map<String,Object> mapValue) throws JBOException{
		for(Iterator<String> it=mapValue.keySet().iterator();it.hasNext();){
			String key = it.next();
			this.setAttributeValue(key, mapValue.get(key));
		}
	}
	
	/**
	 * ���Ƚ���ǰ���������ֵ��գ�Ȼ��һ��businessObject���������Թ鲢����ǰ���󣬶��ڵ�ǰ���󲻾��е����ԣ��Զ���Ϊ��չ���Դ�����������
	 * BizObject�е�setAttributeValue���Զ����Ա�ʡ��ӵ�е�����
	 * @param businessObject
	 * @throws JBOException 
	 */
	public void setAttributes(BusinessObject businessObject) throws JBOException{
		String[] attributeIDs = businessObject.getAttributeIDArray();
		for(String attributeID:attributeIDs){
			Object value = businessObject.getObject(attributeID);
			this.setAttributeValue(attributeID, value);
		}
	}
	
	/**
	 * ��������ֵ
	 * @param dataElement
	 * @return
	 * @throws JBOException
	 */
	public BusinessObject setAttributeValue(DataElement dataElement) throws JBOException{
		return this.setAttributeValue(dataElement.getName(), dataElement.getValue());
	}
	
	/* 
	 * ��������ֵ
	 * @see com.amarsoft.are.jbo.BizObject#setAttributeValue(java.lang.String, java.lang.Object)
	 */
	public BusinessObject setAttributeValue(String attributeID,Object value) throws JBOException{
		if(this.indexOfAttribute(attributeID)>=0){
			super.setAttributeValue(attributeID,value);
		}
		else{
			this.ex_attributes.put(attributeID.toUpperCase(), value);
			this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		}
		return this;
	}
	

	/* 
	 * ��������ֵ
	 * @see com.amarsoft.are.jbo.BizObject#setAttributeValue(java.lang.String, java.lang.Object)
	 */
	public BusinessObject setAttributeValue(String attributeID,int value) throws JBOException{
		if(this.indexOfAttribute(attributeID)>=0){
			super.setAttributeValue(attributeID, value);
		}
		else{
			this.ex_attributes.put(attributeID.toUpperCase(), value);
			this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		}
		return this;
	}
	
	/* 
	 * ��������ֵ
	 * @see com.amarsoft.are.jbo.BizObject#setAttributeValue(java.lang.String, java.lang.Object)
	 */
	public BusinessObject setAttributeValue(String attributeID,double value) throws JBOException{
		if(this.indexOfAttribute(attributeID)>=0){
			super.setAttributeValue(attributeID, value);
		}
		else{
			this.ex_attributes.put(attributeID.toUpperCase(), value);
			this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		}
		return this;
	}
	
	/**
	 * ���ù�������
	 * @param attributeID
	 * @param value
	 * @return
	 * @throws JBOException
	 */
	public BusinessObject setAttributeValue(String attributeID,BusinessObject[] value) throws JBOException{
		this.ex_attributes.remove(attributeID.toUpperCase());
		this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		for(BusinessObject o:value){
			this.appendBusinessObject(attributeID, o);
		}
		return this;
	}
	
	/**
	 * ���ù�������
	 * @param attributeID
	 * @param value
	 * @return
	 * @throws JBOException
	 */
	public BusinessObject setAttributeValue(String attributeID,Collection<BusinessObject> c) throws JBOException{
		this.ex_attributes.remove(attributeID.toUpperCase());
		this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		this.appendBusinessObjects(attributeID, c);
		return this;
	}
	
	/**
	 * ���ù�������
	 * @param attributeID
	 * @param value
	 * @return
	 * @throws JBOException
	 */
	public BusinessObject setAttributeValue(String attributeID,BusinessObject value) throws JBOException{
		this.ex_attributes.remove(attributeID.toUpperCase());
		this.attributeIDMap.put(attributeID.toUpperCase(), attributeID);
		this.appendBusinessObject(attributeID, value);
		return this;
	}
	
	/**
	 * ���ö������������Ϊ��
	 * @param void
	 * @return void
	 * @throws JBOException 
	 */
	public BusinessObject setKeyNull() throws JBOException{
		DataElement[] keys = this.getKey().getAttributes();
		for(int k = 0; k < keys.length; k++){
			super.setAttributeValue(keys[k].getName(), null);
		}
		return this;
	}
	
	/**
	 * ȡָ���������͵�1:1�������󣬵����ڶ����������ʱ����
	 * @param objectType
	 * @return
	 * @throws Exception
	 */
	public BusinessObject getBusinessObject(String attributeID) throws JBOException {
		List<BusinessObject> l=this.getBusinessObjects(attributeID);
		if(l.isEmpty()) return null;
		if(l.size()>1){
			String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}�Ĺ�������{"+attributeID+"}���ڶ��������ʹ�ô˷���!";
			throw new JBOException(desc);
		}
		return l.get(0);
	}
	
	/**
	 * ��ȡ����ɸѡ�����Ĺ��������¼
	 * @param objectType
	 * @param as
	 * @return
	 * @throws Exception
	 */
	public BusinessObject getBusinessObjectByAttributes(String attributeID,Map<String,Object> filterParameters) throws Exception {
		List<BusinessObject> values = this.getBusinessObjects(attributeID);
		return BusinessObjectHelper.getBusinessObjectByAttributes(values, filterParameters);
	}
	
	public BusinessObject getBusinessObjectByKey(String attributeID,Object... parameters) throws JBOException {
		List<BusinessObject> t=this.getBusinessObjects(attributeID);
		if(t.isEmpty()) return null;
		String[] keys=t.get(0).getBizObjectClass().getKeyAttributes();
		Map<String,Object> parameterMap=new HashMap<String,Object>();
		for(int i=0;i<parameters.length;i++){
			parameterMap.put(keys[i], parameters[i]);
		}
		
		List<BusinessObject> l=this.getBusinessObjectsByAttributes(attributeID,parameterMap);
		if(l.isEmpty()) return null;
		if(l.size()>1){
			String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}�Ĺ�������{"+attributeID+"}���ڶ��������ʹ�ô˷���!";
			throw new JBOException(desc);
		}
		return l.get(0);
	}
	
	public BusinessObject getBusinessObjectByAttributes(String attributeID,Object... parameters) throws JBOException {
		List<BusinessObject> l=this.getBusinessObjectsByAttributes(attributeID,parameters);
		if(l.isEmpty()) return null;
		if(l.size()>1){
			String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}�Ĺ�������{"+attributeID+"}���ڶ��������ʹ�ô˷���!";
			throw new JBOException(desc);
		}
		return l.get(0);
	}
	
	/**
	 * ȡָ���������͵�1:1�������󣬵����ڶ����������ʱ����
	 * @param attributeID
	 * @param filterParameters:������������ʽparameter1=value1;parameter2=value2;.....
	 * @return
	 * @throws JBOException
	 */
	public BusinessObject getBusinessObjectBySql(String attributeID,String querySql,Object... parameters) throws JBOException {
		List<BusinessObject> l=this.getBusinessObjectsBySql(attributeID,querySql,parameters);
		if(l.isEmpty()) return null;
		if(l.size()>1){
			String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}�Ĺ�������{"+attributeID+"}���ڶ��������ʹ�ô˷���!";
			throw new JBOException(desc);
		}
		return l.get(0);
	}
	
	public BusinessObject getBusinessObject(String attributeID,BizObjectKey bizObjectKey) throws JBOException {
		List<BusinessObject> l = this.getBusinessObjects(attributeID);
		for(BusinessObject o:l){
			if(bizObjectKey.equals(o.getKey())){
				return o;
			}
		}
		return null;
	}
	
	/**
	 * ȡָ����������
	 * @param objectType
	 * @return
	 * @throws JBOException 
	 * @throws Exception
	 */
	public List<BusinessObject> getBusinessObjects(String attributeID) throws JBOException{
		List<BusinessObject> l=new ArrayList<BusinessObject>();
		Object object = this.getObject(attributeID);
		if(object==null)	return l;
		if(object instanceof List){
			@SuppressWarnings("unchecked")
			List<Object> value = (List<Object>)object;
			if(value!=null&&!value.isEmpty()){
				for(Object o:value){
					if(o instanceof BusinessObject){
						BusinessObject businessObject=(BusinessObject)o;
						l.add(businessObject);
					}
					else{
						String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}������{"+attributeID+"}ֵ����BusinessObject�ļ���!";
						throw new JBOException(desc);
					}
				}
			}
		}
		else{
			String desc ="����{"+this.getBizClassName()+"-"+this.getKeyString()+"}������{"+attributeID+"}ֵ����Ϊ{"+object.getClass().getName()+"}�����Ǽ�������!";
			throw new JBOException(desc);
		}
		return l;
	}
	
	/**
	 * ��ȡ����ɸѡ�����Ĺ��������¼
	 * @param objectType
	 * @param as
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getBusinessObjectsByAttributes(String attributeID,Object... fitlerParameters) throws JBOException {
		List<BusinessObject> values = this.getBusinessObjects(attributeID);
		return BusinessObjectHelper.getBusinessObjectsByAttributes(values, fitlerParameters);
	}
	
	/**
	 * ��ȡ����ɸѡ�����Ĺ��������¼
	 * @param objectType
	 * @param as
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getBusinessObjectsBySql(String attributeID,String querySql,Object... parameters) throws JBOException {
		List<BusinessObject> values = this.getBusinessObjects(attributeID);
		return BusinessObjectHelper.getBusinessObjectsBySql(values,querySql,parameters);
	}
	
	/**
	 * ��ȡ����ɸѡ�����Ĺ��������¼
	 * @param objectType
	 * @param as
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getBusinessObjectsByAttributes(String attributeID,Map<String,Object> filterParameters) throws JBOException {
		List<BusinessObject> values = this.getBusinessObjects(attributeID);
		return BusinessObjectHelper.getBusinessObjectsByAttributes(values, filterParameters);
	}
	
	/**
	 * �Ƴ�ָ����������
	 * @param objectType
	 * @throws JBOException 
	 * @throws Exception
	 */
	public void removeAttribute(String attributeID) throws JBOException {
		if(this.indexOfAttribute(attributeID)>=0){
			super.setAttributeValue(attributeID, null);
		}
		else { 
			this.ex_attributes.remove(attributeID.toUpperCase());
			this.attributeIDMap.remove(attributeID.toUpperCase());
		}
	}
	
	/**
	 * �Ƴ�ָ���������󣬴Ӽ����������Ƴ��ƶ�����
	 * @param attributeID
	 * @param list
	 * @throws Exception
	 */
	public List<BusinessObject> removeBusinessObjects(String attributeID,Collection<BusinessObject> list) throws Exception {
		List<BusinessObject> result=new ArrayList<BusinessObject>();
		for(BusinessObject o:list){
			BusinessObject o1=removeBusinessObject(attributeID,o);
			if(o1!=null)result.add(o1);
		}
		return result;
	}
	
	/**
	 * �Ƴ�ָ����������
	 * @param businessObject
	 * @throws Exception
	 */
	public BusinessObject removeBusinessObject(String attributeID,BusinessObject businessObject) {
		if(businessObject==null) return null;
		@SuppressWarnings("unchecked")
		List<BusinessObject> l=(List<BusinessObject>)this.ex_attributes.get(attributeID.toUpperCase());
		if(l==null) return null;
		else{
			boolean b=l.remove(businessObject);
			if(b) return businessObject;
			else return null;
		}
	}
	
	/**
	 * ׷�ӹ�������
	 * @param attributeID
	 * @param bizObjectList
	 * @throws JBOException
	 */
	public void appendBusinessObjects(String attributeID,Collection<BusinessObject> l) throws JBOException{
		if(l==null) return;
		for(BusinessObject o:l){
			this.appendBusinessObject(attributeID,o);
		}
	}
	
	/**
	 * ׷�ӹ�������
	 * @param attributeID
	 * @param value
	 * @throws JBOException 
	 */
	public void appendBusinessObjects(String attributeID, BusinessObject[] value) throws JBOException {
		if(value==null) return;
		for(BusinessObject o:value){
			this.appendBusinessObject(attributeID,o);
		}
	}
	
	public Object[] getKeyValue() throws JBOException{
		String[] keyAttributeArray = this.getBizObjectClass().getKeyAttributes();
		Object[] keyValue = new Object[keyAttributeArray.length];
		for(int i=0;i<keyAttributeArray.length;i++){
			keyValue[i] =this.getObject(keyAttributeArray[i]);
		}
		return keyValue;
	}

	/**
	 * ׷�ӹ�������
	 * @param attributeID
	 * @param businessObject
	 * @throws JBOException 
	 */
	public void appendBusinessObject(String attributeID,BusinessObject businessObject) throws JBOException{
		if(businessObject == null) return;
		Object[] key = businessObject.getKeyValue();
		BusinessObject o = this.getBusinessObjectByKey(attributeID, businessObject.getKeyValue());
		if(o!=null){
			this.removeBusinessObject(attributeID, o);
		}
		@SuppressWarnings("unchecked")
		List<BusinessObject> data = (List<BusinessObject>)this.ex_attributes.get(attributeID.toUpperCase());
		if (data == null) {
			data = new ArrayList<BusinessObject>();
			ex_attributes.put(attributeID.toUpperCase(), data);
			attributeIDMap.put(attributeID.toUpperCase(),attributeID);
		}
		data.add(businessObject);
	}
	
	public Map<String,Object> convertToMap() throws JBOException{
		Map<String,Map<String,Object>> convertedBusinessObjects = new HashMap<String,Map<String,Object>>();
		return convertToMap(convertedBusinessObjects);
	}
	
	private Map<String,Object> convertToMap(Map<String,Map<String,Object>> convertedBusinessObjects) throws JBOException{
		Map<String,Object> map=new HashMap<String,Object>();
		convertedBusinessObjects.put(getBizClassName()+getKeyString(), map);
		String[] ids=this.getAttributeIDArray();
		for(String attributeID:ids){
			if(hasSubBizObject(attributeID)){
				List<BusinessObject> list=this.getBusinessObjects(attributeID);
				List<Map<String,Object>> subMaps=new ArrayList<Map<String,Object>>();
				map.put(attributeID, subMaps);
				for(BusinessObject subobject:list){
					Map<String, Object> subMap =convertedBusinessObjects.get(subobject.getBizClassName()+subobject.getKeyString());
					if(subMap==null){
						subMap=subobject.convertToMap(convertedBusinessObjects);
						subMaps.add(subMap);
					}
				}
			}
			else{
				map.put(attributeID, this.getObject(attributeID));
			}
		}
		return map;
	}
	
	public boolean hasSubBizObject(String attributeID) throws JBOException{
		Object value=this.getObject(attributeID);
		if(value==null) return false;
		if(!(value instanceof List<?>)) return false;
		List<?> list=(List<?>)value;
		if(list.isEmpty()) return false;
		if(list.get(0) instanceof BusinessObject) return true;
		else return false;
	}
	
	public BusinessObject clone(){
		Map<String,BusinessObject> clonedBusinessObjects = new HashMap<String,BusinessObject>();
		try {
			return this.clone(clonedBusinessObjects);
		} catch (JBOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * ���ƶ����ر����������ѭ�����õ�����
	 * @return
	 * @throws JBOException 
	 */
	private BusinessObject clone(Map<String,BusinessObject> clonedBusinessObjects) throws JBOException{
		//���ƻ�������
		BusinessObject result = (BusinessObject) super.clone();
		clonedBusinessObjects.put(result.getBizClassName()+result.getKeyString(), result);
		//������չ����
		result.attributeIDMap = new HashMap<String, String>(this.attributeIDMap.size());
		result.attributeIDMap.putAll(this.attributeIDMap);
		result.ex_attributes = new HashMap<String, Object>(this.ex_attributes.size());
		for(String key:this.ex_attributes.keySet()){
			Object o = this.ex_attributes.get(key);
			if(o==null){
				result.ex_attributes.put(key, o);
			}
			else if(o instanceof List){
					@SuppressWarnings("unchecked")
					List<Object> oldlist= (List<Object>)o;
					List<Object> newlist= new ArrayList<Object>();
					for(Object oldvalue:oldlist){
						if(oldvalue instanceof BusinessObject){
							BusinessObject oldObject = (BusinessObject) oldvalue;
							BusinessObject newObject = clonedBusinessObjects.get(oldObject.getBizClassName()+oldObject.getKeyString());
							if(newObject==null){
								newObject=oldObject.clone(clonedBusinessObjects);
							}
							newlist.add(newObject);
						}
						else{
							newlist.add(oldvalue);
						}
					}
					result.ex_attributes.put(key, newlist);
			}
			else result.ex_attributes.put(key, o);
		}
		return result;
	}

	/**
	 * ƥ������
	 * @param attributesFilter
	 * @param split
	 * @param operator
	 * @return
	 * @throws Exception
	 */
	public boolean matchAttributes(Object... parameters) throws JBOException{
		String sql="";
		Map<String,Object> parameterMap=new HashMap<String,Object>();
		for(int i=0;i<parameters.length;i++){
			if(!StringX.isEmpty(sql))sql+=" and ";
			sql+=parameters[i]+"=:"+parameters[i];
			parameterMap.put((String)parameters[i], parameters[i+1]);
			i++;
		}
		return this.matchSql(sql, parameterMap);
	}
	
	public boolean matchAttributes(Map<String,Object> parameterMap) throws JBOException{
		String sql="";
		for(String key:parameterMap.keySet()){
			if(!StringX.isEmpty(sql))sql+=" and ";
			sql+=key+"=:"+key;
		}
		return this.matchSql(sql, parameterMap);
	}
	
	/**
	 * ƥ������
	 * @param attributesFilter
	 * @return
	 * @throws JBOException 
	 * @throws Exception
	 */
	public boolean matchSql(String matchSql,Map<String,Object> parameters) throws JBOException{
		try{
			BusinessObjectMatchVisitor visitor = new BusinessObjectMatchVisitor(this,parameters);
			ParseTree tree = ScriptConfig.getParseTree(matchSql);
	        Object result = visitor.visit(tree);
	        return (Boolean)result;
	    }
		catch(Exception e){
			e.printStackTrace();
			JBOException e1 = new JBOException("ִ�����{"+matchSql+"}ʱ����");
			e1.addSuppressed(e);
			throw e1;
		}
	}
	
	
	/**
	 * �ϲ��������ԣ����޸ĵ�ǰ�������е�����ֵ
	 * @param businessObject
	 * @return
	 * @throws Exception
	 */
	public boolean appendAttributes(BusinessObject businessObject) throws Exception{
		if(businessObject==null) return true;
		String[] attributes = businessObject.getAttributeIDArray();
		if(attributes==null) return true;
		for(String attributeID:attributes){
			if(this.containsAttribute(attributeID)) continue;
			Object value = businessObject.getObject(attributeID);
			//if(value!=null){
				this.setAttributeValue(attributeID, value);
			//}
		}
		return true;
	}
	
	/**
	 * ���Ǹ����еĵ����ж�
	 */
	public boolean equals(Object o){
		try{
			BusinessObject bo = (BusinessObject)o;
			if(this.getKeyString().equals(bo.getKeyString()) && this.getKeyString() != null && !"".equals(this.getKeyString()) && this.getBizClassName().equals(bo.getBizClassName())){
				return true;
			}
			else
				return false;
		}catch(Exception ex){
			return false;
		}
	}
	
	/**
	 * �ַ������
	 */
	public String toString(){
		try {
			return toJSONString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * ת��JSON�ַ���
	 * @return
	 * @throws JSONException 
	 * @throws JBOException 
	 * @throws Exception
	 */
	public String toJSONString() throws JBOException, JSONException{
		return JSONEncoder.encode(this.toJSONObject());
	}

	/**
	 * ת��JSON�ַ���
	 * @return
	 * @throws JBOException 
	 * @throws JSONException 
	 * @throws Exception
	 */
	public JSONObject toJSONObject() throws JBOException, JSONException{
		JSONObject jsonObject = JSONObject.createObject();
		String[] ids = this.getAttributeIDArray();
		for(String id:ids){
			Object o1=this.getObject(id);
			if(o1 instanceof List){
				List l=(List) o1;
				if(l.isEmpty()) continue;
				else{
					JSONObject jsonObject1 = JSONObject.createArray();
					for(Object o2:l){
						if(o2 instanceof BusinessObject){
							jsonObject1.add(JSONElement.valueOf(((BusinessObject)o2).toJSONObject()));
						}
					}
					JSONElement attributeElement = JSONElement.valueOf(id, jsonObject1);
					jsonObject.appendElement(attributeElement);
				}
			}
			else{
				JSONElement attributeElement = JSONElement.valueOf(id, o1);
				jsonObject.appendElement(attributeElement);
			}
		}
		
		return JSONObject.createObject().appendElement(JSONElement.valueOf(this.getBizClassName(), jsonObject));
	}
	
	/**
	 * ת�����ַ���
	 * @return
	 * @throws Exception
	 */
	public String toXMLString() throws Exception{
		org.jdom.Element root =  toXML();
		XMLOutputter out = new XMLOutputter();
		return "<?xml version=\"1.0\" encoding=\""+ARE.getProperty("CharSet","GBK")+"\"?>" + out.outputString(root);
	}
	
	/**
	 * ת��XML����
	 * @return
	 * @throws Exception 
	 */
	public org.jdom.Element toXML() throws Exception{
		org.jdom.Element root =new org.jdom.Element(this.getBizClassName());
		String[] ids = this.getAttributeIDArray();
		for(String id:ids){
			Object o1=this.getObject(id);
			if(o1 instanceof List){
				List l=(List) o1;
				if(l.isEmpty()) continue;
				else{
					org.jdom.Element objects =new org.jdom.Element(((BusinessObject)l.get(0)).getBizClassName());
					for(Object o2:l){
						if(o2 instanceof BusinessObject){
							objects.addContent(((BusinessObject)o2).toXML());
						}
					}
					root.addContent(objects);
				}
			}
			else{
				/*
				org.jdom.Element property =new org.jdom.Element(XMLConfig.PROPERTY_ELEMENT_NAME);
				property.setAttribute("name", id);
				property.setAttribute("value", o1 == null ? "" : o1.toString());
				root.addContent(property);
				*/
				root.setAttribute(id, o1 == null ? "" : o1.toString());
			}
		}
		
		return root;
	}
	
	/**
	 * ���캯��
	 * @param clazz
	 * @return this
	 */
	public  static BusinessObject createBusinessObject(String bizClassName,Map<String,Object> values) throws Exception{
		BusinessObject businessObject = createBusinessObject(bizClassName);
		businessObject.setAttributes(values);
		return businessObject;
	}
	
	
	/**
	 * ���캯�� �ù��췽��ֻʹ����Щ���������ʱ����
	 * @param clazz
	 * @return this
	 */
	public  static BusinessObject createBusinessObject(Map<String,Object> values) throws Exception{
		BusinessObject businessObject = createBusinessObject();
		businessObject.setAttributes(values);
		return businessObject;
	}
	
	
	/**
	 * ���캯�� �ù��췽��ֻʹ����Щ���������ʱ����
	 * @param JSONObject
	 * @return this
	 */
	public  static BusinessObject createBusinessObject(JSONObject jsonObject) throws Exception{
		if(jsonObject == null || jsonObject.size() <= 0) return null;
		if(jsonObject.size() > 1)
		{
			BusinessObject bo = BusinessObject.createBusinessObject();
			bo.generateKey();
			for(int i = 0;i < jsonObject.size(); i ++)
			{
				if(jsonObject.get(i).getValue() instanceof JSONObject)
				{
					bo.appendAttributes(BusinessObject.createBusinessObject((JSONObject)jsonObject.get(i).getValue()));
				}
				else
					bo.setAttributeValue(jsonObject.get(i).getName(), jsonObject.get(i).getValue());
			}
			return bo;
		}
		else
		{
			Element e = jsonObject.get(0);
			String bizClassName=e.getName();
			JSONObject attributes=(JSONObject)e.getValue();
			BusinessObject o=BusinessObject.createBusinessObject(bizClassName);
			o.generateKey();
			List<Element> attributeElements = attributes.getElementTable();
			for(Element attributeElement:attributeElements){
				String attributeID=attributeElement.getName();
				Object attributeValue=attributeElement.getValue();
				if(attributeValue!=null&&attributeValue instanceof JSONObject){
					JSONObject subjsonObjects=(JSONObject)attributeValue;
					if(subjsonObjects.getType()==JSONObject.ARRAY){
						int size=subjsonObjects.size();
						for(int i=0;i<size;i++){
							JSONObject subjsonObject=(JSONObject)subjsonObjects.get(i).getValue();
							BusinessObject subo=createBusinessObject(subjsonObject);
							o.appendBusinessObject(attributeID, subo);
						}
					}
					else{
						BusinessObject subo=createBusinessObject(subjsonObjects);
						o.appendBusinessObject(attributeID, subo);
					}
					
				}
				else{
					o.setAttributeValue(attributeID, attributeValue);
				}
			}
			return o;
		}
	}
	
	/**
	 * ת��һ�����󣬱���״̬����
	 * @param bizObject
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject convertFromBizObject(BizObject bizObject) throws JBOException{
		BusinessObject businessObject = createBusinessObject(bizObject.getBizObjectClass().getRoot().getAbsoluteName());
		for(DataElement de : bizObject.getAttributes())
		{
			businessObject.setAttributeValue(de);
		}
		businessObject.changeState(bizObject.getState());
		return businessObject;
	}
	
	/**
	 * ����һ�����󣬶�������ΪSYS_GEN_OBJECTTYPE
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(){
		return createBusinessObject(OBJECT_TYPE_DEFAULT_NAME);
	}
	
	/**
	 * ����һ������״̬Ϊ����
	 * @param businessObject
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(BusinessObject businessObject){
		BusinessObject newBusinessObject = BusinessObject.createBusinessObject(businessObject.getBizClassName());
		newBusinessObject.setAttributesValue(businessObject);
		return newBusinessObject;
	}
	
	public void changeState(byte state){
		super.setState(state);
	}
	
	/**
	 * ����һ������
	 * @param objectType
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(String bizClassName){
		try{
			BusinessObject businessObject = BusinessObject.createBusinessObject(JBOFactory.getBizObjectClass(bizClassName));
			return businessObject;
		}
		catch(JBOException e){
			String[] attributeIDArray= {BusinessObject.OBJECT_KEY_DEFAULT_ATTRIBUTEID};
			BusinessObject businessObject = BusinessObject.createBusinessObject(bizClassName, BusinessObject.OBJECT_KEY_DEFAULT_ATTRIBUTEID,attributeIDArray);
			return businessObject;
		}
	}
	
	public static BusinessObject createBusinessObject(com.amarsoft.are.util.xml.Element element) throws Exception{
		BusinessObject o=BusinessObject.createBusinessObject(element.getName());
		o.generateKey();
		if(!StringX.isEmpty(element.getTextTrim())){
			o.setAttributeValue(element.getName(),element.getTextTrim());
			return o;
		}
		List<Attribute> attributeList = element.getAttributeList();
		if(attributeList==null) return null;

		for(Attribute attribute:attributeList){
			o.setAttributeValue(attribute.getName(),attribute.getValue());
		}
		List<com.amarsoft.are.util.xml.Element> childrens=element.getChildren();
		if(childrens!=null){
			for(com.amarsoft.are.util.xml.Element child:childrens){
				if(XMLConfig.PROPERTY_ELEMENT_NAME.equalsIgnoreCase(child.getName())){
					List<Attribute> ls = child.getAttributeList();
					String name="",value="";
					for(Attribute l:ls)
					{
						if("name".equalsIgnoreCase(l.getName()))
						{
							name = l.getValue();
						}
						else if("value".equalsIgnoreCase(l.getName()))
						{
							value = l.getValue();
						}
					}
					o.setAttributeValue(name, !StringX.isEmpty(value) ? value : child.getTextTrim());
				} else if(!StringX.isEmpty(child.getTextTrim()) && element.getChildren(child.getName()).size() == 1){
					o.setAttributeValue(child.getName(), child.getTextTrim());
				}
				else{
					List<?> childAttributes = child.getAttributeList();
					if((childAttributes==null||childAttributes.isEmpty()) && StringX.isEmpty(child.getTextTrim())){
						List<com.amarsoft.are.util.xml.Element> nextChildElements = child.getChildren();
						if(nextChildElements==null||nextChildElements.isEmpty()) continue;
						for(com.amarsoft.are.util.xml.Element nextChild:nextChildElements){
							BusinessObject childobject = createBusinessObject(nextChild);
							String childName=nextChild.getName();
							o.appendBusinessObject(childName, childobject);
						}
					}
					else{
						BusinessObject childobject = createBusinessObject(child);
						String childName=child.getName();
						o.appendBusinessObject(childName, childobject);
					}
				}
			}
		}
		return o;
	}
	/**
	 * ����ָ��key�������������һ������
	 * @param objectType
	 * @param keyAttributes
	 * @param dataAttributes
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(String bizClassName,String keyAttributes,String[] attributeIDArray){
		BizObjectClass bizObjectClass = new BizObjectClass(bizClassName);
		for(String attributeID:attributeIDArray){
			DataElement dataElement=new DataElement(attributeID);
			bizObjectClass.addAttribute(dataElement);
		}
		bizObjectClass.setKeyAttributes(keyAttributes);
		BusinessObject businessObject = new BusinessObject(bizObjectClass);
		return businessObject;
	}
	
	/**
	 * ����BizObjectClass����һ������
	 * @param bizObjectClass
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(BizObjectClass bizObjectClass){
		BusinessObject businessObject = new BusinessObject(bizObjectClass);
		businessObject.setState(BizObject.STATE_NEW);
		return businessObject;
	}
	
	
	/**
	 * ���������һ������
	 * @param bizClassName
	 * @param rs
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject(String bizClassName,ResultSet rs) throws Exception{
		BusinessObject businessObject = BusinessObject.createBusinessObject(bizClassName);
		for(int i=1;i<=rs.getMetaData().getColumnCount();i++){
			businessObject.setAttributeValue(rs.getMetaData().getColumnName(i),rs.getObject(i));
		}
		businessObject.setState(STATE_SYNC);
		return businessObject;
	}
	
	/**
	 *��������
	 * @param flag Ϊtrueʱǿ����������
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception
	 */
	public void generateKey(boolean flag) throws Exception{
		if(StringX.isEmpty(this.getKeyString())||flag)
			setKey(BusinessObjectKeyFactory.getFactory(getBizObjectClass()).getBizObjectKey(getBizObjectClass()));
	}
	
	/**
	 *����Ϊ��ʱ��������������������
	 * @throws Exception
	 */
	public void generateKey() throws Exception{
		generateKey(false);
	}
}
