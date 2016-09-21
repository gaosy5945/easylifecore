<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String flowSerialNo = DataConvert.toString(CurPage.getParameter("FlowSerialNo"));
	String isShowOpinion = CurPage.getParameter("IsShowOpinion");
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("QueryFlowTaskList", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	if("".equals(isShowOpinion) || isShowOpinion == null || !"Y".equals(isShowOpinion)){
		doTemp.setVisible("Opinion", false);
	}
	doTemp.setBusinessProcess("com.amarsoft.app.workflow.web.FlowInstanceTaskBusinessProcessor");
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(35);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","改派","改派","reasgnTask()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function reasgnTask(){
	var taskSerialNo = getItemValue(0,getRow(),"TaskSerialNo");
	var flowSerialNo = getItemValue(0,getRow(),"FlowSerialNo");
	var phaseNo = getItemValue(0,getRow(),"PhaseNo");
	if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var returnValue = PopPage("/Common/WorkFlow/SelectAvyPcpTreeDialog.jsp?FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo,"","dialogWidth:300px;dialogHeight:440px;resizable:yes;scrollbars:no;status:no;help:no");
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")
	{
		return;
	}
	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.ReasgnTask","run","TaskSerialNo="+taskSerialNo+",ReasgnUserID="+returnValue.split("@")[0]+",ReasgnOrgID="+returnValue.split("@")[1]+",Reason=,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
	if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
	else
	{
		alert(returnValue.split("@")[1]);
		reloadSelf();
	}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
