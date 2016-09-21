/**
 * 选择合作方客户
 */
function selectCustomer(){
	var sParaString = "UserID"+","+AsCredit.userId;	 
	setObjectValue("SelectPartnerCustomer",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3@ListType@4",0,0,"");
}

function cancel(){
	self.close();
}

function submitProjectApply(){
	alert("111111");
}

