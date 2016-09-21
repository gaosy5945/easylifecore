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
	
	String serialNo = CurPage.getParameter("serialNo");
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select FullPath,ContentType from PUB_EDOC_PRINT where SerialNo=:SerialNo").setParameter("SerialNo", serialNo));
	String fullPath="",contentType="";
	if(rs.next())
	{
		fullPath = rs.getString("FullPath");
		contentType = rs.getString("ContentType");
	}
	rs.close();
	
 	//<!-------服务器的绝对路径------------->
	if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
    String realPrepath = CurConfig.getParameter("WorkDocOfflineSavePath");
	fullPath = realPrepath+ fullPath;	
	//fullPath = "D:"+fullPath;
%>

<form name=form1 method=post target="MyAtt" action="<%=sWebRootPath%>/servlet/view/file?CompClientID=<%=sCompClientID%>">
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