///Accounting/js/transaction/Inter-bankPayment_Apply.js
var InterbankPayment={
		
};

/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
function newRecord()
{
	AsCredit.openFunction("Inter-bankPaymentInfo","Type=0");
	reloadSelf();
/*	popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","Type=0","");
	reloadSelf();*/
}

/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
function view()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo"); //�ʺ���ˮ��
	var sStatus = getItemValue(0,getRow(),"Status"); //�˻�״̬
	if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	}else
	{
		AsCredit.openFunction("Inter-bankPaymentInfo","SerialNo="+sSerialNo);
		reloadSelf();
	}
}

/**
 * ȡ����������
 */
function cancelApply(){
	//����������͡�������ˮ��
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(confirm(getHtmlMessage('70'))){
		as_delete(0,'','delete');
		as_do(0,'','save');  //�������ɾ������Ҫ���ô����
	}   //!!���⣺�޷�ɾ����ACCT_TRANSACTION�еļ�¼
	reloadSelf();//����������ȡ��ʱ����
}

/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
function doSubmit()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert("��ѡ��һ����¼��");
		return;
	}
	
	var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",02");
	if(parseInt(sReturn) == 1)
	{
		alert("�ύ�ɹ���");
		reloadSelf();
	}
}

/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
function doBack()
{
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert("��ѡ��һ����¼��");
		return;
	}
	
	var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",04");
	if(parseInt(sReturn) == 1)
	{
		alert("�ύ�ɹ���");
		reloadSelf();
	}
}

/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
function saveRecord(){
	if(!iV_all("0")) return;
	as_save("0","afterSave()");
}


