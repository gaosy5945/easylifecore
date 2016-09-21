
function newProjectApply(){
	AsControl.PopView("/ProjectManage/ProjectNewApply/ProjectNewInfo.jsp","","resizable=yes;dialogWidth=520px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
};

function viewProjectApply(){
	
};

function editProjectApply(){
	var SerialNo = getItemValue(0,getRow(),"SERIALNO");
	var ProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
	if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
		alert("请选择一条信息！");
		return;
	}
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+SerialNo+"&ProjectType="+ProjectType);
};

function deleteProjectApply(){
	if(confirm('确实要删除吗?'))as_delete(0,'');
	//请注意：未添加关联信息的删除，如合作项目的楼盘信息，保证金信息等
	//......请添加
};

function submitProjectApply(){
	var SerialNo = getItemValue(0,getRow(),"SERIALNO");
	var userID = AsCredit.PageSystemParameters["CurUserID"];
	var orgID = AsCredit.PageSystemParameters["CurOrgID"];
	if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
		alert("请选择一条信息！");
		return;
	}
	var returnValue = AsControl.RunASMethod("ProjectApplyBusiness","ProjectApply",SerialNo+","+userID+","+orgID);
	if(returnValue.split("@")[0] == "true"){
		var flowSerialNo = returnValue.split("@")[3];
		var taskSerialNo = returnValue.split("@")[4];
		var phaseNo = returnValue.split("@")[5];
		var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
		{
			return;
		}	
	}else{
		alert("流程启动失败!");
	}
	reloadSelf();
};
function cancelProjectApply(){
	alert("");
};

function viewProjectApprove(){
	
};

function newProjectAlterApply(){
	var result = AsControl.PopView("/ProjectManage/ProjectAlterNewApply/ProjectAlterNew.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=230px;center:yes;status:no;statusbar:no");
	var sReturn = result.split("@");
	var relativeSerialNo = sReturn[1];
	var lastSerialNo = sReturn[2];
	var customerID = sReturn[3];
	var copySerialNo = sReturn[4];
	var relativeType = sReturn[5];

	if(sReturn[0] == "true"){
		AsCredit.openFunction("ProjectAlterInfo", "CopySerialNo="+copySerialNo+"&RelativeType="+relativeType+"&CustomerID="+customerID+"&ProjectSerialNo="+lastSerialNo);
	}else{
		return;
	}
	reloadSelf();
}

function editAlterProjectApply(){
	var SerialNo = getItemValue(0,getRow(),"SERIALNO");
	var ProjectSerialNo = getItemValue(0,getRow(),"PROJECTSERIALNO");
	var ObjectNo = getItemValue(0,getRow(),"OBJECTNO");
	var RelativeType = getItemValue(0,getRow(),"RELATIVETYPE");
	var CustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
		alert("请选择一条信息！");
		return;
	}
	AsCredit.openFunction("ProjectAlterInfo", "CopySerialNo="+ProjectSerialNo+"&RelativeType="+RelativeType+"&CustomerID="+CustomerID+"&ProjectSerialNo="+ObjectNo);
}

function deleteProjectAlterApply(){
	var SerialNo = getItemValue(0,getRow(),"SerialNo");
	if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
		alert("请选择一条信息！");
		return;
	}
	if(confirm('确实要删除吗?'))as_delete(0,'');
}
