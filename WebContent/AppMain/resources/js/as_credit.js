/**
 * 信贷专用对象，包括了当前用户等常用信息和方法。
 */

var AsCredit = {	
};

//定义变量
/*AsCredit.userId="";
AsCredit.orgId="";
AsCredit.userName="";
AsCredit.orgName="";
AsCredit.today="";*/

AsCredit.PageOutputParameters={};
AsCredit.PageSystemParameters={};

/**
 * 获得参数值
 */
AsCredit.getBusinessObjectAtrribute=function(businessObject,attributeID){
	for(var v in businessObject)
	{
		var attribute = businessObject[v];
		var attributeValue=attribute[attributeID];
		if(!attributeValue)attributeValue=attribute[attributeID.toUpperCase()];
		return attributeValue;
	}
};


/**
 * 获得参数值
 */
AsCredit.setBusinessObjectAtrribute=function(businessObject,attributeID,attributeValue){
	for(var v in businessObject)
	{
		var attribute = businessObject[v];
		attribute[attributeID]=attributeValue;
	}
};

/**
 * 获得参数值
 */
AsCredit.setBusinessObjectPropety=function(businessObject,attributeID,attributeValue){
	businessObject[attributeID]=attributeValue;
	//else businessObject[attributeID.toUpperCase()]=attributeValue;
};

/**
 * 获得参数值
 */
AsCredit.getBusinessObjectAtrributes=function(businessObject){
	for(var v in businessObject)
	{
		return businessObject[v];
	}
};


/**
 * 根据功能ID打开一个功能
 */
AsCredit.openFunction=function(functionID,parameters,style,targetWindow){
	if(typeof(style)=="undefined") style="";
	if(typeof(functionID)=="undefined" || functionID==""){
		alert("功能编号不能为空！");
		return ;
	}
	var paramString="SYS_FUNCTIONID="+functionID;
	paramString = paramString+"&"+parameters;
	var _result = "";
	if(typeof(targetWindow)!="undefined"){
		_result=AsControl.OpenComp("/AppMain/resources/widget/FunctionView.jsp",paramString,targetWindow,style);
	}else{
		_result=AsControl.PopComp("/AppMain/resources/widget/FunctionView.jsp",paramString,style);
	}
	return _result;
};

/**
 * 根据功能ID打开一个功能
 */
AsCredit.reopenFunction=function(functionID,parameters,style,targetWindow){
	if(typeof(style)=="undefined") style="";
	if(typeof(functionID)=="undefined" || functionID==""){
		alert("功能编号不能为空！");
		return ;
	}
	var paramString="SYS_FUNCTION_RELOAD=1&SYS_FUNCTIONID="+functionID;
	paramString = paramString+"&"+parameters;
	var _result = "";
	if(typeof(targetWindow)!="undefined"){
		_result=AsControl.OpenComp("/AppMain/resources/widget/FunctionView.jsp",paramString,targetWindow,style);
	}else{
		_result=AsControl.PopComp("/AppMain/resources/widget/FunctionView.jsp",paramString,"_self",style);
	}
	return _result;
};

function FunctionResult(_resultData){
	this.resultData=_resultData;
	this.outPutParameters=_resultData["SYS_FUNCTION_OUTPUTPARAMETERS"];
	this.funtionRunMessage=_resultData["SYS_FUNCTION_RUN_MESSGE"];
	this.outPutParameters_Attributs=this.outPutParameters["Attributes"];
	this.finallyResult=this.resultData["SYS_FUNCTION_RUN_RESULT"];
	this.getResult=function(){
		return this.finallyResult;  
	};
	this.getOutputParameter=function(paraName){ 
		var key=paraName.toUpperCase();
		var value=this.outPutParameters_Attributs[key];
		if(typeof(value)=="undefined") return "";
		return value;
	};
	this.getOutputAllParameter=function(){ 
		return this.outPutParameters_Attributs;
		 
	};
	this.getOutputMessage=function(){ //获得输出的信息
		return this.funtionRunMessage;
	};
	this.toString=function(){
		return JSON.stringify(this.resultData);
	};
	this.getResultArray=function(){
		return this.resultData;
	};
}; 

