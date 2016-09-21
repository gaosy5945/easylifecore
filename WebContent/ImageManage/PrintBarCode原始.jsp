<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.awt.GraphicsEnvironment,java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO,com.amarsoft.app.als.image.QRUtil"%>

<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
	<title>打印影像条码</title>
	
<STYLE> 
P {page-break-after: always}

.box {
	/*非IE的主流浏览器识别的垂直居中的方法*/
	display: table-cell;
	vertical-align:middle;

	/*设置水平居中*/
	text-align:center;

	/* 针对IE的Hack */
	*display: block;
	*font-size: 175px;/*约为高度的0.873，200*0.873 约为175*/
	*font-family:Arial;/*防止非utf-8引起的hack失效问题，如gbk编码*/

	width:200px;
	height:200px;
	border: 1px solid #eee;
}
.box img {
	/*设置图片垂直居中*/
	vertical-align:middle;
}
</STYLE> 



</head>
<body>
<% 
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sTypeName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeName"));
	if( sTypeNo == null ) sTypeNo = "";
	if( sTypeName == null ) sTypeName = "";

	System.out.println(sTypeNo);
	String [] TypeNos = sTypeNo.split("@");
	String [] TypeNames = sTypeName.split("@");
	int length = TypeNos.length;
	%>
	
<%
	for(int i=0; i<TypeNos.length; i++){
		%>
		<P>
		<div>
			<div align="center"><img src="<%=sWebRootPath%>/servlet/BarCodeServlet?TypeNo=<%=TypeNos[i]%>&TypeName=<%=TypeNames[i]%>" width="200" height="50" hspace="20" vspace="400" border="1" align="middle">
			  <%=TypeNos[i]%> <%=TypeNames[i]%>
		    </div>
		</div>
</P>
		<%
	}
%>

</body>
</html>

<script type="text/javascript">
	setDialogTitle("<table border=0 cellspacing=0 cellpadding=0><tr>"+
		"<td><input type=\"button\" value=\"全部打印\" alt=\"全部打印\" onClick=\"if(/mozilla/.test(navigator.userAgent.toLowerCase()) && !/(compatible|webkit)/.test(navigator.userAgent.toLowerCase())) {ObjectList.print();} else ObjectList.document.execCommand('Print');\"/></td>"+
		"</tr></table>");
</script>
<%@ include file="/IncludeEnd.jsp"%>
