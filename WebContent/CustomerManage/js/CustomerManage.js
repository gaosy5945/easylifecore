var CustomerManage={};
//客户新增按钮
CustomerManage.newCustomer1=function(customerType){
	if(customerType.substring(0,2) == "00"){
		var result = AsControl.PopPage("/CustomerManage/MyCustomer/PartnerCustomer/NewPartnerDialog.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		return result;
	}else{
		var result = AsControl.PopPage("/CustomerManage/NewCustomerDialog.jsp","CustomerType="+customerType,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
		return result;
	}
};

CustomerManage.newCustomer2=function(){
	var customerType = AsDialog.OpenSelector("SelectCode","CodeNo=CustomerType","");
	return CustomerManage.newCustomer1(customerType);
};

//客户删除
CustomerManage.deleteCustomer=function(deleteCustomerIDs, userID, inputOrgID){
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.DeleteCustomerBelong", "deleteCustomerBelong", "CustomerID="+deleteCustomerIDs+",InputUserID="+userID+",InputOrgID="+inputOrgID);
	return sResult;
};

//合作方客户删除
CustomerManage.deletePartner=function(CustomerID, userID, inputOrgID){
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.DeleteCustomerBelong", "deletePartner", "CustomerID="+CustomerID+",InputUserID="+userID+",InputOrgID="+inputOrgID);
	return sResult;
};

CustomerManage.importCustomerToTag=function(returnValue,OTCSerialNo,InputUserID,InputOrgID,InputDate){
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JoinMyCustomer", "importCustomerToTag", "CustomerIDs="+returnValue+",OTCSerialNo="+OTCSerialNo+",InputUserID="+InputUserID+",InputOrgID="+InputOrgID+",InputDate="+InputDate);
	return sResult;
};

CustomerManage.checkCertID=function(certType,certID,countryCode){
	//if(certType=="2020"){
	//	return CustomerManage.checkCorpID(certID);
	//}
	if(certType=="1"  || certType =='6' || certType == 'C'){
		return CustomerManage.validIndivdualIndentityCard(certID);
	}
	return true;
};


CustomerManage.checkCorpID=function(CorpID){    	
	var financecode = new Array();
	if(CorpID=="00000000-0")	return false;
	for(var i=0;i<CorpID.length;i++){
		financecode[i]= CorpID.charCodeAt(i);
	}
    var w_i = new Array(8);
    var c_i = new Array(8);
    s = 0,c = 0;
    w_i[0] = 3;
    w_i[1] = 7;
    w_i[2] = 9;
    w_i[3] = 10;
    w_i[4] = 5;
    w_i[5] = 8;
    w_i[6] = 4;
    w_i[7] = 2;
    if(financecode[8] != 45)	return false;
    for(i = 0; i < 10; i++){
        c = financecode[i];
        if(c <= 122 && c >= 97)
            return false;
    }

    fir_value = financecode[0];
    sec_value = financecode[1];
    if(fir_value >= 65 && fir_value <= 90)
        c_i[0] = (fir_value + 32) - 87;
    else if(fir_value >= 48 && fir_value <= 57)
        c_i[0] = fir_value - 48;
    else
        return false;
    s += w_i[0] * c_i[0];
    if(sec_value >= 65 && sec_value <= 90)
        c_i[1] = (sec_value - 65) + 10;
    else if(sec_value >= 48 && sec_value <= 57)
        c_i[1] = sec_value - 48;
    else
        return false;
    s += w_i[1] * c_i[1];
    for(var j = 2; j < 8; j++){
        if(financecode[j] < 48 || financecode[j] > 57)
            return false;
        c_i[j] = financecode[j] - 48;
        s += w_i[j] * c_i[j];
    }

    c = 11 - s % 11;
    return financecode[9] == 88 && c == 10 || c == 11 && financecode[9] == 48 || c == financecode[9] - 48;
};

//身份证校验
CustomerManage.validIndivdualIndentityCard=function(id){

	id = id.trim();
	if (id.length != 15 && id.length != 18)
		return false;
	var dateValue;
	if (id.length == 15)
		dateValue = "19" + id.substring(6, 12);		
	else
		dateValue = id.substring(6, 14);
	if (!checkDate(dateValue))
		return false;
	if (id.length == 18){
		var strJiaoYan = new Array("1","0","X","9","8","7","6","5","4","3","2");
		var intQuan = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1);
		var intTemp = 0;
		for (var i = 0; i < id.length - 1; i++){
				intTemp += id.substring(i, i + 1) * intQuan[i];
	    }
		intTemp %= 11;
		return id.substring(id.length - 1)==strJiaoYan[intTemp];
	}
	return true;   
};


CustomerManage.viewCustomer=function(customerid,customertype){
	var viewFunctionID = CustomerManage.getCustomerViewFunctionID(customertype);
	AsCredit.openFunction(viewFunctionID,"CustomerID="+customerid+"&RightType=ReadOnly");
};

CustomerManage.editCustomer=function(customerid,customertype){
	var editFunctionID = CustomerManage.getCustomerViewFunctionID(customertype);
	AsCredit.openFunction(editFunctionID,"CustomerID="+customerid);
};

CustomerManage.viewCustomerPartner=function(customerid,listtype){
	var editFunctionID = CustomerManage.getCustomerViewFunctionID(listtype);
	AsCredit.openFunction(editFunctionID,"CustomerID="+customerid+"&ListType="+listtype+"&RightType=ReadOnly");
};

CustomerManage.editCustomerPartner=function(customerid,listtype){
	var editFunctionID = CustomerManage.getCustomerViewFunctionID(listtype);
	AsCredit.openFunction(editFunctionID,"CustomerID="+customerid+"&ListType="+listtype);
};

CustomerManage.getCustomerViewFunctionID=function(customertype){
	if(customertype.substring(0,2) == "00"){
		return "PartnerCustomerInfo";
	}else if(customertype == "03"){
		return "IndCustomerInfo";
	}else{
		return "EntCustomerInfo";
	}
};

//个人客户信息查询（查ECIF那边的信息并更新到我们数据库）
CustomerManage.getECIFCustomer1=function(customerid, ctftype, ctfid, clientchnname){
	var temp = AsControl.RunJavaMethodTrans("com.amarsoft.app.oci.instance.ECIFInstance" , "queryCustomer" , 
			"customerid="+customerid+",ctftype="+ctftype+",ctfid="+ctfid+",clientchnname="+clientchnname);
	return temp;
}; 

//对公客户信息查询（查ECIF那边的信息并更新到我们数据库）
CustomerManage.getECIFCustomer2=function(customerid, companycode, clientchnname){
	var temp = AsControl.RunJavaMethodTrans("com.amarsoft.app.oci.instance.ECIFInstance", "queryEntCustomer", 
			"customerid="+customerid+",companycode="+companycode+",clientchnname="+clientchnname);
	return temp;
};

CustomerManage.getECIFCustomer3=function(countryCode,certType,certID){
	;
};

//查询客户履历信息的结束时间
CustomerManage.selectResumeEndDate=function(CustomerID){
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.SelectCustomer", "selectResumeEndDate", "CustomerID="+CustomerID);
	return sResult;
};

//【加入我的客户】功能逻辑实现方法(Developer:xtliu)
CustomerManage.importCustomer=function(recordArray, relaCustomerIDs, userID, inputDate, inputOrgID){
	var returnValue =AsDialog.SelectGridValue("JoinMyCustomer", userID, "serialNo@tagID", "", true);
	if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return "FAILED";
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JoinMyCustomer", "JoinMyCustomer", "SerialNo="+returnValue+",CustomerID="+relaCustomerIDs+",InputUserID="+userID+",InputDate="+inputDate+",InputOrgID="+inputOrgID);
	return sResult;
};

//【调整分组】功能逻辑实现方法(Developer:xtliu)
CustomerManage.adjustTag=function(recordArray, relaCustomerIDs, userID, relaSerialNos, inputDate, inputOrgID){
	var returnValue =AsDialog.SelectGridValue("JoinMyCustomer", userID, "serialNo@tagID", "", true);
	if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return "FAILED";
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.AdjustTag", "AdjustTag", "newTagSerialNo="+returnValue+",CustomerID="+relaCustomerIDs+",InputUserID="+userID+",SerialNo="+relaSerialNos+",InputDate="+inputDate+",InputOrgID="+inputOrgID);
	return sResult;
};

CustomerManage.adjustOrgTag=function(recordArray, relaCustomerIDs, userID, relaSerialNos, inputDate, inputOrgID){
	var returnValue =AsDialog.SelectGridValue("JoinOrgCustomer", userID, "serialNo@tagID", "", true);
	if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return "FAILED";
	var sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.AdjustTag", "AdjustTag", "newTagSerialNo="+returnValue+",CustomerID="+relaCustomerIDs+",InputUserID="+userID+",SerialNo="+relaSerialNos+",InputDate="+inputDate+",InputOrgID="+inputOrgID);
	return sResult;
};

//【合作方客户】检查与新增处理 (Developer:xtliu)
CustomerManage.checkPartnerAndAdd=function(certType,certID,customerName,listType,countryCode,inputOrgID,inputUserID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CheckCustomer", "CheckCustomerListAndInfo", "CertType="+certType+",CertID="+certID+",CustomerName="+customerName+",ListType="+listType+",CountryCode="+countryCode+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",InputDate="+inputDate);
	return result;
};

//【个人客户】与【企业客户】新增时的校验操作 (Developer:xtliu)
CustomerManage.checkCustomer=function(certID,customerName,customerType,certType,issueCountry,inputOrgID,inputUserID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CheckCustomer", "CheckCustomer", 
				"CertID="+certID+",CustomerName="+customerName+",CustomerType="+customerType+",CertType="+certType+",IssueCountry="+issueCountry+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",InputDate="+inputDate);
	return result;
};

