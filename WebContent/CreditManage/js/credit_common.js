//是否需要录入例外贷款原因
function calcExceptReason(){
	var nonstdIndicator = getItemValue(0,getRow(),"NonstdIndicator");
	if(nonstdIndicator == '02'){
		showItem("myiframe0","ExceptReasonName");
		setItemRequired("myiframe0","ExceptReasonName",true);
	}
	else
	{
		hideItem("myiframe0","ExceptReasonName");
		setItemValue(0,getRow(),"ExceptReasonName","");
		setItemValue(0,getRow(),"ExceptReason","");
		setItemRequired("myiframe0","ExceptReasonName",false);
	}
}

//是否需要录入例外贷款原因
function calcBillMail()
{
	var billMailFlag = getItemValue(0,getRow(),"BillMailFlag");
	if(billMailFlag == '1')
	{
		showItem("myiframe0","BillAddressType");
		setItemRequired("myiframe0","BillAddressType",true);
	}
	else
	{
		hideItem("myiframe0","BillAddressType");
		setItemValue(0,getRow(),"BillAddressType","");
		setItemRequired("myiframe0","BillAddressType",false);
	}
}

function CheckSegTerm(){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RPT");
	var RPTTermID = getItemValue(0, getRow(0), "RPTTermID");
	if(RPTTermID == "RPT-07" || RPTTermID == "RPT-08"){
		var segTerm = getItemValue(subdwname,getRow(0),"SegTerm");
		var businessTerm = getItemValue(0, getRow(0), "BusinessTerm");
		if(parseFloat(businessTerm) >= parseFloat(segTerm)){
			alert("无忧月供的期供计算期限应大于贷款期限");
			setItemValue(subdwname, getRow(0), "SegTerm", "");
		}
	}
}

//选择例外贷款原因
function SelectExceptCreditReason(){
	var codeNo = "ExceptCreditReason";
	var returnValue = AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","0",getRow(),"ExceptReason","ExceptReasonName");
}

function calcCLTerm(){
	var clTermYear = getItemValue(0,getRow(),"CLTermYear");
	var clTermMonth = getItemValue(0,getRow(),"CLTermMonth");
	if(typeof(clTermYear) == "undefined" || clTermYear.length == 0
		|| typeof(clTermMonth) == "undefined" || clTermMonth.length == 0) return;
	setItemValue(0,getRow(),"CLTerm",parseInt(clTermYear)*12+parseInt(clTermMonth));
}

//计算贷款期限月
function calcBusinessTerm(){
	var businessTermYear = getItemValue(0,getRow(),"BusinessTermYear");
	var businessTermMonth = getItemValue(0,getRow(),"BusinessTermMonth");
	if(typeof(businessTermYear) == "undefined" || businessTermYear.length == 0
		|| typeof(businessTermMonth) == "undefined" || businessTermMonth.length == 0) return;
	setItemValue(0,getRow(),"BusinessTerm",parseInt(businessTermYear)*12+parseInt(businessTermMonth));
	initRate("1");
	CheckSegTerm();
}

//改变还款方式
function initRPT(){
	var RPTTermID = getItemValue(0,getRow(),"RPTTermID");
	var productID = getItemValue(0,getRow(),"ProductID");
	if(typeof(productID) == "undefined" || productID.length == 0) 
		productID = getItemValue(0,getRow(),"BusinessType");
	if(typeof(productID) == "undefined" || productID.length == 0) 
		productID="";

	if(typeof(RPTTermID) == "undefined" || RPTTermID.length == 0) return;
	var parameters={};
	parameters["TermID"]=RPTTermID;
	parameters["ProductID"]=productID;
	parameters["ProductID"]=productID;
	parameters["ObjectType"]=objectType;
	parameters["ObjectNo"]=objectNo;
	ALSObjectWindowFunctions.refreshSubOW(0,"RPT",parameters,"changePaymentType()");
}

