
/*�鿴���������������*/
function viewApproveInfo(){
	var objectType = "ApproveApply";
	var objectNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(objectNo)=="undefined" || objectNo.length==0)
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
 	var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo;
	AsCredit.openFunction("ApproveFinalDetail",paramString); 
	
}

/*�ǼǺ�ͬ*/
function BookInContract(){
	//������������,��������������,���ڶ����Ч�Լ��
	var objectType = "ApproveApply";//��������
	var serialNo = getItemValue(0,getRow(),"SerialNo");
	var applyType = getItemValue(0,getRow(),"ApplyType");//��������
	var occurType = getItemValue(0,getRow(),"OccurType");
	if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	} 
	
	//ҵ����ռ��
	var riskResult = autoRiskScan("010","OccurType="+occurType+"&ApplyType="+applyType+"&ObjectType="+objectType+"&ObjectNo="+serialNo);
	if(riskResult != true){
		return;
	}
	
	if(!confirm("��ȷ��Ҫ����ѡ�еĵ���������������ǼǺ�ͬ�� \n\rȷ���󽫸�����������������ɺ�ͬ��")){
		return;
	}

	var result = AsCredit.runFunction("ApplyFinish","ObjectNo="+serialNo+"&ObjectType="+objectType+"&NewObjectType=BusinessContract");
	var message = result.getOutputParameter("message");
	alert(message);
	var contractNo = result.getOutputParameter("NewObjectNo");
    
	var paramString = "ObjectType=BusinessContract&ObjectNo="+contractNo;
	AsCredit.openFunction("ContractDetail", paramString);
	reloadSelf();
}