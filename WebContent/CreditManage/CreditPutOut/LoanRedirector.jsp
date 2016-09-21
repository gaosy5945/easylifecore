<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
	String objectType = CurPage.getParameter("ObjectType");	
	String objectNo = CurPage.getParameter("ObjectNo");
	
	//BizObject transaction = JBOHelper.querySingle(CreditConst.TRA_JBOCLASS, "SerialNo=:SerialNo", objectNo);
%>
			

<script type="text/javascript">
	<%
			if(objectType.equalsIgnoreCase("ContractLoan")){
				%>
				OpenPage("/Accounting/LoanDetail/LoanDetailTab.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
				<%
			}
			else if(objectType.equalsIgnoreCase("Loan")){
				%>
				OpenPage("/Accounting/LoanDetail/AcctLoanView.jsp?ObjectNo=<%=objectNo%>","_self","");
				<%
			}
			else if(objectType.equalsIgnoreCase("Fee")){
				%>
				OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp?FeeSerialNo=<%=objectNo%>","_self","");
				<%
			}
			else if(objectType.equalsIgnoreCase("Transaction")){
				%>
				OpenPage("/Accounting/Transaction/TransactionInfo.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
				<%
			}
			else{
				%>
				OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
				<%
			}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>