function changePaymentType(){
	var rpttermID = getItemValue(0,getRow(),"RPTTermID");
	if(typeof(rpttermID) == "undefined" || rpttermID.length == 0){
		ALSObjectWindowFunctions.hideItems(0,"PayFrequencyType,PayFrequency,DefaultDueDay");
		setItemValue(0,0,"PayFrequencyType","");
		setItemValue(0,0,"DefaultDueDay","");
		setItemValue(0,0,"PayFrequency","");
		ALSObjectWindowFunctions.setItemsRequired(0,"PayFrequencyType,PayFrequency,DefaultDueDay",false);
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RPT");
		if(subdwname==-1)return;
		ALSObjectWindowFunctions.hideItems(subdwname,"PayFrequency");
		setItemValue(subdwname, getRow(0), "PayFrequency", "");
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"PayFrequency",false);
	}
	else if(rpttermID=="RPT-06"){//组合还款时显示
		ALSObjectWindowFunctions.showItems(0,"PayFrequencyType,PayFrequency,DefaultDueDay");
		
		var paymentFrequencyType=getItemValue(0,getRow(0),"PayFrequencyType");
		if(typeof(paymentFrequencyType) == "undefined" || paymentFrequencyType == ""||paymentFrequencyType !="6"){
			ALSObjectWindowFunctions.hideItems(0,"PayFrequency");
			setItemValue(0, getRow(0), "PayFrequency", "");
			ALSObjectWindowFunctions.setItemsRequired(0,"PayFrequencyType,DefaultDueDay",true);
			ALSObjectWindowFunctions.setItemsRequired(0,"PayFrequency",false);
		}
		else{
			ALSObjectWindowFunctions.showItems(0,"PayFrequency");
			ALSObjectWindowFunctions.setItemsRequired(0,"PayFrequencyType,PayFrequency,DefaultDueDay",true);
		}
		var oldrptTermID=getItemValue(0,getRow(0),"OLDRPTTERMID");
		if(typeof(oldrptTermID) == "undefined" || oldrptTermID == "" || oldrptTermID == null)return;
		if(oldrptTermID=="RPT-06"){
			var oldpaymentFrequencyType=getItemValue(0,getRow(0),"OldPayFrequencyType");

			setItemValue(0,getRow(0),"PayFrequencyType", oldpaymentFrequencyType);
			ALSObjectWindowFunctions.setItemDisabled(0,getRow(0),"PayFrequencyType", true);
		}
	}
	else{
		ALSObjectWindowFunctions.hideItems(0,"PayFrequencyType,PayFrequency,DefaultDueDay");
		setItemValue(0,0,"PayFrequencyType","");
		setItemValue(0,0,"DefaultDueDay","");
		setItemValue(0,0,"PayFrequency","");
		ALSObjectWindowFunctions.setItemsRequired(0,"PayFrequencyType,PayFrequency,DefaultDueDay",false);
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RPT");
		if(subdwname==-1)return;
		var paymentFrequencyType=getItemValue(subdwname,getRow(subdwname),"PayFrequencyType");
		if(typeof(paymentFrequencyType) == "undefined" || paymentFrequencyType == ""||paymentFrequencyType !="6"){
			ALSObjectWindowFunctions.hideItems(subdwname,"PayFrequency");
			setItemValue(subdwname, getRow(0), "PayFrequency", "");
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"PayFrequency",false);
		}else{
			ALSObjectWindowFunctions.showItems(subdwname,"PayFrequency");
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"PayFrequency",true);
		}
		
	}
}

function checkRPTInfo(){
	var rpttermID = getItemValue(0,getRow(),"RPTTermID");
	if(typeof(rpttermID) == "undefined" || rpttermID.length == 0||rpttermID!="RPT-06")return true;
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RPT");
	if(subdwname==-1)return true;
	var rptCount = getRowCount(subdwname);

	var paymentFrequencyType=getItemValue(0,getRow(0),"PayFrequencyType");
	var defaultDueDay=getItemValue(0,getRow(0),"DefaultDueDay");
	var paymentFrequencyTerm=getItemValue(0,getRow(0),"PayFrequency");
	for(var i=0;i<rptCount;i++){
		setItemValue(subdwname,i,"PayFrequencyType",paymentFrequencyType);
		setItemValue(subdwname,i,"DefaultDueDay",defaultDueDay);
		setItemValue(subdwname,i,"PayFrequency",paymentFrequencyTerm);
	}
	
	var businessSum = getItemValue(0,getRow(),"BusinessSum");
	var businessTerm = getItemValue(0,getRow(),"BusinessTerm");
	var rptdata=ALSObjectWindowFunctions.getAllData(subdwname);
	var inputparameter = {"rptdata":rptdata};
	inputparameter["BusinessSum"]=businessSum;
	inputparameter["BusinessTerm"]=businessTerm;
	inputparameter["PayFrequencyType"]=paymentFrequencyType;
	inputparameter["DefaultDueDay"]=defaultDueDay;
	inputparameter["PayFrequency"]=paymentFrequencyTerm;
	inputparameter["ObjectType"]=objectType;
	inputparameter["ObjectNo"]=objectNo;
	var args=JSON.stringify({"InputParameter":inputparameter});
	var result=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.BusinessApplyCheck", "checkRPT",args);
	result=result.split("@");
	if(result[0]=="1")return true;
	else{
		alert(result[1]);
		return false;
	}
}

function newRecord_RPT(dwname){
	ALSObjectWindowFunctions.addRow(dwname,"","");
}

function deleteRecord_RPT(dwname){
	ALSObjectWindowFunctions.deleteSelectRow(dwname);
}

