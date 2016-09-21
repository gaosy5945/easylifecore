<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("serialNo");
	if(serialNo == null) serialNo = "";
	String preStatus = CurPage.getParameter("preStatus");
	if(preStatus == null) preStatus = "";
	String TodoType = CurPage.getParameter("TodoType");
	if(TodoType == null) TodoType = "";

	String sTempletNo = "CLOperateRecoverInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("OPERATETYPE", "2");
	doTemp.setReadOnly("OPERATETYPE", true);
	doTemp.setDefaultValue("STATUS", preStatus);
	doTemp.setDefaultValue("OPERATEUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("OPERATEORGName", CurOrg.getOrgName());
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("CLSTOPREASON", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"150\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditLineManage/CreditLineLimit/CreditLine/CLStopReason.jsp?CLSerialNo="+serialNo+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"true","All","Button","提交","提交","ensure()","","","",""},
		{"true","All","Button","返回","返回","self.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function ensure(){
		if(!iV_all("myiframe0"))return;
		var CLSerialNo = getItemValue(0,getRow(0),"CLSERIALNO");
		var operateType = getItemValue(0,getRow(0),"OPERATETYPE");
		var reason = getItemValue(0,getRow(0),"REASON");
		var operateUserID = getItemValue(0,getRow(0),"OPERATEUSERID");
		var operateOrgID = getItemValue(0,getRow(0),"OPERATEORGID");
		var inputUserID = "<%=CurUser.getUserID()%>";
		var inputOrgID = "<%=CurOrg.getOrgID()%>";
		var inputDate = "<%=DateHelper.getToday()%>";
		var preStatus = "<%=preStatus%>";
		var TodoType = "<%=TodoType%>";
		var sReturn = CreditLineManage.importCOAndTodoStatus(CLSerialNo,TodoType,operateType,reason,preStatus,operateOrgID,operateUserID,inputUserID,inputOrgID,inputDate);
		if(sReturn == "SUCCEED"){
			alert("恢复申请提交成功！");
			top.close();
		}else{
			alert("恢复申请提交失败！");
		}
	}
	function initRow(){
		setItemValue(0,0,"CLSERIALNO","<%=serialNo%>");
		setItemValue(0,0,"OPERATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"OPERATEORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"OPERATDATE","<%=DateHelper.getToday()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
