var AsContract={
		
};

//���ҵ�����
function riskSkan(){
	//����������͡�������ˮ��
	//var objectNo = AsCredit.getParameter("ObjectNo");
	//var objectType = AsCredit.getParameter("ObjectType");

	//���з�������̽��
	//return autoRiskScan("010","ObjectType="+objectType+"&ObjectNo="+objectNo, "");
	return true;
}

//��ӡ���Ӻ�ͬ
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
		if(confirm("�Ƿ��������ɵ��Ӻ�ͬ��"))
			printSerialNo = RunJavaMethodTrans("com.amarsoft.app.als.edoc.EContractSevice", "updateEdocPrint", param);
	}
	OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+printSerialNo,"_blank","");
	top.close();
}

//��ȡƾ֤ģ���
function getEdocNo(objectNo, objectType){
	return "AAA";
}

//�鵵
function archive(){
	var objectNo = AsCredit.getParameter("ObjectNo");
	var objectType = AsCredit.getParameter("ObjectType");
	
	result = PopPageAjax("/Common/WorkFlow/AddPigeonholeActionAjax.jsp?ObjectType="+objectType+"&ObjectNo="+objectNo,"","");
	if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn!="failed"){
		alert(getBusinessMessage('422'));//�ñʺ�ͬ�Ѿ���Ϊ��ɷŴ���
		top.reloadSelf();
	} else {
		top.close();
	}
}

//ȡ���鵵
function cancelarchive(){
	var objectNo = AsCredit.getParameter("ObjectNo");
	if(confirm(getHtmlMessage('58'))){ //ȡ���鵵����
		result = RunMethod("BusinessManage","CancelArchiveBusiness",objectNo+",BUSINESS_CONTRACT");
		if(typeof(result)=="undefined" || result.length==0) {					
			alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
			return;
		}else{
			alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			top.close();
		}
	}
}
