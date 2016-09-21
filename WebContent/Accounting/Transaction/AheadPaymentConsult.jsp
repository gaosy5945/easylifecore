<%@page import="com.amarsoft.acct.accounting.web.AheadPaymentCalculate"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zmxu 20120614
		Tester:
		Content: 提前还款还款咨询
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "提前还款还款咨询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//交易流水号
	String transactionSerialNo = (String)CurPage.getParameter("TransactionSerialNo");//交易流水号
	if(transactionSerialNo == null)
	{
		throw new Exception("交易流水【TransactionSerialNo】没值！");
	}
	AheadPaymentCalculate ahead = new AheadPaymentCalculate();
	ahead.setTransactionSerialNo(transactionSerialNo);
	BusinessObject payment = ahead.run();
	%>
<%/*~END~*/%>




<html>
	<body class="ListPage" leftmargin="0" topmargin="0">
		<table align="center" border='1' cellspacing='10'> 
			<tr>
				<td width="130" align="right">提前归还本金：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">提前归还利息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayInterestAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">还逾期本金：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYPRINCIPALAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">还逾期利息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYINTERESTAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">还逾期本金罚息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYPRINCIPALPENALTYAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">还逾期利息罚息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYINTERESTPENALTYAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">溢缴金额：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("SuspenseAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">总金额：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")+payment.getDouble("PrePayInterestAmt")+payment.getDouble("PAYPRINCIPALAMT")
							+payment.getDouble("PAYINTERESTAMT")+payment.getDouble("PAYINTERESTAMT")+payment.getDouble("PAYPRINCIPALPENALTYAMT")+payment.getDouble("PAYINTERESTPENALTYAMT")
							+payment.getDouble("SuspenseAmt"))%>
				</td>
			</tr>
		</table>
	</body>
</html>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
		self.returnValue="<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")+payment.getDouble("PrePayInterestAmt")+payment.getDouble("SuspenseAmt"))+"@"+DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt"))+"@"+DataConvert.toMoney(payment.getDouble("PrePayInterestAmt"))+"@"+DataConvert.toMoney(payment.getDouble("SuspenseAmt"))%>";
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>