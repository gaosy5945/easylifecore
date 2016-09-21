function closeTabFunction(itemID,itemName){
	if(confirm("х╥хои╬ЁЩ"))
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.DeletePutOut", "deletePutOut", "SerialNo=" + itemID);
	else
		return false;
}