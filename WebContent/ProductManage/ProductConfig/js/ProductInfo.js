var ProductInfo={};

/**
 * ˢ��ҳ��
 */
ProductInfo.changeProductType1=function(){
	var productType1=getItemValue(0,0,"PRODUCTTYPE1");
	
	if(productType1=="01"){//������Ʒ
		hideItem(0,"RELATIVEPRODUCTLIST");
		hideItemRequired(0,"RELATIVEPRODUCTLIST");
		hideItem(0,"RELATIVEPRODUCTLISTNAME");
		hideItemRequired(0,"RELATIVEPRODUCTLISTNAME");
		setItemValue(0,0,"RELATIVEPRODUCTLIST","");
		setItemValue(0,0,"RELATIVEPRODUCTLISTNAME","");
	}
	else if(productType1=="02"){//������Ʒ
		showItem(0,"RELATIVEPRODUCTLIST");
		showItemRequired(0,"RELATIVEPRODUCTLIST");
		showItem(0,"RELATIVEPRODUCTLISTNAME");
		showItemRequired(0,"RELATIVEPRODUCTLISTNAME");
	}
};

$(document).ready(function(){
	ProductInfo.changeProductType1();
	var productID=getItemValue(0,0,"PRODUCTID");
	if(productID&&productID.length>0){
		setItemDisabled(0,0,"PRODUCTID",true);
	}
		
});