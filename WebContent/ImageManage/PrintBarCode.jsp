<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.awt.GraphicsEnvironment,java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO,com.amarsoft.app.als.image.QRUtil"%>

<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
	<title>打印影像条码</title>
	
<STYLE> 

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

.pitureDiv{
   padding-top:0px;
   float:none;
}
</STYLE> 

</head>
<body>
<% 
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sTypeName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeName"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));//获取客户名称
	String sFileType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FileType"));//获取资料类型
	
	
	if( sTypeNo == null ) sTypeNo = "";
	if( sTypeName == null ) sTypeName = "";
	if( sCustomerName == null ) sCustomerName = "";
	if( sFileType == null ) sFileType = "";

	System.out.println(sTypeNo);
	String [] TypeNos = sTypeNo.split("@");
	String [] TypeNames = sTypeName.split("@");
	int length = TypeNos.length;
	%>
	
<% for(int i=0; i<TypeNos.length-1; i++){ 
%>
			<div style="page-break-after: always" class="pitureDiv">
				<div align="left"  hspace="20"  border="0" >
					<table>
					   <tr><td><font size="4">资料名称:<%=TypeNames[i]%></font></td></tr>
					   <tr><td><font size="4">资料类型:<%=sFileType%></font></td></tr>
					   <tr><td><font size="4">客户名称:<%=sCustomerName %></font></td></tr>
					   <tr><td><font size="4">序列号:<%=TypeNos[i]%></font></td></tr>
					   <th align="center" rowspan="4"><img src="<%=sWebRootPath%>/servlet/BarCodeServlet?TypeNo=<%=TypeNos[i]%>&TypeName=<%=TypeNames[i]%>" ></th>
					 </table>
			    </div>
			</div>
		<%
	}
	int j = TypeNos.length-1;
%>
			<div style="page-break-after: auto" class="pitureDiv">
				<div align="left"  hspace="20"  border="0" >
					<table>
					   <tr><td><font size="4">资料名称:<%=TypeNames[j]%></font></td></tr>
					   <tr><td><font size="4">资料类型:<%=sFileType%></font></td></tr>
					   <tr><td><font size="4">客户名称:<%=sCustomerName %></font></td></tr>
					   <tr><td><font size="4">序列号:<%=TypeNos[j]%></font></td></tr>
					   <th align="center" rowspan="4"><img src="<%=sWebRootPath%>/servlet/BarCodeServlet?TypeNo=<%=TypeNos[j]%>&TypeName=<%=TypeNames[j]%>" ></th>
					 </table>
			    </div>
			</div>

</body>
</html>

<script type="text/javascript">
	setDialogTitle("<table border=0 cellspacing=0 cellpadding=0><tr>"+
		"<td><input type=\"button\" value=\"全部打印\" alt=\"全部打印\" onClick=\"if(/mozilla/.test(navigator.userAgent.toLowerCase()) && !/(compatible|webkit)/.test(navigator.userAgent.toLowerCase())) {ObjectList.print();} else ObjectList.document.execCommand('Print');\"/></td>"+
		"</tr></table>");
</script>
<%@ include file="/IncludeEnd.jsp"%>