//在新增客户的同时，当客户类型为【个人客户】时，向customer_info,ind_info,ind_resume,customer_identity,ind_si表中插入关联数据，当客户类型为【企业客户】时，向customer_info,ent_info,customer_indentity表中插入关联数据 (Developer:xtliu)
CustomerManage.createCustomerInfo=function(customerName,customerType,certID,certType,issueCountry,inputOrgID,inputUserID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CreateCustomerInfo", "CreateCustomerInfo","CustomerName="+customerName+",CustomerType="+customerType+",CertID="+certID+",CertType="+certType+",IssueCountry="+issueCountry+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",InputDate="+inputDate);
	return result;
};

//根据证件类型的不同，更新相应表的证件号码 (Developer:xtliu)
CustomerManage.updateCertID=function(customerID,certType,certID){
	if(certType == "2010"){//证件类型为【营业执照】时，更新ent_info中的营业执照号码为证件号码
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateCertID", "UpdateLicenseNo", "CertID="+certID+",CustomerID="+customerID);
		return result;
	}else if(certType == "1110"){//证件类型为【社会保障卡】时，更新int_si中的社会保障号为证件号码
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateCertID", "UpdateAccountNo", "accountNo="+certID+",CustomerID="+customerID);
		return result;
	}else{
		return;
	}
};

