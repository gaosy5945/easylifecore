/*
 * 公共的交易处理js
 */
var TransactionFunctions={};

/*
 * 根据交易类别、交易码和输入参数，创建一个交易
 */
TransactionFunctions.createTransaction=function(transactionGroup,transactionCode,businessParameters){
	var inputParameterMap = {};
	var businessParameterMap = {};
	var splitChar=",";
	businessParameters = businessParameters.split(splitChar);
	for(var i=0;i<businessParameters.length;i++){
		var s = businessParameters[i].split("=");
		businessParameterMap[s[0]]=s[1];
	}
	var systemParameterMap = {};
	systemParameterMap["CurOrgID"]=AsCredit.PageSystemParameters["CurOrgID"];
	systemParameterMap["CurUserID"]=AsCredit.PageSystemParameters["CurUserID"];
	
	inputParameterMap["BusinessParameters"]=businessParameterMap;
	inputParameterMap["TransactionGroup"]=transactionGroup;
	inputParameterMap["TransactionCode"]=transactionCode;
	inputParameterMap["SystemParameters"]=systemParameterMap;
	var args=JSON.stringify({"InputParameter":inputParameterMap});
	var result =  AsControl.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "createTransaction",args);
	return result;
};

/*
 * 根据交易类别、交易码和输入参数，打开新建交易界面
 */
TransactionFunctions.newTransaction=function(transactionGroup,transactionCode,inputParameters,targetWindow,windowStyle){
	var functionAttributeID = "NewFunctionID";
	var parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	//TransactionSerialNo必须传入，没有时传入空
	var result=AsCredit.openFunction(functionID, "TransactionSerialNo=&TransactionGroup="+transactionGroup+"&TransactionCode="+transactionCode+"&"+inputParameters, windowStyle,targetWindow);
	if(result){
		//alert(JSON.stringify(result));
		//var transactionSerialNo=AsCredit.getBusinessObjectAtrribute(result,"TransactionSerialNo");
		//TransactionFunctions.editTransaction(transactionGroup,transactionSerialNo);
		reloadSelf();
	}
};

/**
 * 打开交易详情，并进行修改
 */
TransactionFunctions.editTransaction=function(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle){
	if(typeof(functionAttributeID) == "undefined" || functionAttributeID == "") {
		functionAttributeID = "EditFunctionID";
	}
	//获取该笔交易的交易代码
	var parameterString = "ObjectType="+transactionGroup+",ObjectNo="+transactionSerialNo+",Attributes=TransCode";
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "getAttributes", parameterString);
	var transactionCode = result["TransCode"];
	//根据交易代码获取交易配置文件中的FunctionID
	parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	if(typeof(functionID) == "undefined" || functionID == "") {
		return TransactionFunctions.viewTransaction(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle);
	}
	else return AsCredit.openFunction(functionID, "TransactionGroup="+transactionGroup+"&TransactionSerialNo="+transactionSerialNo, windowStyle, targetWindow);
};

/**
 * 查看交易详情，不能修改
 */
TransactionFunctions.viewTransaction=function(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle){
	if(typeof(functionAttributeID) == "undefined" || functionAttributeID == "") {
		functionAttributeID = "ViewFunctionID";
	}
	//获取该笔交易的交易代码
	var parameterString = "ObjectType="+transactionGroup+",ObjectNo="+transactionSerialNo+",Attributes=TransCode";
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "getAttributes", parameterString);
	var transactionCode = result["TransCode"];
	//根据交易代码获取交易配置文件中的FunctionID
	parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	if(typeof(functionID) == "undefined" || functionID == "") {
		return TransactionFunctions.editTransaction(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle);
	}
	else return AsCredit.openFunction(functionID, "TransactionGroup="+transactionGroup+"&TransactionSerialNo="+transactionSerialNo, windowStyle, targetWindow);
};

/**
 * 执行一笔交易
 */
TransactionFunctions.runTransaction=function(transactionGroup,transactionSerialNo){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "runTransaction", "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo);
	return result;
};

/**
 * 删除一笔交易
 */
TransactionFunctions.deleteTransaction=function(transactionGroup,transactionSerialNo){
	if(!confirm("确认删除？")) return 0;
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "deleteTransaction"
			, "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo);
	return result;
};


/**
 * 提交一笔交易
 */
TransactionFunctions.submitTransaction=function(transactionGroup,transactionSerialNo,nextTransactionStatus){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "changeTransactionStatus"
			, "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo+",NextTransactionStatus="+nextTransactionStatus);
	return result;
};