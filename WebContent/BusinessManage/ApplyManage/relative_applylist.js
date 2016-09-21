/**
 * 担保申请，关联申请业务。
 */

var relative_apply= {	
};
/**
 * 打包申请、额度下首笔业务申请
 */
relative_apply.newRecord=function(){
	var    objectNo=AsCredit.getParameter("ObjectNo");
	var   applyType=AsCredit.getParameter("ApplyType");
	var   customerID=AsCredit.getParameter("CustomerID");
	if(applyType.indexOf("Ent")==0) applyType="EntDepenApply";//公司额度下业务
	else if(applyType.indexOf("Ind")==0) applyType="IndDepenApply";//个人额度下业务
	 sStyle="width=500px,height=500px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	 AsCredit.openFunction("NewApply","customerID="+customerID+"&RelativeApplyNo="+objectNo+"&ApplyType="+applyType,sStyle);
 	reloadSelf();
};
/**
 * 查看详情
 */
relative_apply.viewAndEdit=function(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(serialNo)=="undefined" || serialNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	 AsCredit.openFunction("ApplyDetail","ObjectType=CreditApply&ObjectNo="+serialNo);
	reloadSelf();
};

/**
 * 删除申请
 */
relative_apply.deleteRecord=function(){
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(!confirm('确实要删除吗?')) return;
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