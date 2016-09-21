function changeCashOnlineFlag(){
	var autoPayFlag = getItemValue(0,getRow(),"AutoPayFlag");
	if(autoPayFlag == "1"){
		//setItemRequired(0,"PayAccountFlag",true);
		//setItemRequired(0,"PayAccountType",true);
		//setItemRequired(0,"PayAccountCurrency",true);
		setItemRequired(0,"PayAccountNo",true);
		setItemRequired(0,"PayAccountName",true);
	}
	else{
		//setItemRequired(0,"PayAccountFlag",false);
		//setItemRequired(0,"PayAccountType",false);
		//setItemRequired(0,"PayAccountCurrency",false);
		setItemRequired(0,"PayAccountNo",false);
		setItemRequired(0,"PayAccountName",false);
	}
}

function queryPayAccount(){
	alert("待接口实现");
}

function QueryAccount(accountFlag,accountType,accountCurrency,accountNo,accountName,accountOrgID)
{
	alert("待接口实现");
}