//是否需要录入公积金
function showReverseFund(){
	var AccuFundRepayFlag=getItemValue(0,getRow(),"AccuFundRepayFlag");
	if(AccuFundRepayFlag=="1"){
		showItem("myiframe0","FundRepayType");
		//showItem("myiframe0","FundRepayMonth");
		//ALSObjectWindowFunctions.setItemsRequired("0","FundRepayType",true);
	}else{
		//ALSObjectWindowFunctions.setItemsRequired("0","FundRepayType",false);
		hideItem("myiframe0","FundRepayType");
		//hideItem("myiframe0","FundRepayMonth");
		setItemValue(0,getRow(),"FundRepayType","");
		//setItemValue(0,getRow(),"FundRepayMonth","");
	}
}

function initRate(status,postEvent){
	
	var loanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	var productID = getItemValue(0,getRow(),"ProductID");
	if(typeof(productID) == "undefined" || productID.length == 0) 
		productID = getItemValue(0,getRow(),"BusinessType");
	if(typeof(productID) == "undefined" || productID.length == 0) 
		productID="";

	if(typeof(loanRateTermID) == "undefined" || loanRateTermID.length == 0) return;
	var parameters={};
	parameters["TermID"]=loanRateTermID;
	parameters["ProductID"]=productID;
	parameters["ProductID"]=productID;
	parameters["ObjectType"]=objectType;
	parameters["ObjectNo"]=objectNo;
	if(typeof(status) == "undefined" || status.length == 0){
		status="0";
	}
	parameters["Status"]=status;
	
	if(typeof(postEvent) == "undefined" || postEvent.length == 0){
		postEvent = "";
	}
	
	ALSObjectWindowFunctions.refreshSubOW(0,"RAT",parameters,"initRepriceDate();initBusinessRate();"+postEvent);

}

//利率调整方式
function initRepriceType(){
	var loanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(loanRateTermID) == "undefined" || loanRateTermID.length == 0) return;
	
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return;
	var rowcount=getRowCount(subdwname);
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(subdwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		rowcount=1;
	}
	
	for(var i=0;i<rowcount;i++){
		var rateMode = getItemValue(subdwname,i,"TermID");
		var repriceType = getItemValue(subdwname,i,"RepriceType");
		if(rateMode == "RAT01"){//浮动
			if(repriceType == "7")
			{
				setItemValue(subdwname,i,"RepriceType","");
			}
			
			if(rightType !="ReadOnly")
			{
				try{
				
					var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.GetRepriceTypeItems", "getItems","");
		 			var repriceTypeList = result.split(",");
					var data = {};
					for(var j = 0; j < repriceTypeList.length-1; j += 2){
						data[repriceTypeList[j]] = repriceTypeList[j+1];
					}
					ALSObjectWindowFunctions.setSelectOptions(subdwname,i,"RepriceType",data);
					setItemValue(subdwname,i,"RepriceType",repriceType);
				
				}catch (e){
					
				}
				ALSObjectWindowFunctions.setItemDisabled(subdwname,i,'RepriceType',false);
			}
		}
		else if(rateMode == "RAT02"){
			setItemValue(subdwname,i,"RepriceType","7");
			ALSObjectWindowFunctions.setItemDisabled(subdwname,i,'RepriceType',true);
		}
	}
	
	initRepriceDate();
}

