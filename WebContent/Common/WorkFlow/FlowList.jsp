<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	/**
	*该页面只负责流程及业务信息显示，不负责业务逻辑处理或校验；
	*请喜欢写js校验的同志高台贵手，该页面高度公用，小心踩着地雷哦
	*
	*author:赵晓建  2014/11/04
	*/
	//获取前端传入的参数
	String isShowOpinion = DataConvert.toString(CurPage.getParameter("IsShowOpinion"));//流程流转信息是否显示意见列
	if(isShowOpinion == null) isShowOpinion = "";
	String flowType = DataConvert.toString(CurPage.getParameter("FlowType"));//流程类型
	String phaseType = DataConvert.toString(CurPage.getParameter("PhaseType"));//阶段类型，支持多个
	String buttonSet = DataConvert.toString(CurPage.getParameter("ButtonSet"));//使用按钮集合代码
	String buttonFilter = DataConvert.toString(CurPage.getParameter("ButtonFilter"));//使用按钮筛选条件
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//对象类型，支持多个
	String queryType = DataConvert.toString(CurPage.getParameter("QueryType"));//查询类型
	String addFunctionID = DataConvert.toString(CurPage.getParameter("AddFunctionID"));//新增调用的FunctionID
	String applyType = DataConvert.toString(CurPage.getParameter("ApplyType"));//申请类型
	String OlPcsFlag = DataConvert.toString(CurPage.getParameter("OlPcsFlag"));//是否在途中 
	if(OlPcsFlag == null) OlPcsFlag = "";
	String multiSelectFlag = DataConvert.toString(CurPage.getParameter("MultiSelectFlag"));//是否可以多选 
	//初始化模板路径
	CurConfig = Configure.getInstance();
	if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
	String realPrepath = CurConfig.getParameter("FileSavePath")+"/AfterLoanReport/";
	
	String templateNo = CurPage.getParameter("TemplateNo");//模板号
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templateNo, inputParameter, CurPage, request);
	if(multiSelectFlag !=null && "Y".equals(multiSelectFlag))
		dwTemp.MultiSelect = true;
	ASDataObject doTemp = dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.workflow.web.FlowTaskBusinessProcessor");
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow("");
	
	//按钮定义
	String sButtons[][]={};
	com.amarsoft.dict.als.object.Item[] its = com.amarsoft.dict.als.cache.CodeCache.getItems(buttonSet);
	if(its != null){
		sButtons = new String[its.length][10];
		for(int i = 0; i < its.length; i ++){
			sButtons[i][0] = (buttonFilter+",").indexOf(its[i].getItemNo()+",") > -1 ? "true" : "false";
			sButtons[i][1] = DataConvert.toString(its[i].getAttribute1());
			sButtons[i][2] = DataConvert.toString(its[i].getAttribute2());
			sButtons[i][3] = DataConvert.toString(its[i].getItemName());
			sButtons[i][4] = DataConvert.toString(its[i].getItemDescribe());
			sButtons[i][5] = DataConvert.toString(its[i].getRelativeCode());
			sButtons[i][6] = "";
			sButtons[i][7] = "";
			sButtons[i][8] = "";
			sButtons[i][9] = "";
		}
	}
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script language=javascript>
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function add(){
		var functionID = "<%=addFunctionID%>";
		var applyType = "<%=applyType%>";
		if(typeof(functionID) == "undefined" || functionID.length == 0) return;
		var style = "";
		if(applyType == "Apply02")
			style = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
		else if(applyType == "Apply05" || applyType == "Apply06")
			style = "dialogWidth:800px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		else if(applyType == "Apply20")
			style = "dialogWidth:460px;dialogHeight:300px;resizable:yes;scrollbars:no;status:no;help:no";
		else if(applyType == "Apply101")
			style = "dialogWidth:1000px;dialogHeight:7000px;resizable:yes;scrollbars:no;status:no;help:no";
		else if(functionID == "AddLimitTodo")
			style = "dialogWidth:400px;dialogHeight:250px;resizable:yes;scrollbars:no;status:no;help:no";
		else
			style = "dialogWidth:500px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var returnValue = AsCredit.openFunction(functionID, "ApplyType=<%=applyType%>",style);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null"){
			reloadSelf();
			return;
		}
		if(returnValue.split("@")[0] == "true")
		{
			var taskSerialNo = returnValue.split("@")[1];
			var flowSerialNo = returnValue.split("@")[2];
			var phaseNo = returnValue.split("@")[3];
			var functionID = returnValue.split("@")[4];
			AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);
			//reloadSelf();
		}
		reloadSelf();
	}
	
	
	function addTransaction(){
		var transactionDate="";
		<%
		String transactionFilter = CurPage.getParameter("TransactionFilter");
		%>
		var transactionCode = "<%=transactionFilter%>";
		//var returnValue1 = setTransactionCodeValue(transactionCode,"",0,0,""); 
		
		var returnCode=AsCredit.selectJavaMethodTree('com.amarsoft.app.als.ui.treeview.XMLDataTree',{'XMLFile':'{$ARE.PRD_HOME}/etc/app/transaction-config.xml','XMLTags':'TransactionConfig||TransactionCode in(\''+transactionCode+'\') ','Keys':'TransactionCode','ID':'TransactionCode','Name':'TransactionName','SortNo':'TransactionCode'},'','N');
		if(!returnCode||returnCode["ID"] == "_CANCEL_") return ;
		transactionCode=returnCode["ID"];

		var relativeObjectNo = "";
		var reverseSerialNo = "";
		var transObjectSelector = AsControl.RunJavaMethod("com.amarsoft.app.base.config.impl.TransactionConfig","getTransactionConfig","transactionCode="+transactionCode+",attributeID=SelectCode");
		var reverseTransactionCode = AsControl.RunJavaMethod("com.amarsoft.app.base.config.impl.TransactionConfig","getTransactionConfig","transactionCode="+transactionCode+",attributeID=ReverseTransactionCode");
		var relativeObjectType = AsControl.RunJavaMethod("com.amarsoft.app.base.config.impl.TransactionConfig","getTransactionConfig","transactionCode="+transactionCode+",attributeID=RelativeObjectType");
		if(typeof(transObjectSelector) == "undefined" || transObjectSelector.length == 0){
			return;
		}
		else{
			var para ;
			if(typeof(reverseTransactionCode) == "undefined" || reverseTransactionCode.length == 0)
			{
				para = "<%=CurUser.getOrgID()%>";
			}
			else
			{
				para = "<%=CurUser.getOrgID()%>,"+reverseTransactionCode;
			}
			var returnValue = AsDialog.SelectGridValue(transObjectSelector,para,"SERIALNO",null,false);
			if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_" || returnValue == null){
				return;
			}
			if(typeof(reverseTransactionCode) == "undefined" || reverseTransactionCode.length == 0 || reverseTransactionCode == null)
			{
				relativeObjectNo = returnValue;
			}else if(transactionCode=="4001" && reverseTransactionCode=="1001")
			{
				var result = AsControl.RunJavaMethod("com.amarsoft.acct.accounting.web.GetRepaymentTrans","GetRepaymentTrans","reverseSerialNo="+returnValue);
				if(result == "false"){
					alert("有未反冲的还款/提前还款交易,无法做放款反冲,请先将还款反冲!")
					return;
				}
				reverseSerialNo = returnValue;
			}
			else{
				reverseSerialNo = returnValue;
			}
		}
		
		// 控制交易申请但未执行成功的各种交易不能重复申请
		var allowApplyFlag = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.GetAllowApplyFlag","getAllowApplyFlag","transactionCode="+transactionCode+",relativeObjectNo="+relativeObjectNo+",relativeObjectType="+relativeObjectType+",ReverseSerialNo="+reverseSerialNo);
		if(allowApplyFlag != "true")
		{
			alert("该业务已经存在一笔未生效的交易记录，不允许同时申请！");
			return;
		}
		//创建一笔交易，并返回交易的流水号
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.acct.accounting.web.CreateTransaction","createTransaction","ApplyType=<%=applyType%>,TransactionCode="+transactionCode+",RelativeObjectType="+relativeObjectType+",RelativeObjectNo="+relativeObjectNo+",ReverseSerialNo="+reverseSerialNo+",TransactionDate="+transactionDate+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue == null || returnValue.length ==0) return;
		else(returnValue.split("@")[0] =="true")
		{
			var taskSerialNo = returnValue.split("@")[1];
			var flowSerialNo = returnValue.split("@")[2];
			var phaseNo = returnValue.split("@")[3];
			var functionID = returnValue.split("@")[4];
			AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);
		}
		reloadSelf();
	}
	
	
	
	/*~[Describe=新增预警;]~*/
	function addRisk(signalType){
		
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
        var result = "";
        if(<%=CurUser.hasRole("PLBS0018")%>){//风险监控岗
	        result = AsDialog.SelectGridValue("SelectLoanByOrgID","<%=CurUser.getOrgID()%>","SERIALNO","",true,sStyle,"","1");
		}else{
			result = AsDialog.SelectGridValue("SelectLoanByUserID","<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>","SERIALNO","",true,sStyle,"","1");
		}
        if(!result || result == "_CANCEL_" || result == "_CLEAR_"
        	||typeof(result) == "undefined" || result.length == 0 )
			return ;
		
		AsControl.RunASMethod("RiskWarningManage","StartRiskWarning",result+","+signalType+",<%=CurUser.getUserID()%>,<%=applyType%>,<%=CurPage.getParameter("FlowNo")%>");
		reloadSelf();
	}
	
	function addPLRisk(signalType){
			
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
        var result = AsDialog.SelectGridValue('SelectLoanByRisk00011',"<%=CurUser.getOrgID()%>",'SerialNo','',true,sStyle);
        if(!result || result == "_CANCEL_" || result == "_CLEAR_")
			return ;
		AsControl.RunASMethod("RiskWarningManage","StartPLRiskWarning",result+","+signalType+",<%=CurUser.getUserID()%>,<%=applyType%>,<%=CurPage.getParameter("FlowNo")%>");
		reloadSelf();
	}
	
	/*~[Describe=取消预警;]~*/
	function cancelRisk(signalType){
		var result = "";
		var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
		if(<%=CurUser.hasRole("PLBS0018")%>){//风险监控岗
	        result = AsDialog.SelectGridValue('SelectLoanByRisk01',"<%=CurUser.getOrgID()%>",'SERIALNO','',true,sStyle,'','1');
		}else{
			result = AsDialog.SelectGridValue('SelectLoanByRisk02',"<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle,'','1');
		}
        if(!result || result == "_CANCEL_" || result == "_CLEAR_")
			return ;
		
		AsControl.RunASMethod("RiskWarningManage","StartRiskWarning",result+","+signalType+",<%=CurUser.getUserID()%>,<%=applyType%>,<%=CurPage.getParameter("FlowNo")%>");
		reloadSelf();
	}
	
	/*~[Describe=新增预警提示;]~*/
	function addRiskPoint(signalType){
		
		 var ySerialNos = getItemValue(0, 0, "SerialNo");
		
		 AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.StartRiskWarningPoint", "reRunRiskPoint", "riskSignalSerialNoString="+ySerialNos);
		 reloadSelf();
	}
	
	/*~[Describe=新增放款申请;InputParam=无;OutPutParam=无;]~*/
	function addPutout(){
		var applyType = "<%=applyType%>";
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurUser.getOrgID()%>";
		var sStyle = "dialogWidth:700px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		sReturn = AsDialog.SetGridValue('SelectContractInfo',userID,'serialNo@customerId','',sStyle);
    	if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CLEAR_") return;
		var SerialNo = sReturn.split("@")[0];
		var returnValue = AsControl.RunASMethod("BusinessManage","InitPutOutInfo",SerialNo+","+applyType+","+userID+","+orgID);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue.indexOf("@") == -1){
			return;
		}else{
			if(returnValue.split("@")[0] == "true"){
				var serialNo = returnValue.split("@")[1];
				var functionID = returnValue.split("@")[2];
				var flowSerialNo = returnValue.split("@")[3];
				var taskSerialNo = returnValue.split("@")[4];
				var phaseNo = returnValue.split("@")[5];
				var msg = returnValue.split("@")[6];
				alert(msg);
				AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);			
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=新增批量放款申请;InputParam=无;OutPutParam=无;]~*/
	function addBatchPutout(){
		
		
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.acct.accounting.web.AddBatchApply","add","ApplyType=<%=applyType%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,FlowNo=<%=CurPage.getParameter("FlowNo")%>,TransactionCode=<%=CurPage.getParameter("TransactionCode")%>,BatchType=<%=CurPage.getParameter("BatchType")%>");
		if(typeof(returnValue) == "undefined" || returnValue == null || returnValue.length ==0) return;
		else(returnValue.split("@")[0] =="true")
		{
			var taskSerialNo = returnValue.split("@")[1];
			var flowSerialNo = returnValue.split("@")[2];
			var phaseNo = returnValue.split("@")[3];
			var functionID = returnValue.split("@")[4];
			AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);
		}
		reloadSelf();
	}
	
	/*~[Describe=新增项目变更申请;InputParam=无;OutPutParam=无;]~*/
	function addProjectChange(){
		var applyType = "<%=applyType%>";
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurUser.getOrgID()%>";
		var sStyle = "dialogWidth:700px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		sReturn = AsDialog.SetGridValue('ProjectTransferList',userID,'serialNo','',sStyle);
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CLEAR_") return;
		var SerialNo = sReturn.split("@")[0];
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CopyProjectData","copyProjectData","serialNo="+SerialNo+",applyType="+applyType+",userID="+userID+",orgID="+orgID);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue.indexOf("@") == -1){
			return;
		}else{
			if(returnValue.split("@")[0] == "true"){
				var serialNo = returnValue.split("@")[1];
				var functionID = returnValue.split("@")[2];
				var flowSerialNo = returnValue.split("@")[3];
				var taskSerialNo = returnValue.split("@")[4];
				var phaseNo = returnValue.split("@")[5];
				var msg = returnValue.split("@")[6];
				alert(msg);
				AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);			
				reloadSelf();
			}
		}
	}	
	
	/*~[Describe=新增押品估值申请;InputParam=无;OutPutParam=无;]~*/
	function addAssetEva(){
		var returnValue = AsDialog.SelectGridValue('CollateralToEvaList',"<%=CurUser.getOrgID()%>",'SerialNo@AssetSerialNo','',false);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue.indexOf("@") == -1){
			return;
		}else{
			var serialNo = returnValue.split("@")[0];
			var assetSerialNo = returnValue.split("@")[1];
		}
        var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEva1","AssetSerialNo="+assetSerialNo);
		if(assetEvaParams == "false") {
			alert("该押品有未完成的估值任务");
			return;
		}
		var rv = AsCredit.openFunction("CollateralEvaluate","SerialNo="+serialNo);
		//var rv = AsControl.PopComp("/BusinessManage/GuarantyManage/CollateralEvaluate.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo, "dialogWidth=600px;dialogHeight=260px;resizable=yes;scrollbars:no;status:no;help:no");
		
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEva","AssetSerialNo="+assetSerialNo);
		assetEvaParams = assetEvaParams.split("@");
		
		if(assetEvaParams[0] == "false" || rv == "4") {
			return;
		}
			
		//window.showModalDialog("/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+assetEvaParams[2]+"&pstnType=1&viewMode=0&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");
		
		reloadSelf();
	}
	
	/*~[Describe=编辑押品估值申请;InputParam=无;OutPutParam=无;]~*/
	function dealAssetEva(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEva","AssetSerialNo="+assetSerialNo);
		assetEvaParams = assetEvaParams.split("@");
		var pstnType = "1";
		if("<%=phaseType%>"=="0030"){
			pstnType = "3";
		}
		else if("<%=phaseType%>"=="0020"){
			pstnType = "2";
		}
		else{}
		//window.showModalDialog("/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+assetEvaParams[2]+"&pstnType="+pstnType+"&viewMode=0&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");

	}
	
	/*~[Describe=查看押品估值申请;InputParam=无;OutPutParam=无;]~*/
	function viewAssetEva(){
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEva","AssetSerialNo="+assetSerialNo);
		assetEvaParams = assetEvaParams.split("@");
		var pstnType = "1";
		if("<%=phaseType%>"=="0030"){
			pstnType = "3";
		}
		else if("<%=phaseType%>"=="0020"){
			pstnType = "2";
		}
		else{}
		//window.showModalDialog("/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+assetEvaParams[2]+"&pstnType="+pstnType+"&viewMode=1&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;");

	}
	
	/*~[Describe=提交押品估值申请;InputParam=无;OutPutParam=无;]~*/
	function submitAssetEva(){
		if(!confirm("确认提交该笔估值任务？")) return;
		var phaseNo = getItemValue(0,getRow(),"PhaseNo");
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		
		//信息完整性校验**************Start************************************************
		var cmisApplyNo = getItemValue(0,getRow(),"CMISApplyNo");//申请号
		var EstDestType = getItemValue(0,getRow(),"EvaluateScenario");//评估目的类型  贷前评估、贷后详细、贷后快速、处置前评估
		var EstMthType = getItemValue(0,getRow(),"EvaluateModel");//评估方法类型
		var PrdNo = "1";//阶段类型
		if("<%=phaseType%>"=="0030"){
			PrdNo = "3";
		}
		else if("<%=phaseType%>"=="0020"){
			PrdNo = "2";
		}
		else{}
		var InrExtEstType = getItemValue(0,getRow(),"EvaluateMethod");//内外评
	
		var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck",
				"checkEvaInfo","CMISApplyNo="+cmisApplyNo+",EstDestType="+EstDestType+",EstMthType="+EstMthType
				+",PrdNo="+PrdNo+",InrExtEstType="+InrExtEstType);
		sReturnValue = sReturn.split("@");
		if (sReturnValue[1] == "000000000000") {
			if(sReturnValue[0] != "1") {
				alert("请完整录入价值评估信息后再提交！");
				return; 
			} 
		} else if(sReturnValue[1] == "021200000002") {
			alert("请进行价值评估后再提交！");
			return; 
		} 
		//信息完整性校验**************End**************************************************

		var returnSValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
		//alert(returnSValue);
		if(typeof(returnSValue) == "undefined" || returnSValue.length == 0 || returnSValue == "_NONE_" || returnSValue == "_CLEAR_" || returnSValue == "_CANCEL_" || returnSValue == "false@已取消！" || returnSValue == "false@提交失败！") { 
			return ;
		} 
		
		//更新ASSET_EVALUATE
		if("<%=phaseType%>"=="0030"){
			var getEvaValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck",
					"getEvaValue","CMISApplyNo="+cmisApplyNo+",FlowStatus=1"+",InrExtEstType="+InrExtEstType);
			var assetEvaNo = getItemValue(0,getRow(),"ObjectNo");
			var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.AssetEvaCheck","updateAssetEva","AssetEvaNo="+assetEvaNo+",AssetSerialNo="+assetSerialNo+",ConfirmValue="+getEvaValue+",UserId=<%=CurUser.getUserID()%>,OrgId=<%=CurUser.getOrgID()%>");
			
		}
		reloadSelf();
	}
	
	/*~[Describe=自动获取任务;InputParam=无;OutPutParam=无;]~*/
	function autoQuery(){
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.AutoQueryTask","run","FlowType=<%=flowType.replaceAll(",","@")%>,PhaseType=<%=phaseType.replaceAll(",","@")%>,QueryType=01,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		
		
		if(returnValue.split("@")[0] == "true")
		{
			var taskSerialNo = returnValue.split("@")[2];
			var flowSerialNo = returnValue.split("@")[3];
			var phaseNo = returnValue.split("@")[4];
			var functionID = returnValue.split("@")[5];
			if(typeof(functionID) == "undefined" || functionID.length == 0){
				reloadSelf();
			}
			else
			{
				//打开页面
				AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);
				reloadSelf();
			}
		}
		else
		{
			alert(returnValue.split("@")[1]);
			return;
		}
	}
	
	/*~[Describe=选择任务;InputParam=无;OutPutParam=无;]~*/
	function selectQuery(){
		var returnValue = PopPage("/Common/WorkFlow/SelectFlowTask.jsp?TemplateNo=<%=templateNo%>&FlowType=<%=flowType%>&PhaseType=<%=phaseType%>&QueryType=01&ObjectType=<%=objectType%>","","dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_CANCEL_" || returnValue == "_CLEAR_" || returnValue == null) return;
		
		var TaskSerialNos = returnValue.split("@")[0];
		var taskSerialNos = TaskSerialNos.split("~");
		var FlowSerialNos = returnValue.split("@")[1];
		var flowSerialNos = FlowSerialNos.split("~");
		var PhaseNos = returnValue.split("@")[2];
		var phaseNos = PhaseNos.split("~");
		for(var i in taskSerialNos){
			if(typeof taskSerialNos[i] ==  "string" && taskSerialNos[i].length > 0 ){
				var taskSerialNo = taskSerialNos[i];
				var flowSerialNo = flowSerialNos[i];
				var phaseNo = phaseNos[i];
				var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.GetAvlTask","run","TaskSerialNo="+taskSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
				if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) continue;
				if(returnValue.split("@")[0] == "false"){
					alert(returnValue.split("@")[1]);
					break;
				}
				
				var taskSerialNo = returnValue.split("@")[2];
				var flowSerialNo = returnValue.split("@")[3];
				var phaseNo = returnValue.split("@")[4];
				var functionID = returnValue.split("@")[5];
				if(typeof(functionID) == "undefined" || functionID.length == 0){
					continue;
				}
				else if(taskSerialNos.length <= 2)
				{
					//打开页面
					AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo);
					reloadSelf();
				}
			}
		}
		reloadSelf();
	}

	/*~[Describe=处理;InputParam=无;OutPutParam=无;]~*/
	function deal(){
		todo("All");
	}
	
	/*~[Describe=取消任务;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var objectType = getItemValue(0,getRow(),"ObjectType");
		var objectNo = getItemValue(0,getRow(),"ObjectNo");
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(!confirm("取消申请后不可恢复，请确认！")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.DeleteInstance","run","FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "true")
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
	
	/*~[Describe=详情;InputParam=无;OutPutParam=无;]~*/
	function view(){
		todo("ReadOnly");
	}
	
	/*~[Describe=处理或查看;InputParam=无;OutPutParam=无;]~*/
	function todo(rightType)
	{
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var phaseNo = getItemValue(0,getRow(),"PhaseNo");
		var functionID = getItemValue(0,getRow(),"FunctionID");
		var OlPcsFlag = "<%=OlPcsFlag%>";
		//打开页面
		if(OlPcsFlag == "N"){
			var objectNo = getItemValue(0, getRow(0), "ObjectNo");
			var objectType = getItemValue(0, getRow(0), "ObjectType");
			if(typeof(objectNo) == "undefined" || objectNo.length == 0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			AsCredit.openFunction("ApplyInfo","ObjectNo="+objectNo+"&ObjectType="+objectType+"&RightType=ReadOnly","");
		}else{
			if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			AsCredit.openFunction(functionID,"TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&RightType="+rightType+"&PhaseNo="+phaseNo,"");
		}
		reloadSelf();
	}
	
	/*~[Describe=收回;InputParam=无;OutPutParam=无;]~*/
	function takeBack(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var phaseNo = getItemValue(0,getRow(),"PhaseNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定收回该任务？")) return;
		//调用收回接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.TakeBackTask","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	} 
	/*~[Describe=带有收回原因的收回;InputParam=无;OutPutParam=无;]~*/
	function iftakeBack(){
	    var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
	    var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
	    var phaseNo = getItemValue(0,getRow(),"PhaseNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var returnValue0 = PopPage("/Common/WorkFlow/TakeBackReasonInfo.jsp?TaskSerialNo="+taskSerialNo,"","dialogWidth:400px;dialogHeight:240px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue0) == "undefined" || returnValue0.length == 0 || returnValue0 == "Null" || returnValue0 == "false"){
			return;
		}
		//if(!confirm("确定收回该任务？")) return;
		//调用收回接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.TakeBackTask","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	} 
	/*~[Describe=挂起任务;InputParam=无;OutPutParam=无;]~*/
	function hangUp(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var execTimep = "";
		/*
		var date = PopPage("/Common/WorkFlow/HangUpTaskInfo.jsp?TaskSerialNo="+taskSerialNo,"","dialogWidth:300px;dialogHeight:190px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(date) == "undefined" || date.length == 0 || date == "Null") return;
		execTimep = date.substring(0, 4) + date.substring(5, 7) + date.substring(8, 10)+date.substring(11, 13)+date.substring(14, 16)+"00000";
		var today = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessTime()%>";
		var nowTime = today.substring(0, 4) + today.substring(5, 7) + today.substring(8, 10)+today.substring(11, 13)+today.substring(14, 16)+"00000";
		if(execTimep <= nowTime)
		{
			alert("定时恢复时间不能小于当前时间");return;
		}
		if(!confirm("挂起后的自动恢复时间为：\n"+date+"\n确定挂起该任务？")) return;
		*/
		//调用挂起任务
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.HangUpTask","run","TaskSerialNo="+taskSerialNo+",HangUpTime="+execTimep+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
		}
		reloadSelf();
	}
	
	/*~[Describe=终止任务;InputParam=无;OutPutParam=无;]~*/
	function tmt(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定终止该任务？")) return;
		//调用终止任务
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.FinishInstance","run","FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue==null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=恢复任务;InputParam=无;OutPutParam=无;]~*/
	function resume(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定恢复该任务？")) return;
		//调用恢复任务
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.ResumeTask","run","TaskSerialNo="+taskSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue==null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		} 
	}
	
	/*~[Describe=退回上一步;InputParam=无;OutPutParam=无;]~*/
	function returnToLastMnulAvy(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(0),"FlowSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定将该任务退回到上一步？")) return;
		//调用退回到最近人工活动接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.ReturnToLastMnulAvy","run","TaskSerialNo="+taskSerialNo+",FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	/*~[Describe=带有检查问题的退回上一步;InputParam=无;OutPutParam=无;]~*/
	function toLastMnulAvy(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(0),"FlowSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProblemmust",flowSerialNo);
		if(rValue == "false"){
			var returnValue0 = PopPage("/Common/WorkFlow/ReturnReasonInfo.jsp?TaskSerialNo="+taskSerialNo+"&ObjectNo="+flowSerialNo,"","dialogWidth:400px;dialogHeight:240px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue0) == "undefined" || returnValue0.length == 0 || returnValue0 == "Null" || returnValue0 == "false"){
				return;
			}
		}
		if(!confirm("确定将该任务退回到上一步？")) return;
		//调用退回到最近人工活动接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.ReturnToLastMnulAvy","run","TaskSerialNo="+taskSerialNo+",FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	/*~[Describe=退回任务池;InputParam=无;OutPutParam=无;]~*/
	function retGotTask(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定将该任务退回到任务池？")) return;
		//调用退回已领任务接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.RetGotTask","run","TaskSerialNo="+taskSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	
	/*~[Describe=改派任务;InputParam=无;OutPutParam=无;]~*/
	function reasgnTask(){
		var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var phaseNo = getItemValue(0,getRow(),"PhaseNo");
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var returnValue = PopPage("/Common/WorkFlow/SelectAvyPcpTreeDialog.jsp?FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo,"","dialogWidth:300px;dialogHeight:440px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")
		{
			return;
		}
		
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.ReasgnTask","run","TaskSerialNo="+taskSerialNo+",ReasgnUserID="+returnValue.split("@")[0]+",ReasgnOrgID="+returnValue.split("@")[1]+",Reason=,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	
	/*~[Describe=将选择行的信息拼成字符串并返回，在选择框任务时使用;]~*/	
	function mySelectRow(){
		var taskSerialNo = "";
		var flowSerialNo = "";
		var phaseNo = "";
		var recordArray = getCheckedRows(0);//获取勾选的行
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1){
			for(var i = 1;i <= recordArray.length;i++){
				taskSerialNo += getItemValue(0,recordArray[i-1],"TaskSerialNo")+"~";
				flowSerialNo += getItemValue(0,recordArray[i-1],"FlowSerialNo")+"~";
				phaseNo += getItemValue(0,recordArray[i-1],"PhaseNo")+"~";
			}
		}
		try{parent.objectInfo = taskSerialNo+"@"+flowSerialNo+"@"+phaseNo;}catch(e){}
	}
	
	
	/*~[Describe=流程流转信息;InputParam=无;OutPutParam=无;]~*/
	function taskQry(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var isShowOpinion = "<%=isShowOpinion%>";
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.PopView("/Common/WorkFlow/QueryFlowTaskList.jsp", "FlowSerialNo="+flowSerialNo+"&IsShowOpinion="+isShowOpinion,"dialogWidth:1300px;dialogHeight:590px;");
	}
	/* ~[Describe=风险预警认定意见;InputParam=无;OutPutParam=无;]~ */
	function riskWarningOpinion(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var taskSerialNo = getItemValue(0,getRow(0),'TaskSerialNo');
		var flowSerialNo = getItemValue(0,getRow(0),'FlowSerialNo');
		var PhaseNo = getItemValue(0,getRow(0),'PhaseNo');
		var FlowNo = getItemValue(0,getRow(0),'FlowNo');
		var FlowVersion = getItemValue(0,getRow(0),'FlowVersion');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo.jsp", "FlowSerialNo="+flowSerialNo+"&TaskSerialNo="+taskSerialNo+"&PhaseNo="+PhaseNo+"&FlowNo="+FlowNo+"&FlowVersion="+FlowVersion, "", "");
	}
	
	/*~[Describe=提交;]~*/
	function submit(){
		var flowSerialNo = getItemValue(0,getRow(0),'FlowSerialNo');
		var taskSerialNo = getItemValue(0,getRow(0),'TaskSerialNo');
		var phaseNo = getItemValue(0,getRow(0),"PhaseNo");
		sbmt(flowSerialNo,taskSerialNo,phaseNo);
	}
	/*~[Describe=业务受理批量导入;]~*/
	function batchImport(){
		var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
		var ApplyType= '<%=applyType%>';
		var parameter = "";
		if(ApplyType == "Apply03"){
			parameter = "clazz=jbo.import.excel.CREDIT_CL_INFO&UserId="+'<%=CurUser.getUserID()%>'+"&OrgId="+'<%=CurOrg.getOrgID()%>';
		}else{
			parameter = "clazz=jbo.import.excel.CREDIT_LOAN&UserId="+'<%=CurUser.getUserID()%>'+"&OrgId="+'<%=CurOrg.getOrgID()%>'+"&ApplyType="+ApplyType;
		}
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
	//风险预警提示，任务转发 按钮
	function giveOut(){
		var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	    AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningGiveOutInfo.jsp", "SerialNo="+serialNo, "_blank");
	    reloadSelf();
	}
	function print(){
		var BusinessType = getItemValue(0,getRow(0),'BusinessType');
		var objectNo = getItemValue(0,getRow(0),'ObjectNo');
		var objectType = getItemValue(0,getRow(0),'ObjectType');
		if(typeof(objectNo) == "undefined" || objectNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("基础产品为空！");//基础产品不能为空！
			return;
		} 
		if(objectType !=  'jbo.app.BUSINESS_APPLY'){
			alert("对象类型要关联申请信息方可打印！");
			return;
		} 
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+objectNo);//消费类贷款审批意见表
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+objectNo,"_blank");//经营类贷款审批意见表
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+objectNo,"_blank");//个人授信额度贷款审批意见表
		}
		
	}
	/*~[Describe=查看已完成项目详情;InputParam=无;OutPutParam=无;]~*/
	function viewFinishedProject()
	{
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var OlPcsFlag = "<%=OlPcsFlag%>";
		//打开页面
		if(OlPcsFlag == "N"){
			var objectNo = getItemValue(0, getRow(0), "ObjectNo");
			var projectType = getItemValue(0, getRow(0), "PROJECTTYPE");
			var functionID = getItemValue(0, getRow(0), "FUNCTIONID");
			if(typeof(objectNo) == "undefined" || objectNo.length == 0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			AsCredit.openFunction(functionID,"SerialNo="+objectNo+"&flowSerialNo="+flowSerialNo+"&ProjectType="+projectType+"&RightType=ReadOnly","");
		}
		reloadSelf();
	}
	
	//风险预警提示反馈
    function DocumentDownLoad(){
      as_fileDownload("<%=realPrepath%>"); 
    }
     
     function as_fileDownload(fileName){
       
       var sReturn = fileName+"risk.xlsx";
          if(sReturn && sReturn!=""){
             var sFormName="form"+AsControl.randomNumber();
           var form = document.createElement("form");
		   		form.setAttribute("method", "post");
		   		form.setAttribute("name", sFormName);
		   		form.setAttribute("id", sFormName);
		   		form.setAttribute("action", sWebRootPath + "/servlet/view/file?CompClientID=<%=sCompClientID%>");
		   		document.body.appendChild(form);
		   		var sHTML = "";
		   		//sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file > ";
		   		sHTML+="<div style='display:none'>";
		   		sHTML+="<input name=filename value='"+sReturn+"' >";
		   		sHTML+="<input name=contenttype value='unknown'>";
		   		sHTML+="<input name=viewtype value='unkown'>";
		   		sHTML+="</div>";
		   		//sHTML+="</form>";
		   		form.innerHTML=sHTML;
		   		form.submit();		
	   	   }
	   }
     
     function afterLoanTransView(){
		 var transSerialNo = getItemValue(0,getRow(),"ObjectNo");
		 if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		 }
		 AsCredit.openFunction("PostLoanChangeTabNew","TransSerialNo="+transSerialNo+"&RightType=ReadOnly");
		 reloadSelf();
     }
     
     /*~[Describe=风险分类进度查询详情;InputParam=无;OutPutParam=无;]~*/
    function viewClassify(){
 		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
 		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		//打开页面
		var objectNo = getItemValue(0, getRow(0), "ObjectNo");
		var objectType = getItemValue(0, getRow(0), "ObjectType");
		var showFlag = '1';
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsCredit.openFunction("ClassifyApprove01","ObjectNo="+objectNo+"ObjectType="+objectType+
				"&ShowFlag="+showFlag+"&FlowSerialNo="+flowSerialNo+"&SerialNo="+serialNo+"&RightType=ReadOnly","");
		reloadSelf();
 	}
     
 	 //预警详情
    function viewRiskWarning(){
		var serialNo = getItemValue(0,getRow(),"ObjectNo");
		var duebillSerialNo = getItemValue(0,getRow(),"DUEBILLSERIALNO");
		var contractSerialno = getItemValue(0,getRow(),"CONTRACTSERIALNO");
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getYRiskSerialNo", "SerialNo="+serialNo);
		AsCredit.openFunction("RiskWarningDetailInfo","SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialno="+contractSerialno+"&ObjectType=jbo.al.RISK_WARNING_SIGNAL&ObjectNo="+serialNo+"&YSerialNo="+result+"&CustomerID="+customerID+"&SignalType=01&RightType=ReadOnly");
		reloadSelf();
	}
	</script>

<script type="text/javascript" src="<%=sWebRootPath%>/Common/WorkFlow/flow.js"> </script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>