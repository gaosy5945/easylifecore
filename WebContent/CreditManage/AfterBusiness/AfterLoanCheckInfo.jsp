<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%
	String creditInspectType = CurPage.getParameter("CreditInspectType");
	String ObjectNo = CurPage.getParameter("ObjectNo");
 	String serialNo = CurPage.getParameter("SerialNo");
 	String ObjectType = CurPage.getParameter("ObjectType");
 	String CustomerID= CurPage.getParameter("CustomerID");
 	String RightType = CurPage.getParameter("RightType");
	if(serialNo == null) serialNo = "";
	if(ObjectNo==null) ObjectNo="";
	if(ObjectType==null) ObjectType="";
	if(CustomerID==null) CustomerID="";
	String sTempletNo = "AfterLoanCheckInfo";//--模板号--
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SERIALNO", serialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo, inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","save()","","","",""},
			{"false","All","Button","发起预警","发起预警","warn()","","","",""},
			{"true","All","Button","完成","完成","finish()","","","",""},
		};
	sButtonPosition = "North";
	dwTemp.replaceColumn("Report", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("Alert", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list1\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("ReCovery", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list2\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("History", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list3\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());

	
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function insert(){
		var inspectAction = getItemValue(0, getRow(0), "InspectAction");
		if(typeof(inspectAction)=="undefined" || inspectAction.length==0 )
		{
			//setItemValue(0, 0, "InspectAction", "01");
			hideItem("myiframe0","IsToRiskManager");
			setItemRequired("myiframe0","IsToRiskManager",false);
		}
	}
	var serialNo="<%=serialNo%>";
	var ObjectNo="<%=ObjectNo%>";
	var CustomerID="<%=CustomerID%>";

	function save(){
		as_save(0);
	}
	
	function finish(){
		as_save(0);
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		var ObjectNo = "<%=ObjectNo%>";
		var status = getItemValue(0, getRow(0), "Status");
		var inspectAction = getItemValue(0, getRow(0),"InspectAction");
		var creditInspectType = "<%=creditInspectType%>";
		var orgID = "<%=CurUser.getOrgID()%>";
		var userID = "<%=CurUser.getUserID()%>";
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
		if(creditInspectType=="03"){
			isUp = AsControl.RunASMethod("AfterBusiness","CheckOperateLoanRelative",ObjectNo+","+creditInspectType);
		}
		if(creditInspectType == "03" && isUp=="true"){
			if(!confirm('该贷款出现违约情况，需提交上级审查！'))return;
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
		if(inspectAction == "01"){
			hideItem("myiframe0","IsToRiskManager");
			setItemRequired("myiframe0","IsToRiskManager",false);
		}else{
			setItemValue(0, 0, "IsToRiskManager", "1");
			showItem("myiframe0","IsToRiskManager");
			setItemRequired("myiframe0","IsToRiskManager",true);
		}
	}
	$(document).ready(function(){
		insert();
		
		AsControl.OpenPage("/CreditManage/AfterBusiness/AfterLoanDocumentList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list");
		AsControl.OpenPage("/CreditManage/AfterBusiness/RiskWarningList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list1");
		AsControl.OpenPage("/CreditManage/AfterBusiness/CollTaskList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list2");
		AsControl.OpenPage("/CreditManage/AfterBusiness/InspectRecordList.jsp","SerialNo="+serialNo+"&ObjectNo="+ObjectNo+"&CustomerID="+CustomerID+"&ObjectType=jbo.app.BUSINESS_DUEBILL","frame_list3");
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
