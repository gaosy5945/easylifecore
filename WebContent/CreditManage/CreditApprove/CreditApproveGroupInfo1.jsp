<%@page import="com.amarsoft.app.als.credit.approve.action.AddApproveInfo"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
    String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
    String objectNo = CurPage.getParameter("ObjectNo");
    String objectType = CurPage.getParameter("ObjectType");
    String phaseNo = CurPage.getParameter("PhaseNo");
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";

    String businessType = "",loanType="";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BusinessType from BUSINESS_CONTRACT where ApplySerialNo=:ApplySerialNo").setParameter("ApplySerialNo", objectNo));
    if(rs.next())
    {
    	businessType = rs.getString("BusinessType");
    }
    rs.close();
    
	
	//通过显示模版产生ASDataObject对象doTemp	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TASKSERIALNO", taskSerialNo);
	inputParameter.setAttributeValue("APPLYSERIALNO", objectNo);
	String sTempletNo = "";//--模板号--
	
	
	if("500".equals(businessType) || "502".equals(businessType) || "666".equals(businessType))
	{
		sTempletNo = "CreditApproveGroupInfo0030";
	}
	else if("555".equals(businessType))
	{
		sTempletNo = "CreditApproveGroupInfo0020";
	}
	else
	{
		sTempletNo = "CreditApproveGroupInfo0010";
	}
	
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";   

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	function SelectPutoutClause(){
	}
	function SelectAfterRequirement(){
	}
	function SelectSpecialArgeement(){
	}
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "jbo.app.BUSINESS_APPROVE";
	var objectNo = getItemValue(0,getRow(),"SERIALNO");
	$(document).ready(function(){
		changePaymentType();
		initRepriceDate();
		initBusinessRate();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