//利率调整方式判断
function initRepriceDate(){
	var loanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(loanRateTermID) == "undefined" || loanRateTermID.length == 0) return;
	
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return;
	var rowcount=getRowCount(subdwname);
	var objectWindowStyle=ALSObjectWindowFunctions.getObjectWindowStyle(subdwname);
	if(objectWindowStyle==ALSObjectWindowFunctions.ObjectWindowStyle_Info){
		rowcount=1;
	}
	
	for(var i=0;i<rowcount;i++){
		var repriceType = getItemValue(subdwname,i,"RepriceType");
		var repriceDate = getItemValue(subdwname,i,"DefaultRepriceDate");
		
		if(repriceType == "8"){//指定日期调整
			if(loanRateTermID=="RAT03"){//组合利率
				ALSObjectWindowFunctions.setItemDisabled(subdwname,i,"RepriceTerm,DefaultRepriceDate,RepriceDateMonth,RepriceDateDay",false);
			}
			else{
				ALSObjectWindowFunctions.showItems(subdwname,"RepriceTerm,RepriceDateMonth,RepriceDateDay");
				ALSObjectWindowFunctions.setItemsRequired(subdwname,"RepriceTerm,RepriceDateMonth,RepriceDateDay",true);
				$("#Unit_"+subdwname+"_0240").html("日");
			}
			if(typeof(repriceDate) == "undefined" || repriceDate == null || repriceDate.length==0){
				setItemValue(subdwname,i,"DefaultRepriceDate","01/01");
				setItemValue(subdwname,i,"RepriceDateMonth","01");
				setItemValue(subdwname,i,"RepriceDateDay","01");
			}
			else{
				var month = getItemValue(subdwname,i,"RepriceDateMonth");
				var day = getItemValue(subdwname,i,"RepriceDateDay");
				
				if(typeof(month) == "undefined" || month.length == 0|| typeof(day) == "undefined" || day.length == 0){
					return;
				}
				else{
					if(month.length==1) month = "0"+month;
					if(day.length==1) day = "0"+day;
					setItemValue(subdwname,i,"DefaultRepriceDate",month+"/"+day);
				}
			}
		}
		else{
			if(loanRateTermID!="RAT03"){
				ALSObjectWindowFunctions.setItemsRequired(subdwname,"RepriceTerm,RepriceDateMonth,RepriceDateDay",false);
			}
			setItemValue(subdwname,i,"DefaultRepriceDate","");
			setItemValue(subdwname,i,"RepriceDateMonth","");
			setItemValue(subdwname,i,"RepriceDateDay","");
			
			if(loanRateTermID=="RAT03"){//组合利率
				ALSObjectWindowFunctions.setItemDisabled(subdwname,i,"RepriceTerm,DefaultRepriceDate,RepriceDateMonth,RepriceDateDay",true);
			}
			else{//单一利率
				ALSObjectWindowFunctions.hideItems(subdwname,"RepriceTerm,DefaultRepriceDate,RepriceDateMonth,RepriceDateDay");
			}
		}
	}
	
	
}

function newRecord_RAT(dwname){
	ALSObjectWindowFunctions.addRow(dwname,"","initBusinessRate()");
}

function deleteRecord_RAT(dwname){
	ALSObjectWindowFunctions.deleteSelectRow(dwname);
}

function checkRateInfo(){
	var rattermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(rattermID) == "undefined" || rattermID.length == 0||rattermID!="RAT03")return true;
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return true;
	
	var businessSum = getItemValue(0,getRow(),"BusinessSum");
	var businessTerm = getItemValue(0,getRow(),"BusinessTerm");
	var ratdata=ALSObjectWindowFunctions.getAllData(subdwname);
	var inputparameter = {"ratdata":ratdata};
	inputparameter["BusinessSum"]=businessSum;
	inputparameter["BusinessTerm"]=businessTerm;
	var args=JSON.stringify({"InputParameter":inputparameter});
	var result=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.BusinessApplyCheck", "checkRAT",args);
	result=result.split("@");
	if(result[0]=="1")return true;
	else{
		alert(result[1]);
		return false;
	}
}

//罚息利率事件
function setFineRateType(){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"FIN");
	if(subdwname==-1)return;
	var rateMode = getItemValue(subdwname,getRow(subdwname),"TermID");
	if(typeof(rateMode) == "undefined" || rateMode == "" || rateMode == null){
		ALSObjectWindowFunctions.hideItems(subdwname,"RateFloat,BusinessRate");
		return;
	}
	if(rateMode == "FIN01"){//浮动
		ALSObjectWindowFunctions.hideItems(subdwname,"BusinessRate");
		ALSObjectWindowFunctions.showItems(subdwname,"RateFloat");
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"RateFloat",true);
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"BusinessRate",false);
	}
	else{
		ALSObjectWindowFunctions.showItems(subdwname,"BusinessRate");
		ALSObjectWindowFunctions.hideItems(subdwname,"RateFloat");
		setItemValue(subdwname,0,"RateFloat","");//清空手工收入的幅度浮动。防止产品参数校验时报错
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"RateFloat",false);
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"BusinessRate",true);
		/*
		if(rightType == "ReadOnly") return;
		
		var baseRateType = getItemValue(subdwname,getRow(subdwname),"BaseRateType");
		var rateUnit = getItemValue(subdwname,getRow(subdwname),"RateUnit");
		var currency = getItemValue(0,getRow(0),"BusinessCurrency");
		var termUnit = getItemValue(0,getRow(0),"BusinessTermUnit");
		var termMonth = getItemValue(0,getRow(0),"BusinessTerm");
		var termDay = getItemValue(0,getRow(0),"BusinessTermDay");
		
		if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
		var baseRateGrade = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRateGrade","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
		setItemValue(subdwname,getRow(subdwname),"BaseRateGrade",baseRateGrade);
		
		var baseRate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRate","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
		if(baseRate==0 || baseRate.length==0){
			alert("请检查是否已经维护基准利率！");
			return;
		}
		var BaseRate = baseRate*3.6;
		setItemValue(subdwname,getRow(subdwname),"BaseRate",BaseRate);
		setItemValue(subdwname,getRow(subdwname),"BusinessRate",BaseRate);
		*/
	}
}

