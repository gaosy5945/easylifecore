var ProjectManage={};
ProjectManage.createNewProjectApply = function(){
	alert("添加");
};

ProjectManage.createModifyProjectApply = function(projectSerialNo){
	alert("添加");
};

ProjectManage.editProjectApply = function(projectSerialNo){
	alert("添加");
};

ProjectManage.deleteProjectApply = function(projectSerialNo){
	alert("添加");
};

ProjectManage.submitProjectApply = function(projectSerialNo){
	alert("添加");
};

ProjectManage.viewProject = function(projectSerialNo){
	alert("添加");
};

ProjectManage.editProjectApprove = function(taskSerialNo){
	alert("添加");
};

ProjectManage.approveProjectApply = function(taskSerialNo){
	alert("添加");
};
//规模额度页面保存逻辑
ProjectManage.ImportClInfo=function(objectNo,objectType,maturityDate,controlType,revolvingFlag,divideType,businessAppAmt,status){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.ImportClInfo", "importClInfo", "objectNo="+objectNo+",objectType="+objectType+",maturityDate="+maturityDate+",controlType="+controlType+",objectType="+objectType+",objectType="+objectType+",objectType="+objectType+",objectType="+objectType+",objectType="+objectType);
	return result;
};
//楼盘库模糊查询
ProjectManage.checkBuildingInfo=function(buildingName,areaCode,locationC1){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CheckBuildingInfo", "checkBuildingInfo", "buildingName="+buildingName+",areaCode="+areaCode+",locationC1="+locationC1);
	return result;
};
//楼盘库新建
ProjectManage.createBuilding=function(buildingName,areaCode,locationC1,inputOrgID,inputUserID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CreateBuilding", "createBuilding", "buildingName="+buildingName+",areaCode="+areaCode+",locationC1="+locationC1+",inputOrgID="+inputOrgID+",inputUserID="+inputUserID);
	return result;
};
//楼盘详情
ProjectManage.editBuilding=function(serialNo){
	AsControl.PopView("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo, "resizable=yes;dialogWidth=900px;dialogHeight=460px;center:yes;status:no;statusbar:no");
	reloadSelf();
};
//新增项目变更
ProjectManage.importPrjRelative=function(ProjectSerialNo,ObjectType,RelativeType,UserID,OrgID,InputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.ImportPrjRelative", "importPrjAndCopyPrj", "ProjectSerialNo="+ProjectSerialNo+",ObjectType="+ObjectType+",RelativeType="+RelativeType+",userID="+UserID+",orgID="+OrgID+",InputDate="+InputDate);
	return result;
};
//项目楼盘删除
ProjectManage.deleteProjectBuilding=function(BuildingSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.DeleteProjectBuilding", "deleteProjectBuilding", "BuildingSerialNo="+BuildingSerialNo);
	return result;
};
//项目切分总额度汇总
ProjectManage.getBusinessAppAmt=function(parentSerialNo,divideType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.GetBusinessAppAmt", "getBusinessAppAmt", "ParentSerialNo="+parentSerialNo+",DivideType="+divideType);
	return result;
};
//
ProjectManage.importCLInfo=function(ProductList,ParticipateOrg,ParentSerialNo,DivideType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.ImportCutCLInfo", "importCutCLInfo", "ProductList="+ProductList+",ParticipateOrg="+ParticipateOrg+",ParentSerialNo="+ParentSerialNo+",DivideType="+DivideType);
	return result;
};
//
ProjectManage.selectCutCL=function(CLSerialNo,DivideType){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectCutCL", "selectCutCL", "CLSerialNo="+CLSerialNo+",DivideType="+DivideType);
	return result;
};
//
ProjectManage.selectProductAndParticipate=function(prjSerialNo,productList,participateOrg){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectProductAndParticipate", "selectProductAndParticipate", "prjSerialNo="+prjSerialNo+",productList="+productList+",participateOrg="+participateOrg);
	return result;
};
//
ProjectManage.deleteCutCL=function(prjSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.DeleteCutCL", "deleteCutCL", "prjSerialNo="+prjSerialNo);
	return result;
};
//
ProjectManage.updateBusinessAppAmt=function(SerialNoGroup,DataGroup,parentSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.UpdateBusinessAppAmt", "updateBusinessAppAmt", "SerialNoGroup="+SerialNoGroup+",DataGroup="+DataGroup+",ParentSerialNo="+parentSerialNo);
	return result;
};

ProjectManage.selectPaymentMoney=function(MarginSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectPaymentMoney", "selectPaymentMoney", "MarginSerialNo="+MarginSerialNo);
	return result;
};

ProjectManage.selectMarginInfo=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectMarginInfo", "selectMarginInfo", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};

ProjectManage.selectMarginSerialNo=function(MarginSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectMarginInfo", "selectMarginSerialNo", "MarginSerialNo="+MarginSerialNo);
	return result;
};

ProjectManage.selectPrjStatus=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectPrjStatus", "selectPrjStatus", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};

ProjectManage.selectIsSaveProjectInfo=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectPrjStatus", "selectIsSaveProjectInfo", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};

ProjectManage.projectMerge=function(ProjectSerialNoNew, ProjectSerialNoOld, relaPRSerialNos){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.ProjectMerge", "projectMerge", "ProjectSerialNo="+ProjectSerialNoNew+",ProjectSerialNoOld="+ProjectSerialNoOld+",relaPRSerialNos="+relaPRSerialNos);
	return result;
};

ProjectManage.selectPrjIsLose=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectPrjStatus", "selectPrjStatus", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};
ProjectManage.selectCustomerName=function(CustomerID){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectCustomerName", "selectCustomerName", "CustomerID="+CustomerID);
	return result;
};
ProjectManage.CreateAndUpdateCL=function(SerialNo,ProjectSerialNo,DivideType,ObjectNo,ObjectType,BusinessAppAmt,RevolvingFlag,InputUserID,InputOrgID,InputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CreateAndUpdateCL", "createAndUpdateCL", "SerialNo="+SerialNo+",ProjectSerialNo="+ProjectSerialNo+",DivideType="+DivideType+",ObjectNo="+ObjectNo+",ObjectType="+ObjectType+",BusinessAppAmt="+BusinessAppAmt+",RevolvingFlag="+RevolvingFlag+",InputUserID="+InputUserID+",InputOrgID="+InputOrgID+",InputDate="+InputDate);
	return result;
};
ProjectManage.selectBusinessSum=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectBuildingData", "selectBusinessSum", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};
ProjectManage.queryMarginBalance=function(ProjectSerialNo,AccountNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.QueryMarginBalance", "queryMarginBalance", "ProjectSerialNo="+ProjectSerialNo+",AccountNo="+AccountNo);
	return result;
};
ProjectManage.updateAgreementNo=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateAgreementNo", "udpateAgreementNo", "SerialNo="+ProjectSerialNo);
	return result;
};
ProjectManage.updateProjectStatus=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateAgreementNo", "udpateProejctStatus", "SerialNo="+ProjectSerialNo);
	return result;
};
ProjectManage.getAccountNo=function(ProjectSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectAccountNo", "selectAccountNo", "ProjectSerialNo="+ProjectSerialNo);
	return result;
};
ProjectManage.judgeIsAlterApply=function(AgreementNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.JudgeIsAlterApply", "judgeIsAlterApply", "AgreementNo="+AgreementNo);
	return result;
};