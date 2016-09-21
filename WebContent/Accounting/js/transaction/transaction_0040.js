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
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
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
	if (getRowCount(0)==0) {
		as_add("myiframe0");//新增记录
	}
	
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);
	setItemValue(0,getRow(),"SeqFlag","03");
	//setValue("TransDate",businessDate);
	afterSave();
	changeCashOnlineFlag();
}

/*~[Describe=重算还款总金额;InputParam=后续事件;OutPutParam=无;]~*/
function changeActualPayAmt(){
	var PayPrincipalAmt = getItemValue(0,getRow(),"PayPrincipalAmt");
	var PayInteAmt = getItemValue(0,getRow(),"PayInteAmt");
	var OverDueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var ODInteBalance = getItemValue(0,getRow(),"ODInteBalance");
	var FineInteBalance = getItemValue(0,getRow(),"FineInteBalance");
	var CompdInteBalance = getItemValue(0,getRow(),"CompdInteBalance");
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");
	var ActualPayInteAmt = getItemValue(0,getRow(),"ActualPayInteAmt");
	var ActualPayODPrincipalAmt = getItemValue(0,getRow(),"ActualPayODPrincipalAmt");
	var ActualPayODInteAmt = getItemValue(0,getRow(),"ActualPayODInteAmt");
	var ActualPayFineAmt = getItemValue(0,getRow(),"ActualPayFineAmt");
	var ActualPayCompdInteAmt = getItemValue(0,getRow(),"ActualPayCompdInteAmt");
	
	var temp = "不能超过";
	if(ActualPayPrincipalAmt>PayPrincipalAmt){
		alert("实收当期本金"+temp+"当期本金");
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(ActualPayInteAmt>PayInteAmt){
		alert("实收当期利息"+temp+"当期利息");
		setItemValue(0,getRow(),"ActualPayInteAmt",0);
		return;
	}
	if(ActualPayODPrincipalAmt>OverDueBalance){
		alert("实收期供逾期本金"+temp+"期供欠本金额");
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt",0);
		return;
	}
	if(ActualPayODInteAmt>ODInteBalance){
		alert("实收期供欠息"+temp+"期供欠息金额");
		setItemValue(0,getRow(),"ActualPayODInteAmt",0);
		return;
	}
	if(ActualPayFineAmt>FineInteBalance){
		alert("实收罚息"+temp+"逾期罚息金额");
		setItemValue(0,getRow(),"ActualPayFineAmt",0);
		return;
	}
	if(ActualPayCompdInteAmt>CompdInteBalance){
		alert("实收复息"+temp+"逾期复息金额");
		setItemValue(0,getRow(),"ActualPayCompdInteAmt",0);
		return;
	}
	
	if(ActualPayPrincipalAmt<0){
		alert("实收当期本金"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(ActualPayInteAmt<0){
		alert("实收当期利息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInteAmt",0);
		return;
	}
	if(ActualPayODPrincipalAmt<0){
		alert("实收期供逾期本金"+nLessZ);
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt",0);
		return;
	}
	if(ActualPayODInteAmt<0){
		alert("实收期供欠息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayODInteAmt",0);
		return;
	}
	if(ActualPayFineAmt<0){
		alert("实收罚息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayFineAmt",0);
		return;
	}
	if(ActualPayCompdInteAmt<0){
		alert("实收复息"+nLessZ);
		setItemValue(0,getRow(),"ActualPayCompdInteAmt",0);
		return;
	}
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");
	var ActualPayInteAmt = getItemValue(0,getRow(),"ActualPayInteAmt");
	
	setItemValue(0,getRow(),"ActualPayAmt",(ActualPayPrincipalAmt+ActualPayInteAmt+ActualPayODPrincipalAmt+ActualPayODInteAmt+ActualPayFineAmt+ActualPayCompdInteAmt).toFixed(2));
}

function splitActualPayAmt() {
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var PayPrincipalAmt = getItemValue(0,getRow(),"PayPrincipalAmt");
	var PayInteAmt = getItemValue(0,getRow(),"PayInteAmt");
	var OverDueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var ODInteBalance = getItemValue(0,getRow(),"ODInteBalance");
	var FineInteBalance = getItemValue(0,getRow(),"FineInteBalance");
	var CompdInteBalance = getItemValue(0,getRow(),"CompdInteBalance");
	if(actualPayAmt > CompdInteBalance) {
		setItemValue(0,getRow(),"ActualPayCompdInteAmt", CompdInteBalance);
		actualPayAmt = (actualPayAmt - CompdInteBalance).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayCompdInteAmt", actualPayAmt);
		actualPayAmt = 0;
	}
	
	if(actualPayAmt > FineInteBalance) {
		setItemValue(0,getRow(),"ActualPayFineAmt", FineInteBalance);
		actualPayAmt = (actualPayAmt - FineInteBalance).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayFineAmt", actualPayAmt);
		actualPayAmt = 0;
	}
	
	if(actualPayAmt > ODInteBalance) {
		setItemValue(0,getRow(),"ActualPayODInteAmt", ODInteBalance);
		actualPayAmt = (actualPayAmt - ODInteBalance).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayODInteAmt", actualPayAmt);
		actualPayAmt = 0;
	}
	
	if(actualPayAmt > OverDueBalance) {
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt", OverDueBalance);
		actualPayAmt = (actualPayAmt - OverDueBalance).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt", actualPayAmt);
		actualPayAmt = 0;
	}
	
	if(actualPayAmt > PayInteAmt) {
		setItemValue(0,getRow(),"ActualPayInteAmt", PayInteAmt);
		actualPayAmt = (actualPayAmt - PayInteAmt).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayInteAmt", actualPayAmt);
		actualPayAmt = 0;
	}
	
	if(actualPayAmt > PayPrincipalAmt) {
		setItemValue(0,getRow(),"ActualPayPrincipalAmt", PayPrincipalAmt);
		actualPayAmt = (actualPayAmt - OverDueBalance).toFixed(2);
	}else
	{
		setItemValue(0,getRow(),"ActualPayPrincipalAmt", actualPayAmt);
		actualPayAmt = 0;
	}
}
