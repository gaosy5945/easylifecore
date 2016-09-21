<%@ page contentType="text/html; charset=GBK"%>

<%
	String sURLName = request.getParameter("URLName");
	String sRootPath = request.getParameter("RootPath");
%>

<html>
<head>
<title>«Î…‘∫Ú...</title>
</head>
<body>
<form name=form1 method=post action=<%=sRootPath%>/servlet/viewpic>
	<div style="display:none">
		<input name=filename value="<%=sURLName%>">
		<input name=contenttype value="application">
		<input name=viewtype value="download">
	</div>
</form>
</body>
</html>

<script language=javascript>
	form1.submit();
	setTimeout('closeTop();',2000);	
	function closeTop()
	{
		top.close();
	}
</script>