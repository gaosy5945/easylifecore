<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//����������
	String objectType = CurPage.getParameter("ObjectType");	
	String objectNo = CurPage.getParameter("ObjectNo");
	BizObject bc = JBOHelper.querySingle(CreditConst.BC_JBOCLASS, "SerialNo=:SerialNo", objectNo);
	String businessType = "";
	if(bc!=null){
	   businessType = JBOHelper.getAttribute(bc, "BusinessType").toString();
	   if(businessType == null) businessType = "";
	}
%>


<script type="text/javascript">
	<%
	//�����ƷΪ���Ŷ��ʱ����ô�������Ŷ���������
	if(businessType.startsWith("3")) 
	{	
		if(objectType.equalsIgnoreCase("ReinforceContract")){
			%>
			//��Ȳ�����ReinforceCreditLineView��ʵ��
			OpenPage("/InfoManage/DataInput/InputCreditLineView.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
			<%
		}else{
			%>
			//���Ŷ�ȵ����롢��������ͬͳһ��CreditLineView��ʵ��
			OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
			<%	
		}
	}else
	{
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
	}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>