/**
 * 执行Function
 * functionParameters 可以定义未字符从 key=value&key1=value1
 * 如果value中包含了&特殊符号，需采用[key,value]形式的数组
 * var functionParameters=[];
 * functionParameters[key]=value;
 */ 
AsCredit.runFunction=function(sys_functionId,functionParameters){
	if(typeof(functionParameters)=="undefined") functionParameters="";
	if(typeof(sys_functionId)=="undefined" || sys_functionId==""){
		alert("功能编号为空");
		return ;
	}
	var mapValue ={};
	mapValue["SYS_FUNCTIONID"]=sys_functionId;
	mapValue["SYS_FUNCTION_USERID"]=AsCredit.userId;
	if(typeof(functionParameters)=="string"){
			var paramArray=functionParameters.split("&");
			//获得参数
			for(var i=0;i<paramArray.length;i++){
				paramStr=paramArray[i];
				if(typeof(paramStr)=="undefined" || paramStr.indexOf("=")<0) continue;
				paraName=paramStr.split("=")[0];
				paraValue=paramStr.split("=")[1];
				mapValue[paraName]=paraValue;
			}
	}else{
		for(var paraName in functionParameters){
				paraValue=functionParameters[paraName];
				mapValue[paraName]=paraValue;
		}
	}
	
	var result=AsControl.RunJavaMethodTrans("com.amarsoft.app.als.sys.function.model.FunctionRun", "run", JSON.stringify({"data":mapValue}));
	var  fresult=new FunctionResult(result);
	return fresult;
};

/****
 * SelectTree树图选择器：
 * selector:对应与select_catalog表中的selname
 * inputParameters:传入的参数值，包括
 * outputParameters:返回值，json的返回值
 */
AsCredit.setMultipleTreeValue = function(selector,inputParameters,splitchar,windowStyle,dw,rownum,returnColumnID,returnColumnName){
	var selectedValues = getItemValue(dw, rownum, returnColumnID);
	var selectedValue = AsCredit.selectMultipleTree(selector,inputParameters,splitchar,windowStyle,"",selectedValues);
	if(selectedValue["Name"] == "_CLEAR_"){
		setItemValue(dw,rownum,returnColumnID,"");
		setItemValue(dw,rownum,returnColumnName,"");
	}
	if(!selectedValue["ID"]) return ;
	if(returnColumnID)  setItemValue(dw,rownum,returnColumnID,selectedValue["ID"]);
	if(returnColumnName)  setItemValue(dw,rownum,returnColumnName,selectedValue["Name"]);
};

/****
 * SelectTree树图选择器：
 * selector:对应与select_catalog表中的selname
 * inputParameters:传入的参数值，包括
 * outputParameters:返回值，json的返回值
 */
AsCredit.selectMultipleTree = function(selector,inputParameters,splitchar,windowStyle,selectLevel,selectedValues){
	if(!splitchar) splitchar=",";
	if(!selectLevel) selectLevel="Top";
	var selectedValue={};
	selectedValue["ID"]="";
	selectedValue["Name"]="";
	if(typeof(windowStyle)=="undefined" || windowStyle=="") windowStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var returnValue = PopPage("/Frame/DialogSelect.jsp?SelectedValues="+selectedValues+"&SelectLevel="+selectLevel+"&SelName="+selector+"&MultipleFlag=Y&ParaString="+inputParameters,"",windowStyle);
	if(returnValue == "_NONE_" || returnValue == "_CLEAR_"){
		selectedValue["Name"] = "_CLEAR_";
		return selectedValue;
	}
	if(!returnValue || returnValue == "_NONE_" || returnValue == "_CANCEL_"|| returnValue == "_CLEAR_")
		return selectedValue;
	returnValue = returnValue.split("~");
	for(var i=0;i<returnValue.length;i++){
		var selectedItem=returnValue[i];
		if(selectedItem.length>0){
			selectedItem = selectedItem.split("@");
			selectedValue["ID"]+=splitchar+selectedItem[0];
			selectedValue["Name"]+=splitchar+selectedItem[1];
		}
	}
	
	if(selectedValue["ID"].length>0)selectedValue["ID"] = selectedValue["ID"].substring(1);
	if(selectedValue["Name"].length>0)selectedValue["Name"] = selectedValue["Name"].substring(1);
	return selectedValue;
};

