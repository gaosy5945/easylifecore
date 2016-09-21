package com.amarsoft.app.base.businessobject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;
import com.amarsoft.are.jbo.JBOClassNotFoundException;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.Element;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ElementList;

public class BusinessObjectHelper {
	public static Map<String,Object> getBizClassRelativeType(BizObjectClass bizObjectClass,String relativeType) throws JBOException{
		String relativeTypeString=getBizClassProperty(bizObjectClass,"RelativeType."+relativeType);
		if(StringX.isEmpty(relativeTypeString)) return null;
		
		List<String> configInfo=new ArrayList<String>();
        String regex = "[^{}]+";
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(relativeTypeString);
        while (m.find()) {
        	configInfo.add(m.group());
        }
		Map<String,Object> relativeConfig=new HashMap<String,Object>();
		relativeConfig.put("BizObjectClass",configInfo.get(0));
		String[] t=configInfo.get(1).split(";");
		String[][] attributes=new String[t.length][3];
		for(int i=0;i<t.length;i++){
			String[] s=t[i].split("=");
			attributes[i][0]=s[0];
			if(s[1].trim().startsWith("'")){
				attributes[i][1]="CONSTANT";
				s[1]=s[1].substring(1, s[1].length()-2);
			}
			else 
				attributes[i][1]="ATTRIBUTE";
			attributes[i][2]=s[1];
		}
		relativeConfig.put("AttributeMapping",attributes);
		return relativeConfig;
	}
	
	public static String getBizClassProperty(BizObjectClass bizObjectClass ,String propertyName) throws JBOException{
		try {
			BizObjectClass c = JBOFactory.getBizObjectClass(bizObjectClass.getRoot().getAbsoluteName());
			ElementList properties = c.getProperties();
			if(properties==null) return null;
			for(int i=0;i<properties.size();i++){
				Element e = properties.get(i);
				if(propertyName.equals(e.getName())) return (String)e.getValue();
			}
		} catch (JBOClassNotFoundException e) {
		}
		return null;
	}
	
	public static Object getValue(Collection<BusinessObject> array,String attributeID) throws Exception{
		List<Object> l=getDistinctValues(array,attributeID);
		if(l.isEmpty()) return null;
		if(l.size()>1){
			String desc ="查到多个对象，不能使用此方法!";
			throw new JBOException(desc);
		}
		return l.get(0);
	}
	
	public static List<Object> getDistinctValues(Collection<BusinessObject> array,String attributeID) throws Exception{
		TreeSet<Object> l=new TreeSet<Object>();
		for(BusinessObject o:array){
			Object value = o.getObject(attributeID);
			if(value!=null)
				l.add(value);
		}
		List<Object> result = new ArrayList<Object>();
		result.addAll(l);
		return result;
	}
	
	public static List<Object> getValues(Collection<BusinessObject> array,String attributeID) throws Exception{
		List<Object> l=new ArrayList<Object>();
		for(BusinessObject o:array){
			l.add(o.getObject(attributeID));
		}
		return l;
	}
	
	public static Object getMaxValue(Collection<BusinessObject> array,String attributeID) throws Exception{
		List<Object> l=BusinessObjectHelper.getValues(array, attributeID);
		if(l.isEmpty()) return null;
		Comparable<Object> r=null;
		for(Object o:l){
			if(o==null) continue;
			if(o instanceof Comparable<?>){
				@SuppressWarnings("unchecked")
				Comparable<Object> c=(Comparable<Object>)o;
				if(r==null) r=c;
				else if(c.compareTo(r)>0) r=c;
			}
			else throw new ALSException("ED1002",o.getClass().getName());
		}
		return r;
	}
	
	public static Object getMinValue(Collection<BusinessObject> array,String attributeID) throws Exception{
		List<Object> l=BusinessObjectHelper.getValues(array, attributeID);
		if(l.isEmpty()) return null;
		Comparable<Object> r=null;
		for(Object o:l){
			if(o==null) continue;
			if(o instanceof Comparable<?>){
				@SuppressWarnings("unchecked")
				Comparable<Object> c=(Comparable<Object>)o;
				if(r==null) r=c;
				else if(c.compareTo(r)<0) r=c;
			}
			else throw new ALSException("ED1002",o.getClass().getName());
		}
		return r;
	}
	
	public static double getSumValue(Collection<BusinessObject> array,String attributeID) throws Exception{
		double d=0d;
		List<Object> l=BusinessObjectHelper.getValues(array, attributeID);
		if(l.isEmpty()) return 0.0;
		for(Object o:l){
			if(o==null) continue;
			d=d+((Number)o).doubleValue();
		}
		return d;
	}
	
