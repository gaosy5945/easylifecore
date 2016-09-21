<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%
    String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
    String flowNo = CurPage.getParameter("FlowNo");
    String flowVersion = CurPage.getParameter("FlowVersion");
    String phaseNo = CurPage.getParameter("PhaseNo");
    String approveType = CurPage.getParameter("ApproveType");
    if(approveType == null) approveType = "";
    String rightType = CurPage.getParameter("RightType");
    if(rightType == null) rightType = "";    
    String finalFlag = CurPage.getParameter("FinalFlag");//终审意见标志
    if(finalFlag == null) finalFlag = "";
    String flowType = com.amarsoft.app.workflow.config.FlowConfig.getFlowCatalog(flowNo, flowVersion).getString("FlowType");
    String phaseName = com.amarsoft.app.workflow.config.FlowConfig.getFlowPhase(flowNo,flowVersion,phaseNo).getString("PhaseName");
    String templateNo = com.amarsoft.app.workflow.config.FlowConfig.getFlowPhase(flowNo,flowVersion,phaseNo).getString("OpnTemplateNo");
    String userId = CurUser.getUserID();
    String userName = CurUser.getUserName();
    String orgId = CurUser.getOrgID();
    String orgName = CurUser.getOrgName();
   
    if(flowSerialNo == null) flowSerialNo = "";
   
    
    BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templateNo, inputParameter, CurPage, request);//new ASObjectWindow(CurPage,doTemp,request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		{("0010".equals(flowType) ? "true" : "false"),"","Button","意见附件","意见附件","upload()","","","",""}
	};
	//风险分类
	String classifyMethod ="",adjustedGrade="";
	if ("RiskClassify".equals(approveType)){
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		ASValuePool para = new ASValuePool();
		para.setAttribute("FlowSerialNo",flowSerialNo);
		List<BusinessObject> alList = bom.loadBusinessObjects("jbo.al.CLASSIFY_RECORD","SerialNo in (select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo=:FlowSerialNo)", para);
		if(alList != null){
			for(BusinessObject al:alList){
				classifyMethod = al.getString("CLASSIFYMETHOD");
				adjustedGrade = al.getString("ADJUSTEDGRADE");
			}
		}		
	}

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	
	function upload(){
		AsControl.PopView("/Common/BusinessObject/BusinessObjectDocumentList.jsp", "ObjectType=jbo.flow.FLOW_TASK&ObjectNo=<%=taskSerialNo%>&RightType=<%=rightType%>");
	}
	function checkOtherPersion(){
		var phaseAction = getItemValue(0, getRow(0), "PHASEACTION");
		if(phaseAction == "32"){
			
			var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.IfHasOtherPersion","run","FlowSerialNo=<%=flowSerialNo%>,TaskSerialNo=<%=taskSerialNo%>,PhaseNo=<%=phaseNo%>,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
			if(returnValue.split("@")[0] == "1"){
				alert("本机构存在有权审批人，请确认是否要直接提交到上级机构？");
			}
			if(returnValue.split("@")[1] == "1"){
				alert("该笔贷款审批模式为组合审批，请选择继续提交至本机构其他审批人!")
				setItemValue(0, getRow(0), "PHASEACTION", "");
			}
		}
	}
	function save(){
		setItemValue(0,0,"INPUTDATE", "<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,0,"INPUTTIME", "<%=DateHelper.getBusinessTime()%>");
		setItemValue(0,0,"UPDATETIME", "<%=DateHelper.getBusinessDate()+" "+DateX.format(new java.util.Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT)%>");
		as_save(0);
	}
	
	function opinion(){
		var approveType = "<%=approveType%>";	
		var workTemplateType = getItemValue(0,getRow(),"WorkTemplateType");
		var phaseAction = getItemValue(0,getRow(),"PHASEACTIONTYPE");
		if(workTemplateType == '01')
		{
			if(phaseAction == '01') {
				AsCredit.showOWGroupItem("0020");
				<%-- AsCredit.openFunction("SignBApproveInfo","TaskSerialNo=<%=taskSerialNo%>&FlowSerialNo=<%=flowSerialNo%>&RightType=<%=rightType%>","","rightdown"); --%>
			}
			else
			{
				AsCredit.hideOWGroupItem("0020");
				/* AsControl.OpenView("/Blank.jsp","","rightdown",""); */
			}
		}
		if(rightType == "ReadOnly") return;
		
		if (approveType == "RiskClassify"){
			setItemValue(0,0,"PHASEACTION","<%=classifyMethod%>");
			setItemValue(0,0,"PHASEACTION1","<%=adjustedGrade%>");
		}	
		
		if(phaseAction == '01'){
			setItemRequired(0,"PhaseOpinion",false);
		}
		else{
			setItemRequired(0,"PhaseOpinion",true);
		}
	}
	
	function setTempValues(){
		if(rightType == "ReadOnly") return;
		var result01 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskWarningManagement", "getDealMethod", "FlowSerialNo=<%=flowSerialNo%>");
		if(result01=="null"){
			result01 = "";
		} 
		setItemValue(0,getRow(0),"DEALMETHOD",result01);
	}
	
	function onChangePhaseAction(){
		var phaseAction = getItemValue(0,getRow(),"PHASEACTIONTYPE");		
		if(phaseAction == '01'){
			setItemRequired(0,"PhaseOpinion",false);
		}
		else{
			setItemRequired(0,"PhaseOpinion",true);
		}
	}
	
	//当三级审查岗选择 “跳过分行审查岗 ”时 ，“是否行使行长知情权否决权 ”才为必输项 ，否则应为非必输项
	function setPhaseAction0203(){
		var phaseAction1 = getItemValue(0,getRow(),"PHASEACTION1");		
		if(phaseAction1 == '52'){
			setItemRequired("myiframe0","PHASEACTION2",true);
			showItem(0,"PHASEACTION2");
		}
		else if(phaseAction1 == '51'){
			setItemRequired("myiframe0","PHASEACTION2",false);
			hideItem(0,"PHASEACTION2");
		}
	}
	
	
	function initRow(){
		var flowNo = "<%=flowNo%>";
		if(flowNo != "S0215.plbs_cooperation.Flow_015"){
			opinion();	
		}
		if(flowNo=="S0215.plbs_afterloan04.Flow_013"||flowNo =="S0215.plbs_afterloan04.Flow_014"){
			setTempValues();
		}
	}
	function initPahseActionType(){
		if(rightType == "ReadOnly") return;
		var templateNo = "<%=templateNo%>";
		var workTempLateType = getItemValue(0, getRow(0), "workTempLateType");
		var PhaseOpinion = getItemValue(0, getRow(0), "PhaseOpinion");
		var phaseActionType = getItemValue(0, getRow(0), "PhaseActionType");
	    var phaseActionTypes = AsControl.RunASMethod("WorkFlowEngine","SetPhaseActionType","<%=flowSerialNo%>,<%=phaseNo%>");
		if(workTempLateType == "01" && phaseActionTypes.split("@")[1] != "false" && PhaseOpinion == ""){
			setItemValue(0, getRow(0), "PhaseOpinion", phaseActionTypes.split("@")[1]);
		}
		if(templateNo == "CreditApproveInfo0300" || templateNo == "ChangeApproveInfo0300"){
			 setItemValue(0, getRow(0), "PhaseActionType", phaseActionTypes.split("@")[0]);
		}else if(templateNo == "CreditApproveInfoIsKnow" || templateNo == "ChangeApproveInfoIsKnow"){
			setItemValue(0, getRow(0), "PhaseActionType", phaseActionTypes.split("@")[0]);
			if(phaseActionTypes.split("@")[0] == "03"){
				setItemDisabled(0,0, "PhaseActionType", true);
			}
		}
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckIsCallGrade","<%=flowSerialNo%>,<%=phaseNo%>,<%=taskSerialNo%>");
		if(rValue == "true" && phaseActionType != ""){
			//setItemDisabled(0,0, "PHASEACTION1", true);
			//setItemDisabled(0,0, "PHASEACTION", true);
			//setItemDisabled(0,0, "PHASEACTION2", true);
			setItemDisabled(0,0, "PhaseActionType", true);
		}
	}
	//项目审批流程签署意见专用，勿动
	function isSbmtBossBank(){
		var phaseAction = getItemValue(0,getRow(0),"PhaseActionType");
		if(phaseAction == "02"){
			hideItem(0,"PHASEACTION1");
			setItemValue(0,getRow(),"PHASEACTION1","");
		}else{
			showItem(0,"PHASEACTION1");
		}
	}
	//项目审批流程签署意见专用，勿动
	function isSbmtHigherBank(){
		var phaseAction = getItemValue(0,getRow(0),"PhaseActionType");
		if(phaseAction == "02"){
			hideItem(0,"PHASEACTION");
			setItemValue(0,getRow(),"PHASEACTION","");
		}else{
			showItem(0,"PHASEACTION");
		}
	}
	
	$(document).ready(function(){
		setItemValue(0,0,"TASKSERIALNO","<%=taskSerialNo%>");
		setItemValue(0,0,"FLOWSERIALNO","<%=flowSerialNo%>");
		setItemValue(0,0,"PHASENO","<%=phaseNo%>");
		setItemValue(0,0,"PHASENAME","<%=phaseName%>");
		if("<%=finalFlag%>"=="1"){
			hideItem(0, "USERNAME");
			setItemHeader(0,0,"ORGNAME", "终批机构");
		}
		initPahseActionType();
		initRow();
		setPhaseAction0203();
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
