<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";

	String sTempletNo = "CLViewBasicInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.setParameter("SERIALNO", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
