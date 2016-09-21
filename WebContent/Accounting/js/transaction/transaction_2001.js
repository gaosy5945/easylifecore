var nLessZ = "不能小于等于0";
var MoreZ = "必须大于0";
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	if(actualPayAmt<=0){
		alert("还款总金额"+nLessZ);
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	//校验账号必输
	var payAccountNo = getItemValue(0,getRow(),"PayAccountNo");
	if(typeof(payAccountNo)=="undefined"||payAccountNo.length==0){
		alert("必须引入还款账号!");
		return false;
	}
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	
}


/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
function initRow(){
	setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	setValue("TransDate",businessDate);
	afterSave();
	changeCashOnlineFlag();
}

/*~[Describe=重算还款总金额;InputParam=后续事件;OutPutParam=无;]~*/
function changeActualPayAmt(){
	var OverdueBalance = getItemValue(0,getRow(),"OverdueBalance");//期供欠本金额
	var InterestBalance = getItemValue(0,getRow(),"InterestBalance");//期供欠息金额
	var PrincipalPenaltyBalance = getItemValue(0,getRow(),"PrincipalPenaltyBalance");//逾期罚息金额
	var InterestPenaltyBalance = getItemValue(0,getRow(),"InterestPenaltyBalance");//逾期复息金额
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");//实收本金
	var ActualPayInterestAmt = getItemValue(0,getRow(),"ActualPayInterestAmt");//实收利息
	var ActualPayPrincipalPenaltyAmt = getItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt");//实收罚息
	var ActualPayInterestPenaltyAmt = getItemValue(0,getRow(),"ActualPayInterestPenaltyAmt");//实收复息
	
	var temp = "不能超过";
	if(parseFloat(ActualPayPrincipalAmt)>parseFloat(OverdueBalance)){
		alert("实收本金"+temp+"欠还本金");
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestAmt)>parseFloat(InterestBalance)){
		alert("实收利息"+temp+"欠还利息");
		setItemValue(0,getRow(),"ActualPayInterestAmt",0);
		return;
	}
	if(parseFloat(ActualPayPrincipalPenaltyAmt)>parseFloat(PrincipalPenaltyBalance)){
		alert("实收罚息"+temp+"逾期罚息金额");
		setItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestPenaltyAmt)>parseFloat(InterestPenaltyBalance)){
		alert("实收复息"+temp+"逾期复息金额");
		setItemValue(0,getRow(),"ActualPayInterestPenaltyAmt",0);
		return;
	}
	
	if(parseFloat(ActualPayPrincipalAmt)<0){
		alert("实收本金"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestAmt)<0){
		alert("实收利息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInterestAmt",0);
		return;
	}
	if(parseFloat(ActualPayPrincipalPenaltyAmt)<0){
		alert("实收罚息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestPenaltyAmt)<0){
		alert("实收复息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInterestPenaltyAmt",0);
		return;
	}
	
	setItemValue(0,getRow(),"ActualPayAmt",(parseFloat(ActualPayPrincipalAmt)+parseFloat(ActualPayInterestAmt)+parseFloat(ActualPayPrincipalPenaltyAmt)+parseFloat(ActualPayInterestPenaltyAmt)).toFixed(2));
}