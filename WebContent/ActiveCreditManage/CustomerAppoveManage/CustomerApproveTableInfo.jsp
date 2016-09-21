<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String SerialNo = CurComp.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String sTempletNo = CurComp.getParameter("TempleteNo");
	if(sTempletNo == null) sTempletNo = "";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", SerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 