<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>SessionOut</title>
</head>
<%	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	com.amarsoft.awe.RuntimeContext CurARC = (com.amarsoft.awe.RuntimeContext) session.getAttribute("CurARC");
	if (CurARC != null) {com.amarsoft.awe.control.model.ComponentSession compSession = CurARC.getCompSession();	if (compSession !=null) compSession.clear();}
	session.invalidate(); %>
<script type="text/javascript">
document.execCommand('ClearAuthenticationCache', false);
if(navigator.userAgent.toLowerCase().indexOf("msie 6")>-1)
{
	window.opener = null;
	window.close();
}
else{
	window.open("<%=request.getContextPath()%>/","_top","");
	//self.close();
}
	
</script>
<body>
</body>
</html>