	public static BizObjectKey[] convertToBizObjectKey(String objectType,Object... objectNoArray) throws JBOException{
		BizObjectKey[] bizObjectKeyArray = new BizObjectKey[objectNoArray.length];
		for(int i=0;i<objectNoArray.length;i++){
			BizObjectKey bizObjectKey=new BizObjectKey(objectType);
			bizObjectKey.setAttributeValue(0, objectNoArray[i]);
			bizObjectKeyArray[i]=bizObjectKey;
		}
		return bizObjectKeyArray;
	}
	
	public static BusinessObject getBusinessObjectByAttributes(List<BusinessObject> data,Object... parameters) throws Exception{
		List<BusinessObject> list = BusinessObjectHelper.getBusinessObjectsByAttributes(data, parameters);
		if(list==null||list.isEmpty()) return null;
		if(list.size()>1){
			throw new ALSException("ED1018");
		}
		return list.get(0);
	}
	
	public static BusinessObject getBusinessObjectByAttributes(List<BusinessObject> data,Map<String,Object> parameterMap) throws Exception{
		List<BusinessObject> list = BusinessObjectHelper.getBusinessObjectsByAttributes(data, parameterMap);
		if(list==null||list.isEmpty()) return null;
		if(list.size()>1){
			throw new ALSException("ED1018");
		}
		return list.get(0);
	}
	
	public static BusinessObject getBusinessObjectBySql(List<BusinessObject> data,String querySql,Object... parameters) throws Exception{
		List<BusinessObject> list = BusinessObjectHelper.getBusinessObjectsBySql(data, querySql, parameters);
		if(list==null||list.isEmpty()) return null;
		if(list.size()>1){
			throw new ALSException("ED1018");
		}
		return list.get(0);
	}
	
	public static List<BusinessObject> getBusinessObjectsByAttributes(List<BusinessObject> data,Map<String,Object> parameterMap) throws JBOException{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		for (BusinessObject businessObject : data) {
			if (!businessObject.matchAttributes(parameterMap))
				continue;
			list.add(businessObject);
		}
		return list;
	}
	
	public static List<BusinessObject> getBusinessObjectsByAttributes(List<BusinessObject> data,Object... parameters) throws JBOException{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		for (BusinessObject businessObject : data) {
			if (!businessObject.matchAttributes(parameters))
				continue;
			list.add(businessObject);
		}
		return list;
	}
	
	public static List<BusinessObject> getBusinessObjectsBySql(List<BusinessObject> data,String querySql,Object... parameters) throws JBOException{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		Map<String,Object> parameterMap=new HashMap<String,Object>();
		for(int i=0;i<parameters.length;i++){
			parameterMap.put((String)parameters[i], parameters[i+1]);
			i++;
		}
		
		for (BusinessObject businessObject : data) {
			if (!businessObject.matchSql(querySql,parameterMap))
				continue;
			list.add(businessObject);
		}
		return list;
	}

	/**
	 * 对列表数据（装有com.amarsoft.app.base.businessobject.BusinessObject）针对某个属性按照字符串进行升序排列
	 * @param list
	 * @param attributeID
	 */
	public static void sortBusinessObject(List<BusinessObject> list, String attributeID){
		sortBusinessObject(list, attributeID,BusinessObjectComparator.sortIndicator_asc);
	}
	
	/**
	 * 对列表数据（装有com.amarsoft.app.base.businessobject.BusinessObject）针对某个属性按照字符串进行降序排列
	 * @param list
	 * @param attributeID
	 */
	public static void reverseBusinessObject(List<BusinessObject> list, String attributeID){
		sortBusinessObject(list, attributeID,BusinessObjectComparator.sortIndicator_desc);
	}
	
	/**
	 * 对列表数据（装有com.amarsoft.app.base.businessobject.BusinessObject）针对某个属性按照传入的数据类型和排序类型进行排列
	 * @param list
	 * @param attributeID
	 * @param dataType
	 * @param sortIndicator
	 */
	private static void sortBusinessObject(List<BusinessObject> list, String attributeID, int sortIndicator){
		BusinessObjectComparator comparator = new BusinessObjectComparator();
		comparator.attributeID = attributeID;
		comparator.sortIndicator = sortIndicator;
		Collections.sort(list, comparator);
	}
	
	public static List<Object> convertToMapList(List<BusinessObject> l) throws JBOException{
		List<Object> ll=new ArrayList<Object>();
		for(BusinessObject o:l){
			Map<String,Object> map=o.convertToMap();
			ll.add(map);
		}
		return ll;
	}
	
	/**
	 * 将BusinessObject对象生成Hashtable数据集合
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	public static Hashtable<String,Object> convertToHashtable(BusinessObject obj)throws Exception{
		Hashtable<String,Object> hashvalues = new Hashtable<String,Object>();
		if(obj!=null){
			String[] attributeIDArray = obj.getAttributeIDArray();
			for(int i=0;i<attributeIDArray.length;i++){
				Object value = obj.getObject(attributeIDArray[i]);
				if(value == null) value = "";
				hashvalues.put(attributeIDArray[i].toUpperCase(),value);
			}
		}
		return hashvalues;
	}
}
