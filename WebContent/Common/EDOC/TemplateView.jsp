<%@page import="com.amarsoft.app.als.edoc.EdocConst"%>
<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String edocNo = CurPage.getParameter("EDocNo");
    String edocType = CurPage.getParameter("EDocType");

    BizObject edoc = JBOHelper.querySingle(EdocConst.JBO_EDOC_DEFINE, "EDocNo=:EDocNo", edocNo);
    String fullPath = JBOHelper.getAttribute(edoc, "FullPath"+edocType).toString();
    String contentType = JBOHelper.getAttribute(edoc, "ContentType"+edocType).toString();
%>

<form name="form1" method="post" action="<%=sWebRootPath%>/servlet/view/file">
	<div style="display:none">
		<input name=filename value="<%=fullPath%>">
		<input name=contenttype value="<%=contentType%>">
		<input name=viewtype value="view">		
	</div>
</form>

<script type="text/javascript">
	form1.submit();
</script>

<%@ include file="/IncludeEnd.jsp"%>