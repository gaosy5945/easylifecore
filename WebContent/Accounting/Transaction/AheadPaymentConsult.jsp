<%@page import="com.amarsoft.acct.accounting.web.AheadPaymentCalculate"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ include file="/Accounting/include_accounting.jspf"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zmxu 20120614
		Tester:
		Content: ��ǰ�������ѯ
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ǰ�������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//������ˮ��
	String transactionSerialNo = (String)CurPage.getParameter("TransactionSerialNo");//������ˮ��
	if(transactionSerialNo == null)
	{
		throw new Exception("������ˮ��TransactionSerialNo��ûֵ��");
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
				<td width="130" align="right">��ǰ�黹����</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��ǰ�黹��Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayInterestAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�����ڱ���</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYPRINCIPALAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��������Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYINTERESTAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�����ڱ���Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYPRINCIPALPENALTYAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��������Ϣ��Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PAYINTERESTPENALTYAMT")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��ɽ�</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("SuspenseAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�ܽ�</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")+payment.getDouble("PrePayInterestAmt")+payment.getDouble("PAYPRINCIPALAMT")
							+payment.getDouble("PAYINTERESTAMT")+payment.getDouble("PAYINTERESTAMT")+payment.getDouble("PAYPRINCIPALPENALTYAMT")+payment.getDouble("PAYINTERESTPENALTYAMT")
							+payment.getDouble("SuspenseAmt"))%>
				</td>
			</tr>
		</table>
	</body>
</html>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		self.returnValue="<%=DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt")+payment.getDouble("PrePayInterestAmt")+payment.getDouble("SuspenseAmt"))+"@"+DataConvert.toMoney(payment.getDouble("PrePayPrincipalAmt"))+"@"+DataConvert.toMoney(payment.getDouble("PrePayInterestAmt"))+"@"+DataConvert.toMoney(payment.getDouble("SuspenseAmt"))%>";
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>