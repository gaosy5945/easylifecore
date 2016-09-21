var productTransactionGroup = "jbo.prd.PRD_TRANSACTION";

var ProductTransaction={};

/*
 * 新建产品交易，选择产品目录后，创建一个新的产品
 */
ProductTransaction.newProductApply=function(){
	TransactionFunctions.newTransaction("jbo.prd.PRD_TRANSACTION","0010");
	reloadSelf();
};

/*
 * 新建产品交易，修改一个已有产品的信息
 */
ProductTransaction.modifyProductApply=function(){
	var productIDValues = AsCredit.selectTree("SelectProduct","ProductCatalog,Standard");
	if(!productIDValues||!productIDValues["ID"]) return;
	var transactionSerialNo = TransactionFunctions.createTransaction(productTransactionGroup,"0020","ProductID="+productIDValues["ID"]);
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/*
 * 以外部文件导入的方式，创建一个或多个产品交易
 */
ProductTransaction.importProductApply=function(){
	AsControl.PopComp("/Common/BusinessObject/ImportFileSelect.jsp","ObjectType=jbo.prd.PRD_PRODUCT_LIBRARY"
			,"resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	reloadSelf();
};

/*
 * 新建产品交易，将一个产品停用
 */
ProductTransaction.closeProductApply=function(){
	var productIDValues = AsCredit.selectTree("SelectProduct","ProductCatalog,Standard");
	if(!productIDValues||!productIDValues["ID"]) return;
	var transactionSerialNo = TransactionFunctions.createTransaction(productTransactionGroup,"0040","ProductID="+productIDValues["ID"]);
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/**
 * 从列表中选择一条，查看交易详情
 */
ProductTransaction.viewProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo);
};

/**
 * 从列表中选择一条，打开并编辑交易详情
 */
ProductTransaction.editProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/**
 * 从列表中选择一条，取消该交易，后台将从数据库中删除
 */
ProductTransaction.cancelProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(!confirm("确定要取消吗？")) return;
	var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.transaction.script.changestatus.UpdateStatusForCancelProductApply", "deleteTransaction"
			, "TransactionGroup="+productTransactionGroup+",TransactionSerialNo="+transactionSerialNo);
	//var returnValue = TransactionFunctions.deleteTransaction(productTransactionGroup,transactionSerialNo);
	if(returnValue=="1"){
		reloadSelf();
	}else{
		alert(returnValue);
	}
};

/**
 * 从列表中选择一条，审批该笔交易
 */
ProductTransaction.approveProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	var returnValue = TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo,"approveFunctionID");
	if(returnValue) reloadSelf();
};

/**
 * 从列表中选择一条，审批该笔交易
 */
ProductTransaction.publishProduct=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	var returnValue = TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo,"runFunctionID");
	reloadSelf();
};

/**
 * 从列表中选择一条，将该笔交易提交下一阶段
 */
ProductTransaction.submitProductTransaction=function(nextTransactionStatus){
	var transactionSerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == ""){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var result=TransactionFunctions.submitTransaction(productTransactionGroup,transactionSerialNo,nextTransactionStatus);
	reloadSelf();
};

/**
 * 从列表中选择一条，执行该笔交易
 */
ProductTransaction.runProductTransaction=function(){
	var transactionSerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	return;
	var result=TransactionFunctions.runTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};