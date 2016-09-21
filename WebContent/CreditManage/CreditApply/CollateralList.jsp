<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "抵质押物列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String serialNo = CurPage.getParameter("GCSerialNo");
	if(serialNo == null) serialNo = "";
	String vouchType = CurPage.getParameter("VouchType");
	if(vouchType == null) vouchType = "02010";
	String changeFlag = CurPage.getParameter("ChangeFlag");
	if(changeFlag == null) changeFlag = "";
	String transSerialNo = CurPage.getParameter("TransSerialNo"); //变更总交易流水号	
	if(transSerialNo == null) transSerialNo = "";
	String objectType =  CurComp.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo"); 
	if(objectNo == null) objectNo = "";
	String contractStatus =  CurPage.getParameter("CStatus");
	if(contractStatus == null) contractStatus = "";
	String contractType = CurPage.getParameter("ContractType"); 
	if(contractType == null) contractType = "";
	String mode = CurPage.getParameter("Mode"); 
	if(mode == null) mode = "";
	String rightType = CurPage.getParameter("RightType");
	if(rightType == null) rightType = "";
	
	ASObjectModel doTemp = new ASObjectModel("CollateralList");
	if(vouchType.startsWith("020")){
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "抵押物编号");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "抵押物名称");
	}
	else{
		doTemp.setColumnAttribute("AssetSerialNo", "ColHeader", "质押物编号");
		doTemp.setColumnAttribute("AssetName", "ColHeader", "质押物名称");
	}
	if(!"".equals(changeFlag))
		doTemp.setVisible( "ChangeFlag", true);
	
	if(("02".equals(contractStatus) && "020".equals(contractType)) || mode.equals("ReadOnly")){//最高额已生效时或查询模式
		doTemp.setVisible( "Status", true);
	}else if("jbo.app.BUSINESS_CONTRACT".equals(objectType)&&"ReadOnly".equals(rightType)){
		doTemp.setVisible( "Status", true);
	}
	
	//最高额担保合同管理查询模式，将详情押品信息置为只读。
	if("ReadOnly".equals(mode)){
		rightType = mode;
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(100);
	dwTemp.setParameter("GCSerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","All","Button","新增抵押物","新增抵押物","newRecord()","","","",""},
			{"false","All","Button","引入抵押物","引入抵押物","importColl()","","","",""},
			{"true","","Button","详情","查看详情","viewAndEdit()","","","",""},
			{"true","All","Button","删除","删除信息","deleteRecord()","","","",""},
			{"false","All","Button","删除","删除信息","deleteChange()","","","",""},
	};
	if(vouchType.startsWith("040")){
		sButtons[0][3] = "新增质押物";
		sButtons[0][4] = "新增质押物";
		sButtons[1][3] = "引入质押物";
		sButtons[1][4] = "引入质押物";
	}
	if(changeFlag.indexOf("新增")>=0 || changeFlag.indexOf("原记录")>=0){
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
	}
	if(("02".equals(contractStatus) && "020".equals(contractType)) || mode.equals("ReadOnly")){//最高额已生效时或查询模式
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
	}
	
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newRecord(){
		var returnValue = null;
		<%-- if("<%=vouchType%>".substring(0,3) == "020"){//抵押
			returnValue = selectObjectValue("SelectAssetType1","CodeNo,AssetType","",0,0,"");
		} --%>
		if("<%=vouchType%>" == "02010"){//房地产抵押
			returnValue = selectObjectValue("SelectAssetType11","CodeNo,AssetType","");
		}
		else if("<%=vouchType%>" == "02060"){//其他抵押
			returnValue = selectObjectValue("SelectAssetType12","CodeNo,AssetType","");
		}
		else if("<%=vouchType%>".substring(0,3) == "040"){//质押
			returnValue = selectObjectValue("SelectAssetType2","CodeNo,AssetType","");
		}
		else{}
		//var returnValue = selectObjectValue("SelectAssetType","CodeNo,AssetType","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")  return;
		var assetType = returnValue.split("@")[0];
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置"+returnValue[1]+"的模板！");
			return;
		}
		AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo=&GCSerialNo=<%=serialNo%>&VouchType=<%=vouchType%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ObjNo=<%=objectNo%>&ObjType=<%=objectType%>&ChangeFlag=<%=changeFlag%>&ParentTransSerialNo=<%=transSerialNo%>&TemplateNo="+templateNo[1]+"&AssetType="+assetType+"&Mode=1", "");
		reloadSelf();
	}
	
	function importColl(){
		var assetSource = "SelectAsset";
		if("<%=vouchType%>".substring(0,3) == "020"){
			assetSource = "SelectAsset1";//抵押物
		}
		else if("<%=vouchType%>" == "040"){
			assetSource = "SelectAsset2";//质押物
		}
		else{}
		var returnValue =AsDialog.SelectGridValue(assetSource, "", "SERIALNO@ASSETTYPE@ASSETNAME@ASSETSTATUS@CONFIRMVALUE", "", false);
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		var parameter = returnValue.split("@");
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+parameter[1]);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置"+returnValue[1]+"的模板！");
			return;
		}
		var sReturn =AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo=&GCSerialNo=<%=serialNo%>"+
				"&VouchType=<%=vouchType%>&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&ChangeFlag=<%=changeFlag%>"+
				"&ParentTransSerialNo=<%=transSerialNo%>&TemplateNo="+templateNo[1]+"&AssetType="+parameter[1]+"&AssetSerialNo="+parameter[0], "");
		//if(typeof(sReturn) == "undefined" || sReturn.length == 0)  return;
		reloadSelf();
	}
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");	
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var assetType=getItemValue(0,getRow(),"AssetType");	
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置"+returnValue[1]+"的模板！");
			return;
		}
		var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
		<%-- AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&VouchType=<%=vouchType%>&TemplateNo="+templateNo[1], ""); --%>
		AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&GCSerialNo=<%=serialNo%>&TemplateNo="+templateNo[1]+"&Mode=1&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType=<%=rightType%>");
		reloadSelf();
	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			return ;
		}
		as_delete('0','');
	}

	function deleteChange(){	
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(!confirm('确实要删除吗?')) return;			
		var gcSerialNo = "<%=serialNo%>";
		var objectNo = "<%=objectNo%>";
		var objectType = "jbo.app.BUSINESS_CONTRACT";
		var documentObjectNo = getItemValue(0,getRow(),"AssetSerialNo");//取新增抵质押物流水号
		var parentTransSerialNo = "<%=transSerialNo%>";
		var documentObjectType ="jbo.app.ASSET_INFO";
		var changeAssetFlag = getItemValue(0,getRow(),"ChangeFlag");
		if(changeAssetFlag == "原记录"){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003004,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
			reloadSelf();
		}else if(changeAssetFlag.indexOf("新增") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",GCSerialNo="+gcSerialNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003003,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);	
			reloadSelf();
		}else if(changeAssetFlag.indexOf("减少") >=0){
			var para = "ObjectType="+objectType+",ObjectNo="+objectNo+",DocumentObjectType="+documentObjectType+",DocumentObjectNo="+documentObjectNo+",TransSerialNo="+parentTransSerialNo+",TransCode=003004,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
			alert(result);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=取消任务;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEvaInfo","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("没有估值任务");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
					"delEva","SerialNo="+assetSerialNo);
			
			alert("任务取消成功!");
			return;
		}
		
		if(!confirm("取消申请后不可恢复，请确认！")) return;
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","DeleteBusiness",flowSerialNo);
	
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue == "true")
		{
			alert("任务取消成功!");
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
	
	function taskQry(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "viewEva","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("没有估值任务");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			alert("您还没有提交评估!");
			return;
		}
		
		
		AsControl.PopView("/Common/WorkFlow/QueryFlowTaskList.jsp", "FlowSerialNo="+flowSerialNo,"dialogWidth:1300px;dialogHeight:590px;");
	}
	
	function updateEva(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck","updateInfoEva","SerialNo="+assetSerialNo);
		if(sReturn=="false") {
			alert("您还没有估值！");
			return;
		}else if(sReturn=="") {
			alert("估值任务还未结束！");
			return;
		}else {
			alert("更新成功！");
		}
		
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 