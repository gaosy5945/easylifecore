<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@ page import="com.amarsoft.app.als.credit.apply.action.PaymentAbilityAnalyse"%>
	<%
		//获取前端传入的参数
		String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
		String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
		
		int curPage = DataConvert.toInt(CurPage.getParameter("CurPage") == null || "".equals(CurPage.getParameter("CurPage")) ? "1" : CurPage.getParameter("CurPage"));
		
		ASObjectModel doTemp = new ASObjectModel("PaymentAbilityAnalyse");
		
		ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
		dwTemp.Style="2";      //设置风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		dwTemp.genHTMLObjectWindow("");
		
		//获取数据信息
		PaymentAbilityAnalyse analyse = new PaymentAbilityAnalyse(objectType,objectNo);
		double monthlyPayAmount = analyse.getMonthlyPayment();		//贷款月供
		double monthlyIncome = analyse.getMonthlyIncome();			//个人月收入
		double avgMonthlyIncome = analyse.getAvgMonthlyIncome();	//个人平均月收入
		String incomeCurrency = "CNY";
		String paymentCurrency = "CNY";
		
		/*------------------使用内存对象展示页面结束----------------------*/
		
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