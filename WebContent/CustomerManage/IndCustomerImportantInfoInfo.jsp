<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	String sTempletNo = "IndCustomerImportantInfoInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", SerialNo);
	if("".equals(SerialNo)){
		doTemp.setDefaultValue("INPUTORGNAME", CurOrg.getOrgName());
		doTemp.setDefaultValue("INPUTUSERNAME", CurUser.getUserName());
	}
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
			{"true","","Button","返回","返回列表","returnBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnBack()
	{
	  AsControl.OpenPage("/CustomerManage/IndCustomerImportantInfoList.jsp","CustomerID="+"<%=CustomerID%>","_self","");
	} 
	function initRow(){
		var sSerialNo = "<%=SerialNo%>";
		if(sSerialNo == "undefined" || sSerialNo.length == 0 || sSerialNo == "null"){
			setItemValue(0,0,"CUSTOMERID","<%=CustomerID%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateHelper.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getToday()%>");
		}else{
			setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getToday()%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