function initRateFloat(){
	
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return;
	initBaseRate();
   	var baseRate = getItemValue(subdwname,getRow(subdwname),"BaseRate");
   	if(typeof(baseRate) == "undefined" || baseRate == "" || baseRate == 0){
   		return;
   	}
   	var rateFloatType = getItemValue(subdwname,getRow(subdwname),"RateFloatType");
   	if(typeof(rateFloatType) == "undefined" || rateFloatType.length == 0){
   		return;
   	}
   	var loanRate = getItemValue(subdwname,getRow(subdwname),"BusinessRate");
   	var rateFloat = getRateFloat(baseRate*1.0,rateFloatType+"",loanRate*1.0);
   	if(typeof(loanRate) == "undefined" || loanRate.length == 0){
   		alert("未获取到执行利率！");
   		return;
   	}
	if(loanRate<0){
		alert("输入的执行利率不能小于0！");
		return;
	}
   	setItemValue(subdwname,getRow(subdwname),"RateFloat",rateFloat.toFixed(14));
}

function initBusinessRate(){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return;
	initBaseRate();
   	var baseRate = getItemValue(subdwname,getRow(subdwname),"BaseRate");
   	if(typeof(baseRate) == "undefined" || baseRate == "" || baseRate == 0){
   		return;
   	}
   	var rateFloatType = getItemValue(subdwname,getRow(subdwname),"RateFloatType");
   	if(typeof(rateFloatType) == "undefined" || rateFloatType.length == 0){
   		return;
   	}
   	var rateFloat = getItemValue(subdwname,getRow(subdwname),"RateFloat");
   	var loanRate = getLoanExecuteRate(baseRate*1.0,rateFloatType+"",rateFloat*1.0);
   	if(typeof(loanRate) == "undefined" || loanRate.length == 0){
   		alert("未获取到执行利率！");
   		return;
   	}
	if(loanRate<0){
		alert("输入的执行利率不能小于0！");
		return;
	}
   	setItemValue(subdwname,getRow(subdwname),"BusinessRate",loanRate.toFixed(14));
}

//计算基准利率，需页面录入开始时间、结束时间、基准利率类型
function initBaseRate(){
	if(rightType == "ReadOnly") return;
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	if(subdwname==-1)return;
	var baseRateType = getItemValue(subdwname,getRow(subdwname),"BaseRateType");
	var rateUnit = getItemValue(subdwname,getRow(subdwname),"RateUnit");
	var currency = getItemValue(0,getRow(0),"BusinessCurrency");
	var termUnit = getItemValue(0,getRow(0),"BusinessTermUnit");
	var termMonth = getItemValue(0,getRow(0),"BusinessTerm");
	var termDay = getItemValue(0,getRow(0),"BusinessTermDay");
	
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


function getLoanExecuteRate(baseRate,rateFloatType,rateFloat){
	if(rateFloatType == "0" || rateFloatType == 0){
		return baseRate*(1.0+rateFloat/100.0);
	}else if(rateFloatType == "1" || rateFloatType == 1){
		return baseRate+rateFloat/100.0;
	}else{
		return baseRate;
	}
}

function getRateFloat(baseRate,rateFloatType,rate){
	if(rateFloatType == "0" || rateFloatType == 0){
		return rate/baseRate*100-100;
	}else if(rateFloatType == "1" || rateFloatType == 1){
		return rate-baseRate;
	}else{
		return 0;
	}
}

//校验账户信息
function checkAccount(subdwname,ai,at,an,ana,ac,an1,acid,amfcid,callType)
{
	var paymentType = getItemValue(0, getRow(), "PaymentType");
	if(paymentType == "3" && subdwname == "ATT"){
		callType = "0005";
	}
	var subdw = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdwname);
	var accountIndicator = getItemValue(subdw, getRow(), ai);
	var accountType = getItemValue(subdw, getRow(), at);
	var accountNo = getItemValue(subdw, getRow(), an);
	var accountName = getItemValue(subdw, getRow(), ana);
	var accountCurrency = getItemValue(subdw, getRow(), ac);
	
	if(typeof(accountType) == "undefined" || accountType.length == 0) return;

	if(subdwname.indexOf("ATT") >= 0 && accountType != "7")
	{
		ALSObjectWindowFunctions.setItemHeader(subdw,an,"放款卡号/一本通号");
	}
	
	if(accountType == "4")
	{
		ALSObjectWindowFunctions.hideItems(subdw,an+","+ana+","+an1+",AccountOrgID");
		setItemValue(subdw, getRow(), an, "");
		setItemValue(subdw, getRow(), ana, "");
		setItemValue(subdw, getRow(), an1, "");
		setItemValue(subdw, getRow(), amfcid, "");
		ALSObjectWindowFunctions.setItemsRequired(subdw,an+","+ana+","+an1, false);
	}
	else if(subdwname.indexOf("ATT") >= 0 && accountType == "7")
	{
		ALSObjectWindowFunctions.showItems(subdw,an+","+ana+",AccountOrgID");
		ALSObjectWindowFunctions.hideItems(subdw,an1);
		ALSObjectWindowFunctions.setItemsRequired(subdw,an+","+ana, true);
		ALSObjectWindowFunctions.setItemHeader(subdw,an,"放款账户账号");
	}
	else
	{
		ALSObjectWindowFunctions.showItems(subdw,an+","+ana+","+an1+",AccountOrgID");
		ALSObjectWindowFunctions.setItemsRequired(subdw,an+","+ana, true);
	}
	
	queryAccount(subdwname,ai,at,an,ana,ac,an1,acid,amfcid,callType);
	
	return true;
}

