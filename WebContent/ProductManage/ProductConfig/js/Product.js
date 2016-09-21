var ProductFunctions={};

/**
 * 刷新页面
 */
ProductFunctions.reloadSpecific=function(){
	var specificSerialNo=getItemValue(0,0,"SERIALNO");
	var productID=getItemValue(0,0,"ProductID");
	AsCredit.reopenFunction("PRD_ProductSpecificInfo","ProductID="+productID+"&SpecificSerialNo="+specificSerialNo,"","_self");
};

/**
 * 引入组件到产品版本中
 */
ProductFunctions.importBusinessComponentPrd=function(specificSerialNo,xmlFile,xmlTags,keys,process,componentType){
	if(specificSerialNo==""){
		specificSerialNo=getItemValue(0,0,"SERIALNO");
	}
	
	var inputParameters={"XMLFile":xmlFile,"XMLTags":xmlTags+"||type like '"+componentType+"'","Keys":keys,"BusinessProcess":process};
	var inputParameterString=JSON.stringify(inputParameters);
	var parameterIDString =AsDialog.SelectGridValue("PRD_ComponentList", inputParameterString, "ID@NAME", "", false);
	if(!parameterIDString || parameterIDString == "_CANCEL_" || parameterIDString == "_CLEAR_")
		return ;
	
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "importComponents",
				"SpecificSerialNo="+specificSerialNo+",ComponentID="+parameterIDString.split("@")[0] +",FromXMLFile="+xmlFile+",FromXMLTags="+xmlTags+",Keys="+keys);
	ProductFunctions.reloadSpecific();
};

/**
 * 删除组件
 */
ProductFunctions.removeComponentPrd=function(specificSerialNo,xmlTags,keys,componentID){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "deleteComponents","SpecificSerialNo="+ specificSerialNo+",XMLTags="+xmlTags+",Keys="+keys+",ComponentID="+componentID );
	ProductFunctions.reloadSpecific();
};

/**
 * 刷新页面
 */
ProductFunctions.reloadTransactionSpecific=function(){
	var specificSerialNo=getItemValue(0,0,"SERIALNO");
	var transactionSerialNo=getItemValue(0,0,"TRTransactionSerialNo");
	var productID=getItemValue(0,0,"ProductID");
	AsCredit.reopenFunction("PRD_TransactionSpecificInfo","ProductID="+productID+"&TransactionSerialNo="+transactionSerialNo+"&SpecificSerialNo="+specificSerialNo,"","_self");
};

/**
 * 引入组件到产品版本中
 */
ProductFunctions.importBusinessComponent=function(specificSerialNo,xmlFile,xmlTags,keys,process,componentType){
	if(specificSerialNo==""){
		specificSerialNo=getItemValue(0,0,"SERIALNO");
	}
	
	var inputParameters={"XMLFile":xmlFile,"XMLTags":xmlTags+"||type like '"+componentType+"'","Keys":keys,"BusinessProcess":process};
	var inputParameterString=JSON.stringify(inputParameters);
	var parameterIDString =AsDialog.SelectGridValue("PRD_ComponentList", inputParameterString, "ID@NAME", "", false);
	if(!parameterIDString || parameterIDString == "_CANCEL_" || parameterIDString == "_CLEAR_")
		return ;
	
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "importComponents",
				"SpecificSerialNo="+specificSerialNo+",ComponentID="+parameterIDString.split("@")[0] +",FromXMLFile="+xmlFile+",FromXMLTags="+xmlTags+",Keys="+keys);
	ProductFunctions.reloadTransactionSpecific();
};

/**
 * 删除组件
 */
ProductFunctions.removeComponent=function(specificSerialNo,xmlTags,keys,componentID){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "deleteComponents","SpecificSerialNo="+ specificSerialNo+",XMLTags="+xmlTags+",Keys="+keys+",ComponentID="+componentID );
	ProductFunctions.reloadTransactionSpecific();
};


ProductFunctions.copySpecific=function(transactionserialno,productID){
	var result = AsCredit.selectGrid("PRD_SelectTransSpecificList", productID+","+transactionserialno, "SerialNo@SpecificID@ProductID");
	if(!result||!result["SerialNo"]||result["SerialNo"]=="") return;
	result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "copySpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" +result["SerialNo"]);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

ProductFunctions.modifySpecific=function(transactionserialno,productID){
	var result = AsCredit.selectGrid("PRD_SelectProductSpecificList", productID+",1", "SerialNo@SpecificID@ProductID");
	if(!result||!result["SerialNo"]||result["SerialNo"]=="") return;
	result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "modifySpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" +result["SerialNo"]);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

/**
 * 删除一个产品版本
 */
ProductFunctions.disableSpecific=function(transactionserialno,productID){
	var result = AsCredit.selectGrid("PRD_SelectProductSpecificList", productID+",1", "SerialNo@SpecificID@ProductID");
	if(!result||!result["SerialNo"]||result["SerialNo"]=="") return;
	result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "disableSpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" +result["SerialNo"]);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

/**
 * 新增一个产品版本
 */
ProductFunctions.newSpecific=function(transactionserialno,productID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "newSpecific", "TransactionSerialNo="+transactionserialno+",ProductID=" + productID);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

/**
 * 删除一个产品版本
 */
ProductFunctions.deleteSpecific=function(transactionserialno,specificSerialNo){
	if(confirm("确认删除该版本？")){
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "deleteTransactionSpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" + specificSerialNo);
		if(result=="1") return true;
		else return false;
	}
	else return false;
};