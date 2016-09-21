<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.config.impl.*"%>
<%@page import="com.amarsoft.app.base.businessobject.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-29
        Content: 示例详情页面
        History Log: 
    */
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";
	
	String phaseNo = CurPage.getParameter("PhaseNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String flowNo = Sqlca
			.getString(new SqlObject("select FlowNo from flow_instance where serialno = :SerialNo")
					.setParameter("SerialNo", flowSerialNo));
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String checkListName = CurPage.getParameter("CheckListName");

	String sRightType = (String) CurComp.getAttribute("RightType");
	if (sRightType == null)
		sRightType = "";

	if (phaseNo == null)
		phaseNo = "";
	if (flowNo == null)
		flowNo = "";
	
	//获取BusinessApply中的申请流水号、客户编号以及客户姓名
	String sBASerialno = "";
	String sCustomerID = "";
	String sCustomerName = "";
	ASResultSet rs = Sqlca.getASResultSet("select BA.SerialNo,BA.CustomerId,BA.CustomerName from FLOW_OBJECT FO, BUSINESS_APPLY BA where FO.FlowSerialNo = '"+ flowSerialNo + "' and FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and BA.SerialNo = FO.ObjectNo");
	while(rs.next()){
		sBASerialno = rs.getString("SerialNo") + "";
		sCustomerID = rs.getString("CustomerId") + "";
		sCustomerName = rs.getString("CustomerName") + "";
	}
	
	BusinessObject checkList = CreditCheckConfig.getCheckList(flowNo, phaseNo, checkListName);
	List<BusinessObject> checkGroupList = CreditCheckConfig.getCheckGroups(checkList);
	if (checkGroupList == null || checkGroupList.size() == 0 || phaseNo.equals("") || flowNo.equals("")) {
		out.println("该任务阶段未配置信息核查清单数据！");
		return;
	}
	String sTempletNo = "CreditTelCheck";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(sBASerialno);
	
	dwTemp.replaceColumn("CustomerTel", "<iframe type='iframe' name='frame_list' width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditApprove/CreditTelCheckList.jsp?CustomerID="+sCustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
// 		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
// 		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 AsControl.OpenView("<%=sPrevUrl%>", "","_self","");
	}
	function reloadPage(){
		AsControl.OpenView("/CreditManage/CreditApprove/CreditTelCheck.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&FlowSerialNo=<%=flowSerialNo%>&TaskSerialNo=<%=taskSerialNo%>&PhaseNo=<%=phaseNo%>&CheckListName=TelCheck","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>