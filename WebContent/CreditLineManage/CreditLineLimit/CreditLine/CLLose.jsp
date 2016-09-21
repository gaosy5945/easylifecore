<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String CLSerialNo = CurPage.getParameter("SerialNo");
	if(CLSerialNo == null) CLSerialNo = "";
	String Status = CurPage.getParameter("Status");
	if(Status == null) Status = "";

	String sTempletNo = "CLLose";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", CLSerialNo);
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.replaceColumn("CLLOSE", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditLineManage/CreditLineLimit/CreditLine/CLLoseInfo.jsp?CLSerialNo="+CLSerialNo+"&Status="+Status+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
