<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(null==sAISerialNo) sAISerialNo="";
	String sAssetTxt = CurPage.getParameter("AssetTxt");
	if(null==sAssetTxt) sAssetTxt="";
	String sTempletNo = "Doc1EntryWarehouseInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "����");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	
	String sColumnUrl = "/DocManage/Doc1Manage/Doc1RightCertificateList.jsp";
	dwTemp.genHTMLObjectWindow(sAISerialNo);
	dwTemp.replaceColumn("RIGHTCERTIFICATE", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" onload=\"this.height=this.contentWindow.document.documentElement.scrollHeight\" frameborder=\"0\" src=\""+sWebRootPath+sColumnUrl+"?AISerialNo="+sAISerialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	 String sButtons[][] = {
			//{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
			//{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","����","�����б�","returnList()","","","",""}
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
