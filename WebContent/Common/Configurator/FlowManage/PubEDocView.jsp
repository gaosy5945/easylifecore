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
	String edocNo = CurPage.getParameter("EDocNo");
	String flag = CurPage.getParameter("Flag");

	String fullPath = "",contentType = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from PUB_EDOC_CONFIG where EDocNo=:EDocNo").setParameter("EDocNo", edocNo));
	if(rs.next())
	{
		if("1".equals(flag))
		{
			fullPath = rs.getString("FullPathFmt");
			contentType = rs.getString("ContentTypeFmt");
		}
		else
		{
			fullPath = rs.getString("FullPathDef");
			contentType = rs.getString("ContentTypeDef");	
		}
	}
	rs.close();
	
	
	String realPrepath = CurConfig.getParameter("WorkDocOfflineSavePath");
	fullPath = realPrepath+ fullPath;	
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

</script>

<%@ include file="/IncludeEnd.jsp"%>