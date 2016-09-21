package com.amarsoft.app.als.ui.function;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.awe.ow.creator.ObjectWindowCreator;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.sys.function.model.FunctionInstance;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectWindow;

public class FunctionObjectWindowManager {
	private Page page;
	private HttpServletRequest request;
	private FunctionInstance functionInstance;
	private Map<String,ASObjectWindow> dwTempMap= new HashMap<String,ASObjectWindow>();
	
	public FunctionObjectWindowManager(Page page,HttpServletRequest request,FunctionInstance functionInstance) throws Exception{
		this.page=page;
		this.request=request;
		this.functionInstance=functionInstance;
		initObjectWindowMap();
	}
	public ASObjectWindow getObjectWindow(String functionItemID) throws Exception{
		return dwTempMap.get(functionItemID);
	}
	
	private void initObjectWindowMap() throws Exception{
		List<BusinessObject> objectWindowList = functionInstance.getFunctionItemListByType(FunctionInstance.FUNCTION_ITEM_TYPE_INFO+","+FunctionInstance.FUNCTION_ITEM_TYPE_LIST);
		if(objectWindowList==null||objectWindowList.isEmpty()) return;
		int i=0;
		for(BusinessObject owitem:objectWindowList){
			String dwname= i+"";
			ASObjectWindow dwTemp=createObjectWindow(dwname,owitem);
			if(dwTemp==null) continue;
			dwTempMap.put(owitem.getString("FunctionItemID"), dwTemp);
			i++;
		}
	}

	private ASObjectWindow createObjectWindow(String dwname,BusinessObject owitem) throws Exception{
		String parameterString=owitem.getString("Parameters");
		Map<String,Object> parameterMap = StringHelper.stringToHashMap(parameterString, "&", "=");
		
		String dwStyle="2";
		if(owitem.getString("FunctionType").equalsIgnoreCase(FunctionInstance.FUNCTION_ITEM_TYPE_LIST)){
			dwStyle="1";
		}
		parameterMap.put("DWStyle", dwStyle);
		parameterMap.put("DWName", dwname);

		BusinessObject inputParameters = BusinessObject.createBusinessObject(parameterMap);
		
		String className = inputParameters.getString("OWCreator");
		if(!inputParameters.containsAttribute("RightType")){
			if(!StringX.isEmpty(owitem.getString("RightType")))
				inputParameters.setAttributeValue("RightType", owitem.getString("RightType"));
		}
		if(StringX.isEmpty(className))className="com.amarsoft.app.als.awe.ow.creator.BasicObjectWindowCreator";
		Class<?> c = Class.forName(className);
		ObjectWindowCreator objectWindowCreator = (ObjectWindowCreator)c.newInstance();
		ASObjectWindow dwTemp = objectWindowCreator.createObjectWindow(inputParameters, page, request);
		return dwTemp;
	}
}
