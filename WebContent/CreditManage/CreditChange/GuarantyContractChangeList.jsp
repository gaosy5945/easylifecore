<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"  %>
<%@ page import="com.amarsoft.dict.als.object.Item"  %>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	String flowFlag = CurPage.getParameter("FlowFlag");
	String taskType = CurPage.getParameter("TaskType");
	String transCode = CurPage.getParameter("TransCode");
	
	Item changeCode = CodeCache.getItem("ChangeCode", transCode);
	String selectCode = changeCode.getAttribute2();
	if(selectCode==null)selectCode="";

	ASObjectModel doTemp = new ASObjectModel("GuarantyContractChangeList");	
	
	doTemp.appendJboWhere(" and AT.TransStatus in ('"+transStatus.replaceAll(",", "','")+"')");
	doTemp.appendJboWhere(" and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.orgid='"+CurUser.getOrgID()+"' and OB.belongorgID=AT.InputOrgID)");
	if("0".equals(transStatus)||"1,2,3,4".equals(transStatus)){
		doTemp.appendJboWhere(" and AT.InputUserID = '"+CurUser.getUserID()+"' ");
	}else if("1,2,3".equals(transStatus)){
		doTemp.appendJboWhere(" and GCC.ApproveUserID = '"+CurUser.getUserID()+"' ");
	}
	
	doTemp.setJboOrder(" AT.INPUTTIME ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	//dwTemp.setParameter("TransCode",transCode );
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{("0".equals(transStatus)&&"1".equals(taskType))?"true":"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
		{("0".equals(transStatus)&&"1".equals(taskType))?"true":"false","All","Button","删除","删除","cancel()","","","","btn_icon_delete",""},
		{("0".equals(transStatus)&&"1".equals(taskType))?"true":"false","All","Button","提交","提交","updateTransStatus('4');","","","","",""},
		{("1,2,3,4".equals(transStatus)&&"2".equals(taskType))?"true":"false","All","Button","收回","收回","updateTransStatus('0');","","","","",""},
		{("4".equals(transStatus)&&"1".equals(taskType))?"true":"false","All","Button","提交","提交执行交易","runTransaction();","","","","",""},
		{("4".equals(transStatus)&&"1".equals(taskType))?"true":"false","All","Button","退回","退回","updateTransStatus('0');","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var userID = "<%=CurUser.getUserID()%>";
		var orgID = "<%=CurUser.getOrgID()%>";
		var sStyle = "dialogWidth:700px;dialogHeight:500px;resizable:yes;scrollbars:no;status:no;help:no";
		
		sReturn = AsDialog.SelectGridValue("<%=selectCode%>",orgID,'serialNo@customerId','','',sStyle,'','1');
    	if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CLEAR_") return;
    	else{
    		var serialNo = sReturn.split("@")[0];
    		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "createTransaction", "GCSerialNo="+serialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,TransCode=<%=transCode%>");
    		if(typeof(returnValue) == "undefined" || returnValue.length == 0)  return;
    		var returns = returnValue.split("@");
    		var transactionSerialNo = returns[0];
    		var serialNo = returns[1];
    		var guarantorID = returns[2];
    		var guarantyType = returns[3];
    		var gcSerialNo = returns[4];
	    	AsCredit.openFunction("CeilingGCChangeTab","ObjectNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&GCSerialNo="+gcSerialNo+"&transSerialNo="+transactionSerialNo);
	    	reloadSelf();
    	}
	}
	
	
	function submit(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm('确实要提交吗?'))return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","sumbit","TransactionSerialNo="+transSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,ApplyType=<%=applyType%>");
		if(returnValue != null && returnValue !=""){
			var returnValue1 = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.ChangeHelper","presumbit","TransactionSerialNo="+transSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,ApplyType=<%=applyType%>");
			
			var flag = returnValue1.split("@")[0];
			var functionID = returnValue1.split("@")[1];
			var flowSerialNo = returnValue1.split("@")[2];
			var taskSerialNo = returnValue1.split("@")[3];
			var phaseNo = returnValue1.split("@")[4];
			var msg = returnValue1.split("@")[5];
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") {
				return;
			}
		}
		reloadSelf();
	}
	function cancel(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
		if(!confirm('确实要删除吗?')) return;	
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "deleteTransaction", "TransactionSerialNo="+transSerialNo);
		if("true"==returnValue){
			alert("删除成功！");
		}else{
			alert(returnValue);
		}
		
		reloadSelf();
	}
	
	function takeBack(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var taskSerialNo = getItemValue(0,getRow(0),"CORERETURNSERIALNO");
		var userID = "<%=CurUser.getUserID()%>";
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		if(!confirm("确定收回该任务？")) return;
		//调用收回接口
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterLoanTakeBack","back","TransSerialNo="+transSerialNo+",TaskSerialNo="+taskSerialNo+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	}
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"DocumentObjectNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var guarantorID=getItemValue(0,getRow(),"GuarantorID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			guarantorID = "";
		}
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var gcSerialNo=getItemValue(0,getRow(),"RelativeObjectNo");
		var rightType = "ReadOnly";
		if("1"=="<%=taskType%>"){
			rightType="All";
		}
		AsCredit.openFunction("CeilingGCChangeTab", "ObjectNo="+serialNo+"&GuarantyType="+guarantyType+"&GuarantorID="+guarantorID+"&GCSerialNo="+gcSerialNo+"&RightType="+rightType);
		reloadSelf();
	}
	
	function updateTransStatus(transStatus){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		var transStatusTmp = getItemValue(0,getRow(0),"TRANSSTATUS");
		if("1"==transStatusTmp){
			alert("所选交易已经执行，不能进行收回操作！");
			return
		}
			
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "updateTransStatus", "TransactionSerialNo="+transSerialNo+",TransStatus="+transStatus);
		if("true"==returnValue){
			var parameter = "执行成功！";
			if("4"==transStatus){
				parameter = "提交审查岗成功！";
			}else if("0"==transStatus){
				if("1"=="<%=taskType%>"){
					parameter = "退回成功！";
				}else{
					parameter = "收回成功！";
				}
			}
			alert(parameter);
		}else{
			alert(returnValue);
		}
		
		reloadSelf();
	}
	
	function runTransaction(){
		var transSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(transSerialNo)=="undefined" || transSerialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}		
			
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "finish", "TransactionSerialNo="+transSerialNo+",ApproveUserID=<%=CurUser.getUserID()%>");
		if("true"==returnValue){
			alert("执行成功！");
		}else{
			alert(returnValue);
		}
		
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
