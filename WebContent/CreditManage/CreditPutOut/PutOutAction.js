function closeTabFunction(itemID,itemName){
	if(confirm("ȷ��ɾ��"))
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.DeletePutOut", "deletePutOut", "SerialNo=" + itemID);
	else
		return false;
}