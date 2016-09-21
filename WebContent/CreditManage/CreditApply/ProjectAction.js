function addProject(objectType,objectNo,relativeType){	
	var returnValue =AsDialog.SelectGridValue("SelectProjects", "", "SERIALNO@PROJECTTYPE@PROJECTNAME@STATUS", "", true);
	if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return ;
	returnValue = returnValue.split("~");
	for(var i in returnValue){
		if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
			var parameter = returnValue[i].split("@");
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "importProjects",
					"SerialNo=" + parameter[0]+",ObjectType=" + objectType+",ObjectNo="+objectNo+",RelativeType="+relativeType);
		}
	}
	if (result != "true") alert(result);
	else
		AsCredit.openFunction("ProjectsTab", "ObjectNo="+objectNo+"&ObjectType="+objectType+"&RelativeType=1&NeedClose=true&AlwaysShowFlag=1","","_self");
}


function closeTabFunction(itemID,itemName){
	if(confirm("确认删除"))
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "deleteProject", "SerialNo=" + itemID);
	else
		return false;
}


function deleteproject(objectType,objectNo,relativeType){
	var returnValue =AsDialog.SelectGridValue("SelectRelativeProjects", objectNo+","+objectType+","+relativeType, "SERIALNO", "", true);
	if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return ;
	returnValue = returnValue.split("~");
	if(confirm("确认删除")){
		var result="";
		for(var i in returnValue){
			if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
				result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.RelativeProject", "deleteProject", "SerialNo=" + returnValue[i]);
				if (result != "true") {
					alert(result);return;
				}else{
					continue;
				}
			}
		}
		
		if (result == "true") {
			alert("删除成功!");
			AsCredit.openFunction("ProjectsTab", "ObjectNo="+objectNo+"&ObjectType="+objectType+"&RelativeType=1&NeedClose=true&AlwaysShowFlag=1","","_self");
		}
	}else{
		return;
	}
	
}