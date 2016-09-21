<%@page import="com.amarsoft.app.als.edoc.EdocConst"%>
<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<body>
<table width="100%" height="100%" border=0 cellpadding=0 cellspacing=0>
<tr height=1>
	<td style=" border-bottom:solid 2px #ff6d1e"> 

	</td>
</tr>
<tr>
	<td id="printtd">
	<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
	</td>
</tr>
</table>
</body>
</html>
<%
	String serialNo = CurPage.getParameter("SerialNo");

	BizObject print = JBOHelper.querySingle(EdocConst.JBO_EDOC_PRINT, "SerialNo=:SerialNo", serialNo);
 	String fullPath = JBOHelper.getAttribute(print, "FullPath").toString();
 	String contentType = JBOHelper.getAttribute(print, "ContentType").toString();
%>

<form name=form1 method=post target="MyAtt" action="<%=sWebRootPath%>/servlet/view/file">
	<div style="display:none">
		<input name=filename value="<%=fullPath%>">
		<input name=contenttype value="<%=contentType%>">
		<input name=viewtype value="view">		
	</div>

</form>

<script type="text/javascript">
	form1.submit();

	function docPrint2()
	{
		var compID = "EdocPrint";
		var compURL = "/Common/EDOC/EdocPrint.jsp";
		var param = "SerialNo=<%=serialNo%>";
		var dialogStyle = "dialogWidth=200px;dialogHeight=100px;resizable=yes;maximize:yes;help:no;status:no;";
		popComp(compID,compURL,param,"_blank",dialogStyle);
		
	}
</script>

<%@ include file="/IncludeEnd.jsp"%>