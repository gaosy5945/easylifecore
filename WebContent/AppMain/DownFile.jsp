<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String sFileName = DataConvert.toString((String)CurComp.getParameter("FileName"));
    String sFileUrl = DataConvert.toString((String)CurComp.getParameter("FileUrl"));
	
	String sViewType="save"; //"view" or "save"
	if(sViewType.equals("save"))
	{
%>

<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/file?CompClientID=<%=sCompClientID%>">
	<div style="display:none">
		<input name=filename value="<%=sFileUrl+"/"+sFileName%>">
		<input name=contenttype value="">
		<input name=viewtype value="save">		
	</div>
</form>

<script language=javascript>
	form1.submit();
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>