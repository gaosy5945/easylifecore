<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String serialNo = CurPage.getParameter("SerialNo"); 
	if(taskSerialNo == null) taskSerialNo = "";
	if(flowSerialNo == null) flowSerialNo = "";
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("RiskWarningBHistoryList01");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("flowSerialNo", flowSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		AsControl.OpenView("/BusinessManage/RiskWarningManage/RiskWaringDoneHistoryInfo.jsp","TaskSerialNo=<%=taskSerialNo%>&SerialNo=<%=serialNo%>" ,'_blank','');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
