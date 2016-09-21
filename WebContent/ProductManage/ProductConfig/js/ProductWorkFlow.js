var productTransactionGroup = "jbo.prd.PRD_TRANSACTION";

var ProductTransaction={};

/*
 * �½���Ʒ���ף�ѡ���ƷĿ¼�󣬴���һ���µĲ�Ʒ
 */
ProductTransaction.newProductApply=function(){
	TransactionFunctions.newTransaction("jbo.prd.PRD_TRANSACTION","0010");
	reloadSelf();
};

/*
 * �½���Ʒ���ף��޸�һ�����в�Ʒ����Ϣ
 */
ProductTransaction.modifyProductApply=function(){
	var productIDValues = AsCredit.selectTree("SelectProduct","ProductCatalog,Standard");
	if(!productIDValues||!productIDValues["ID"]) return;
	var transactionSerialNo = TransactionFunctions.createTransaction(productTransactionGroup,"0020","ProductID="+productIDValues["ID"]);
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/*
 * ���ⲿ�ļ�����ķ�ʽ������һ��������Ʒ����
 */
ProductTransaction.importProductApply=function(){
	AsControl.PopComp("/Common/BusinessObject/ImportFileSelect.jsp","ObjectType=jbo.prd.PRD_PRODUCT_LIBRARY"
			,"resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	reloadSelf();
};

/*
 * �½���Ʒ���ף���һ����Ʒͣ��
 */
ProductTransaction.closeProductApply=function(){
	var productIDValues = AsCredit.selectTree("SelectProduct","ProductCatalog,Standard");
	if(!productIDValues||!productIDValues["ID"]) return;
	var transactionSerialNo = TransactionFunctions.createTransaction(productTransactionGroup,"0040","ProductID="+productIDValues["ID"]);
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/**
 * ���б���ѡ��һ�����鿴��������
 */
ProductTransaction.viewProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo);
};

/**
 * ���б���ѡ��һ�����򿪲��༭��������
 */
ProductTransaction.editProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	
	TransactionFunctions.editTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};

/**
 * ���б���ѡ��һ����ȡ���ý��ף���̨�������ݿ���ɾ��
 */
ProductTransaction.cancelProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(!confirm("ȷ��Ҫȡ����")) return;
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
 * ���б���ѡ��һ���������ñʽ���
 */
ProductTransaction.approveProductTransaction=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	
	var returnValue = TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo,"approveFunctionID");
	if(returnValue) reloadSelf();
};

/**
 * ���б���ѡ��һ���������ñʽ���
 */
ProductTransaction.publishProduct=function(){
	var transactionSerialNo =  getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	
	var returnValue = TransactionFunctions.viewTransaction(productTransactionGroup,transactionSerialNo,"runFunctionID");
	reloadSelf();
};

/**
 * ���б���ѡ��һ�������ñʽ����ύ��һ�׶�
 */
ProductTransaction.submitProductTransaction=function(nextTransactionStatus){
	var transactionSerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == ""){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	var result=TransactionFunctions.submitTransaction(productTransactionGroup,transactionSerialNo,nextTransactionStatus);
	reloadSelf();
};

/**
 * ���б���ѡ��һ����ִ�иñʽ���
 */
ProductTransaction.runProductTransaction=function(){
	var transactionSerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo == "") {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	return;
	var result=TransactionFunctions.runTransaction(productTransactionGroup,transactionSerialNo);
	reloadSelf();
};