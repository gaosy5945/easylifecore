<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%><%
	String sItemNo = CurPage.getParameter("ItemNo");
	String sHref = CurPage.getParameter("Href");
	String sExist = CurPage.getParameter("Exist");
	String sSuccessFlag = CurPage.getParameter("SuccessFlag");
	String sColor = "black";
	if("false".equals(sExist)){
		sColor = "red";
	}
%>
<script type="text/javascript">
	<%if("true".equals(sSuccessFlag)){%>
		setDialogTitle("恭喜配置成功！");
	<%}else{%>
		setDialogTitle("配置页面路径有误，请检查！");
	<%}%>
</script>
<table border="1" width="100%" bordercolor="#ADC9D8">
	<thead>
		<tr>
			<td><font size="3pt">编号</font></td>
			<td><font size="3pt">路径</font></td>
			<td><font size="3pt">是否存在</font></td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><font size="3pt"><%=sItemNo%></font></td>
			<td><font size="3pt"><%=sHref%></font></td>
			<td><font size="3pt" color="<%=sColor%>"><%=sExist%></font></td>
		</tr>
	</tbody>
</table>
<%@ include file="/Frame/resources/include/include_end.jspf"%>