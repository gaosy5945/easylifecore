<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String ObjectNo = CurPage.getParameter("ObjectNo");
	if(ObjectNo == null) ObjectNo = "";
	String AccountNo = CurPage.getParameter("AccountNo");
	if(AccountNo == null) AccountNo = "";
	String ProjectSerialNo = CurPage.getParameter("ProjectSerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	String ReadFlag = CurPage.getParameter("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";

	String sTempletNo = "PrjectMarginFrame";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("ACCOUNTSLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"240\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/ProjectAcctList.jsp?ObjectType="+ObjectType+"&ObjectNo="+ObjectNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("MARGINDETAILLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/ProjectMarginDetailList.jsp?MarginSerialNo="+ObjectNo+"&AccountNo="+AccountNo+"&ProjectType="+ProjectType+"&CustomerID="+CustomerID+"&ReadFlag="+ReadFlag+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("MARGINDETAILGATHER", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"280\" frameborder=\"0\" src=\""+sWebRootPath+"/ProjectManage/ProjectNewApply/ProjectMarginDetailGather.jsp?MarginSerialNo="+ObjectNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
