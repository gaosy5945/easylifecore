<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.amarscript.Expression"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.app.als.afterloan.change.handler.ChangeCommonHandler"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>


<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String serialNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(serialNo == null) serialNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";

	SqlObject selectOpType = new SqlObject("select OPERATETYPE from cl_operate where serialno=:SerialNo");
	selectOpType.setParameter("SerialNo", objectNo);
	String operateType = Sqlca.getString(selectOpType);
	
	String sTempletNo = "CLOperateInfo";//--模板号--
	if("2".equals(operateType)){
		sTempletNo = "CLOperateRecoverInfo";//--模板号--
	}else if("4".equals(operateType)){
		sTempletNo = "CLOperateInfo-Stop";//--模板号--
	}
	

	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	inputParameter.setAttributeValue("CLSerialNo", serialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	//doTemp.setDefaultValue("OPERATEUSERName", CurUser.getUserName());
	//doTemp.setDefaultValue("OPERATEORGName", CurOrg.getOrgName());
	

	dwTemp.Style = "2";//freeform
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存信息","saveRecord()","","","",""},
		{"false","All","Button","返回","返回","self.close()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
	}

	function initRow(){
		if(getRowCount(0)==0){
			setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OPERATEUSERName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OPERATEORGName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"OPERATDATE","<%=StringFunction.getToday()%>");
		}
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
