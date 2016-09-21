<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDFPSerialNo = CurPage.getParameter("DFPSerialNo");
	if(sDFPSerialNo == null) sDFPSerialNo = "";
	String sPTISerialNo = CurPage.getParameter("PTISerialNo");
	if(sPTISerialNo == null) sPTISerialNo = "";
	String sTempletNo = "DocFilePackageInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform  
	//dwTemp.ReadOnly = "-2";//只读模式
	String sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocFileInfoList.jsp";
	dwTemp.genHTMLObjectWindow(sDFPSerialNo);
	dwTemp.replaceColumn("DOCFILEINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+sListUrl+"?CompClientID="+sCompClientID+"&DFPSerialNo"+sDFPSerialNo+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		//{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
		{"true","","Button","返回","返回列表","returnList()","","","",""},
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		var sPTISerialNo = "<%=sPTISerialNo%>";
		var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc2TranferTaskOPList.jsp?" +"&PTISerialNo="+sPTISerialNo;
		OpenPage(sUrl, "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
