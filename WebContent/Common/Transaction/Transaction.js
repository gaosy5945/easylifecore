/*
 * �����Ľ��״���js
 */
var TransactionFunctions={};

/*
 * ���ݽ�����𡢽�������������������һ������
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
 * ���ݽ�����𡢽������������������½����׽���
 */
TransactionFunctions.newTransaction=function(transactionGroup,transactionCode,inputParameters,targetWindow,windowStyle){
	var functionAttributeID = "NewFunctionID";
	var parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	//TransactionSerialNo���봫�룬û��ʱ�����
	var result=AsCredit.openFunction(functionID, "TransactionSerialNo=&TransactionGroup="+transactionGroup+"&TransactionCode="+transactionCode+"&"+inputParameters, windowStyle,targetWindow);
	if(result){
		//alert(JSON.stringify(result));
		//var transactionSerialNo=AsCredit.getBusinessObjectAtrribute(result,"TransactionSerialNo");
		//TransactionFunctions.editTransaction(transactionGroup,transactionSerialNo);
		reloadSelf();
	}
};

/**
 * �򿪽������飬�������޸�
 */
TransactionFunctions.editTransaction=function(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle){
	if(typeof(functionAttributeID) == "undefined" || functionAttributeID == "") {
		functionAttributeID = "EditFunctionID";
	}
	//��ȡ�ñʽ��׵Ľ��״���
	var parameterString = "ObjectType="+transactionGroup+",ObjectNo="+transactionSerialNo+",Attributes=TransCode";
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "getAttributes", parameterString);
	var transactionCode = result["TransCode"];
	//���ݽ��״����ȡ���������ļ��е�FunctionID
	parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	if(typeof(functionID) == "undefined" || functionID == "") {
		return TransactionFunctions.viewTransaction(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle);
	}
	else return AsCredit.openFunction(functionID, "TransactionGroup="+transactionGroup+"&TransactionSerialNo="+transactionSerialNo, windowStyle, targetWindow);
};

/**
 * �鿴�������飬�����޸�
 */
TransactionFunctions.viewTransaction=function(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle){
	if(typeof(functionAttributeID) == "undefined" || functionAttributeID == "") {
		functionAttributeID = "ViewFunctionID";
	}
	//��ȡ�ñʽ��׵Ľ��״���
	var parameterString = "ObjectType="+transactionGroup+",ObjectNo="+transactionSerialNo+",Attributes=TransCode";
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.businessobject.web.BusinessObjectWebMethod", "getAttributes", parameterString);
	var transactionCode = result["TransCode"];
	//���ݽ��״����ȡ���������ļ��е�FunctionID
	parameterString="TransactionGroup="+transactionGroup+",TransactionCode="+transactionCode+",Attributes="+functionAttributeID;
	result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "getTransactionConfig", parameterString);
	var functionID = result[functionAttributeID];
	if(typeof(functionID) == "undefined" || functionID == "") {
		return TransactionFunctions.editTransaction(transactionGroup,transactionSerialNo,functionAttributeID,targetWindow,windowStyle);
	}
	else return AsCredit.openFunction(functionID, "TransactionGroup="+transactionGroup+"&TransactionSerialNo="+transactionSerialNo, windowStyle, targetWindow);
};

/**
 * ִ��һ�ʽ���
 */
TransactionFunctions.runTransaction=function(transactionGroup,transactionSerialNo){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "runTransaction", "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo);
	return result;
};

/**
 * ɾ��һ�ʽ���
 */
TransactionFunctions.deleteTransaction=function(transactionGroup,transactionSerialNo){
	if(!confirm("ȷ��ɾ����")) return 0;
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "deleteTransaction"
			, "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo);
	return result;
};


/**
 * �ύһ�ʽ���
 */
TransactionFunctions.submitTransaction=function(transactionGroup,transactionSerialNo,nextTransactionStatus){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.TransactionWebMethod", "changeTransactionStatus"
			, "TransactionGroup="+transactionGroup+",TransactionSerialNo="+transactionSerialNo+",NextTransactionStatus="+nextTransactionStatus);
	return result;
};