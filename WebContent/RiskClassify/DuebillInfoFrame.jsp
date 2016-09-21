<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%	
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sDuebillNo = CurPage.getParameter("DuebillNo");
	String sFlowSerialNo = CurPage.getParameter("FlowSerialNo");
	String sTaskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flag = CurPage.getParameter("Flag");
	
	if(sSerialNo == null) sSerialNo = "";
	if(sDuebillNo == null) sDuebillNo = "";
	if(sFlowSerialNo == null) sFlowSerialNo = "";
	if(sTaskSerialNo == null) sTaskSerialNo = "";
%>
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/RiskClassify/DuebillInfoList.jsp","","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>