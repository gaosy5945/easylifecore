<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String sTempletNo = "TakeBackReasonInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);
	String sButtons[][] = {
		{"true","All","Button","确定","保存所有修改","save()","","","",""},
		{"true","All","Button","取消","返回","returnList()","","","",""},
	};
	sButtonPosition = "south";
%>
<title>请填写收回原因</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		as_save(0);
		top.returnValue = "true";
		top.close();
	}
	function returnList(){
		top.returnValue = "false";
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
