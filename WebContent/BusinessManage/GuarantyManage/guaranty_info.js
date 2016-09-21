/**
 * �����ﴦ������JS
 * 
 */

function newGuarantyInfo(objectType,objectNo,guarantyContractNo)
{
	if(typeof(objectType)=="undefined") 		objectType=AsCredit.getParameter("ObjectType");
	if(typeof(objectNo)=="undefined") 			objectNo=AsCredit.getParameter("ObjectNo");
	if(typeof(guarantyContractNo)=="undefined") guarantyContractNo=AsCredit.getParameter("GuarantyContractNo");
	sReturn = setObjectValue("SelectGuarantyType","","",0,0,"");
	//�ж��Ƿ񷵻���Ч��Ϣ
	if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
	sReturn = sReturn.split('@');
	guarantyType = sReturn[0];	
	parameters="GuarantyID=&ObjectType="+objectType+"&ObjectNo="+objectNo+"&GuarantyContractNo="+guarantyContractNo+"&GuarantyType="+guarantyType;
	AsCredit.openFunction("GuarantyInfo", parameters, "", "_self");
};

function viewAndEdit(){
	guarantyId=getItemValue(0, getRow(), "GuarantyID");
	if(typeof(guarantyId)=="undefined" || guarantyId.length==0) 
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	 objectType=AsCredit.getParameter("ObjectType");
	 objectNo=AsCredit.getParameter("ObjectNo");
    guarantyContractNo=AsCredit.getParameter("GuarantyContractNo");
	parameters="GuarantyID="+guarantyId+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&GuarantyContractNo="+guarantyContractNo;
	AsCredit.openFunction("GuarantyInfo", parameters, "", "_self");
}

function importGuarantyInfo()
{
	
} 
 
 

function deleteGuarantyInfo(){
	guarantyID = getItemValue(0,getRow(),"GuarantyID");		
	if(typeof(guarantyID)=="undefined" || guarantyID.length==0) 
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	if(!confirm(getHtmlMessage('2'))) return ;//�������ɾ������Ϣ�� 
	var functionParameters="ObjectType="+AsCredit.getParameter("ObjectType")+"&ObjectNo="+AsCredit.getParameter("ObjectNo")+"&GuarantyID="+guarantyID
												+"&GuarantyContractNo="+AsCredit.getParameter("GuarantyContractNo");
	vReturn=AsCredit.runFunction("DeleteGuarantyInfo", functionParameters)
	alert(vReturn.getOutputParameter("DELETESUCCESS"));
	reloadSelf();
		//RunMethod("BusinessManage","DeleteGuarantyInfo","<%=sObjectType%>"+","+"<%=sObjectNo%>"+","+"<%=sContractNo%>"+","+sGuarantyID);
}
function goGuarantyList(){
	objectType=AsCredit.getParameter("ObjectType");
	 objectNo=AsCredit.getParameter("ObjectNo");
    guarantyContractNo=AsCredit.getParameter("GuarantyContractNo");
	AsCredit.openFunction("GuarantyList", "GuarantyContractNo="+guarantyContractNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType, "", "_self");
}
/**
 * ����
 */
function saveGuarantyInfo(){
	if(!iV_all("0")) return ;
	if(!ValidityCheck()) return ;
	as_save("myiframe0","");		
}

/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
function ValidityCheck()
{			
	//���֤������Ƿ���ϱ������
	sCertType = getItemValue(0,0,"CertType");//--֤������		
	sCertID = getItemValue(0,0,"CertID");//֤������
	//У��Ȩ���˴�����
	sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//Ȩ���˴�����	
	if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
	{			
		//����Ȩ���˴�����Ψһ��
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//Ȩ���˴�����	
		sOwnerName = getItemValue(0,getRow(),"OwnerName");//Ȩ��������	
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets","run","CustomerID="+sOwnerName+",LoanCardNo="+sLoanCardNo);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
		{
			alert(getBusinessMessage('236'));//��Ȩ���˴������ѱ������ͻ�ռ�ã�							
			return false;
		}
	}
	//��������Ȩ�����Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡȨ���˵Ŀͻ����
	result=queryCustomer('OWNERID','OWNERNAME');		//��as_query.js��
	return result;
}


/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
function selectCustomer()
{
	//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
	var sReturn = "";
	sCertType=getItemValue(0,getRow(),"CertType");
	if(sCertType!=''&&typeof(sCertType)!='undefined'){
		sParaString = "CertType,"+sCertType;
		sReturn = setObjectValue("SelectOwner",sParaString,"@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
	}
	else{
		sParaString = "CertType, "
		sReturn = setObjectValue("SelectOwner",sParaString,"@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");			
	}	
	var sCertID = getItemValue(0,0,"CertID");
	if( String(sReturn)==String("_CLEAR_") ){
        setItemDisabled(0,0,"CertType",false);
        setItemDisabled(0,0,"CertID",false);
        setItemDisabled(0,0,"OwnerName",false);
        setItemDisabled(0,0,"LoanCardNo",false);
	}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
        setItemDisabled(0,0,"CertType",true);
        setItemDisabled(0,0,"CertID",true);
        setItemDisabled(0,0,"OwnerName",true);
		var certType = getItemValue(0,0,"CertType");
        var temp = certType.substring(0,3);
        if(temp=='Ent'){
        	setItemRequired(0,"LoanCardNo",true);
        	setItemDisabled(0,0,"LoanCardNo",true);
        }
        else{
        	setItemRequired(0,"LoanCardNo",false);
        	setItemDisabled(0,0,"LoanCardNo",false);
        }     
        sCertType ="";
    }
};


function selectEvalOrgName()
{
		
		setObjectValue("selectNewEvalOrgName","","@EvalOrgName@0",0,0,"");
  }