CustomerManage.updateCustomerName=function(customerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateCertID", "updateCustomerName", "CustomerID="+customerID);
	return result;
};

//【个人客户】详情页面，在更改【社会保障号】时，执行更新ind_si表中的accountNo字段操作 (Developer:xtliu)
CustomerManage.updateAccountNo=function(customerID,accountNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateCertID", "UpdateAccountNo", "accountNo="+accountNo+",CustomerID="+customerID);
	return result;
};

//删除客户分组组别逻辑(Developer:xtliu)
CustomerManage.deleteCustomerTag=function(serialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.DeleteCustomerTag", "deleteCustomerTag", "serialNo="+serialNo);
	return result;
};

//删除分组中的客户逻辑(Developer:xtliu)
CustomerManage.deleteTagCustomer=function(deleteCustomerIDs){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.DeleteTagCustomer", "deleteTagCustomer", "CustomerID="+deleteCustomerIDs);
	return result;
};

//查询客户信息(Developer:xtliu)
CustomerManage.selectCustomer=function(customerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.JudgeHasCustomer", "judgeHasCustomer", "customerID="+customerID);
	return result;
};

//通过客户编号查询该客户的customerType(Developer:xtliu)
CustomerManage.selectCustomerType=function(customerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.common.action.SelectCustomer", "selectCustomerType", "customerID="+customerID);
	return result;
};

//客户名单管理提交处理逻辑(Developer:xtliu)
CustomerManage.updatePhaseAction=function(todoType,status,serialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateTodoList", "updatePhaseAction","TodoType="+todoType+",Status="+status+",SerialNo="+serialNo);
	return result;
};

//客户名单复核更新复核结论
CustomerManage.updateTodoList=function(serialNos,phaseActionType,relaTodoTypes){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateTodoList", "updateTodoList", "serialNos="+serialNos+",phaseActionType="+phaseActionType+",relaTodoTypes="+relaTodoTypes);
	return result;
};

