///Accounting/js/transaction/Inter-bankPayment_Apply.js
var InterbankPayment={
		
};

/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
function newRecord()
{
	AsCredit.openFunction("Inter-bankPaymentInfo","Type=0");
	reloadSelf();
/*	popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","Type=0","");
	reloadSelf();*/
}

/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
function view()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo"); //帐号流水号
	var sStatus = getItemValue(0,getRow(),"Status"); //账户状态
	if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
	}else
	{
		AsCredit.openFunction("Inter-bankPaymentInfo","SerialNo="+sSerialNo);
		reloadSelf();
	}
}

/**
 * 取消交易申请
 */
function cancelApply(){
	//获得申请类型、申请流水号
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(confirm(getHtmlMessage('70'))){
		as_delete(0,'','delete');
		as_do(0,'','save');  //如果单个删除，则要调用此语句
	}   //!!问题：无法删除表ACCT_TRANSACTION中的记录
	reloadSelf();//解决连续多次取消时报错
}

/*~[Describe=提交复核;InputParam=无;OutPutParam=无;]~*/
function doSubmit()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert("请选择一条记录！");
		return;
	}
	
	var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",02");
	if(parseInt(sReturn) == 1)
	{
		alert("提交成功！");
		reloadSelf();
	}
}

/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
function doBack()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert("请选择一条记录！");
		return;
	}
	
	var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",04");
	if(parseInt(sReturn) == 1)
	{
		alert("提交成功！");
		reloadSelf();
	}
}

/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
function saveRecord(){
	if(!iV_all("0")) return;
	as_save("0","afterSave()");
}


