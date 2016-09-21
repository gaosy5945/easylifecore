<html>
<head>
	<title></title>
	<style>
		.table1 {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000} 
		.td1 {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000}
		.myInput1{ background:#dedede;border-color:black;width:640px;border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
		.myInput2{ background:transparent;border-color:black;width:100px;border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
		.myInput3{ background:transparent;border-color:black;width:200px;border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
	</style>	
</head>
<body class="ReportPage" leftmargin="0" topmargin="0" onload=" " style="overflow: auto;width: 100%;height: 100%" >
<table align='center' cellspacing=0 cellpadding=0 style='display: none;width: 100%'>
	<tr>
		<td height=30 valign='middle' style='border-bottom: #000000 0px solid;'></td>
	</tr>
</table>
<iframe name=mypost0 src="<%=com.amarsoft.awe.util.Escape.getBlankHtml(sWebRootPath)%>" frameborder=0 width=1 height=1 style="display:none"> </iframe>
<div id="Layer1" style="width:100%; height:100%; z-index:1; overflow: auto">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr id="DetailTitle" class="DetailTitle" style="display: none;">
		<td colspan=2></td>
	</tr>
	<tr height=1 valign=top>
		<td colspan=2 valign=top>
			<%for(int ijk=0;ijk<sButtons.length;ijk++){
				if(sButtons[ijk][0]==null || !sButtons[ijk][0].equals("true")) continue;
			%>
				<%=new Button(sButtons[ijk][3],sButtons[ijk][4],sButtons[ijk][5],"","").getHtmlText()%>
			<%}%>
	    </td>
	</tr>
	<tr height=1 >
		<td colspan=2>&nbsp;</td>
	</tr>	
	<tr valign="top" >
		<td>&nbsp;</td>
	    <td style='BORDER-bottom: #000000 1px solid;' > 
			<%=sReportInfo%>
		</td>
	</tr>	
</table>
</div>
</body>
</html>