function add(){
		menuId=FunctionLibraryFunctions.getFunctionParameter("MenuID");
		 AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","MenuID="+menuId,"");
		 reloadSelf();
	};
	
	function copy(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var result = RunJavaMethodTrans("com.amarsoft.app.als.sys.function.action.SysFunctionService", "copyFunctionConfig", "FunctionID="+functionID);
		if(result == "false"){
			alert("�Ѵ��ڸ�����Ϣ��");
		} else {
			alert("���Ƴɹ���FunctionIDΪCopyOf"+functionID);
		}
		reloadSelf();
	};
	
	function edit(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID="+functionID,'','');
		reloadSelf();
	};
