<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sDFPSerialNo = CurPage.getParameter("DFPSerialNo");
	if(sDFPSerialNo == null) sDFPSerialNo = "";
	String sPTISerialNo = CurPage.getParameter("PTISerialNo");
	if(sPTISerialNo == null) sPTISerialNo = "";
	String sTempletNo = "DocFilePackageInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform  
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	String sListUrl = "/DocManage/Doc2Manage/Doc2BPManage/DocFileInfoList.jsp";
	dwTemp.genHTMLObjectWindow(sDFPSerialNo);
	dwTemp.replaceColumn("DOCFILEINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+sListUrl+"?CompClientID="+sCompClientID+"&DFPSerialNo"+sDFPSerialNo+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		//{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
		{"true","","Button","����","�����б�","returnList()","","","",""},
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
