<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "CollTaskManualInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","save()","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<title>�˹���Ԥ</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		as_save(0);
	}
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
