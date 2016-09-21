<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String templetNo = CurPage.getParameter("templetNo");
	if(templetNo == null) templetNo = "";
	String prjSerialNo = CurPage.getParameter("ProjectSerialNo");
	if(prjSerialNo == null) prjSerialNo = "";

	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//Ö»¶ÁÄ£Ê½
	dwTemp.setParameter("PRJSERIALNO", prjSerialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
