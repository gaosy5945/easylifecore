/**
 * �绰�˲�����¼���������ύ
 */

function submitTask(objectType,objectNo,todoType){
	if(confirm('ȷʵҪ�ύ��?')){
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.AcquireTodoTask",
				"submitTask", "ObjectType="+objectType+",ObjectNo="+objectNo+",TodoType="+todoType);
		top.close();
	}
	
}