<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "CLSubmitInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","�ύ","�ύ","submit()","","","",""},
		{"true","All","Button","����","�����б�","self.close()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function submit(){
		as_save(0,"windowAlert()");
	}
	function windowAlert(){
		alert("�ύ�ɹ���");
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
