<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
    String flowNo = CurPage.getParameter("FlowNo");
    String flowVersion = CurPage.getParameter("FlowVersion");
    String phaseNo = CurPage.getParameter("PhaseNo");
    String approveType = CurPage.getParameter("ApproveType");
    if(approveType == null) approveType = "";
    String rightType = CurPage.getParameter("RightType");
    if(rightType == null) rightType = "";
    String objectType = "RectifyDemandExplain";
    
    String phaseName = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("PhaseName");
    //String templateNo = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("OpnTemplateNo");
    
    String userId = CurUser.getUserID();
    String userName = CurUser.getUserName();
    String orgId = CurUser.getOrgID();
    String orgName = CurUser.getOrgName();
   
    if(flowSerialNo == null) flowSerialNo = "";
   
    
	ASObjectModel doTemp = new ASObjectModel("RiskWarningOpinionInfo02");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	//dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow("");
	//整改落实情况附件
	dwTemp.replaceColumn("ATTACHMENT", "<iframe type='iframe' name=\"frame_list1\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""}
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
	function save(){
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.risk.RiskWarningBack", "updateAfterDoFlag", "FLOWSERIALNO=<%=flowSerialNo%>,TASKSERIALNO=<%=taskSerialNo%>");
		as_save("myiframe0","reloadPage()");
	}
	function reloadPage(){
		//var flowVersion = "1.0.0";
		AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo02.jsp", 
				"FlowSerialNo=<%=flowSerialNo%>&TaskSerialNo=<%=taskSerialNo%>&FlowNo=<%=flowNo%>&PhaseNo=<%=phaseNo%>&SerialNo=<%=serialNo%>&FlowVersion=<%=flowVersion%>",
				"_self", "");
	}
	
	/*~[Describe=打开附件页面;InputParam=无;OutPutParam=无;]~*/
	function openDoc(){
		var taskSerialno = getItemValue(0,0,"TASKSERIALNO"); 
		OpenComp("DocumentList","/Common/BusinessObject/BusinessObjectDocumentList.jsp","ObjectType=<%=objectType%>&RightType=<%=rightType%>&ObjectNo="+taskSerialno,"frame_list1","");
	}
	
	$(document).ready(function(){
		//if(getRowCount(0)==0){
			setItemValue(0,0,"TASKSERIALNO",getSerialNo("FLOW_TASK", "TASKSERIALNO", "")); 
			setItemValue(0,0,"FLOWSERIALNO","<%=flowSerialNo%>");
			setItemValue(0,0,"USERID","<%=userId%>");
			setItemValue(0,0,"USERNAME","<%=userName%>");
			setItemValue(0,0,"ORGID","<%=orgId%>");
			setItemValue(0,0,"ORGNAME","<%=orgName%>");
			setItemValue(0,0,"PHASENO","<%=phaseNo%>");
			setItemValue(0,0,"PHASENAME","<%=phaseName%>");
			setItemValue(0,0,"PHASENAME","<%=phaseName%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		//}

		openDoc();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
