var AsApply={
		
};
 
/**
 * �ύ���ܣ�
 */
AsApply.doSubmit=function(sObjectNo){
	var objectType="CreditApply";
		//���з�������̽��
	var sReturn = autoRiskScan("001","ObjectType="+objectType+"&ObjectNo="+sObjectNo,"20");
	if(sReturn != true){
		return;
	}
	 vReturn=AsCredit.runFunction("QuickApplyAction","objectType="+objectType+"&ObjectNo="+sObjectNo);
	 sReturn=vReturn.getResult();
	 if(!sReturn){
		 alert("���̳�ʼ��ʧ��,����ԭ��["+sReturn+"]");
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
  * ɾ������
  */
AsApply.deleteRecord=function(){
	if(!confirm('ȷʵҪɾ����?')) return;
	var objectNo=getItemValue(0,getRow(),"SerialNo");
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

 function newApply(){
	 sStyle="width=500px,height=500px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	 AsCredit.openFunction("NewApply","ApplyType="+AsCredit.parameter["ApplyType"],sStyle);
	reloadSelf();
 }
 
 /**
  * �����µ�����
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
		alert("����ʧ��:"+vResult.toString());
	}
	//AsControl.OpenObjectTab(sParamString);
 };
 /**
  * �����һ�׶�������Ϣ
  * @param objectNo
  * @param objectType
  * @returns
  */
 AsApply:getNextBusinessInfo=function(objectNo, objectType){
	 return AsTask.getNextBusinessInfo(objectNo, objectType); 
 };
 /**
  * �ύ����
  */
 function viewDetail(){
 	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	var sParamString = "ObjectType=CreditApply&ObjectNo="+sObjectNo;
	AsCredit.openFunction("ApplyDetail",sParamString);
	reloadSelf();		
 };
  