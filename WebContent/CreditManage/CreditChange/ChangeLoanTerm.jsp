<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String serialNo = CurPage.getParameter("RelativeObjectNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
	String maturityDate="",putoutDate="";
	String currency="",businessTermUnit="020";
	int termMonth = 0,termDay=0;
	String loanRateTermID = "";
	
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_DUEBILL" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo).getSingleResult(false);
	if(bo!=null){
		maturityDate=bo.getAttribute("MATURITYDATE").getString();	
		putoutDate=bo.getAttribute("PUTOUTDATE").getString();
		currency=bo.getAttribute("BUSINESSCURRENCY").getString();
		
		termMonth = DateHelper.getMonths(putoutDate, maturityDate);
		termDay = DateHelper.getDays(DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, termMonth), maturityDate);
		loanRateTermID=bo.getAttribute("LoanRateTermID").getString();
	}
	if(maturityDate == null) maturityDate = "";
	
	String sTempletNo = "ChangeLoanTerm";//--模板号--
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TransSerialNo", transSerialNo);
	inputParameter.setAttributeValue("LoanType", bo.getAttribute("LoanType").getString());
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	if("RAT03".equals(loanRateTermID)){
		doTemp.setReadOnly("RepriceRateFlag", true);
	}
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(transSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<script type="text/javascript">

	var rightType="<%=CurPage.getParameter("RightType")%>";
	var objectType="jbo.acct.ACCT_LOAN_CHANGE";
	var objectNo= getItemValue(0,getRow(),"SerialNo");
	
	function saveRecord(){
		var maturityDate=getItemValue(0,getRow(),"MATURITYDATE");
		if(maturityDate < "<%=StringFunction.getToday()%>"){
			alert("新到期日期不可早于当前日期,请重新输入！");
			return;
		}
		as_save('selfRefresh()');
	}

	function initRow(){
		var oldMaturityDate=getItemValue(0,getRow(),"OLDMATURITYDATE");
		if(typeof(oldMaturityDate) == "undefined" || oldMaturityDate.length == 0) {
			setItemValue(0,0,"OLDMATURITYDATE","<%=maturityDate%>");
		}
		
		var maturityDate=getItemValue(0,getRow(),"MaturityDate");
		if(typeof(maturityDate) == "undefined" || maturityDate.length == 0) {
			setItemValue(0,0,"MaturityDate","<%=maturityDate%>");
		}
	}
	
	//由起始日计算期限
	function initTerm()
	{
		var putoutDate="<%=putoutDate%>";
		var maturityDate=getItemValue(0,getRow(),"OLDMATURITYDATE");
		if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
		if(typeof(maturityDate) == "undefined" || maturityDate.length == 0) return;
		
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.DateAction","calcTerm","BeginDate="+putoutDate+",EndDate="+maturityDate);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
		setItemValue(0, getRow(0), "OLDLOANTERM",returnValue.split("@")[0]);
		setItemValue(0, getRow(0), "OldBusinessTermYear",returnValue.split("@")[2]);
		setItemValue(0, getRow(0), "OldBusinessTermMonth",returnValue.split("@")[3]);
		setItemValue(0, getRow(0), "OldBusinessTermDay",returnValue.split("@")[1]);
	}

	
	function calTerm()
	{
		var putoutDate="<%=putoutDate%>";
		var maturityDate=getItemValue(0,getRow(),"MaturityDate");
		
		if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
		if(typeof(maturityDate) == "undefined" || maturityDate.length == 0) return;
		
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.DateAction","calcTerm","BeginDate="+putoutDate+",EndDate="+maturityDate);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;		
		setItemValue(0, getRow(0), "LOANTERM",returnValue.split("@")[0]);
		setItemValue(0, getRow(0), "NewBusinessTermYear",returnValue.split("@")[2]);
		setItemValue(0, getRow(0), "NewBusinessTermMonth",returnValue.split("@")[3]);
		setItemValue(0, getRow(0), "NewBusinessTermDay",returnValue.split("@")[1]);
		if("ReadOnly"!=rightType){
			initRate('1','initChangeRate();');
		}else{
			initChangeRate();
		}
	}
	
	
	function initChangeRate()
	{
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		ALSObjectWindowFunctions.hideItems(subdwname,"RepriceType,RepriceDate,RepriceDateMonth,RepriceDateDay");

		var repriceRateFlag = getItemValue(0,getRow(),"RepriceRateFlag");
		if(repriceRateFlag == "1")
		{
			var atz = $("#A_Group_0020");
			var obj_dw = document.getElementById('A_Group_0020');
			obj_dw.style.display="";
			ALSObjectWindowFunctions.setItemsRequired(0,"LoanRateTermID",true);
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"RepriceType,RepriceType,RepriceDateMonth,RepriceDateDay,RateFloat",false);
			setItemDisabled(0, 0, "LoanRateTermID", true);
			setItemDisabled(subdwname, 0, "RepriceType", true);
			setItemDisabled(subdwname, 0, "RepriceType", true);
			setItemDisabled(subdwname, 0, "RepriceDateMonth", true);
			setItemDisabled(subdwname, 0, "RepriceDateDay", true);
			setItemDisabled(subdwname, 0, "RATEFLOAT", true);
			setItemDisabled(subdwname, 0, "BusinessRate", true);
		}else
		{
			var atz = $("#A_Group_0020");
			var obj_dw = document.getElementById('A_Group_0020');
			obj_dw.style.display="none";
			ALSObjectWindowFunctions.setItemsRequired(0,"LoanRateTermID",false);
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"BaseRate,BaseRateType,RateUnit,RateFloatType,BusinessRate,RateFloat,RepriceType,RepriceDate,RepriceDateMonth,RepriceDateDay",false);
		}
		
	}
	
	//计算基准利率，需页面录入开始时间、结束时间、基准利率类型
	function initBaseRate(){
		var currency = "<%=currency%>";
		var termUnit = "<%=businessTermUnit%>";
		var termMonth = getItemValue(0, getRow(0), "LOANTERM");
		var termDay = getItemValue(0, getRow(0), "NewBusinessTermDay");

		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		var baseRateType = getItemValue(subdwname,getRow(subdwname),"BaseRateType");
		var rateUnit = getItemValue(subdwname,getRow(subdwname),"RateUnit");
		
		if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
		
		var baseRateGrade = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRateGrade","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
		setItemValue(subdwname,getRow(subdwname),"BaseRateGrade",baseRateGrade);
		
		var baseRate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRate","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(baseRate==0 || baseRate.length==0){
			alert("请检查是否已经维护基准利率！");
			return;
		}
		setItemValue(subdwname,getRow(subdwname),"BaseRate",baseRate);
	}
	
	function selfRefresh(){
		AsControl.OpenView("/CreditManage/CreditChange/ChangeLoanTerm.jsp",
				"TransSerialNo=<%=transSerialNo%>&RelativeObjectNo=<%=serialNo%>&TransCode=<%=transCode%>","_self","");
	}
	
	$(document).ready(function(){
		initRow();
		initTerm();
		calTerm();
		//initRate('1','initChangeRate();');
	});
	
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
