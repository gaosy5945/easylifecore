<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";	
	String applyType = CurPage.getParameter("ApplyType");
	String sTempletNo = "RiskWarningGiveOutInfo";//--模板号--
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(serialNo);
	dwTemp.replaceColumn("GivenOutOrgList", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"700\" frameborder=\"0\" src=\""+sWebRootPath+"/BusinessManage/RiskWarningManage/RiskWarningGiveOutOrgList.jsp?CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","任务转发","选择转发机构","selectOrgMuti()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function selectOrgMuti(){
	var returnValue = AsCredit.selectMultipleTree('SelectBelongSubOrg', "OrgID,<%=CurUser.getOrgID()%>,ObjectNo,<%=serialNo%>", ",", "");
	if(returnValue["ID"].length == 0) return;
	var orgID = returnValue["ID"];
	var orgIDs = orgID.replace(/,/g,"@");
	startGiveOutProcess(orgIDs);
}

function startGiveOutProcess(orgIDs){
	var result = AsControl.RunASMethod("RiskWarningManage","StartRiskWarningGiveOut","<%=serialNo%>,"+orgIDs+",<%=CurUser.getUserID()%>,<%=applyType%>,<%=CurPage.getParameter("FlowNo")%>");
	if(!typeof(result)== "undefined" || result != null){
		
		if(result.split("@")[0]=="true"){
			alert("风险预警转发成功！");
		}else{
			alert("风险预警转发失败！");
		}
	}
    AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWarningGiveOutInfo.jsp", "SerialNo=<%=serialNo%>", "_self");
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
