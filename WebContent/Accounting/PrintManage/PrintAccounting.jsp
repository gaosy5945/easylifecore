<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.interest.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sTransSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransSerialNo"));//还款拆分流水号
//	String sCorereTurnSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CorereTurnSerialNo"));//还款拆分流水号
	//打印业务凭证(还款)
	double jie=0,dai=0;
	String sBusinessDate = DateHelper.getBusinessDate();//当前系统日期
	String sYear = sBusinessDate.substring(0,4);//当前年
	String sMonth = sBusinessDate.substring(5,7);//当前月
	String sDay = sBusinessDate.substring(8,10);//当前日
	int sCount = 1;
	
	//创建交易
	String transactionSerialNo = Sqlca.getString("Select SerialNo from Acct_Transaction where DocumentType='"+BUSINESSOBJECT_CONSTANTS.back_bill+"'"+" and DocumentSerialNo='"+sTransSerialNo+"'");
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(Sqlca);
	BusinessObject transaction = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, transactionSerialNo);
	BusinessObject loan = bom.loadBusinessObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	String whereClauseSql =" TransSerialNo = :TransSerialNo and BookType = 'B' " ;
	List<BusinessObject> detailArrayList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail, whereClauseSql,"TransSerialNo", transactionSerialNo);
	String LoanNo=Sqlca.getString("Select LoanNo from Business_Duebill where LoanSerialNo='"+loan.getObjectNo()+"'");
%><head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="720" border="1">
  <tr>
    <td height="50" colspan="6" align="center"><h2>会计凭证</h2></td>
  </tr>
  <tr>
    <td height="32" colspan="6" align="right"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="79" height="31" >业务内容：</td>
    <td colspan="2">&nbsp;<%=NameManager.getBusinessTypeName(loan.getString("BusinessType"), Sqlca)%></td>
    <td width="92">核心流水号：</td>
    <td colspan="2"><%=transaction.getString("CoreReturnSerialNo") %></td>
  </tr>
  <tr>
    <td height="31">借据号：</td>
    <td colspan="2">&nbsp;<%=LoanNo%></td>
    <td>客户名称：</td>
    <td colspan="2">&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td>交易类型：</td>
    <td colspan="5" height="31" >&nbsp;<%=transaction.getString("TransName") %></td>
  </tr>
  <tr>
    <td height="31" colspan="6">核心分录：<%=transaction.getString("CoreReturnSerialNo") %></td>
  </tr>
  <tr>
    <td height="30" width="50">发生方向</td>
    <td width="70">账号</td>
    <td width="140">户名</td>
    <td width="100">发生金额</td>
    <td width="75">币种</td>
    <td width="120">机构</td>
  </tr>
  <%
  for(BusinessObject detailArray:detailArrayList){
	  %>
	  <tr>
	 	<td height="30"><%= CodeManager.getItemName("Ctrldir",detailArray.getString("Direction"))%></td>
  		<td><%=detailArray.getString("SortNo") %></td>
	    <td><%=detailArray.getString("AccountCodeName") %></td>
	    <%
	    	if(detailArray.getString("Direction").equals("D")){
	    		jie=jie+(detailArray.getDouble("DebitAmt") - detailArray.getDouble("CreditAmt"));
    		%>
    			<td align="right"><%= DataConvert.toMoney(detailArray.getDouble("DebitAmt") - detailArray.getDouble("CreditAmt"))%></td>
    		<%
	    	}else{
	    		dai=dai+(detailArray.getDouble("CreditAmt")-detailArray.getDouble("DebitAmt"));
	    	%>
    			<td align="right"><%= DataConvert.toMoney(detailArray.getDouble("CreditAmt")-detailArray.getDouble("DebitAmt")) %></td>
    		<%
	    	}
	    %>
	    <td><%=CodeManager.getItemName("Currency",detailArray.getString("Currency"))%></td>
	    <td><%=NameManager.getOrgName(detailArray.getString("AccountingOrgID"), Sqlca) %></td>
	  </tr>
	  <%
	}
  %>
 <tr>
    <td colspan="3" height="25">借方金额合计：&nbsp;&nbsp;<%=DataConvert.toMoney(jie)%></td>
    <td colspan="3">贷方金额合计：&nbsp;&nbsp;<%=DataConvert.toMoney(dai) %></td>
  </tr>
   <tr>
    <td height="31" colspan="2">经办柜员：<%=transaction.getString("InputUserID") %></td>
    <td>复核柜员：<%=transaction.getString("TransUserID") %></td>
    <td>交易机构：<%=transaction.getString("TransOrgID") %></td>
    <td> 交易码：<%=transaction.getString("TransCode") %></td>
    <td>交易时间：<%=transaction.getString("TransDate") %></td>
  </tr>

</table>


<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("打印","打印审批通知书","javascript: my_Print()","")%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("返回","返回","javascript: window.close();","")%>
        </td>
    </tr>
</table>
</div>
<script language=javascript>
		
		function my_Print()
		{
			var print=document.getElementById("PrintButton").innerHTML;
			document.getElementById("PrintButton").innerHTML="";
			window.print();
			var sPrintCount=<%=sCount%>+1;
			RunMethod("LoanAccount","UpdatePrintCount","<%=sTransSerialNo%>"+","+"001"+","+sPrintCount);
			document.getElementById("PrintButton").innerHTML=print;
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
</script>

<%@	include file="/IncludeEnd.jsp"%>