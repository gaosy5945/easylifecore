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
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	//����Ԥ�����η���ʱflow_task����û�����ݣ������ȡ����orgid��ҳ��Ĭ�ϸ�ֵ��ǰ������
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
			{"true","","Button","����","����","view()","","","","",""},
			{"A".equals(flag)?"true":"false","","Button","ɾ��","ɾ��","deleteRecord()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function view(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		if (typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		AsControl.OpenView("/CreditManage/CreditApprove/CreditApproveInfo0201.jsp", "FlowSerialNo=<%=flowSerialNo%>&TaskSerialno="+taskSerialNo+"&FlowNo=<%=flowNo%>&PhaseNo=<%=phaseNo%>&SerialNo=<%=serialNo%>&FlowVersion=<%=flowVersion%>&RightType=ReadOnly", "_blank");
	}
	
	function deleteRecord(){
		var taskSerialNo = getItemValue(0,getRow(),"TASKSERIALNO");
		if (typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		if(confirm(getHtmlMessage(2))){ //�������ɾ������Ϣ��
			as_delete('myiframe0');
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