function queryAccount(subdwname,ai,at,an,ana,ac,an1,acid,amfcid,callType)
{
	var paymentType = getItemValue(0, getRow(), "PaymentType");
	if(paymentType == "3" && subdwname == "ATT"){
		callType = "0005";
	}
	var subdw = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdwname);
	var accountIndicator = getItemValue(subdw, getRow(), ai);
	var accountType = getItemValue(subdw, getRow(), at);
	var accountNo = getItemValue(subdw, getRow(), an);
	var accountName = getItemValue(subdw, getRow(), ana);
	var accountCurrency = getItemValue(subdw, getRow(), ac);
	
	if(typeof(accountType) == "undefined" || accountType.length == 0) return;
	if(typeof(accountNo) == "undefined" || accountNo.length == 0) return;
	if(rightType == "ReadOnly") return;
	/*
	var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency+","+callType);
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
	if(returnValue.split("@")[0] == "false"){
		alert(returnValue.split("@")[1]);
		setItemValue(subdw, getRow(0), an, "");
		setItemValue(subdw, getRow(0), ana, "");
		setItemValue(subdw, getRow(0), an1, "");
		return false;
	}else{
		setItemValue(subdw, getRow(0), an1, returnValue.split("@")[1]);
		setItemValue(subdw, getRow(0), ana, returnValue.split("@")[2]);
		setItemValue(subdw, getRow(0), acid, returnValue.split("@")[3]);
		setItemValue(subdw, getRow(0), amfcid, returnValue.split("@")[4]);
	}
	*/
}


