var ProductFunctions={};

/**
 * ˢ��ҳ��
 */
ProductFunctions.reloadSpecific=function(){
	var specificSerialNo=getItemValue(0,0,"SERIALNO");
	var productID=getItemValue(0,0,"ProductID");
	AsCredit.reopenFunction("PRD_ProductSpecificInfo","ProductID="+productID+"&SpecificSerialNo="+specificSerialNo,"","_self");
};

/**
 * �����������Ʒ�汾��
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
 * ɾ�����
 */
ProductFunctions.removeComponentPrd=function(specificSerialNo,xmlTags,keys,componentID){
	var result=AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductSpecificManager", "deleteComponents","SpecificSerialNo="+ specificSerialNo+",XMLTags="+xmlTags+",Keys="+keys+",ComponentID="+componentID );
	ProductFunctions.reloadSpecific();
};

/**
 * ˢ��ҳ��
 */
ProductFunctions.reloadTransactionSpecific=function(){
	var specificSerialNo=getItemValue(0,0,"SERIALNO");
	var transactionSerialNo=getItemValue(0,0,"TRTransactionSerialNo");
	var productID=getItemValue(0,0,"ProductID");
	AsCredit.reopenFunction("PRD_TransactionSpecificInfo","ProductID="+productID+"&TransactionSerialNo="+transactionSerialNo+"&SpecificSerialNo="+specificSerialNo,"","_self");
};

/**
 * �����������Ʒ�汾��
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
 * ɾ�����
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
 * ɾ��һ����Ʒ�汾
 */
ProductFunctions.disableSpecific=function(transactionserialno,productID){
	var result = AsCredit.selectGrid("PRD_SelectProductSpecificList", productID+",1", "SerialNo@SpecificID@ProductID");
	if(!result||!result["SerialNo"]||result["SerialNo"]=="") return;
	result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "disableSpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" +result["SerialNo"]);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

/**
 * ����һ����Ʒ�汾
 */
ProductFunctions.newSpecific=function(transactionserialno,productID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "newSpecific", "TransactionSerialNo="+transactionserialno+",ProductID=" + productID);
	if(result==1) AsCredit.reopenFunction(AsCredit.PageSystemParameters["SYS_FUNCTIONID"],"TransactionSerialNo="+transactionserialno,"","_self");
};

/**
 * ɾ��һ����Ʒ�汾
 */
ProductFunctions.deleteSpecific=function(transactionserialno,specificSerialNo){
	if(confirm("ȷ��ɾ���ð汾��")){
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductTransactionMethod", "deleteTransactionSpecific", "TransactionSerialNo="+transactionserialno+",SpecificSerialNo=" + specificSerialNo);
		if(result=="1") return true;
		else return false;
	}
	else return false;
};