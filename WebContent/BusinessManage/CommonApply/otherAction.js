/**
 * 申请时快速新增客户
 */
function newCustomer(customerType) {
	var returnValue = AsControl
			.PopComp(
					"/CustomerManage/NewCustomerDialog.jsp",
					"CustomerType=" + customerType + "&SourceType=APPLY",
					"resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
	if (!returnValue)
		return;
	if (returnValue.indexOf("@") > 0) {
		setItemValue(0, getRow(), "CustomerID", returnValue.split("@")[0]);
		setItemValue(0, getRow(), "CustomerName", returnValue.split("@")[1]);
		setItemValue(0, getRow(), "CertID", returnValue.split("@")[2]);
		setItemValue(0, getRow(), "CertType", returnValue.split("@")[3]);
	}
}
 
/**
 * 设置隐藏是否我行主办行
 */
function initRow(){
	try{
		var obj=getObj(0,"isHostBank");
		if(typeof(obj)!="undefined"){
			hideItem(0,'isHostBank');
		}
	}catch(e){
		
	}
}
 $(function(){
	 initRow();
 });
