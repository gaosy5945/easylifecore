package com.amarsoft.app.base.config.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.util.xml.Document;

public class FunctionConfig extends XMLConfig{
	public static String BIZOBJECT_CLASS_NAME_FUNCTION="Function";
	public static String BIZOBJECT_CLASS_NAME_FUNCTION_ITEM="Item";
	public static String BIZOBJECT_CLASS_NAME_FUNCTION_PARAMETER="Parameter";
	public static String ATTRIBUTE_FUNCTION_ID="id";
	public static String ATTRIBUTE_FUNCTION_ITEM_ID="id";
	private static FunctionConfig functionConfig=null;
	
	public static FunctionConfig getFunctionConfig(){
		if(functionConfig==null)functionConfig=new FunctionConfig();
		return functionConfig;
	}
	
	@Override
	public void init(String configFiles, int cacheSize) throws Exception {
		cache=new BusinessObjectCache(cacheSize);
		String[] configFileArray=configFiles.split(",");
		for(String configFile:configFileArray){
			Document document = this.getDocument(configFile);
			@SuppressWarnings("unchecked")
			List<BusinessObject> functionList = this.convertToBusinessObjectList(document.getRootElement().getChildren(BIZOBJECT_CLASS_NAME_FUNCTION));
			this.config.appendBusinessObjects(BIZOBJECT_CLASS_NAME_FUNCTION, functionList);
		}
	}
	
	public BusinessObject getFunction(String functionID) throws Exception{
		String cacheKey="FunctionID="+functionID;
		if(cache.isCached(cacheKey)) return (BusinessObject)cache.getCacheObject(cacheKey);
		BusinessObject function=config.getBusinessObjectByAttributes(BIZOBJECT_CLASS_NAME_FUNCTION, ATTRIBUTE_FUNCTION_ID,functionID);
		cache.setCache(cacheKey, function);
		if(function==null){
			throw new ALSException("E1000", functionID);
		}
		return function;
	}
	
	public static String getFunctionTypeAttributeValue(String functionType,String attributeID) throws Exception{
		BusinessObject functionTypeConfig = FunctionConfig.getFunctionConfig().getFunction("FunctionConfig")
				.getBusinessObjectByAttributes("FunctionType","id",functionType);
		return functionTypeConfig.getString(attributeID);
	}

	public static String getFunctionItemTypeAttributeValue(String functionItemType,String attributeID) throws Exception{
		BusinessObject functionItemTypeConfig = FunctionConfig.getFunctionConfig().getFunction("FunctionConfig")
				.getBusinessObjectByAttributes("FunctionItemType","id",functionItemType);
		return functionItemTypeConfig.getString(attributeID);
	}
}
