/**
 * 合同处理的相关Js文件
 */

function viewContract(){
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	AsCredit.openFunction("ContractDetail","ObjectType=BusinessContract&ObjectNo="+objectNo);
	reloadSelf();
}

/**
 * 合同签约
 */
function signContract(){
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	AsCredit.openFunction("ContractSignInfo","ObjectType=BusinessContract&ObjectNo="+objectNo);
}

function printContract(){ 
	
	var objectNo = getItemValue(0,getRow(),"SerialNo");
	var objectType = "BusinessContract";
	var edocNo = getEdocNo(objectNo, objectType);
	
	var param = "ObjectNo="+objectNo+",ObjectType="+objectType+",EdocNo="+edocNo+",UserID="+AsCredit.userId;
	var printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "getPrintSerialNo", param);
	if(printSerialNo == ""){
		printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "initEdocPrint", param);
	} else {
		if(confirm("是否重新生成电子合同？"))
			printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "updateEdocPrint", param);
	}
	OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+printSerialNo,"_blank","");
}

function updatePhaseType(phaseType){
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	if (typeof(phaseType)=="undefined" || phaseType.length==0)
	{
		alert("合同阶段类型没有传入！");
		return;
	}
	
	AsCredit.runFunction("UpdateContractPhase","SerialNo="+objectNo+"&PhaseType="+phaseType);
	reloadSelf();
}

function cancelContract(){
	var objectNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var objectType = "BusinessContract";
	vResult=AsCredit.runFunction("CancelContract", "ObjectType="+objectType+"&ObjectNo="+objectNo);
	result=vResult.getOutputParameter("DeleteResult");
	if(result=="ERROR"){
		message=vResult.getOutputMessage(); 
		for(var i=0;i<message.length;i++){
			tips=message[i][1];
			alert(tips);
		}
		return ;
	}
	reloadSelf();
}
//获取凭证模版号
function getEdocNo(objectNo, objectType){
	return "AAA";
}
