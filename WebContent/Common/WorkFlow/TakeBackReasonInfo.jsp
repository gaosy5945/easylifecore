<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String sTempletNo = "TakeBackReasonInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);
	String sButtons[][] = {
		{"true","All","Button","ȷ��","���������޸�","save()","","","",""},
		{"true","All","Button","ȡ��","����","returnList()","","","",""},
	};
	sButtonPosition = "south";
%>
<title>����д�ջ�ԭ��</title>
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
