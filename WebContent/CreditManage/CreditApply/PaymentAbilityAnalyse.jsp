<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@ page import="com.amarsoft.app.als.credit.apply.action.PaymentAbilityAnalyse"%>
	<%
		//��ȡǰ�˴���Ĳ���
		String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
		String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
		
		int curPage = DataConvert.toInt(CurPage.getParameter("CurPage") == null || "".equals(CurPage.getParameter("CurPage")) ? "1" : CurPage.getParameter("CurPage"));
		
		ASObjectModel doTemp = new ASObjectModel("PaymentAbilityAnalyse");
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      //���÷�� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.genHTMLObjectWindow("");
		
		//��ȡ������Ϣ
		PaymentAbilityAnalyse analyse = new PaymentAbilityAnalyse(objectType,objectNo);
		double monthlyPayAmount = analyse.getMonthlyPayment();		//�����¹�
		double monthlyIncome = analyse.getMonthlyIncome();			//����������
		double avgMonthlyIncome = analyse.getAvgMonthlyIncome();	//����ƽ��������
		String incomeCurrency = "CNY";
		String paymentCurrency = "CNY";
		
		/*------------------ʹ���ڴ����չʾҳ�����----------------------*/
		
		String sButtons[][] = {
		};
		
	%>

	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
	<script language=javascript>
	
	function init(){
		setItemValue(0,0,"MonthlyPayment","<%=monthlyPayAmount%>");
		setItemValue(0,0,"PaymentCurrency","<%=paymentCurrency%>");
		setItemValue(0,0,"AvgMonthlyIncome","<%=avgMonthlyIncome%>");
		setItemValue(0,0,"MonthlyIncome","<%=monthlyIncome%>");
		setItemValue(0,0,"IncomeCurrency","<%=incomeCurrency%>");
	}
	
	init();
	
	</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>