function selectProduct(){//产品选择
	//var returnValue = AsCredit.setMultipleTreeValue("SelectBusinessType", "", "", "","0",getRow(),"ProductList","ProductListName");//多选树
	//if(typeof(returnValue)=="undefined") return;
	var returnValue= AsCredit.selectTree("SelectBusinessType","","","");//单选树
	if(returnValue["ID"]!=null && returnValue["Name"]!=null && returnValue["ID"]!="" && returnValue["Name"]!=""){
		setItemValue(0,getRow(),'ProductList',returnValue["ID"]);
		setItemValue(0,getRow(),'ProductListName',returnValue["Name"]);
	}
}
//选择商品型号,选择完商品型号之后会自动的带出来我想要的所有的商品的数据和信息
function selectMerchandiseBrandModel(){
	var merchandiseType = getItemValue(0,0,'MerchandiseType');
	if(typeof(merchandiseType)=="undefined" || merchandiseType=="") {
		alert("请先选择商品类型");
		return;
	}
	setGridValuePretreat('MerchandiseList',merchandiseType,'MerchandiseID=MERCHANDISEID@MerchandiseBrandName=MERCHANDISEBRANDNAME@BrandModelName=BRANDMODELNAME@BrandModel=BRANDMODEL@MerchandiseBrand=MERCHANDISEBRAND@MerchandisePrice=MERCHANDISEPRICE@MerchandiseAttribute1=ATTRIBUTE1@MerchandiseAttribute2=ATTRIBUTE2@CommunicationProviderType=ATTRIBUTE3','#{MerchandiseID}');
}
//选择商品类型触发，自动设置产品类型
function selectMerchandiseType(){
	var merchandiseType = getItemValue(0,0,'MerchandiseType');
	var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.prd.web.GetProductInfo","getProductID","productType3="+merchandiseType);
	if(returnValue.split('@')[0]=='false') {
		alert("没有查询到相关产品信息,请检查商品信息");
		return;
	}
	returnValue = returnValue.replace('true@','');
	setItemValue(0,0,'ProductList',returnValue.replace(/[@]/g,","));
	var name = RunJavaMethodTrans("com.amarsoft.app.als.prd.web.GetProductInfo","getProductNames","productID="+returnValue);//str.replace(/[,]/g,"");正则表达式替换，
	setItemValue(0,0,'ProductListName',name.replace(/[@]/g,","));
}
//选择商品品牌
function selectMerchandiseBrand(){
	alert("正在做别着急");
}
