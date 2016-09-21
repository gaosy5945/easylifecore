/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	var transCode = getItemValue(0,getRow(),"TransCode");
	if(transCode == "3508")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var waiveType = getItemValue(0,getRow(),"WaiveType");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		var calFeeAmount = "";
		if(waiveType == "0"){//按照金额减免
			var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
			calFeeAmount = parseFloat(feeAmount)+parseFloat(waiveAmount);
		}
		else if(waiveType == "1")//按照比例减免
		{
			var waivePercent = getItemValue(0,getRow(),"WaivePercent");
			calFeeAmount = parseFloat(feeAmount)*(1+parseFloat(waivePercent)/100.0);
		}
		
		if(actualFeeAmount>calFeeAmount){
			alert("实收费用金额不能超过计算所得的实收费用金额："+calFeeAmount);
			return false;
		}
		
		if(actualFeeAmount <= 0)
		{
			alert("实收费用金额不能小于等于0！");
			return false;
		}
	}
	else if(transCode == "3520")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(feeAmount < actualFeeAmount)
		{
			alert("实收费用金额不能超过应收费用金额！");
			return false;
		}
		if(actualFeeAmount <= 0)
		{
			alert("实收费用金额不能小于等于0！");
			return false;
		}
	}
	else if(transCode == "3530")
	{
		var waiveType = getItemValue(0,getRow(),"WaiveType");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		var calFeeAmount = "";
		if(waiveType == "0"){//按照金额减免
			var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
			calFeeAmount = parseFloat(feeAmount)+parseFloat(waiveAmount);
		}
		else if(waiveType == "1")//按照比例减免
		{
			var waivePercent = getItemValue(0,getRow(),"WaivePercent");
			calFeeAmount = parseFloat(feeAmount)*(1+parseFloat(waivePercent)/100.0);
		}
		if(calFeeAmount < 0)
		{
			alert("调整后的费用金额不能为负数，请检查！");
			return false;
		}
	}
	else if(transCode == "3540")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(feeAmount < actualFeeAmount)
		{
			alert("实退费用金额不能大于应退费用金额！");
			return false;
		}
		if(actualFeeAmount <= 0)
		{
			alert("实退费用金额不能小于等于0！");
			return false;
		}
	}
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	calcFeeAmount();
}

/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//新增记录
	}
	calcFeeAmount();
}

function selectFeeScheduleSerialNo(sFeeFlag)
{
	var feeSerialNo = getItemValue(0,getRow(),"FeeSerialNo");
	setObjectValue("SelectFeeSchedule","ObjectType,jbo.acct.ACCT_FEE,ObjectNo,"+feeSerialNo+",FeeFlag,"+sFeeFlag,"@FeeScheduleSerialno@0@FeeAmount@1",0,0,"");
}

/*~[Describe=计算减免后的费用;InputParam=后续事件;OutPutParam=无;]~*/
function calcFeeAmount(){
	var waiveType = getItemValue(0,getRow(),"WaiveType");
	if(waiveType == "0")//按照金额减免
	{
		setItemRequired(0,"WaivePercent",false);
		setItemRequired(0,"WaiveAmount",true);
		setItemDisabled(0,getRow(),"WaivePercent",true);
		setItemDisabled(0,getRow(),"WaiveAmount",false);
		var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(typeof(waiveAmount) == "undefined" || waiveAmount.length == 0) waiveAmount = 0.0;
		setItemValue(0,getRow(),"WaivePercent",waiveAmount/feeAmount*100);
		
	}
	else if(waiveType == "1")//按照比例减免
	{
		setItemRequired(0,"WaivePercent",true);
		setItemRequired(0,"WaiveAmount",false);
		setItemDisabled(0,getRow(),"WaivePercent",false);
		setItemDisabled(0,getRow(),"WaiveAmount",true);
		var waivePercent = getItemValue(0,getRow(),"WaivePercent");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent.length == 0) waivePercent = 0.0;
		setItemValue(0,getRow(),"WaiveAmount",feeAmount*waivePercent/100.0);
	}
}