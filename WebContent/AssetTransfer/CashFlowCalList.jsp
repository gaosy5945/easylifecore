<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="com.amarsoft.app.als.assetTransfer.action.CashFlowCalAction" %>


<html>
<head> 
<title></title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%

	//���ҳ�����	
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
  		<td rowspan="2" align="center" width="10%">Ԥ���ڼ�</td>
  		<td colspan="2" align="center" width="30%">�ջر���</td>
  		<td colspan="2" align="center" width="30%">�ջ���Ϣ</td>
  		<td colspan="2" align="center" width="30%">�ջغϼ�</td>
  	</tr>
  	<tr>
  		<td align="center">����</td>
  		<td align="center">���</td>
  		<td align="center">����</td>
  		<td align="center">���</td>
  		<td align="center">����</td>
  		<td align="center">���</td>
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