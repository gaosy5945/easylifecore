<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%
    String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
   
    if(flowSerialNo == null) flowSerialNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
    String flag = "hide";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from BUSINESS_APPROVE where TaskSerialNo = :TaskSerialNo").setParameter("TaskSerialNo", taskSerialNo));
    if(rs.next()){
    	flag = "show";
    }
    rs.close();
    BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CreditApproveInfoCL", inputParameter, CurPage, request);
	ASDataObject doTemp = dwTemp.getDataObject();
	dwTemp.setParameter("FlowSerialNo", flowSerialNo);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","","Button","意见附件","意见附件","upload()","","","",""}
	};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function upload(){
		AsControl.PopView("/Common/BusinessObject/BusinessObjectDocumentList.jsp", "ObjectType=jbo.flow.FLOW_TASK&ObjectNo=<%=taskSerialNo%>&RightType=ReadOnly");
	}
	
	function opinion(){
		var phaseAction = getItemValue(0,getRow(),"PHASEACTIONTYPE");
		if(phaseAction == '01' && "<%=flag%>" == "show"){
			AsCredit.showOWGroupItem("0020");
		}
		else
		{
			AsCredit.hideOWGroupItem("0020");
		}
	}
	opinion();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
