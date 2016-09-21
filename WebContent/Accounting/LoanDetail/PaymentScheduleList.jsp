<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

	<%
	String PG_TITLE = "现金流列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得页面参数
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String psType = CurPage.getParameter("PSType");
	
	if(objectNo==null) objectNo="";
	if(objectType==null) objectType="";
	
	// 贷款台账列表
	ASObjectModel doTemp = new ASObjectModel("PaymentScheduleList");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(15);//服务器分页
	dwTemp.genHTMLObjectWindow(objectNo+","+objectType+","+psType);

	String sButtons[][] = {
			{"true","","Button","还款计划","还款计划","viewPayment()","","","",""},
			{"true","","Button","IRR计划","IRR计划","viewIRRPayment()","","","",""},
		};
	%>


<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=查询还款计划表;InputParam=无;OutPutParam=无;]~*/
	function viewPayment(){
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&LoanSerialNo=<%=objectNo%>&TransactionCode=9090&TransDate=<%=DateHelper.getBusinessDate()%>","");
	}
	
	/*~[Describe=查询还款计划表;InputParam=无;OutPutParam=无;]~*/
	function viewIRRPayment(){
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewIRRPrepaymentConsult.jsp","ToInheritObj=y&LoanSerialNo=<%=objectNo%>&TransactionCode=9090&TransDate=<%=DateHelper.getBusinessDate()%>","");
	}
	
	/*~[Describe=页面初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		//计算应还总金额、实还总金额
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