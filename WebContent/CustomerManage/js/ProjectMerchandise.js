function selectProduct(){//��Ʒѡ��
	//var returnValue = AsCredit.setMultipleTreeValue("SelectBusinessType", "", "", "","0",getRow(),"ProductList","ProductListName");//��ѡ��
	//if(typeof(returnValue)=="undefined") return;
	var returnValue= AsCredit.selectTree("SelectBusinessType","","","");//��ѡ��
	if(returnValue["ID"]!=null && returnValue["Name"]!=null && returnValue["ID"]!="" && returnValue["Name"]!=""){
		setItemValue(0,getRow(),'ProductList',returnValue["ID"]);
		setItemValue(0,getRow(),'ProductListName',returnValue["Name"]);
	}
}
//ѡ����Ʒ�ͺ�,ѡ������Ʒ�ͺ�֮����Զ��Ĵ���������Ҫ�����е���Ʒ�����ݺ���Ϣ
function selectMerchandiseBrandModel(){
	var merchandiseType = getItemValue(0,0,'MerchandiseType');
	if(typeof(merchandiseType)=="undefined" || merchandiseType=="") {
		alert("����ѡ����Ʒ����");
		return;
	}
	setGridValuePretreat('MerchandiseList',merchandiseType,'MerchandiseID=MERCHANDISEID@MerchandiseBrandName=MERCHANDISEBRANDNAME@BrandModelName=BRANDMODELNAME@BrandModel=BRANDMODEL@MerchandiseBrand=MERCHANDISEBRAND@MerchandisePrice=MERCHANDISEPRICE@MerchandiseAttribute1=ATTRIBUTE1@MerchandiseAttribute2=ATTRIBUTE2@CommunicationProviderType=ATTRIBUTE3','#{MerchandiseID}');
}
//ѡ����Ʒ���ʹ������Զ����ò�Ʒ����
function selectMerchandiseType(){
	var merchandiseType = getItemValue(0,0,'MerchandiseType');
	var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.prd.web.GetProductInfo","getProductID","productType3="+merchandiseType);
	if(returnValue.split('@')[0]=='false') {
		alert("û�в�ѯ����ز�Ʒ��Ϣ,������Ʒ��Ϣ");
		return;
	}
	returnValue = returnValue.replace('true@','');
	setItemValue(0,0,'ProductList',returnValue.replace(/[@]/g,","));
	var name = RunJavaMethodTrans("com.amarsoft.app.als.prd.web.GetProductInfo","getProductNames","productID="+returnValue);//str.replace(/[,]/g,"");������ʽ�滻��
	setItemValue(0,0,'ProductListName',name.replace(/[@]/g,","));
}
//ѡ����ƷƷ��
function selectMerchandiseBrand(){
	alert("���������ż�");
}
