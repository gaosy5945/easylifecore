package com.amarsoft.app.base.businessobject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.jbo.JBOException;

public class BusinessObjectSet {
	private final static String NULL_VALUE_STRING="SYS_NULL_VALUE";
	private String[] indexNameArray;
	private Map<String,Map<Object,Map<String[],Integer>>> objectIndex=new HashMap<String,Map<Object,Map<String[],Integer>>>();
	private List<BusinessObject> dataList=new ArrayList<BusinessObject>();
	
	protected BusinessObjectSet(String indexNameString){
		String[] indexNameArray=indexNameString.toUpperCase().split(",");
		this.indexNameArray=indexNameArray;
		for(String indexname:indexNameArray){
			objectIndex.put(indexname, new HashMap<Object,Map<String[],Integer>>());
		}
	}
	
	public void clear(){
		objectIndex.clear();
		dataList.clear();
	}
	
	/**
	 * 获取集合中的对象列表
	 * @param parameterMap
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getList(Map<String,Object> filterParameters) throws Exception{
		Collection<Integer> resultList = null;
		
		Set<String> filterKeySet = filterParameters.keySet();
		for(String indexName:filterKeySet){
			Object indexValue = filterParameters.get(indexName);
			if(indexValue==null||"".equals(indexValue)) indexValue=NULL_VALUE_STRING;
			Map<Object,Map<String[],Integer>> indexData = this.objectIndex.get(indexName.toUpperCase());
			if(indexData==null) continue;
			Map<String[],Integer> dataIndexMap = indexData.get(indexValue);
			if(dataIndexMap==null) return null;
			 Collection<Integer> dataIndexList = dataIndexMap.values();
			if(resultList==null){
				resultList=dataIndexList;
			}
			else{
				resultList.containsAll(dataIndexList);
			}
			if(resultList.isEmpty()) break;
		}
		
		List<BusinessObject> l = new ArrayList<BusinessObject>();
		for(int i:resultList){
			l.add(dataList.get(i));
		}
		return BusinessObjectHelper.getBusinessObjectsByAttributes(l, filterParameters);
	}
	
	public void remove(BusinessObject o){
		
	}
	
	public void remove(List<BusinessObject> l){
		for(BusinessObject o:l){
			remove(o);
		}
	}
	
	/**
	 *  获取集合中的对象列表
	 * @param parameterString
	 * @param splitChar
	 * @param operateChar
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> getList(String parameterString,String splitChar,String operateChar)  throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, splitChar, operateChar);
		return getList(parameterMap);
	}
	
	/**
	 *  获取集合中的对象列表
	 * @param parameterString
	 * @param splitChar
	 * @return
	 * @throws ALSException
	 */
	public List<BusinessObject> getList(String parameterString,String splitChar)  throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, splitChar, "=");
		return getList(parameterMap);
	}
	
	/**
	 *  获取集合中的对象列表
	 * @param parameterString
	 * @return
	 * @throws ALSException
	 */
	public List<BusinessObject> getList(String parameterString) throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, ",", "=");
		return getList(parameterMap);
	}

	/**
	 *  获取集合中的对象
	 * @param parameterString
	 * @param splitChar
	 * @param operateChar
	 * @return
	 * @throws ALSException
	 */
	public BusinessObject getBusinessObject(String parameterString,String splitChar,String operateChar)  throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, splitChar, operateChar);
		return getBusinessObject(parameterMap);
	}
	
	/**
	 *  获取集合中的对象
	 * @param parameterString
	 * @param splitChar
	 * @return
	 * @throws ALSException
	 */
	public BusinessObject getBusinessObject(String parameterString,String splitChar)  throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, splitChar, "=");
		return getBusinessObject(parameterMap);
	}
	
	/**
	 *  获取集合中的对象
	 * @param parameterString
	 * @return
	 * @throws ALSException
	 */
	public BusinessObject getBusinessObject(String parameterString) throws Exception{
		Map<String, Object> parameterMap = StringHelper.stringToHashMap(parameterString, ";", "=");
		return getBusinessObject(parameterMap);
	}
	
	/**
	 * 获取集合中的对象
	 * @param parameterMap
	 * @return
	 * @throws ALSException
	 */
	public BusinessObject getBusinessObject(Map<String,Object> parameterMap) throws Exception{
		List<BusinessObject> list = this.getList(parameterMap);
		if(list==null||list.isEmpty()) return null;
		if(list.size()>1){
			String desc ="集合数据中根据参数可以找到多个对象，不适用此方法，请确认传入参数值是否足够！ParameterString = {" + parameterMap.toString() + "}!";
			throw new Exception(desc);
		}
		return list.get(0);
	}
	
	public void setBusinessObjects(List<BusinessObject> list) throws Exception{
		for(BusinessObject businessObject:list){
			this.setBusinessObject(businessObject);
		}
	}

	public void setBusinessObject(BusinessObject businessObject) throws Exception{
		String[] objectKey = {businessObject.getBizClassName(),businessObject.getKeyString()};
		int objectPosition = this.dataList.indexOf(businessObject);
		if(objectPosition<0){
			this.dataList.add(businessObject);
			objectPosition=this.dataList.size()-1;
		}
		
		for(int i=0;i<this.indexNameArray.length;i++){
			String indexName = indexNameArray[i];
			if(!businessObject.containsAttribute(indexName)){
				String desc ="对象{"+businessObject.getBizClassName()+"-"+businessObject.getKeyString()+"}中不包含属性{"+indexName+"}!";
				throw new Exception(desc);
			}
			Object indexValue = businessObject.getObject(indexName);
			if(indexValue==null||indexValue.equals("")){
				if(indexValue==null||"".equals(indexValue)) indexValue=NULL_VALUE_STRING;
			}
			
			Map<Object, Map<String[], Integer>> indexData = this.objectIndex.get(indexName);
			if(indexData==null){
				indexData=new HashMap<Object,Map<String[],Integer>>();
				this.objectIndex.put(indexName.toUpperCase(),indexData);
			}
			Map<String[], Integer> data = indexData.get(indexValue);
			if(data==null){
				data=new HashMap<String[], Integer>();
				indexData.put(indexValue, data);
			}
			data.put(objectKey, objectPosition);
		}
	}

	/**
	 * 将List转换为Key-Value形式，多个key以逗号隔开
	 * @param list
	 * @param keyAttributeString
	 * @return
	 * @throws ALSException
	 * @throws JBOException 
	 */
	public static BusinessObjectSet createBusinessObjectSet(List<BusinessObject> list,String dimAttributeString) throws Exception{
		BusinessObjectSet businessObjectSet = createBusinessObjectSet(dimAttributeString);
		businessObjectSet.setBusinessObjects(list);
		return businessObjectSet;
	}
	
	public static BusinessObjectSet createBusinessObjectSet(String dimAttributeString){
		BusinessObjectSet businessObjectSet = new BusinessObjectSet(dimAttributeString);
		return businessObjectSet;
	}
}
