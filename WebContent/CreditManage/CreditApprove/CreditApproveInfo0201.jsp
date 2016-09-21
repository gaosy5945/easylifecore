<%@page import="com.amarsoft.app.als.sys.widget.DwTempTools"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialno");
    String flowNo = CurPage.getParameter("FlowNo");
    String flowVersion = CurPage.getParameter("FlowVersion");
    String phaseNo = CurPage.getParameter("PhaseNo");
    String objectType = "RectifyDemandExplain";
    
    String phaseName = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("PhaseName");
    String templateNo = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("OpnTemplateNo");
    
    String userId = CurUser.getUserID();
    String userName = CurUser.getUserName();
    String orgId = CurUser.getOrgID();
    String orgName = CurUser.getOrgName();
   
	ASObjectModel doTemp = new ASObjectModel("RiskWarningOpinionInfo02");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);

	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);
	//整改落实情况附件
	dwTemp.replaceColumn("ATTACHMENT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"430\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {

	};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function hide(){
		AsCredit.hideOWGroupItem("0030");
		AsCredit.hideOWGroupItem("0040");
	}
	
	/*~[Describe=打开附件页面;InputParam=无;OutPutParam=无;]~*/
	function openDoc(){
		OpenComp("DocumentList","/Common/BusinessObject/BusinessObjectDocumentList.jsp","ObjectType=<%=objectType%>&RightType=ReadOnly&ObjectNo=<%=taskSerialNo%>","frame_list","");
	}
	
	$(document).ready(function(){
		if(getRowCount(0)==0){
			setItemValue(0,0,"TASKSERIALNO","<%=taskSerialNo%>"); 
			setItemValue(0,0,"USERID","<%=userId%>");
			setItemValue(0,0,"USERNAME","<%=userName%>");
			setItemValue(0,0,"ORGID","<%=orgId%>");
			setItemValue(0,0,"ORGNAME","<%=orgName%>");
			setItemValue(0,0,"PHASENO","<%=phaseNo%>");
			setItemValue(0,0,"PHASENAME","<%=phaseName%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
		}

		openDoc();
		hide();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
