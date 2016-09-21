<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*有重名字段（ColActualName相同）的Info案例*/
	String sCustomerID = CurPage.getParameter("CustomerID");
	if(sCustomerID == null) sCustomerID = "2010081000000001";

	ASObjectModel doTemp = new ASObjectModel("DemoEntInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";
	dwTemp.genHTMLObjectWindow(sCustomerID);
	String sButtons[][] = {
		{"true","All","Button","获取编号","","getColNo()","","","","btn_icon_save"},
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function getColNo(){
		alert("CI客户编号:"+getItemValue(0,0,"V.CUSTOMERID1")+"\nEI客户编号:"+getItemValue(0,0,"CUSTOMERID"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
