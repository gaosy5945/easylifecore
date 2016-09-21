<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.are.jbo.ql.Parser"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();
	List<BusinessObject> functionItemList= functionInstance.getFunctionItemList(functionItemID, FunctionInstance.FUNCTION_ITEM_TYPE_LIST);
	if(functionItemList==null||functionItemList.isEmpty()||functionItemList.size()>1){
		throw new Exception("功能"+functionID+"中未定义或定义了多个List!");
	}
	BusinessObject listFunctionItem = functionItemList.get(0);
	
	String templetNo = functionInstance.getFunctionItemParameter(listFunctionItem, "TempletNo");
	if(templetNo==null) templetNo="";
	
	String multiFlag=functionInstance.getFunctionItemParameter(listFunctionItem, "MultiFlag");
	if(multiFlag==null) multiFlag="";
	
	String owRightType=functionInstance.getFunctionItemParameter(listFunctionItem, "OWRightType");
	if(owRightType==null) owRightType="";
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templetNo, BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	if("MULTI".equalsIgnoreCase(multiFlag)){
		dwTemp.MultiSelect = true;
	}
	if("ReadOnly".equalsIgnoreCase(owRightType)){
		dwTemp.ReadOnly = "1";
	}
	
	String parameterString=listFunctionItem.getString("Parameters");
	Map<String,Object> parameterMap = StringHelper.stringToHashMap(parameterString, "&", "=");
	
	for(String parameterID:parameterMap.keySet()){
		dwTemp.setParameter(parameterID, parameterMap.get(parameterID).toString());
	}
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = FunctionWebTools.genButtons(functionInstance, functionItemID);
	
	if(sButtons == null) sButtons = new String[0][6];
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Common/FunctionPage/jspf/FunctionScript.jspf" %>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 