function initATT(){
	var paymentType = getItemValue(0, getRow(), "PaymentType");
	if(typeof(paymentType) == "undefined" || paymentType.length == 0) return;
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ATT");//放款账户信息
	var subdwname1 = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ACT");//还款账户信息
	var subdwname2 = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ABZ");//保证金账户信息
	
	ALSObjectWindowFunctions.setItemDisabled(subdwname,0,'AccountType',false);
	ALSObjectWindowFunctions.setItemDisabled(subdwname,0,'AccountNo',false);
	ALSObjectWindowFunctions.setItemDisabled(subdwname2,0,'AccountNo',false);
	ALSObjectWindowFunctions.setItemUnit(subdwname,'AccountNo',"");
	//0 收款人为借款人（备用金）
	if("0" == paymentType)
	{
		ALSObjectWindowFunctions.hideItems(subdwname,"AccountType,AccountNo,AccountName,AccountNo1");
		setItemValue(subdwname,getRow(),'AccountType',"");
		setItemValue(subdwname,getRow(),'AccountNo',"");
		setItemValue(subdwname,getRow(),'AccountName',"");
		setItemValue(subdwname,getRow(),'AccountNo1',"");
		setItemValue(subdwname,getRow(subdwname),'AccountType','');
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"AccountType,AccountNo,AccountName,AccountNo1", false);
		ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountType',false);
		//只有支付方式为合作商时才需要显示保证金账号信息
		ALSObjectWindowFunctions.hideItems(subdwname2,"AccountNo,AccountName,AccountAmt");
		setItemValue(subdwname2,getRow(),'AccountNo1',"");
		setItemValue(subdwname2,getRow(),'AccountNo',"");
		setItemValue(subdwname2,getRow(),'AccountName',"");
		setItemValue(subdwname2,getRow(),'AccountAmt',"");
	}else if("1" == paymentType)//合作商
	{
		ALSObjectWindowFunctions.showItems(subdwname,"AccountType,AccountNo,AccountName,AccountNo1");
		setItemValue(subdwname,getRow(subdwname),'AccountType','7');
		ALSObjectWindowFunctions.setItemDisabled(subdwname,0,'AccountType',true);
		ALSObjectWindowFunctions.setItemDisabled(subdwname,0,'AccountNo',true);
		ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountType',false);
		ALSObjectWindowFunctions.setItemUnit(subdwname,'AccountNo',"<input class=\"inputdate\" value=\"..\" type=button onClick=selectProjectAccount(\""+objectType+"\",\""+objectNo+"\")>");
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"AccountType,AccountName,AccountNo", true);

		//只有支付方式为合作商时才需要显示保证金账号信息
		ALSObjectWindowFunctions.showItems(subdwname2,"AccountNo,AccountName,AccountAmt");
		ALSObjectWindowFunctions.setItemDisabled(subdwname2,0,'AccountNo',true);
		ALSObjectWindowFunctions.setItemDisabled(subdwname2,0,'AccountName',true);
		if(rightType != "ReadOnly"){
			var returnValue = RunJavaMethodSqlca("com.amarsoft.app.check.apply.InitProjectAccount","initAccount","ObjectType="+objectType+",ObjectNo="+objectNo);
			returnValue = returnValue.split("@");
			if(returnValue[0]=="true" && typeof(returnValue[2]) != "undefined" && returnValue[2].length != 0){
				setItemValue(subdwname,getRow(),'AccountType',returnValue[1]);
				setItemValue(subdwname,getRow(),'AccountNo',returnValue[2]);
				setItemValue(subdwname,getRow(),'AccountName',returnValue[3]);
				setItemValue(subdwname,getRow(),'AccountNo1',returnValue[4]);
				setItemValue(subdwname,getRow(),'CustomerID',returnValue[5]);
				setItemValue(subdwname,getRow(),'MFCustomerID',returnValue[6]);
				setItemValue(subdwname2,getRow(),'AccountType',returnValue[7]);
				setItemValue(subdwname2,getRow(),'AccountNo',returnValue[8]);
				setItemValue(subdwname2,getRow(),'AccountName',returnValue[9]);
				setItemValue(subdwname2,getRow(),'AccountNo1',returnValue[10]);
				setItemValue(subdwname2,getRow(),'CustomerID',returnValue[11]);
				setItemValue(subdwname2,getRow(),'MFCustomerID',returnValue[12]);
				if(typeof(returnValue[8]) != "undefined" && returnValue[8].length != 0)
				{
					ALSObjectWindowFunctions.setItemDisabled(subdwname2,0,'AccountNo',true);
					var percent = parseFloat(returnValue[13])/100.0;
					var businessSum = getItemValue(0,getRow(0),"BusinessSum");
					setItemValue(subdwname2,getRow(),'AccountAmt',parseFloat(businessSum)*percent);
				}
			}	
		}
	}else if("2" == paymentType) //2 指定账号 
	{
		ALSObjectWindowFunctions.showItems(subdwname,"AccountType,AccountNo,AccountName,AccountNo1");
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"AccountType,AccountName,AccountNo", true);
		//只有支付方式为合作商时才需要显示保证金账号信息
		ALSObjectWindowFunctions.hideItems(subdwname2,"AccountNo,AccountName,AccountAmt");
		setItemValue(subdwname2,getRow(),'AccountNo1',"");
		setItemValue(subdwname2,getRow(),'AccountNo',"");
		setItemValue(subdwname2,getRow(),'AccountName',"");
		setItemValue(subdwname2,getRow(),'AccountAmt',"");
		ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountType',false);
	}else if("3" == paymentType) //3 贷款专户
	{
		ALSObjectWindowFunctions.showItems(subdwname1,"AccountType,AccountNo,AccountName,AccountNo1");
		setItemValue(subdwname1, getRow(), "AccountType", "0");
		ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountType',true);
		ALSObjectWindowFunctions.showItems(subdwname,"AccountType,AccountNo,AccountName,AccountNo1");
		ALSObjectWindowFunctions.setItemsRequired(subdwname,"AccountType,AccountName,AccountNo", true);
		setItemValue(subdwname,getRow(),'AccountType','0');
		ALSObjectWindowFunctions.setItemDisabled(subdwname,0,'AccountType',true);
		//只有支付方式为合作商时才需要显示保证金账号信息
		ALSObjectWindowFunctions.hideItems(subdwname2,"AccountNo,AccountName,AccountAmt");
		setItemValue(subdwname2,getRow(),'AccountNo1',"");
		setItemValue(subdwname2,getRow(),'AccountNo',"");
		setItemValue(subdwname2,getRow(),'AccountName',"");
		setItemValue(subdwname2,getRow(),'AccountAmt',"");
	}
	
	checkAccount('ATT','AccountIndicator','AccountType','AccountNo','AccountName','AccountCurrency','AccountNo1','CustomerID','MFCustomerID');
}


