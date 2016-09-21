<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	if(taskSerialNo == null) taskSerialNo = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
    String objectType = "RectifyDemandExplain";
	String sTempletNo = "RiskWarningBHistoryInfo01";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	doTemp.setReadOnly("*",true);
	dwTemp.genHTMLObjectWindow(taskSerialNo);
	dwTemp.replaceColumn("ATTACHMENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"\\Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function openDoc(){
		OpenComp("DocumentList","/Common/BusinessObject/BusinessObjectDocumentList.jsp","ObjectType=<%=objectType%>&RightType=ReadOnly&ObjectNo=<%=serialNo%>","frame_list","");
	}
	
	openDoc();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
