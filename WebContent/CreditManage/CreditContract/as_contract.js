var AsContract={
		
};

//检测业务风险
function riskSkan(){
	//获得申请类型、申请流水号
	//var objectNo = AsCredit.getParameter("ObjectNo");
	//var objectType = AsCredit.getParameter("ObjectType");

	//进行风险智能探测
	//return autoRiskScan("010","ObjectType="+objectType+"&ObjectNo="+objectNo, "");
	return true;
}

//打印电子合同
function printContract(){
	if(!riskSkan()) return;
	
	var objectNo = AsCredit.getParameter("ObjectNo");
	var objectType = AsCredit.getParameter("ObjectType");
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
	top.close();
}

//获取凭证模版号
function getEdocNo(objectNo, objectType){
	return "AAA";
}

//归档
function archive(){
	var objectNo = AsCredit.getParameter("ObjectNo");
	var objectType = AsCredit.getParameter("ObjectType");
	
	result = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+objectType+"&ObjectNo="+objectNo,"","");
	if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){
		alert(getBusinessMessage('422'));//该笔合同已经置为完成放贷！
		top.reloadSelf();
	} else {
		top.close();
	}
}

//取消归档
function cancelarchive(){
	var objectNo = AsCredit.getParameter("ObjectNo");
	if(confirm(getHtmlMessage('58'))){ //取消归档操作
		result = RunMethod("BusinessManage","CancelArchiveBusiness",objectNo+",BUSINESS_CONTRACT");
		if(typeof(result)=="undefined" || result.length==0) {					
			alert(getHtmlMessage('61'));//取消归档失败！
			return;
		}else{
			alert(getHtmlMessage('59'));//取消归档成功！
			top.close();
		}
	}
}
