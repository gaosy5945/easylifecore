/**
 * ������ͬ��ش����JS
 */
/**
 * ���浣����ͬ
 */
function saveRecord(){
	 as_save(0);
};

/**
 * ����
 */
function goBack(){
		objectNo=AsCredit.getParameter("ObjectNo");
		objectType=AsCredit.getParameter("ObjectType");
		contractType=AsCredit.getParameter("ContractType");
		sPara="ObjectNo="+objectNo+"&ObjectType="+objectType+"&ContractType="+contractType;
		AsControl.OpenPage("/BusinessManage/GuarantyManage/GuarantyContractFrame.jsp", sPara, "_self");
}

/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
function selectCustomer(){
	//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������
	sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������
	sCertType = getItemValue(0,0,"CertType");//--֤������
	var sReturn = "";
	if(sCertType!=''&&typeof(sCertType)!='undefined'){
		sParaString = "CertType,"+sCertType;
		sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
	}
	else{
		sParaString = "CertType, ";
		sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
	}
	if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
	//���Ӷ�CertType��CertID��GuarantorName��LoanCardNo����ʾ����  add by zhuang 2010-04-01
	var sCertID = getItemValue(0,0,"CertID");
	if( String(sReturn)==String("_CLEAR_")||String(sReturn)=="undefined"  ){ 
        setItemDisabled(0,0,"CertType",false);
        setItemDisabled(0,0,"CertID",false);
        setItemDisabled(0,0,"GuarantorName",false);
        setItemDisabled(0,0,"LoanCardNo",false);
        isSelect=false;
	}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
		isSelect=true;
        setItemDisabled(0,0,"CertType",true);
        setItemDisabled(0,0,"CertID",true);
        setItemDisabled(0,0,"GuarantorName",true);
        setItemDisabled(0,0,"LoanCardNo",true);
		var certType = getItemValue(0,0,"CertType");
        var temp = certType.substring(0,3);
        if(temp=='Ent'){
        	setItemDisabled(0,0,"LoanCardNo",true);
        	setItemRequired(0,"LoanCardNo",true);
        }
       else{
        	setItemValue(0,getRow(),"LoanCardNo","");  
        	setItemRequired(0,"LoanCardNo",false);
         	setItemDisabled(0,getRow(),"LoanCardNo",false);
        }
    }
}
