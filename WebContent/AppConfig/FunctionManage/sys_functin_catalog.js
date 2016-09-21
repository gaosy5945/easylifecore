function add(){
		menuId=FunctionLibraryFunctions.getFunctionParameter("MenuID");
		 AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","MenuID="+menuId,"");
		 reloadSelf();
	};
	
	function copy(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var result = RunJavaMethodTrans("com.amarsoft.app.als.sys.function.action.SysFunctionService", "copyFunctionConfig", "FunctionID="+functionID);
		if(result == "false"){
			alert("已存在复制信息！");
		} else {
			alert("复制成功，FunctionID为CopyOf"+functionID);
		}
		reloadSelf();
	};
	
	function edit(){
		var functionID = getItemValue(0,getRow(),"FunctionID");		
		if (typeof(functionID)=="undefined" || functionID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopComp("/AppConfig/FunctionManage/FunctionCatalogInfo.jsp","FunctionID="+functionID,'','');
		reloadSelf();
	};
