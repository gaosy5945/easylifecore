<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String TaskSerialNo = CurPage.getParameter("TaskSerialNo");
	if(TaskSerialNo == null) TaskSerialNo = "";
	String ObjectNo = CurPage.getParameter("ObjectNo");
	if(ObjectNo == null) ObjectNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType==null) RightType="All";
	String sTempletNo = "ALBlankInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("RePayNow", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("RepayHtT", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list1\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","save()","","","",""},
		{"false","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
var ObjectNo="<%=ObjectNo%>";
var TaskSerialNo="<%=TaskSerialNo%>";
var RightType="<%=RightType%>";
AsControl.OpenPage("/CreditManage/Collection/CollRepaymentList.jsp","ObjectNo="+ObjectNo+"&RightType"+RightType+"&TaskSerialNo="+TaskSerialNo,"frame_list");
AsControl.OpenPage("/CreditManage/Collection/HSCollRepaymentList.jsp","ObjectNo="+ObjectNo+"&TaskSerialNo="+TaskSerialNo,"frame_list1");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
