<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String sTempletNo = "BusinessApplyStatusInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","确定","保存所有修改","save()","","","",""},
		{"true","All","Button","取消","返回","returnList()","","","",""},
	};
	sButtonPosition = "south";
%>
<title>请选择复议原因</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		var ResderationReasons = getItemValue(0,getRow(0),"ResderationReasons");
		if(typeof(ResderationReasons) == "undefined" || ResderationReasons.length == 0){
			return;
		}
		as_save(0,"sure()");
		//window.setTimeout("sure();", 10);
	}
	function sure(){
		top.returnValue = "true";
		top.close();
	}
	function returnList(){
		top.returnValue = "false";
		top.close();
	}
	function SelectResderationReasons(){
		var codeNo = "ResderationReasons";
		var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","myiframe0",getRow(),"","ResderationReasons");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
