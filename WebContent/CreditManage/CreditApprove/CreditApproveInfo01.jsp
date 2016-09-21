<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
    String flowSerialNo = CurPage.getParameter("FlowSerialNo");
    String taskSerialNo = CurPage.getParameter("TaskSerialNo");
    String objectNo = CurPage.getParameter("ObjectNo");
    String objectType = CurPage.getParameter("ObjectType");
    String flowNo = CurPage.getParameter("FlowNo");
    String flowVersion = CurPage.getParameter("FlowVersion");
    String phaseNo = CurPage.getParameter("PhaseNo");
    String phaseName = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("PhaseName");
    String templateNo = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("OpnTemplateNo");

    String userId = CurUser.getUserID();
    String userName = CurUser.getUserName();
    String orgId = CurUser.getOrgID();
    String orgName = CurUser.getOrgName();

    if(flowSerialNo == null) flowSerialNo = "";
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";

 

    ASObjectModel doTemp = new ASObjectModel(templateNo);

    ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
    dwTemp.Style = "2";//freeform
    dwTemp.ReadOnly = "0";//只读模式
    dwTemp.setParameter("ObjectType", objectType);
    dwTemp.setParameter("ObjectNo", objectNo);
    dwTemp.setParameter("FlowSerialNo", flowSerialNo);
    dwTemp.setParameter("TaskSerialNo", taskSerialNo);
    dwTemp.genHTMLObjectWindow("");
    String sButtons[][] = {
	    {"true","All","Button","保存","保存所有修改","as_save(0)","","","",""}
    };

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
    setItemValue(0,0,"TASKSERIALNO","<%=taskSerialNo%>");
    setItemValue(0,0,"FLOWSERIALNO","<%=flowSerialNo%>");
    setItemValue(0,0,"USERID","<%=userId%>");
    setItemValue(0,0,"USERNAME","<%=userName%>");
    setItemValue(0,0,"ORGID","<%=orgId%>");
    setItemValue(0,0,"ORGNAME","<%=orgName%>");
    setItemValue(0,0,"PHASENO","<%=phaseNo%>");
    setItemValue(0,0,"PHASENAME","<%=phaseName%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
