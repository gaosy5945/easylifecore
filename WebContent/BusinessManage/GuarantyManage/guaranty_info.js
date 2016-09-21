/**
 * 担保物处理的相关JS
 * 
 */

function newGuarantyInfo(objectType,objectNo,guarantyContractNo)
{
	if(typeof(objectType)=="undefined") 		objectType=AsCredit.getParameter("ObjectType");
	if(typeof(objectNo)=="undefined") 			objectNo=AsCredit.getParameter("ObjectNo");
	if(typeof(guarantyContractNo)=="undefined") guarantyContractNo=AsCredit.getParameter("GuarantyContractNo");
	sReturn = setObjectValue("SelectGuarantyType","","",0,0,"");
	//判断是否返回有效信息
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
		alert(getHtmlMessage('1'));//请选择一条信息！
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
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	if(!confirm(getHtmlMessage('2'))) return ;//您真的想删除该信息吗？ 
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
 * 保存
 */
function saveGuarantyInfo(){
	if(!iV_all("0")) return ;
	if(!ValidityCheck()) return ;
	as_save("myiframe0","");		
}

/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
function ValidityCheck()
{			
	//检查证件编号是否符合编码规则
	sCertType = getItemValue(0,0,"CertType");//--证件类型		
	sCertID = getItemValue(0,0,"CertID");//证件代码
	//校验权利人贷款卡编号
	sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//权利人贷款卡编号	
	if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
	{			
		//检验权利人贷款卡编号唯一性
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//权利人贷款卡编号	
		sOwnerName = getItemValue(0,getRow(),"OwnerName");//权利人名称	
		sReturn=RunJavaMethodTrans("com.amarsoft.app.lending.bizlets","run","CustomerID="+sOwnerName+",LoanCardNo="+sLoanCardNo);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
		{
			alert(getBusinessMessage('236'));//该权利人贷款卡编号已被其他客户占用！							
			return false;
		}
	}
	//检查输入的权利人是否建立信贷关系，如果未建立，需要新获取权利人的客户编号
	result=queryCustomer('OWNERID','OWNERNAME');		//在as_query.js中
	return result;
}


/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
function selectCustomer()
{
	//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号		
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