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
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String clSerialNo = CurPage.getParameter("CLSerialNo");
	if(clSerialNo == null) clSerialNo = "";
	String doStatus = CurPage.getParameter("doStatus");
	if(doStatus == null) doStatus = "";

	SqlObject selectOpType = new SqlObject("select OPERATETYPE from cl_operate where serialno=:SerialNo");
	selectOpType.setParameter("SerialNo", serialNo);
	String operateType = Sqlca.getString(selectOpType);
	
	String sTempletNo = "CLOperateInfo";//--ģ���--
	if("1".equals(operateType)){
		if(!"1".equals(doStatus)){
			sTempletNo = "CLOperateApproveInfo";//--ģ���--
		}
	}else if("2".equals(operateType)){
		if("1".equals(doStatus)){
			sTempletNo = "CLOperateRecoverInfo";//--ģ���--
		}else{
			sTempletNo = "CLOperateRecoverApproveInfo";//--ģ���--
		}
	}
	

	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	inputParameter.setAttributeValue("CLSerialNo", clSerialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	doTemp.setDefaultValue("OPERATEUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("OPERATEORGName", CurOrg.getOrgName());
	

	dwTemp.Style = "2";//freeform
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","������Ϣ","saveRecord()","","","",""},
		{"true","All","Button","����","����","self.close()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
	}

	function initRow(){
		setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"OPERATEUSERName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"OPERATEORGName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"OPERATDATE","<%=StringFunction.getToday()%>");
	}
	
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
