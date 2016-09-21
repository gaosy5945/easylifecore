<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%> 
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID=functionInstance.getFunction().getKeyString();
	String functionItemID=functionInstance.getCurFunctionItemID();
	
	List<BusinessObject> functionItemList= functionInstance.getFunctionItemList(functionItemID, FunctionInstance.FUNCTION_ITEM_TYPE_INFO);
	if(functionItemList==null||functionItemList.isEmpty()||functionItemList.size()>1){
		throw new Exception("功能"+functionID+"中未定义或定义了多个Info!");
	}
	BusinessObject listFunctionItem = functionItemList.get(0);
	
	String templetNo = functionInstance.getFunctionItemParameter(listFunctionItem.getString("FunctionItemID"), "TempletNo");
	if(templetNo==null) templetNo="";
	String owRightType=functionInstance.getFunctionItemParameter(listFunctionItem, "OWRightType");
	if(owRightType==null) owRightType="";
	
	String parameterString=listFunctionItem.getString("Parameters");
	BusinessObject inputParameters = StringHelper.stringToBusinessObject(parameterString, "&", "=");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,inputParameters,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	if("ReadOnly".equalsIgnoreCase(owRightType)){
		dwTemp.ReadOnly = "1";
	}
	dwTemp.genHTMLObjectWindow("");
	
	sButtonPosition=functionInstance.getFunctionItemParameter(listFunctionItem, "ButtonPosition");
	if(StringX.isEmpty(sButtonPosition)) sButtonPosition = "north";
	
	String sButtons[][] = FunctionWebTools.genButtons(functionInstance, functionItemID);
	if(sButtons == null) sButtons = new String[0][6];
%> 

<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/FunctionScript.jspf" %>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 