//客户名单管理提交取消特殊客户名单处理逻辑(Developer:xtliu)
CustomerManage.importCancelTodoList=function(objectType, objectNo, todoType, status, phaseOpinion, memo, operateOrgID, operateUserID, inputDate, inputOrgID, inputUserID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.ImportTodoList", "importCancelTodoList","ObjectType="+objectType+",ObjectNo="+objectNo+",TodoType="+todoType+",Status="+status+",PhaseOpinion="+phaseOpinion+",Memo="+memo+",OperateOrgID="+operateOrgID+",OperateUserID="+operateUserID+",InputDate="+inputDate+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID);
	return result;
};

//客户名单管理取消特殊客户名单处理逻辑(new:Developer:xtliu)
CustomerManage.CancelSpecialCustomer=function(SerialNos){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CancelSpecialCustomer", "cancelSpecialCustomer","SerialNos="+SerialNos);
	return result;
};

//合作项目删除控制逻辑(Developer:xtliu)
CustomerManage.selectPartnerIsDelete=function(CustomerID,UserID,OrgID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.SelectPartnerIsApplying", "selectProjecting","CustomerID="+CustomerID+",UserID="+UserID+",OrgID="+OrgID);
	return result;
};

CustomerManage.selectCustomerBelong=function(CustomerID,InputOrgID,InputUserID,InputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CreateCustomerInfo", "SelectCustomerBelong","CustomerID="+CustomerID+",InputOrgID="+InputOrgID+",InputUserID="+InputUserID+",InputDate="+InputDate);
	return result;
};

CustomerManage.judgeIndDate=function(CustomerID,jboYears){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeIndDate", "judgeIndDate","CustomerID="+CustomerID+",jboYears="+jboYears);
	return result;
};

CustomerManage.selectAddressIsNew=function(CustomerID,AddressType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.SelectAddressIsNew", "selectAddressIsNew","CustomerID="+CustomerID+",AddressType="+AddressType);
	return result;
};

CustomerManage.judgeIsRelative=function(CustomerID,RelativeCustomerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeIsRelative", "judgeIsRelative","CustomerID="+CustomerID+",RelativeCustomerID="+RelativeCustomerID);
	return result;
};

CustomerManage.judgeIsLover=function(CustomerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeIsLover", "judgeIsLover","CustomerID="+CustomerID);
	return result;
};

CustomerManage.importRelationShip=function(customerid,relativeCustomerid,RelationShip,InputOrgID,InputUserID,InputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.ImportRelativeShip", "importRelationShip","CustomerID="+customerid+",relativeCustomerid="+relativeCustomerid+",RelationShip="+RelationShip+",InputOrgID="+InputOrgID+",InputUserID="+InputUserID+",InputDate="+InputDate);
	return result;
};

CustomerManage.updateSex=function(customerID,certType,certID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.CreateCustomerInfo", "updateSex","CustomerID="+customerID+",CertType="+certType+",CertID="+certID);
	return result;
};

CustomerManage.selectTelIsNew=function(customerID,telType,InformationType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.SelectTelIsNew", "selectTelIsNew","CustomerID="+customerID+",TelType="+telType+",InformationType="+InformationType);
	return result;
};

CustomerManage.judgeIsExists=function(CertID,CertType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeIsExists", "judgeIsExists","CertID="+CertID+",CertType="+CertType);
	return result;
};

CustomerManage.updateIncome=function(CustomerID,OccurDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateIncome", "updateIncome","CustomerID="+CustomerID+",OccurDate="+OccurDate);
	return result;
};

CustomerManage.judgeIncomeType=function(CustomerID,financialItem){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeIncomeType", "judgeIncomeType","CustomerID="+CustomerID+",FinancialItem="+financialItem);
	return result;
};
CustomerManage.selectRelativePercent=function(CustomerID,RelativePercent){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.SelectRelativePercent", "selectRelativePercent","CustomerID="+CustomerID+",RelativePercent="+RelativePercent);
	return result;
};
CustomerManage.judgeDwellNum=function(BirthDay,DwellNum){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.JudgeDwellNum", "judgeDwellNum","BirthDay="+BirthDay+",DwellNum="+DwellNum);
	return result;
};
CustomerManage.qureyFinanceAssetInfo=function(CustomerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.QueryFinanceAssetInfo", "queryFinanceAssetInfo","CustomerID="+ CustomerID);
	return result;
};