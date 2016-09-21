<%@page import="com.amarsoft.app.als.awe.ow.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.customer.action.JudgeIncomeType"%>
<%@page import="com.amarsoft.app.als.customer.action.UpdateIncome"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String customerID =  CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
   	JBOTransaction tx = null;
	try{
		tx = JBOFactory.createJBOTransaction();
 		JudgeIncomeType JIE = new JudgeIncomeType();
		String result = JIE.judgeIncomeExists(customerID,tx);
		if(!"Empty".equals(result)){
			UpdateIncome UI = new UpdateIncome();
			UI.updateIncomeFirst(customerID,CurUser.getUserID(),CurOrg.getOrgID(),tx);
		} 
		tx.commit();
	}catch(Exception ex)
	{
		tx.rollback();
		throw ex;
	}   
	
	String sTempletNo = "IndCustomerFinance";//--模板号--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("CustomerID", customerID);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("CustomerID", customerID);
	ALSInfoHtmlGenerator.replaceSubObjectWindow(dwTemp);
	dwTemp.replaceColumn("INCOMESUM", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IncomeSum.jsp?CustomerID="+customerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function saveRecord()
	{
		as_save("reloadPage()");
	}
	function reloadPage(){
		CustomerManage.updateIncome("<%=customerID%>","<%=CurUser.getUserID()%>","<%=CurOrg.getOrgID()%>");
		AsControl.OpenPage("/CustomerManage/MyCustomer/IndCustomer/IndCustomerFinance.jsp","CustomerID="+"<%=customerID%>","_self","");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
