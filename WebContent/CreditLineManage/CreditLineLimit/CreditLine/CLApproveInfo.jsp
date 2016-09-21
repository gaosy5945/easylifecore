<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String COSerialNo = CurPage.getParameter("COSerialNo");
	if(COSerialNo == null) COSerialNo = "";
	String CLSerialNo = CurPage.getParameter("CLSerialNo");
	if(CLSerialNo == null) CLSerialNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType == null) RightType = "";

	String sTempletNo = "CLApproveInfo1";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
 	if("01".equals(RightType)){
		dwTemp.ReadOnly = "-2";
	} 
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CLSTOPREASON", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"150\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditLineManage/CreditLineLimit/CreditLine/CLStopReason.jsp?CLSerialNo="+CLSerialNo+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("APPROVECLINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"150\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditLineManage/CreditLineLimit/CreditLine/ApproveCLInfo.jsp?SerialNo="+CLSerialNo+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","self.close()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
