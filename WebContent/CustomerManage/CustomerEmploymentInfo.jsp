<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID =  CurComp.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String serialNo =  CurComp.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "IndCustomerEmploymentInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
			{"true","All","Button","����","�����б�","top.close()","","","",""}	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		var customerID = "<%=customerID%>";
		var jboYears = getItemValue(0,0,"BEGINDATE");
		var today = "<%=DateHelper.getToday()%>";
		
		if(jboYears == today || jboYears > today){
			alert("��ְʱ�䲻�ܴ��ڻ���ڵ�ǰ���ڣ���ȷ�ϣ�");
			return;
		}else{
			as_save(0);
		}
	}


	function initRow(){

	<% if(CurComp.getParameter("SerialNo") == null){%>
		setItemValue(0,0,"CUSTOMERID","<%=customerID%>");
		setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
	<% }else{%>
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	<%}%>
}
initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
