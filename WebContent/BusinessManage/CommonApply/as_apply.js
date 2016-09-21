var AsApply={
		
};
 
/**
 * 提交功能，
 */
AsApply.doSubmit=function(sObjectNo){
	var objectType="CreditApply";
		//进行风险智能探测
	var sReturn = autoRiskScan("001","ObjectType="+objectType+"&ObjectNo="+sObjectNo,"20");
	if(sReturn != true){
		return;
	}
	 vReturn=AsCredit.runFunction("QuickApplyAction","objectType="+objectType+"&ObjectNo="+sObjectNo);
	 sReturn=vReturn.getResult();
	 if(!sReturn){
		 alert("流程初始化失败,错误原因["+sReturn+"]");
		 return ;
	 }
	 sReturn=AsTask.doSubmit(sObjectNo,"CreditApply",AsCredit.userId);

	 if(sReturn){
		 if(typeof(DZ) != "undefined" && DZ && DZ.length > 0){
			 reloadSelf();
		 }else{
			 top.returnValue="success";
			 top.close();
		 }
	 }
};
 /**
  * 删除申请
  */
AsApply.deleteRecord=function(){
	if(!confirm('确实要删除吗?')) return;
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	functionParameters="ObjectType=CreditApply&ObjectNo="+objectNo+"&Action=delete";
	var returnValue = AsCredit.runFunction("BusinessProcess", functionParameters);//AsTask.delRecord(objectNo,"CreditApply");
	var result=returnValue.getResult();
	if(result){
		alert("删除成功！");
		reloadSelf();
	}else{
		alert("删除失败！");
	}
};

 function newApply(){
	 sStyle="width=500px,height=500px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	 AsCredit.openFunction("NewApply","ApplyType="+AsCredit.parameter["ApplyType"],sStyle);
	reloadSelf();
 }
 
 /**
  * 保存新的申请
  */
 AsApply.saveNewApply=function(){
	if(!iV_all("0")) return;
	var owDataStr=AsCredit.getOWDataArray();
	owDataStr["RelativeApplyNo"]=AsCredit.getParameter("");
	var vResult=AsCredit.runFunction("BizNewApplyAction",owDataStr);
	if(vResult.getResult()){
		objectNo=vResult.getOutputParameter("SerialNo");
		var sParamString = "ObjectType=CreditApply&ObjectNo="+objectNo;
		AsCredit.openFunction("ApplyDetail",sParamString);
		top.close();
	}else{
		alert("新增失败:"+vResult.toString());
	}
	//AsControl.OpenObjectTab(sParamString);
 };
 /**
  * 获得下一阶段任务信息
  * @param objectNo
  * @param objectType
  * @returns
  */
 AsApply:getNextBusinessInfo=function(objectNo, objectType){
	 return AsTask.getNextBusinessInfo(objectNo, objectType); 
 };
 /**
  * 提交申请
  */
 function viewDetail(){
 	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var sParamString = "ObjectType=CreditApply&ObjectNo="+sObjectNo;
	AsCredit.openFunction("ApplyDetail",sParamString);
	reloadSelf();		
 };
  