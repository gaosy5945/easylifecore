<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";

	String sTempletNo = "GuarantyContractInfo_Customer";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","�����б�","self.close()","","","",""}
	};
%>
<head>
<title>���е�����Ϣ����</title>
</head>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
