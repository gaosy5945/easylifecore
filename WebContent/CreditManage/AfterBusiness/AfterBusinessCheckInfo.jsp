<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String creditInspectType = CurPage.getParameter("CreditInspectType");
	String serialNo = CurPage.getParameter("SerialNo");
	String projectType = CurPage.getParameter("ProjectType");
	String ObjectNo=CurPage.getParameter("ObjectNo");
	String PutOutDate=CurPage.getParameter("PutOutDate");
	String RightType=CurPage.getParameter("RightType");
	String CustomerID=CurPage.getParameter("CustomerID");

	
	if(projectType == null) projectType = "";
	if(serialNo == null) serialNo = "";
	if(ObjectNo==null) ObjectNo="";
	if(PutOutDate==null) PutOutDate="";
	if(CustomerID==null) CustomerID="";
	if(RightType==null) RightType="";
	String userId = CurUser.getUserID();
	String OperateDate = DateHelper.getBusinessDate().toString();
	
	String templateNo = "";
	if("01".equals(creditInspectType)){
		templateNo = "AfterBusinessCheckInfo";
	}else if("02".equals(creditInspectType)){
		templateNo = "AfterBusinessCheckInfo1";
	}else{
		templateNo = "AfterLoanCheckInfo1";
	}
	String sTempletNo = templateNo;//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	if("01".equals(creditInspectType)){
		dwTemp.replaceColumn("AccountInfo", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("OrderInfo", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list1\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("Alert", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list6\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("ReCovery", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list7\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("History", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list8\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	}else if("02".equals(creditInspectType)){
		dwTemp.replaceColumn("Report", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list3\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("Alert", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list6\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("ReCovery", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list7\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("History", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list8\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		//dwTemp.replaceColumn("OrderInfo1", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list4\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	}else{
		dwTemp.replaceColumn("LoanInfo", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list5\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
		dwTemp.replaceColumn("Report", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list4\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	}
	
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		{"false","All","Button","发起预警","发起预警","warn()","","","",""},
		{"true","All","Button","完成","完成","finish()","","","",""},
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	var serialNo="<%=serialNo%>";
	var ObjectNo="<%=ObjectNo%>";
	var PutOutDate="<%=PutOutDate%>";
	var RightType="<%=RightType%>";
	var creditInspectType="<%=creditInspectType%>";
	var CustomerID="<%=CustomerID%>";
	if(creditInspectType=='01'){
		//AsControl.OpenPage("/CreditManage/AfterBusiness/AfterAccountList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&PutOutDate="+PutOutDate+"&RightType="+RightType+"&ObjectType=jbo.app.BUSINESS_DUEBILL"+"&creditInspectType="+creditInspectType,"frame_list");
		AsControl.OpenPage("/CreditManage/AfterBusiness/SelectPayMessageInfo.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&PutOutDate="+PutOutDate+"&RightType="+RightType+"&ObjectType=jbo.app.BUSINESS_DUEBILL"+"&creditInspectType="+creditInspectType,"frame_list1");	
		AsControl.OpenPage("/CreditManage/AfterBusiness/RiskWarningList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list6");
		AsControl.OpenPage("/CreditManage/AfterBusiness/CollTaskList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list7");
		AsControl.OpenPage("/CreditManage/AfterBusiness/InspectRecordList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL&ButtonShowFlag=0","frame_list8");
	}else if(creditInspectType=='02'){
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=AfterLoanReport","frame_list3");
		AsControl.OpenPage("/CreditManage/AfterBusiness/RiskWarningList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list6");
		AsControl.OpenPage("/CreditManage/AfterBusiness/CollTaskList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list7");
		AsControl.OpenPage("/CreditManage/AfterBusiness/InspectRecordList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL&ButtonShowFlag=0","frame_list8");
		//AsControl.OpenPage("/CreditManage/AfterBusiness/AfterAccountList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&PutOutDate="+PutOutDate+"&RightType="+RightType+"&ObjectType=jbo.app.BUSINESS_DUEBILL"+"&creditInspectType="+creditInspectType,"frame_list3");
		//AsControl.OpenPage("/Blank.jsp","","frame_list4");	
	}else{
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanBDList.jsp","CustomerID="+CustomerID+"&RightType="+RightType+"&ObjectNo="+ObjectNo,"frame_list5");
		//modified by jqliang
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.prj.PRJ_BASIC_INFO","frame_list4");
	}
	function insert(){
		var inspectAction = getItemValue(0, getRow(0), "InspectAction");
		if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
			{
			//setItemValue(0, 0, "InspectAction", "01");
			hideItem("myiframe0","OperateDate");
			setItemRequired("myiframe0","OperateDate",false);
		}
	}
	function save(){
		as_save(0);
	}
	function finish(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var ObjectNo = "<%=ObjectNo%>";
		var status = getItemValue(0, getRow(0), "Status");
		var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		var creditInspectType = "<%=creditInspectType%>";
		var orgID = "<%=CurUser.getOrgID()%>";
		var userID = "<%=CurUser.getUserID()%>";
		var projectType = "<%=projectType%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0 )
		{
			alert("参数不能为空！");
			return ;
		}
		if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
		{
			alert("请填写检查结论！");
			return ;
		}
		var isUp = "";
		if(creditInspectType=="02" ||creditInspectType=="05" || creditInspectType=="06"){
			isUp = AsControl.RunASMethod("AfterBusiness","CheckOperateLoanRelative",ObjectNo+","+creditInspectType+","+inspectAction);
		}
		if(isUp=="true"){
			var sAlertConfirm="";
			if(creditInspectType=="02"){
				sAlertConfirm="该类型的资金用途检查，需要提交上级审查";
			}else if(creditInspectType=="05"){
				sAlertConfirm="该类型的合作项目检查，需提交上级审查！";
			}else{
				sAlertConfirm="该类型的合作方检查，需提交上级审查！";
			}
			if(!confirm(sAlertConfirm))return;
			save();
			var returnValue = AsControl.RunASMethod("AfterBusiness","AfterBusinessCheckInfo","Apply65"+creditInspectType+","+serialNo+","+creditInspectType+","+userID+","+orgID);
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
				}
			}
				
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
			{
				return;
			}
			else
			{
				if(returnValue.split("@")[0] == "true")
				{
					AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord","finishInspectRecord","SerialNo="+serialNo+",Status=0");
					top.close();
				}
			}
			return;
		}else{
			if(confirm('确实要完成检查吗?')){
				setItemValue(0, getRow(0), "UpdateDate", "<%=DateHelper.getBusinessDate()%>");
				save();
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertInspectRecord","finishInspectRecord","SerialNo="+serialNo+",Status="+status);
				alert("检查完成！");
				top.close();
			}
		}
		
	}
	function warn(){
		alert("待实现");
		return;
	}
	function ChangeAction(){
		var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		if(inspectAction == "05" || inspectAction == "06"){
			showItem("myiframe0","OperateDate");
			setItemRequired("myiframe0","OperateDate",true);
		}else{
			hideItem("myiframe0","OperateDate");
			setItemRequired("myiframe0","OperateDate",false);
		}
	}
	
	$(document).ready(function(){
		insert();
		ChangeAction();
		
		//设置默认值
		setItemValue(0,0,"OPERATEUSERID",'<%=userId%>');
		setItemValue(0,0,"UPDATEDATE",'<%=OperateDate%>');
		hideItem("myiframe0","IsToRiskManager");
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
