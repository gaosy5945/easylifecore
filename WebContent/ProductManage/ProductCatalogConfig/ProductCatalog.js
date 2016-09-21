var ProductCatalog={};

ProductCatalog.reopenCatalog = function(productCatalog){
	//刷新重新打开
	AsCredit.openFunction("PRD_ProductCatalogTree","ProductCatalog="+productCatalog,"","_self");
};

ProductCatalog.newProductType = function(productCatalog){
	var parentProductType = getCurTVItem().id;
	if(parentProductType=="root") parentProductType="";
	setItemValue(0,0,"ParentProductType",parentProductType);
	setItemValue(0,0,"ProductCatalog",productCatalog);
	$("#EditTreeItem_SUBMIT_BUTTON").unbind("click");
	$("#EditTreeItem_SUBMIT_BUTTON").click(function(){ProductCatalog.createProductType();});
	$("#TreeItemEdit_DIV").show();
};

ProductCatalog.createProductType = function(){
	if(!iV_all(0)) return;
	var productCatalog = getItemValue(0,0,"ProductCatalog");
	var productType = getItemValue(0,0,"ProductType");
	var productTypeName = getItemValue(0,0,"ProductTypeName");
	var parentProductType = getItemValue(0,0,"ParentProductType");
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductCatalogManager","newProductType", 
			"ParentProductType=" + parentProductType + ",ProductCatalog=" + productCatalog + ",ProductType=" + productType + ",ProductTypeName=" + productTypeName);
	if(result == "2"){
		alert("输入的产品类型编号已经存在!");
		return;
	}
	if(result == "1") ProductCatalog.reopenCatalog(productCatalog);
};

ProductCatalog.editProductType = function(productCatalog){
	var productType = getCurTVItem().id;
	setItemValue(0,0,"ProductCatalog",productCatalog);
	setItemValue(0,0,"ProductType",productType);
	setItemValue(0,0,"ProductTypeName", getCurTVItem().name);
	$("#EditTreeItem_SUBMIT_BUTTON").unbind("click");
	$("#EditTreeItem_SUBMIT_BUTTON").click(function(){ProductCatalog.modifyProductType(productCatalog,productType);});
	$("#TreeItemEdit_DIV").show();
};

ProductCatalog.modifyProductType = function(productCatalog,productType){
	if(!iV_all(0)) return;
	var productTypeName = getItemValue(0,0,"ProductTypeName");
	var result =AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductCatalogManager","modifyProductType", 
			"ProductCatalog=" + productCatalog + ",ProductType=" + productType + ",NewProductTypeName=" + productTypeName  );
	if(result == "1") ProductCatalog.reopenCatalog(productCatalog);
};



ProductCatalog.deleteProductType =function(productCatalog){
	if(!confirm("确认删除当前选择的产品类型及其所有子类型？")) return;
	var productType = getCurTVItem().id;
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.prd.web.ProductCatalogManager","deleteProductType", 
			"ProductCatalog=" + productCatalog + ",ProductType=" + productType  );
	if(result == "1") ProductCatalog.reopenCatalog(productCatalog);
};

