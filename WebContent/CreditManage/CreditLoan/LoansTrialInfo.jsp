<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sTempletNo = "LoanTrialInfo";//--模板号--
	
	String sObjectType = "";  
	String sObjectNo ="";
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType",sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","试算","试算","trial()","","","",""}
	};
	//sButtonPosition = "south";
    
%>

<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<script type="text/javascript">
	var rightType = "";
	var objectType = "jbo.app.BUSINESS_DUEBILL";
	var objectNo = "X000001";
	
	function trial(){
		
		if(!ALSObjectWindowFunctions.objectWindowMetaData||ALSObjectWindowFunctions.objectWindowMetaData.length<=0){
			return;
		}

		var checkResult = true;
		for(var i=0;i<ALSObjectWindowFunctions.objectWindowMetaData.length;i++){
				if(!iV_all(i)){//首先校验是否可以保存，并组装数据
					checkResult=false;
					continue;
				}
		}
		if(!checkResult){
			ALSObjectWindowFunctions.showErrors();
			return;
		}
		
		if(!checkRPTInfo() || !checkRateInfo()) return;
		
		//基本信息
		var DstrAmt = getItemValue(0,getRow(),"BusinessSum");//贷款金额
		var BusinessTerm = getItemValue(0,getRow(),"BusinessTerm");//贷款期限
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");//贷款起始日
		var ExpiredDate = getItemValue(0,getRow(),"ExpiredDate");//贷款到期日
		var StartNum1 = getItemValue(0,getRow(),"StartNum1");//起始笔数（查询起始期数）
		var QueryNum1 = getItemValue(0,getRow(),"QueryNum1");//查询笔数（查询结束期数）
		

		//---------還款方式組件----------
		var RepayMode = getItemValue(1,getRow(),"RPTTermID");//还款方式
		if(RepayMode.length==0 || typeof(RepayMode) == "undefined") RepayMode = "";
				
		var FixedPeriod1 = getItemValue(1,getRow(),"PaymentFrequencyTerm"); //固定周期<!-----有问题-------->
		if(FixedPeriod1 == null || typeof(FixedPeriod1) == "undefined" || FixedPeriod1.length == 0) FixedPeriod1 = getItemValue(0,getRow(),"PaymentFrequencyTerm");
		if(FixedPeriod1 == null || typeof(FixedPeriod1) == "undefined" || FixedPeriod1.length == 0) FixedPeriod1 = "";
		
		var IntActualPrd = getItemValue(1,getRow(),"PaymentFrequencyType");//计息周期(还款周期)
		if(IntActualPrd == null || typeof(IntActualPrd) == "undefined" || IntActualPrd.length == 0) IntActualPrd = getItemValue(0,getRow(),"PaymentFrequencyType");
		if(IntActualPrd == null || typeof(IntActualPrd) == "undefined" || IntActualPrd.length == 0) IntActualPrd = "";
		
		var DeductDate = getItemValue(1,getRow(),"DefaultDueDay");//每月扣款日（还款日）
		if(DeductDate == null || typeof(DeductDate) == "undefined" || DeductDate.length == 0) DeductDate = getItemValue(0,getRow(),"DefaultDueDay");
		if(DeductDate == null || typeof(DeductDate) == "undefined" || DeductDate.length == 0) DeductDate = "";
		
		var IncrDecPrd = getItemValue(1,getRow(),"GainCyc");//递增递减周期（递变周期）
		if(IncrDecPrd == null || typeof(IncrDecPrd) == "undefined" || IncrDecPrd.length == 0) IncrDecPrd = "";
		var IncrDecAmt = getItemValue(1,getRow(),"GainAmount");//递增递减额（递变幅度）
		if(IncrDecAmt == null || typeof(IncrDecAmt) == "undefined" || IncrDecAmt.length == 0) IncrDecAmt = "";
		
		var PayCountTime = getItemValue(1,getRow(),"SegTerm");//期供计算期限
		if(PayCountTime == null || typeof(PayCountTime) == "undefined" || PayCountTime.length == 0) PayCountTime = "";	
		
		//-------利率組件----------
		var RateType = getItemValue(2,getRow(),"RateType");	//利率類型 <!-------有问题--------->
		if(RateType == null || typeof(RateType) == "undefined" || RateType.length == 0) RateType = ""; 

		var StandardRate = getItemValue(2,getRow(),"BaseRate");	//基準利率(自動顯示)??????
		
		//浮動幅度
		var FloatRange = getItemValue(2,getRow(),"RateFloat");	//浮动幅度
		if(FloatRange == null || FloatRange == "undefined") FloatRange = "";
		//執行利率(自动显示)
		var BusinessRate = 	getItemValue(2,getRow(),"BusinessRate"); //执行利率
		if(BusinessRate == null || BusinessRate == "undefined") BusinessRate = "";
		//利率調整方式
		var RateChangeType = getItemValue(2,getRow(),"RepriceType");
		if(RateChangeType == null || RateChangeType == "undefined") RateChangeType = "";	
		//利率調整日期
		var RateChangeDate = getItemValue(2,getRow(),"RepriceDate");
		if(RateChangeDate == null || RateChangeDate == "undefined") RateChangeDate = "";
		var repaylength="";
		if(RepayMode=="RPT-06"){
			var n = getRowCount(1);
			for(var i =0;i<n;i++){
				var SEGRPTTermID = getItemValue(1,i,"SEGRPTTermID");
				var SegRPTAmount = getItemValue(1,i,"SegRPTAmount");
				var SEGToStage = getItemValue(1,i,"SEGToStage");
				SegRPTAmount = SegRPTAmount.replace(",","");
				
				if(typeof(SegRPTAmount) == "undefined" || SegRPTAmount.length == 0) SegRPTAmount = 0;
				repaylength += SEGRPTTermID+"@"+SegRPTAmount+"@"+SEGToStage+"~";
			}
			if(repaylength.length>0)
				repaylength=repaylength.substring(0, repaylength.length-1);
			
		}
		
		
		
		AsControl.OpenView("/CreditManage/CreditLoan/LoansTrialList.jsp","DstrAmt="+DstrAmt+"&StartIntDate="+StartIntDate+"&ExpiredDate="+ExpiredDate+"&StartNum1="+StartNum1+"&QueryNum1="+QueryNum1
				+"&RepayMode="+RepayMode+"&FixedPeriod1="+FixedPeriod1+"&IntActualPrd="+IntActualPrd+"&DeductDate="+DeductDate+"&IncrDecPrd="+IncrDecPrd+"&IncrDecAmt="+IncrDecAmt+"&PayCountTime="+PayCountTime
				+"&RateType="+RateType+"&StandardRate="+StandardRate+"&FloatRange="+FloatRange+"&BusinessRate="+BusinessRate+"&RateChangeType="+RateChangeType+"&RateChangeDate="+RateChangeDate+"&TermValue="+repaylength,"_blank","");
		
	}
		 
	$(document).ready(function(){		 	 
		 //initRPT();
		 //initRate();		 
		changePaymentType();
		ALSObjectWindowFunctions.hideItems(0,"LoanRateTermID");
		setItemValue(0,getRow(),"LoanRateTermID","RAT01");
		initRate();
	 })
	 
	 function changeDate(date){
		 return parseInt(date.substring(0, 4) + date.substring(5, 7) + date.substring(8, 10));
	}
	
	function validateDate(date){
		var month = date.split("/")[0];
		var day = date.split("/")[1];
		if(month > 12 || month < 1){
			alert("输入月有误");
			return false;
		}
		if(day > 31 || day < 1){
			alert("输入日有误");	
			return false;
		}
		return true;
	}


	function getDate(date1,date2){
		
		var month1 = parseInt(date1.split("/")[1]);
		var year1 = parseInt(date1.split("/")[0]);
		var month2 = parseInt(date2.split("/")[1]);
		var year2 = parseInt(date2.split("/")[0]);
		
		var allMonth;
		if(month1 < month2){
			allMonth = (year2-year1)*12+month2-month1;
		}
		else{
			allMonth = (year2-year1-1)*12+month2+12-month1;
		}
		return allMonth;
	}
	
	function ChangeLoanTerm(){
		var ExpiredDate = "";
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");
		var LoanTerm = getItemValue(0,getRow(),"BusinessTerm");//贷款期限 
		if(LoanTerm !=0){
			  sLoanTermFlag ="020";
			  ExpiredDate = RunJavaMethod("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+sLoanTermFlag+",loanTerm="+LoanTerm+",putOutDate="+StartIntDate); 
			  setItemValue(0,getRow(),"ExpiredDate",ExpiredDate);
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
