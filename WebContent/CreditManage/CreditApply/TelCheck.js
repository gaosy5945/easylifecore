/**
 * 电话核查任务、录入抽检任务提交
 */

function submitTask(objectType,objectNo,todoType){
	if(confirm('确实要提交吗?')){
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.AcquireTodoTask",
				"submitTask", "ObjectType="+objectType+",ObjectNo="+objectNo+",TodoType="+todoType);
		top.close();
	}
	
}