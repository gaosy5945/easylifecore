<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String serialNo = CurPage.getParameter("SerialNo");
	String taskSerialno = CurPage.getParameter("TaskSerialno");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String flowNo = CurPage.getParameter("FlowNo");
	String flowVersion = CurPage.getParameter("FlowVersion");
    String phaseNo = CurPage.getParameter("PhaseNo");
	String flag = CurPage.getParameter("Flag");
	String orgID= "";
	String tempNo = "";
	if("A".equals(flag)){
		tempNo = "RiskWarningBHistoryList";
	}else{
		tempNo = "RiskWarningBackHistoryList";
	}
	
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	
	//风险预警初次反馈时flow_task表里没有数据，组件获取不到orgid，页面默认赋值当前机构号
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct FT.ORGID as OrgID from FLOW_TASK FT where FT.FLOWSERIALNO =:FLOWSERIALNO and FT.PhaseNo=:PhaseNo").setParameter("FLOWSERIALNO", flowSerialNo).setParameter("PhaseNo", phaseNo));
	if(rs.next()){
		orgID = rs.getString("OrgID");
	} else {
		if("A".equals(flag)) {
			orgID = CurUser.getOrgID();
		} else {
			orgID = CurPage.getParameter("OrgID");
		}
	}
	rs.close();
	
	if("A".equals(flag)){
		dwTemp.genHTMLObjectWindow(flowSerialNo+","+orgID);
	}else{
		dwTemp.genHTMLObjectWindow(serialNo+","+orgID);
	}
	

	String sButtons[][] = {
			{"true","","Button","详情","详情","view()","","","","",""},
			{"A".equals(flag)?"true":"false","","Button","删除","删除","deleteRecord()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function view(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		if (typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo0201.jsp", "FlowSerialNo=<%=flowSerialNo%>&TaskSerialno="+taskSerialNo+"&FlowNo=<%=flowNo%>&PhaseNo=<%=phaseNo%>&SerialNo=<%=serialNo%>&FlowVersion=<%=flowVersion%>&RightType=ReadOnly", "_blank");
	}
	
	function deleteRecord(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		if (typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}

		if(confirm(getHtmlMessage(2))){ //您真的想删除该信息吗？
			as_delete('myiframe0');
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
