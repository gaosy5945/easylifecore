<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sRelaSerialNos = DataConvert.toString(CurPage.getParameter("relaSerialNos"));//

	String sTempletNo = "CashFlowCalInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	dwTemp.replaceColumn("replace", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
	$(document).ready(function(){
		var relaSerialNos = '<%=sRelaSerialNos%>';
		AsControl.OpenView("/AssetTransfer/CashFlowCalList.jsp","relaSerialNos="+relaSerialNos,"frame_list","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	});
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
