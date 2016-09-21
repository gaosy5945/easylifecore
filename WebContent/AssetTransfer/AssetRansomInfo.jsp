<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//接收参数
	String relaSerialNos = DataConvert.toString(CurPage.getParameter("relaSerialNos"));

	String sTempletNo = "AssetRansomInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	///AppMain/Blank.html
	dwTemp.replaceColumn("replace", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/AppMain/Blank.html\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","确定","确定","ok()","","","",""},
		{"true","All","Button","取消","取消","cancel()","","","",""}
	};
	//sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	$(document).ready(function(){
		var relaSerialNos = '<%=relaSerialNos%>';
		AsControl.OpenView("/AssetTransfer/AssetRansomList.jsp","relaSerialNos="+relaSerialNos,"frame_list","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	});

	function ok(){
		as_save(0,"cancel()");
	}
	
	function cancel(){
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
