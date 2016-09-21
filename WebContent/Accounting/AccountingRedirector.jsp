<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
	String sObjectType = CurPage.getParameter("ObjectType");	
	String sObjectNo = CurPage.getParameter("ObjectNo");
%>


<script type="text/javascript">
	<%
			if(sObjectType.equalsIgnoreCase("Transaction")){
				%>
				OpenPage("/Accounting/Transaction/TransactionInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
				<%
			}
			else if(sObjectType.equalsIgnoreCase("Loan")){
					%>
					OpenPage("/Accounting/LoanDetail/AcctLoanView.jsp?ObjectNo=<%=sObjectNo%>","_self","");
					<%
				}
			else{
				%>
				OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
			<%
			}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
