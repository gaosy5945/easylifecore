var AsSelect={
		
};

/**
 * �μ�Code:CustomerType
 */
AsSelect.selectCustomer=function(cutomerType){
	if(typeof(cutomerType)=="undefined") cutomerType="01";
	var sParaString = "UserID"+","+AsCredit.userId+","+"CustomerType"+","+cutomerType;
	
	//CustomerID@CustomerName@CertType@CertID@CustomerType	
	setObjectValue("SelectCustomerInfo",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");

};

/**
 * businessFlag Ϊѡ���־��EntΪ��˾�ͻ���Ʒ��IndΪ���˲�Ʒ
 * ALL Ϊȫ��
 */
AsSelect.selectBusinessType=function(applyType){
	  applyType=getItemValue(0,getRow(),"ApplyType");
	//var sParaString = "UserID"+","+AsCredit.userId+","+"CustomerType"+","+cutomerType;
	  if(applyType.indexOf("Ent")>=0){
		var sParaString="Type,1";
		if(applyType.indexOf("Limit")>=0){//���
			setObjectValue("SelectCreditLineBusiness",sParaString,"@BusinessType@0@BusinessName@1",0,0,"");	
		}else{
			setObjectValue("SelectEntBusinessType",sParaString,"@BusinessType@0@BusinessName@1",0,0,"");	
		}
		
	}else if(applyType.indexOf("Ind")>=0){
		var sParaString="Type,020";
		if(applyType.indexOf("Limit")>=0){//���
			setObjectValue("SelectCLBusinessType","SortNo,3010","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			//setObjectValue("SelectCreditLineBusiness",sParaString,"@BusinessType@0@BusinessName@1",0,0,"");	
		}else{
			setObjectValue("SelectIndivBusinessType",sParaString,"@BusinessType@0@BusinessTypeName@1",0,0,"");	
		}
	}
};

 
selectOperate=function(){
	var operateType = getItemValue(0,0,"OperateType");
	if(operateType=="01"){
		hideItem(0,"isHostBank");
	}else if(operateType == "02"){
		showItem(0,"isHostBank");
	}
};

/**
 * businessFlag Ϊѡ���־��EntΪ��˾�ͻ���Ʒ��IndΪ���˲�Ʒ
 * ALL Ϊȫ��
 */
AsSelect.selectCreditLine=function(){
	setItemUnit(0,getRow(),"CLTypeNo","");
	var clTypeNo=getItemValue(0,getRow(),"CLTypeNo");
	if(typeof(clTypeNo)=="undefined" || clTypeNo==""){
		setItemUnit(0,getRow(),"CLTypeNo","<font color=red>��ѡ�����Ŷ��</font>");
		return ;
	}
	sReturn=AsDialog.SetGridValue("CreditLineAccountList",clTypeNo+","+AsCredit.userId,"BusinessTypeName=BusinessTypeName@RelativeSerialNo=SerialNo@CustomerName=CustomerName@BusinessType=BusinessType@BUSINESSCURRENCY=BUSINESSCURRENCY@BusinessSum=BusinessSum@ExposureSum=ExposureSum@PutOutDate=PutOutDate@Maturity=Maturity",false);
};