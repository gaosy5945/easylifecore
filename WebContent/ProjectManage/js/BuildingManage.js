//楼盘库管理-新增楼盘(Developer:xtliu)
function newBuilding(){
	var result = AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageNew.jsp","DialogTitle=新建楼盘","resizable=yes;dialogWidth=500px;dialogHeight=180px;center:yes;status:no;statusbar:no");
	result = result.split("@");
	var k=result.length;
	var j=result.length;
	if(result[0] == "true"){
		var serialNos = "";
		for(var i=1; i<result.length-5;i++){
			serialNos +=result[i]+",";
		}
		var buildingName = result[k-5];
		var areaCode = result[k-4];
		var locationC1 = result[k-3];
		var inputOrgID = result[k-2];	
		var inputUserID = result[k-1];
		AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageCheckList.jsp","SerialNo="+serialNos+"&buildingName="+buildingName+"&areaCode="+areaCode+"&locationC1="+locationC1+"&inputUserID="+inputUserID+"&inputOrgID="+inputOrgID,"resizable=yes;dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no");
	}else if(result[0] == "listResultNull"){
		var buildingName = result[j-5];
		var areaCode = result[j-4];
		var locationC1 = result[j-3];
		var inputOrgID = result[j-2];
		var inputUserID = result[j-1];
		if(confirm("无疑似楼盘，是否继续新增楼盘？")){
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.CreateBuilding", "createBuilding", "buildingName="+buildingName+",areaCode="+areaCode+",locationC1="+locationC1+",inputOrgID="+inputOrgID+",inputUserID="+inputUserID);
			result = result.split("@");
			if(result[0]=="true"){
				alert("楼盘新建成功！");
				AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+result[1], "");
			}else{
				alert("楼盘新建失败！");
				return;
			}
		}
	}else if(result[0] == "false"){
		alert("该楼盘已存在");
		return;
	}else{
		return;
	}
}
//楼盘库管理-楼盘详情(Developer:xtliu)
function viewBuilding(){
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	AsControl.PopPage("/ProjectManage/BuildingManage/BuildingManageInfo.jsp", "SerialNo="+serialNo, "");
	//reloadSelf();
}
//楼盘库管理-批量导入(Developer:xtliu)
function importBuilding(){
    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
    var parameter = "clazz=jbo.import.excel.BUILDING_IMPORT";
    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
   // reloadSelf();
}
//楼盘库管理-关联项目查询(Developer:xtliu)
function selectRelativeProject(){
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	
	AsControl.PopPage("/ProjectManage/BuildingManage/RelativeProjectList.jsp", "SerialNo="+serialNo, "resizable=yes;dialogWidth=800px;dialogHeight=460px;center:yes;status:no;statusbar:no");
}
//楼盘库管理-删除(Developer:xtliu)
function deleteBuilding(){
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(serialNo) == "undefined" || serialNo.length == 0){
	    alert(getHtmlMessage('1'));//请选择一条信息！
	    return;
	}
	if(confirm('确实要删除吗?')){
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectBuildingIsDelete", "selectBuildingIsDelete","BuildingSerialNo="+serialNo);
		if(sReturn == "ProjectSerialNoFull"){
			alert("该楼盘存在关联的合作项目，不允许删除！");
			return;
		}else{
			sResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.DeleteBuilding", "deleteBuilding", "BuildingSerialNo="+serialNo);
			if(sResult == "SUCCEED"){
				alert("删除成功！");
			}
			reloadSelf();
		}
	}
}
//楼盘库管理-关联业务查询(Developer:xtliu)
function selectRelativeBusiness(){
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	AsControl.PopPage("/ProjectManage/BuildingManage/RelativeBusinessInfo.jsp", "SerialNo="+serialNo, "");

}