/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
	
}



/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//������¼
	}
}