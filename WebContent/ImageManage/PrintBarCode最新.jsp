<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.awt.GraphicsEnvironment,java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO,com.amarsoft.app.als.image.QRUtil"%>

<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
	<title>��ӡӰ������</title>
	
<STYLE> 
P {page-break-after: always}

.box {
	/*��IE�����������ʶ��Ĵ�ֱ���еķ���*/
	display: table-cell;
	vertical-align:middle;

	/*����ˮƽ����*/
	text-align:center;

	/* ���IE��Hack */
	*display: block;
	*font-size: 175px;/*ԼΪ�߶ȵ�0.873��200*0.873 ԼΪ175*/
	*font-family:Arial;/*��ֹ��utf-8�����hackʧЧ���⣬��gbk����*/

	width:200px;
	height:200px;
	border: 1px solid #eee;
}
.box img {
	/*����ͼƬ��ֱ����*/
	 vertical-align:middle; 
}

.pitureDiv{
   padding-top:350;
   float:none;
}
</STYLE> 

</head>
<body>
<% 
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sTypeName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeName"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));//��ȡ�ͻ�����
	String sFileType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FileType"));//��ȡ��������
	
	
	if( sTypeNo == null ) sTypeNo = "";
	if( sTypeName == null ) sTypeName = "";
	if( sCustomerName == null ) sCustomerName = "";
	if( sFileType == null ) sFileType = "";

	System.out.println(sTypeNo);
	String [] TypeNos = sTypeNo.split("@");
	String [] TypeNames = sTypeName.split("@");
	int length = TypeNos.length;
	%>
	
<% for(int i=0; i<TypeNos.length; i++){%>
		<P>
			<div class="pitureDiv">
				<div align="center"  hspace="20"  border="0" align="middle">
					<table>
					   <tr><td><font size="4">��������:<%=TypeNames[i]%></font></td><th align="center" rowspan="4"><img src="<%=sWebRootPath%>/servlet/BarCodeServlet?TypeNo=<%=TypeNos[i]%>&TypeName=<%=TypeNames[i]%>" ></th></tr>
					   <tr><td><font size="4">��������:<%=sFileType%></font></td></tr>
					   <tr><td><font size="4">�ͻ�����:<%=sCustomerName %></font></td></tr>
					   <tr><td><font size="4">���к�:<%=TypeNos[i]%></font></td></tr>
					 </table>
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
		"<td><input type=\"button\" value=\"ȫ����ӡ\" alt=\"ȫ����ӡ\" onClick=\"if(/mozilla/.test(navigator.userAgent.toLowerCase()) && !/(compatible|webkit)/.test(navigator.userAgent.toLowerCase())) {ObjectList.print();} else ObjectList.document.execCommand('Print');\"/></td>"+
		"</tr></table>");
</script>
<%@ include file="/IncludeEnd.jsp"%>
