var ProductComponentFunctions={};

/*
 * 保存component信息
 */
ProductComponentFunctions.saveComponent = function(tempSaveFlag){
	var oldID = getItemValue(0,0,"OLDVALUEBACKUPID");
	var id=getItemValue(0,0,"ID");
	if(typeof(oldID)=="undefined" || oldID.length==0) {
		setItemValue(0,0,"OLDVALUEBACKUPID",id);
	}
	ALSObjectWindowFunctions.saveAllObjectWindow("ProductComponentFunctions.reopenComponent()",tempSaveFlag);
};

ProductComponentFunctions.reopenComponent = function(){
	//刷新重新打开
	var id=getItemValue(0,0,"ID");
	var format=getItemValue(0,0,"Format");
	
	AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile="+ProductComponentFunctions.XMLFile+"&XMLTags="+ProductComponentFunctions.XMLTags+"&Keys="+ProductComponentFunctions.Keys+"&ID="+id+"&SYS_FUNCTION_RELOAD=1&Format="+format,"","_self");
};



/*
 * 引入组件参数
 */
ProductComponentFunctions.importParameters=function(dwname,xmlFile,xmlTags,keys,process){
	
	var inputParameters={"XMLFile":xmlFile,"XMLTags":xmlTags,"Keys":keys,"BusinessProcess":process};
	var inputParameterString=JSON.stringify(inputParameters);
	var parameterIDString =AsDialog.SelectGridValue("PRD_ParameterList", inputParameterString, "PARAMETERID@PARAMETERNAME", "", true);
	if(!parameterIDString || parameterIDString == "_CANCEL_" || parameterIDString == "_CLEAR_")
		return ;
	
	var position=getRow(dwname);
	if(position<0) position= getRowCount(dwname);
	else position = position+1;
	var parameterArray = parameterIDString.split("~");
	ALSObjectWindowFunctions.addRows(dwname,position,parameterArray.length,''," ProductComponentFunctions.setValue("+dwname+","+position+",'"+parameterIDString+"')  ");
};

//引入组件后输入选择值
ProductComponentFunctions.setValue=function(dwname,row,parameterIDString)
{
	var parameterArray = parameterIDString.split("~");
	for(var i = 0; i < parameterArray.length; i ++)
	{
		setItemValue(dwname,row+i,'PARAMETERID',parameterArray[i].split("@")[0]);
		setItemValue(dwname,row+i,'PARAMETERNAME',parameterArray[i].split("@")[1]);
		setItemValue(dwname,row+i,'DISPLAYNAME',parameterArray[i].split("@")[1]);
	}
}

/*
 * 新建子组件
 */
ProductComponentFunctions.newChildrenComponent=function(dwname){
	var id=getItemValue(0,0,"ID");
	AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile="+ProductComponentFunctions.XMLFile+"&XMLTags="+ProductComponentFunctions.XMLTags+"|| ID='"+id+"'//ChildrenComponents//ChildrenComponent&Keys="+ProductComponentFunctions.Keys+"&ID=&SYS_FUNCTION_RELOAD=1");
	ProductComponentFunctions.reopenComponent()
};

/*
 * 新建子组件
 */
ProductComponentFunctions.editChildrenComponent=function(dwname){
	var id=getItemValue(0,0,"ID");
	var childrenID=getItemValue(dwname,getRow(dwname),"ID");
	var format=getItemValue(dwname,getRow(dwname),"Format");
	if(typeof(childrenID)=="undefined" || childrenID.length==0) {
		alert(getHtmlMessage('1'));//请选择一条信息！
       return ;
	}
	
	AsCredit.openFunction("PRD_BusinessComponentInfo","XMLFile="+ProductComponentFunctions.XMLFile+"&XMLTags="+ProductComponentFunctions.XMLTags+"|| ID='"+id+"'//ChildrenComponents//ChildrenComponent&Keys="+ProductComponentFunctions.Keys+"&ID="+childrenID+"&SYS_FUNCTION_RELOAD=1&Format="+format);
	ProductComponentFunctions.reopenComponent()
};


ProductComponentFunctions.popSelectParameterValues = function(selectType,selectString,parameterID,dwName,idColumn,nameColumn,multiFlag,style){
	if(!style)style = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var returnValue = "";
	if(selectType=="01"){//列表选择
		selectString = selectString.split(",");
		var templetNo = selectString[0];
		var returnColumns = selectString[1];
		var inputParameters = "";
		var selectedValues="";
		if(selectString[2])inputParameters=selectString[2];
		returnValue =AsDialog.SelectGridValue(templetNo,inputParameters, returnColumns,selectedValues, multiFlag);
	}
	else if(selectType=="02"){//树图选择
		var selectedValues=getItemValue(dwName, getRow(dwName), idColumn);
		if(typeof(selectedValues)=="undefined")selectedValues="";
		var readOnlyFlag=ALSObjectWindowFunctions.getObjectWindowColAttribute(dwName,idColumn,"COLREADONLY");
		returnValue = PopPage("/ProductManage/ParameterConfig/ParameterSqlCodeSelector.jsp?ReadOnly="+readOnlyFlag+"&MultiFlag="+multiFlag+"&SelectedValues="+selectedValues+"&ParameterID="+parameterID,"",style);
	}
	else if(selectType=="03"){//自定义选择
		alert("不支持的方式");
		return;
	}
	else {
		alert("不支持的方式");
		return;
	}
	
	if(typeof(returnValue)=="undefined" || returnValue=="null" ||returnValue==""|| returnValue==null
		||!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_"){
		return;	
	}
	var items = returnValue.split("~");
    var ids = "";
    var names = "";
    for(var i = 0 ; i < items.length; i++){
    	if(items[i].length==0) continue;
    	ids +=  "," + items[i].split("@")[0] ;
    	names += "," +  items[i].split("@")[1] ;
    }

    setItemValue(dwName, getRow(dwName), idColumn, ids.substring(1));
	setItemValue(dwName, getRow(dwName), nameColumn, names.substring(1));
};