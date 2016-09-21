<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="com.amarsoft.app.als.assetTransfer.action.CashFlowCalAction" %>


<html>
<head> 
<title></title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%

	//获得页面参数	
	String sRelaSerialNos = DataConvert.toString(CurPage.getParameter("relaSerialNos"));//
	CashFlowCalAction action = new CashFlowCalAction();
	List<List<String>> allList = action.getCashFlowCalDatas(sRelaSerialNos);
	
	%>
<%/*~END~*/%>


<script type="text/javascript">
</script>
</head>

<body>
<br>
  <table border="1" style="width:100%;height:100%">
  	<tr>
  		<td rowspan="2" align="center" width="10%">预测期间</td>
  		<td colspan="2" align="center" width="30%">收回本金</td>
  		<td colspan="2" align="center" width="30%">收回利息</td>
  		<td colspan="2" align="center" width="30%">收回合计</td>
  	</tr>
  	<tr>
  		<td align="center">笔数</td>
  		<td align="center">金额</td>
  		<td align="center">笔数</td>
  		<td align="center">金额</td>
  		<td align="center">笔数</td>
  		<td align="center">金额</td>
  	</tr>
  	
  	<%
	  	for(List list : allList){
	%>
	  		<tr>
	<%
  			for(Object data : list){
  	%>
  				<td align="center"><%=data.toString() %></td>
  		<% }%>
	  		</tr>
  	<% }%>
  	
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>