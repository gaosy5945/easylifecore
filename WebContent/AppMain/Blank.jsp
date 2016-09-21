<%@
page contentType="text/html; charset=GBK"%><%!
boolean checkRequestString(String str)  {
	if (str == null) return true;
   	if( str.toUpperCase().indexOf("SCRIPT>")>=0 || str.length()>4000 ||
   			str.indexOf("(")>=0 || str.indexOf(")")>=0 ||   //alert()
   			str.indexOf("<")>=0 || str.indexOf(">")>=0 ||   //<img src...<frame name...
   			str.indexOf("+")>=0  || str.indexOf("Content-Transfer-Encoding:base64")>=0
		)
   		return false;
	return true;
}
%><%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
String sTextToShow  = request.getParameter("TextToShow");
if(sTextToShow == null || sTextToShow.length() == 0) sTextToShow = "";
else sTextToShow = java.net.URLDecoder.decode(sTextToShow,"UTF-8");
if (!checkRequestString(sTextToShow)) sTextToShow="非法参数";
%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<body>
<table><tr><td><span style="font-size:12px;"><%=sTextToShow%></span></td></tr></table>
<script type="text/javascript">
window.history.forward(1);
</script>
</body>
</html>