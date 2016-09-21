<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.interest.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sDocumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType"));
	String sDocumentSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentSerialNo"));
	
	//��ӡҵ��ƾ֤����(��֤�𷵻�)
	
	String sBusinessDate = DateHelper.getBusinessDate();//��ǰϵͳ����
	String sYear = sBusinessDate.substring(0,4);//��ǰ��
	String sMonth = sBusinessDate.substring(5,7);//��ǰ��
	String sDay = sBusinessDate.substring(8,10);//��ǰ��
	int sCount = 1;
	
	//��������
	String transactionSerialNo = Sqlca.getString("Select SerialNo from Acct_Transaction where DocumentType='"+sDocumentType+"'"+" and DocumentSerialNo='"+sDocumentSerialNo+"'");
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(Sqlca);
	BusinessObject transaction = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, transactionSerialNo);
	BusinessObject loan = bom.loadBusinessObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	BusinessObject businessPutout = bom.loadBusinessObject(sDocumentType, sDocumentSerialNo);
	
	
	BusinessObject bailInfo = bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.bail_info, sDocumentSerialNo);//��֤����Ϣ
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>
<table width="627" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="266"> ҵ�����ݣ�&nbsp;<%=NameManager.getBusinessTypeName(loan.getString("BusinessType"), Sqlca)%></td>
    <td width="231"> ��ˮ�ţ�&nbsp;<%=transaction.getString("CoreReturnSerialNo") %></td>
    <td width="108">&nbsp;</td>
  </tr>
  <tr>
    <td >��ݺţ�&nbsp;<%=loan.getObjectNo()%></td>
    <td>��֤���&nbsp;<%=loan.getDouble("BusinessSum") %>&nbsp;Ԫ</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>���֣�&nbsp;<%=CodeManager.getItemName("Currency",loan.getString("Currency"))%></td>
    <td>�������ͣ�&nbsp;<%=transaction.getString("TransName") %></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">�ͻ����ƣ�&nbsp;<%=loan.getString("CustomerName") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤���˺ţ�&nbsp;<%=bailInfo.getString("BailAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤���˻��˺ţ�&nbsp;<%=bailInfo.getString("BailBackAccountBankID") %></td>
  </tr>
  <tr>
    <td colspan="3">��֤���˻��˻����ƣ�&nbsp;<%=bailInfo.getString("BailBackAccountBankName") %></td>
  </tr>
  <tr>
    <td>�����Ա��<%=transaction.getString("InputUserID") %> ���˹�Ա��<%=transaction.getString("TransUserID") %></td>
    <td>���׻�����<%=transaction.getString("TransOrgID") %>�����룺<%=transaction.getString("TransCode") %></td>
    <td>����ʱ�䣺<%=transaction.getString("TransDate") %></td>
  </tr>
</table>

<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("��ӡ","��ӡ����֪ͨ��","javascript: my_Print()","")%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("����","����","javascript: window.close();","")%>
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
			RunMethod("LoanAccount","UpdatePrintCount","<%=sDocumentSerialNo%>"+","+"001"+","+sPrintCount);
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