/**主要是使用在select_catalog中自定义查询选择信息*/	
AsCredit.selectTree=function(selector,inputParameters,windowStyle,folderSelectFlag){
	var selectedValue={};
	selectedValue["ID"]="";
	selectedValue["Name"]="";
	
	if(typeof(windowStyle)=="undefined" || windowStyle=="") windowStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var returnValue = PopPage("/Frame/DialogSelect.jsp?SelName="+selector+"&FolderSelectFlag="+folderSelectFlag+"&ParaString="+inputParameters,"",windowStyle);
	
	if(!returnValue || returnValue == "_NONE_" || returnValue == "_CANCEL_")
		return selectedValue;
	returnValue = returnValue.split("@");

	selectedValue["ID"]=returnValue[0];
	selectedValue["Name"]=returnValue[1];
	
	return selectedValue;
};

/**主要是使用在select_catalog中自定义查询选择信息*/	
AsCredit.setTreeValue=function(selector,inputParameters,windowStyle,dw,rownum,returnColumnID,returnColumnName,folderSelectFlag){
	var selectedValue=AsCredit.selectTree(selector,inputParameters,windowStyle,folderSelectFlag);
	if(!selectedValue["ID"]||selectedValue == "_CANCEL_") return ;
	if(returnColumnID)  {
		if(!selectedValue["ID"]||selectedValue["ID"] == "_NONE_"){
			setItemValue(dw,rownum,returnColumnID,"");
		}
		else{
			setItemValue(dw,rownum,returnColumnID,selectedValue["ID"]);
		}
	}
	if(returnColumnName){
		if(!selectedValue["Name"]){
			setItemValue(dw,rownum,returnColumnName,"");
		}
		else {
			setItemValue(dw,rownum,returnColumnName,selectedValue["Name"]);
		}
	}
};


/**主要是使用在select_catalog中自定义查询选择信息*/	
AsCredit.selectJavaMethodTree=function(selectClassName,inputParameters,windowStyle,multipleFlag){
	var selectedValue={};
	selectedValue["ID"]="";
	selectedValue["Name"]="";
	
	var inputParameterString=JSON.stringify(inputParameters);
	if(typeof(windowStyle)=="undefined" || windowStyle=="") windowStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var returnValue = PopPage("/Common/FunctionPage/TreeSelector.jsp?SelectClassName="+selectClassName+"&InputParameters="+inputParameterString+"&MultipleFlag="+multipleFlag,"",windowStyle);
	if(!returnValue)returnValue = "_CANCEL_";
	returnValue = returnValue.split("@");
	selectedValue["ID"]=returnValue[0];
	if(returnValue[1])selectedValue["Name"]=returnValue[1];
	else selectedValue["Name"]="";
	return selectedValue;
};

/**主要是使用在select_catalog中自定义查询选择信息*/	
AsCredit.setJavaMethodTree=function(selectClassName,inputParameters,dw,rownum,returnColumnID,returnColumnName,multipleFlag,windowStyle){
	inputParameters["ClearButtonFlag"]="1";
	var selectedValue=AsCredit.selectJavaMethodTree(selectClassName,inputParameters,windowStyle,multipleFlag);
	if(!selectedValue||selectedValue["ID"] == "_CANCEL_") return ;
	var idValue=selectedValue["ID"];
	var nameValue=selectedValue["Name"];
	if(selectedValue["ID"] == "_NONE_"){
		idValue="";
		nameValue="";
	}
	if(returnColumnID)  {
		setItemValue(dw,rownum,returnColumnID,idValue);
	}
	if(returnColumnName){
		setItemValue(dw,rownum,returnColumnName,nameValue);
	}
};