//通过期限计算到期日
function initMaturity()
{
	initRate("1");
	var putoutDate=getItemValue(0,getRow(),"PutOutDate");
	var termMonth=getItemValue(0,getRow(),"BusinessTerm");
	var termDay=getItemValue(0,getRow(),"BusinessTermDay");
	if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
	if(typeof(termMonth) == "undefined" || termMonth.length == 0) return;
	if(typeof(termDay) == "undefined" || termDay.length == 0) return;
	
	if(termDay>30 || termDay<0){
		alert("贷款期限天数应在0~30之间，请重新输入！");
		return;
	}
	var maturity = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","PutOutDate="+putoutDate+",LoanTermFlag=M,LoanTerm="+termMonth);
	maturity=AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","PutOutDate="+maturity+",LoanTermFlag=D,LoanTerm="+termDay);
	setItemValue(0, getRow(0), "MaturityDate",maturity);

}

function initTerm(){
	var putoutDate=getItemValue(0,getRow(),"PutOutDate");
	var maturityDate=getItemValue(0,getRow(),"MaturityDate");
	if(typeof(putoutDate) == "undefined" || putoutDate.length == 0) return;
	if(typeof(maturityDate) == "undefined" || maturityDate.length == 0) return;
	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.DateAction","calcTerm","BeginDate="+putoutDate+",EndDate="+maturityDate);
	if(typeof(returnValue) == "undefined" || returnValue.length == 0) return;
	var termMonth = returnValue.split("@")[0];
	var termDay = returnValue.split("@")[1];
	var year = returnValue.split("@")[2];
	var otherMonth = returnValue.split("@")[3];
	setItemValue(0, getRow(0), "BusinessTermYear",year);
	setItemValue(0, getRow(0), "BusinessTermMonth",otherMonth);
	setItemValue(0, getRow(0), "BusinessTerm",termMonth);
	setItemValue(0, getRow(0), "BusinessTermDay",termDay);
}


//设置下拉框选项
function setItemSelect(dwname,rowindex,fieldName,value){
	var fieldValue = getItemValue(0,rowindex,fieldName);
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	try{
		var obj = getObj(dwindex,fieldName);
		obj.options[0] = new Option("","");
		obj.length = 1;
		
		var i = 0;
		var opts = value.split(";");
		for(var j = 0; j < opts.length; j ++)
		{
			obj.options[i++]=new Option(opts[j].split(",")[1],opts[j].split(",")[0]);
		}
		setItemValue(0,rowindex,fieldName,fieldValue);
	}catch(e){}
}

//选择合作项目账号
function selectProjectAccount(objectType,objectNo){
	var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ATT");
	var returnValue = AsDialog.SelectGridValue("SelectProjectAccount",objectType+","+objectNo,
			"AccountType@AccountNo@AccountName@AccountNo1@CustomerID@MFCustomerID@ObjectNo","","");
	if(!returnValue || returnValue == "_NONE_" || returnValue == "_CANCEL_") return;
	returnValue = returnValue.split("@");
	setItemValue(subdwname,getRow(),'AccountType',returnValue[0]);
	setItemValue(subdwname,getRow(),'AccountNo',returnValue[1]);
	setItemValue(subdwname,getRow(),'AccountName',returnValue[2]);
	setItemValue(subdwname,getRow(),'AccountNo1',returnValue[3]);
	setItemValue(subdwname,getRow(),'CustomerID',returnValue[4]);
	setItemValue(subdwname,getRow(),'MFCustomerID',returnValue[5]);
	
	var subdwname1 = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ABZ");
	var returnValue = RunJavaMethodSqlca("com.amarsoft.app.check.apply.InitProjectBailAccount","initAccount","ObjectType=jbo.prj.PRJ_BASIC_INFO,ObjectNo="+returnValue[6]);
	returnValue = returnValue.split("@");
	if(returnValue[0]=="true"){
		setItemValue(subdwname1,getRow(),'AccountType',returnValue[1]);
		setItemValue(subdwname1,getRow(),'AccountNo',returnValue[2]);
		setItemValue(subdwname1,getRow(),'AccountName',returnValue[3]);
		setItemValue(subdwname1,getRow(),'AccountNo1',returnValue[4]);
		setItemValue(subdwname1,getRow(),'CustomerID',returnValue[5]);
		setItemValue(subdwname1,getRow(),'MFCustomerID',returnValue[6]);
		if(typeof(returnValue[2]) != "undefined" && returnValue[2].length != 0)
		{
			ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountNo',true);
			
			var percent = parseFloat(returnValue[7])/100.0;
			var businessSum = getItemValue(0,getRow(0),"BusinessSum");
			setItemValue(subdwname1,getRow(),'AccountAmt',parseFloat(businessSum)*percent);
		}
		else
		{
			ALSObjectWindowFunctions.setItemDisabled(subdwname1,0,'AccountNo',false);
		}
	}
	checkAccount('ATT','AccountIndicator','AccountType','AccountNo','AccountName','AccountCurrency','AccountNo1','CustomerID','MFCustomerID');
}
