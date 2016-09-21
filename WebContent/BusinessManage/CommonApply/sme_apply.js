
function changeCertType(){
		var customerType=getItemValue(0,getRow(),"CustomerType");
		var oCertType = document.getElementById("CertType");
		var options = oCertType.options;
		options.length = 1;
		options[0] = new Option("---请选择---","");
		options[0].selected = true;
		var sReturn = RunJavaMethod("com.amarsoft.app.als.credit.apply.action.NewApplyAction","getCertType","customerType="+customerType);
		//alert(sReturn);
		var i=1;
		for(var key in sReturn){
			options[i] = new Option(sReturn[key],key);
			i++;
		}
		setItemValue(0,getRow(),"CustomerName","");
		setItemValue(0,getRow(),"CertID","");
		setItemValue(0,getRow(),"CustomerID","");
		setItemValue(0,getRow(),"BusinessType","");
		setItemValue(0,getRow(),"BusinessName","");
		
};

$(function(){
	changeCertType();
});

/**小企业选择客户信息*/
function sme_selectCustomer(){
	var customerType=getItemValue(0,getRow(),"CustomerType");
	AsSelect.selectCustomer(customerType);
};

/**选择产品信息*/
function sme_selectBusinessType(){
	var applyType=AsCredit.getParameter("ApplyType");
	var customerType=getItemValue(0,getRow(),"CustomerType");
	if(customerType=="01"){
		applyType="Ent"+applyType;
	}else if(customerType=="03"){
		applyType="Ind"+applyType;
	} 
	AsSelect.selectBusinessType(applyType);
};