<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

	String sTempletNo = "FlowMaxAccount";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("CodeNo", "FlowMaxAccount");
	dwTemp.genHTMLObjectWindow("FlowMaxAccount");
	String sButtons[][] = {
		{"true","","Button","�޸�","�޸�","returnList()","","","",""},
		{"true","","Button","����","���������޸�","save()","","","",""},
	};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setItemDisabled(0, getRow(), "ATTRIBUTE1", true);
	function returnList(){
		setItemDisabled(0, getRow(), "ATTRIBUTE1", false);
	}
	function save(){
		as_save(0);
		setItemDisabled(0, getRow(), "ATTRIBUTE1", true);
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
