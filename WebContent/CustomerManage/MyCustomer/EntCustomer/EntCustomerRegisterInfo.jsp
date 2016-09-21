<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID =  CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String serialNo =  CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "EntCustomerRegisterInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
			{"true","","Button","返回","返回列表","returnBack()","","","",""}	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>注册信息</title>
</HEAD>
<script type="text/javascript">
function returnBack()
{
  AsControl.OpenView("/CustomerManage/MyCustomer/EntCustomer/EntCustomerRegisterList.jsp","CustomerID="+"<%=customerID%>","_self");
} 
function initRow(){

	<% if(CurComp.getParameter("SerialNo") == null){%>
		setItemValue(0,0,"CUSTOMERID","<%=customerID%>");
		setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
	<% }%>
}
initRow();
</script>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
