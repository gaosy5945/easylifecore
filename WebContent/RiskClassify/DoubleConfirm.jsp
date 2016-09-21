<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%  
     String flowSerialNo = CurPage.getParameter("FlowSerialNo");
     String taskSerialNo = CurPage.getParameter("TaskSerialNo");
     String flowNo = CurPage.getParameter("FlowNo");
     String flowVersion = CurPage.getParameter("FlowVersion");
     String phaseNo = CurPage.getParameter("PhaseNo");
     String phaseName = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("PhaseName");
     String templateNo = com.amarsoft.app.workflow.FlowConfig.getFlowModel(flowNo,flowVersion,phaseNo).getString("OpnTemplateNo");

     String orgId = CurUser.getOrgID();
     String orgName = CurUser.getOrgName();
     
     String sSerialno = CurPage.getParameter("SerialNo");
     sSerialno=	sSerialno.replace("@", ",");
     sSerialno=sSerialno.substring(1);
	//String sDocNo = CurPage.getParameter("DocNo");
	String sTempletNo = "SingleConfirmInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("FlowNo", flowNo);
	dwTemp.setParameter("PhaseNo", phaseNo);
	dwTemp.setParameter("FlowVersion", flowVersion);
	dwTemp.genHTMLObjectWindow("");
	
	dwTemp.replaceColumn("APPLYADJUSTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/RiskClassify/DoubleAdjustList.jsp?SerialNo="+sSerialno+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("ADDITIONINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/RiskClassify/DocInfoList.jsp?DOCNO="+CurPage.getParameter("DocNo")+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveInfo()","","","","",""},
		{"true","All","Button","�ύ","�ύ","saveInfo()","","","","",""},
		{"true","All","Button","ȡ��","ȡ��","returnList()","","","","",""},
		};
%> 
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script>
     setItemValue(0,0,"TASKSERIALNO","<%=taskSerialNo%>");
     setItemValue(0,0,"FLOWSERIALNO","<%=flowSerialNo%>");
     setItemValue(0,0,"ORGID","<%=orgId%>");
     setItemValue(0,0,"ORGNAME","<%=orgName%>");
     setItemValue(0,0,"PHASENO","<%=phaseNo%>");
     setItemValue(0,0,"PHASENAME","<%=phaseName%>");
	
	</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
