<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(null==sAISerialNo) sAISerialNo="";
	String sAssetTxt = CurPage.getParameter("AssetTxt");
	if(null==sAssetTxt) sAssetTxt="";
	String sTempletNo = "Doc1EntryWarehouseInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式
	
	String sColumnUrl = "/DocManage/Doc1Manage/Doc1RightCertificateList.jsp";
	dwTemp.genHTMLObjectWindow(sAISerialNo);
	dwTemp.replaceColumn("RIGHTCERTIFICATE", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" onload=\"this.height=this.contentWindow.document.documentElement.scrollHeight\" frameborder=\"0\" src=\""+sWebRootPath+sColumnUrl+"?AISerialNo="+sAISerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	 String sButtons[][] = {
			//{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
			//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
		};
		sButtonPosition = "north"; 
		
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
