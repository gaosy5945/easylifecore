<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "�ֽ����б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//���ҳ�����
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String psType = CurPage.getParameter("PSType");
	
	if(objectNo==null) objectNo="";
	if(objectType==null) objectType="";
	
	// ����̨���б�
	ASObjectModel doTemp = new ASObjectModel("PaymentScheduleList");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(15);//��������ҳ
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType+","+psType);

	String sButtons[][] = {
			{"true","","Button","����ƻ�","����ƻ�","viewPayment()","","","",""},
			{"true","","Button","IRR�ƻ�","IRR�ƻ�","viewIRRPayment()","","","",""},
		};
	%>


<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=��ѯ����ƻ���;InputParam=��;OutPutParam=��;]~*/
	function viewPayment(){
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&LoanSerialNo=<%=objectNo%>&TransactionCode=9090&TransDate=<%=DateHelper.getBusinessDate()%>","");
	}
	
	/*~[Describe=��ѯ����ƻ���;InputParam=��;OutPutParam=��;]~*/
	function viewIRRPayment(){
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewIRRPrepaymentConsult.jsp","ToInheritObj=y&LoanSerialNo=<%=objectNo%>&TransactionCode=9090&TransDate=<%=DateHelper.getBusinessDate()%>","");
	}
	
	/*~[Describe=ҳ���ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		//����Ӧ���ܽ�ʵ���ܽ��
			var num = getRowCount(0);
			for(var i=0;i<num;i++){
			var PayPrincipalAmt=getItemValue(0,i,"PayPrincipalAmt");
			var PayInteAMT=getItemValue(0,i,"PayInteAMT");
			var PayFineAMT=getItemValue(0,i,"PayFineAMT");
			var PayCompdInteAMT=getItemValue(0,i,"PayCompdInteAMT");
			var sPayAll=PayPrincipalAmt+PayInteAMT+PayFineAMT+PayCompdInteAMT;
			setItemValue(0,i,"PayAll",sPayAll);
			var ActualPayPrincipalAmt=getItemValue(0,i,"ActualPayPrincipalAmt");
			var ActualPayInteAMT=getItemValue(0,i,"ActualPayInteAMT");
			var ActualPayFineAMT=getItemValue(0,getRow(),"ActualPayFineAMT");
			var ActualPayCompdInteAMT=getItemValue(0,i,"ActualPayCompdInteAMT");
			var sActualAll=ActualPayPrincipalAmt+ActualPayInteAMT+ActualPayFineAMT+ActualPayCompdInteAMT;
			setItemValue(0,i,"ActualAll",sActualAll);
		}
	}
	initRow();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>