/**主要是使用在显示模板中自定义查询选择信息*/	
AsCredit.selectGrid=function(doNo,inputParameters,returnFieldString,windowStyle,multiFlag,splitchar,manualQueryFlag){
	if(!splitchar)splitchar=",";
	var selectedValue={};
	var returnFields = returnFieldString.split("@");
	for(var j=0;j<returnFields.length;j++){//col
		selectedValue[returnFields[j]]="";
	}
	var returnValue = AsDialog.SelectGridValue(doNo, inputParameters, returnFieldString, "",multiFlag,windowStyle,"",manualQueryFlag);
	if(!returnValue || returnValue == "_NONE_" || returnValue == "_CANCEL_")
		return selectedValue;
	returnValue = returnValue.split("~");
	for(var i=0;i<returnValue.length;i++){//row
		var values=returnValue[i].split("@");
		for(var j=0;j<returnFields.length;j++){//col
			var colName = returnFields[j];
			selectedValue[colName]+=splitchar+values[j];
		}
	}
	for(var value in selectedValue){
		selectedValue[value]=selectedValue[value].substring(1);
	}
	return selectedValue;
};

/**主要是使用在显示模板中自定义查询选择信息*/	
AsCredit.setGridValue=function(doNo,inputParameters,fieldMap,windowStyle,multiFlag,dw,rownum,manualQueryFlag){
	fieldMap=fieldMap.split("@");
	var valueFields=[];
	var returnFields=[];
	var valueFieldString="";
	for(var i=0;i<fieldMap.length;i++){//row
		var fields=fieldMap[i].split("=");
		returnFields[i]=fields[0];
		valueFields[i]=fields[1];
		
		if(valueFieldString=="") valueFieldString=fields[1];
		else valueFieldString+="@"+fields[1];
	}
	var selectedValue=AsCredit.selectGrid(doNo,inputParameters,valueFieldString,windowStyle,multiFlag,",",manualQueryFlag);

	for(var i=0;i<returnFields.length;i++){
		setItemValue(dw,rownum,returnFields[i],selectedValue[valueFields[i]]);
	}
};

/****
 * 将参数转为json后传给后续程序，避免参数的set、get方法扰乱程序结构，是程序更简洁清晰。
 */
AsCredit.RunJavaMethodTrans = function(className,methodName,args,splitChar){
	var parameterMap = {};
	if(!splitChar)splitChar=",";
	args = args.split(splitChar);
	for(var i=0;i<args.length;i++){
		var s = args[i].split("=");
		parameterMap[s[0]]=s[1];
	}
	
	var systemParameterMap = {};
	systemParameterMap["CurOrgID"]=AsCredit.PageSystemParameters["CurOrgID"];
	systemParameterMap["CurUserID"]=AsCredit.PageSystemParameters["CurUserID"];
	parameterMap["SystemParameters"]=systemParameterMap;
	args=JSON.stringify({"InputParameter":parameterMap});
	var result =  AsControl.RunJavaMethodTrans(className, methodName,args);
	return result;
};
/**
 * Describe: 自定义Confirm提示框;Message：提示信息 Sure：确定按钮名称 Cancel：取消按钮名称
 */
AsCredit.newConfirm = function(Message,Sure,Cancel){
	var Height = 100+(Message.length/20)*12;
	var returnValue = PopPage("/Frame/Confirm.jsp?Message="+Message+"&Sure="+Sure+"&Cancel="+Cancel,"","dialogWidth:300px;dialogHeight:"+Height+"px;resizable:yes;scrollbars:no;status:no;help:no");
	if(returnValue == "true"){
		return true;
	}else{
		return false;
	}
}

AsCredit.hideOWGroupItem=function(groupID){
	$("#A_Group_" +groupID ).hide();
};
AsCredit.showOWGroupItem=function(groupID){
	$("#A_Group_" +groupID).show();
};
AsCredit.getOWGroupItemStatus=function(groupID){
	return $("#A_Group_" +groupID).is(":visible");
};