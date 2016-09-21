
/*查看最终审批意见详情*/
function viewApproveInfo(){
	var objectType = "ApproveApply";
	var objectNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
 	var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo;
	AsCredit.openFunction("ApproveFinalDetail",paramString); 
	
}

/*登记合同*/
function BookInContract(){
	//新增申请类型,对象类型两参数,用于额度有效性检查
	var objectType = "ApproveApply";//对象类型
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	var applyType = getItemValue(0,getRow(),"ApplyType");//申请类型
	var occurType = getItemValue(0,getRow(),"OccurType");
	if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	} 
	
	//业务风险检测
	var riskResult = autoRiskScan("010","OccurType="+occurType+"&ApplyType="+applyType+"&ObjectType="+objectType+"&ObjectNo="+serialNo);
	if(riskResult != true){
		return;
	}
	
	if(!confirm("你确定要根据选中的电子最终审批意见登记合同吗？ \n\r确定后将根据最终审批意见生成合同！")){
		return;
	}

	var result = AsCredit.runFunction("ApplyFinish","ObjectNo="+serialNo+"&ObjectType="+objectType+"&NewObjectType=BusinessContract");
	var message = result.getOutputParameter("message");
	alert(message);
	var contractNo = result.getOutputParameter("NewObjectNo");
    
	var paramString = "ObjectType=BusinessContract&ObjectNo="+contractNo;
	AsCredit.openFunction("ContractDetail", paramString);
	reloadSelf();
}