<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
//获取前端传入的参数
	String flowNo =  DataConvert.toString(CurPage.getParameter("FlowNo"));
	if(flowNo==null||flowNo.length()==0)flowNo="";
	
	String status = DataConvert.toString(CurPage.getParameter("Status"));
	if(status==null||status.length()==0)status="";

	String sTempletNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo="";
	
	String applyType = DataConvert.toString(CurPage.getParameter("ApplyType"));
	if(applyType==null||applyType.length()==0)applyType="";
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);//"RiskWarningPointList"
	if("3".equals(status)){
		doTemp.appendJboWhere("Status = '3'");
	}else if("4".equals(status)){
		doTemp.appendJboWhere("Status = '4'");
	}else if("2".equals(status)){
		doTemp.appendJboWhere("Status = '2'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.MultiSelect = true; 	 //允许多选
	dwTemp.ReadOnly = "1";	 	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
    
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","风险提示详情","风险提示详情","edit()","","","","",""},
			{("2".equals(status) ? "true" : "false"),"","Button","收回","收回","takeBack()","","","","",""},
			/* {("1".equals(status))?"true":"false","","Button","再次发起","再次发起风险预警","addRiskPoint()","","","","",""}, */
		};
	
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function takeBack(){
		var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
		var taskSerialNo = flowSerialNo+"0001";
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(!confirm("确定收回该任务？")) return;
		//调用收回接口
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","TakeBack","<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+taskSerialNo+","+flowSerialNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
		else
		{
			var rwSerialNo = getItemValue(0,getRow(),"SERIALNO");
			AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningThreeSubmitDeal", "updateThreeWarningSubmitStatus", "SerialNo="+rwSerialNo+",Status=1");
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
	} 
	function addRiskPoint(signalType){
		 var ySerialNos = getItemValue(0, getRow(0), "SerialNo");
		 
		 AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.StartRiskWarningPoint", "reRunRiskPoint", "FlowNo=<%=flowNo%>"+",ApplyType=<%=applyType%>"+",riskSignalSerialNoString="+ySerialNos);
		 reloadSelf();
	}
	
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 var status = "<%=status%>";
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("参数不能为空！");
			return ;
		 }
		 if(status =="3"){
			 AsCredit.openFunction("AddRiskPoint05","SerialNo="+serialNo);
		 }else{
			AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningPointInfo.jsp","SerialNo="+serialNo+"&RightType2=ReadOnly","_blank");
		 }
	}
	
	function updateSignalStatus(status){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		alert(sSerialNo);
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var num = AsControl.RunASMethod("RiskWarningManage","UpdateSignalStatus",sSerialNo+","+status);
		
       	if(num>0){
       		alert("提交成功！");
       	}else
       	{
       		alert("提交失败！");
       	}
       	reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
