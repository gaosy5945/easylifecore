/**
 * �������룬��������ҵ��
 */

var relative_apply= {	
};
/**
 * ������롢������ױ�ҵ������
 */
relative_apply.newRecord=function(){
	var    objectNo=AsCredit.getParameter("ObjectNo");
	var   applyType=AsCredit.getParameter("ApplyType");
	var   customerID=AsCredit.getParameter("CustomerID");
	if(applyType.indexOf("Ent")==0) applyType="EntDepenApply";//��˾�����ҵ��
	else if(applyType.indexOf("Ind")==0) applyType="IndDepenApply";//���˶����ҵ��
	 sStyle="width=500px,height=500px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	 AsCredit.openFunction("NewApply","customerID="+customerID+"&RelativeApplyNo="+objectNo+"&ApplyType="+applyType,sStyle);
 	reloadSelf();
};
/**
 * �鿴����
 */
relative_apply.viewAndEdit=function(){
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(serialNo)=="undefined" || serialNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	 AsCredit.openFunction("ApplyDetail","ObjectType=CreditApply&ObjectNo="+serialNo);
	reloadSelf();
};

/**
 * ɾ������
 */
relative_apply.deleteRecord=function(){
	var objectNo=getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(!confirm('ȷʵҪɾ����?')) return;
	functionParameters="ObjectType=CreditApply&ObjectNo="+objectNo+"&Action=delete";
	var returnValue = AsCredit.runFunction("BusinessProcess", functionParameters);//AsTask.delRecord(objectNo,"CreditApply");
	var result=returnValue.getResult();
	if(result){
		alert("ɾ���ɹ���");
		reloadSelf();
	}else{
		alert("ɾ��ʧ�ܣ�");
	}
};