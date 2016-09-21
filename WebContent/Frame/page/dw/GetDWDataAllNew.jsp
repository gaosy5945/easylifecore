<%@ page contentType="text/html; charset=GBK"%><%@ 
include file="/Frame/resources/include/IncludeBeginDWAJAX.jspf"%><%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));
	if(sType==null || sType.equals("") || sType.equals("null")) sType = "export";   //print,export

	String sURLName = "";
	if(sDWName!=null && !sDWName.equals("")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
		sURLName = dwTemp.genHTMLAllEx(Sqlca,request,"",65535);
	}
%>
<html>
<head>
<title>гКит╨Р...</title>
</head>
<body>
<a id=mydownload name=mydownload href="<%=sWebRootPath%><%=sURLName%>" >обть</a>
</body>
</html>
<script type="text/javascript">
	mydownload.click();	
	setTimeout('closeTop();',1000);	
	function closeTop(){
		//top.close();
		parent.myhide('myiframe0');
	}
</script>
<%@ include file="/IncludeEndAJAX.jsp"%>