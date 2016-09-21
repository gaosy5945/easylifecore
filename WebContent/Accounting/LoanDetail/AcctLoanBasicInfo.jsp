<%@page import="com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

	<%
		String PG_TITLE = "借据基本信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

		String templetFilter="1=1";
		String templetNo;
		//获得组件参数
		
		//获得页面参数
		String SerialNo =  CurPage.getParameter("ObjectNo");//借据编号
		if(SerialNo == null)SerialNo = "";
		  //通过显示模版产生ASObjectModel对象doTemp---------------------------------
		String sTemplete = "ACCT_LOAN";
		templetNo=sTemplete;
	  		ASObjectModel doTemp = new ASObjectModel(sTemplete);
	  		ASObjectWindow dwTemp = new ASObjectWindow(CurPage ,doTemp,request); 
	  		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	  		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	  	//生成HTMLObjectWindow
	  	dwTemp.genHTMLObjectWindow(SerialNo);	
	    
		String sButtons[][] = {
		};
	%> 


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~END~*/%>

<script language=javascript>
// 	function afterLoad()
// 	{
// 		calcLoanRateTermID();
// 		calcRPTTermID();
// 	}
	/*~[Describe=利率信息;InputParam=无;OutPutParam=无;]~*/
// 	function calcLoanRateTermID(){
// 		var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
// 		if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
// 		var currency = getItemValue(0,getRow(),"CurrencyCode");
// 		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
// 		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
// 		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);

<%-- 		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Currency="+currency+"&ToInheritObj=y&termMonth="+termMonth+"&Status=1&ObjectNo="+"<%=SerialNo%>"+"&ObjectType="+"<%=BUSINESSOBJECT_CONSTANTS.loan%>"+"&TempletNo=RateSegmentView&TermObjectType="+"<%=BUSINESSOBJECT_CONSTANTS.loan_rate_segment%>"+"&TermID="+sLoanRateTermID,"RatePart",""); --%>
// 	}
// 	/*~[Describe=还款方式信息;InputParam=无;OutPutParam=无;]~*/
// 	function calcRPTTermID(){
// 		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
// 		if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
<%-- 		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","ToInheritObj=y&Status=1&ObjectNo=<%=SerialNo%>&ObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan%>&TempletNo=RPTSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan_rpt_segment%>&TermID="+sRPTTermID,"RPTPart",""); --%>
// 	}
	
	
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
// 	afterLoad();
</script>	


<%@ include file="/Frame/resources/include/include_end.jspf"%>
