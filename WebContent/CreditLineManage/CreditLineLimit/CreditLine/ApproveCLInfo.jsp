<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "ApproveCLInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
