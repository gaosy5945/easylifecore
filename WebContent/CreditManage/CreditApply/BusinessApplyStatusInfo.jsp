<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String sTempletNo = "BusinessApplyStatusInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","ȷ��","���������޸�","save()","","","",""},
		{"true","All","Button","ȡ��","����","returnList()","","","",""},
	};
	sButtonPosition = "south";
%>
<title>��ѡ����ԭ��</title>
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
