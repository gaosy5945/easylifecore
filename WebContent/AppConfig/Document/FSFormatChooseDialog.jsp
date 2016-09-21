<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
// 	out.print("hello");
%>
<html>
<head> 
<title>请选择财务报表导出的格式</title>
<script type="text/javascript">
	function setReturnValue(value)
	{
		top.returnValue = value;
		top.close();	
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">
<table align="center">
   	<tr>
      		<td>&nbsp;&nbsp;</td>
    </tr>
	<tr>
   		<td class="black9pt"  align="left"><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请选择财务报表导出的格式:</font></td> 
   	</tr>
   	<tr>
      		<td>&nbsp;&nbsp;</td>
    </tr>
   	<tr>
     	<td>
     			&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:65px"  name="xlsFmt" value=".xls格式" onclick="javascript:setReturnValue('xls');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:65px"  name="xlsxFmt" value=".xlsx格式" onclick="javascript:setReturnValue('xlsx');">
		</td>
	</tr>
 </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>