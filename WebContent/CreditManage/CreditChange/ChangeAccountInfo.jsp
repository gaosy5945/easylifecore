<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "还款账户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sObjectNo = CurPage.getParameter("OBJECTNO");
	String sObjectType = CurPage.getParameter("OBJECTTYPE");
	String accountIndicator =CurPage.getParameter("ACCOUNTINDICATOR");
	String status = CurPage.getParameter("STATUS");
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	String templateNo="FixAccountsInfo03";

	if("0".equals(status) ) templateNo ="FixAccountsInfo05";
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templateNo,BusinessObject.createBusinessObject(),CurPage);
	
	doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@","','")+"')");
	if(accountIndicator != null && !"".equals(accountIndicator)) 
		doTemp.appendJboWhere(" and AccountIndicator in('"+accountIndicator.replaceAll("@","','")+"')");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp, CurPage, request);
	
	dwTemp.setParameter("ObjectType", sObjectType);
	dwTemp.setParameter("ObjectNo", sObjectNo);
	dwTemp.genHTMLObjectWindow("");

	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		
		if(!checkAccount()) return;
		
		if(!iV_all(0)) return;
		as_save(0);
	}
	
	function checkAccount(){
		if(!iV_all(0)) return;
		//账户性质 如果为放款账户则为多个可以保存如果为其他账户性质则只能保存一次再次出现则不能保存
		var accountIndicator = getItemValue(0,getRow(),"AccountIndicator");
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var accountType = getItemValue(0, getRow(), "AccountType");
		var accountNo = getItemValue(0, getRow(), "AccountNo");
		var accountName = getItemValue(0, getRow(), "AccountName");
		var accountCurrency = getItemValue(0, getRow(), "AccountCurrency");
		if("0" == accountType || "1" == accountType || "7" == accountType)
		{
			var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency);
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
			if(returnValue.split("@")[0] == "false"){
				alert(returnValue.split("@")[1]);
				return false;
			}else{
				setItemValue(0, getRow(0), "AccountNo1", returnValue.split("@")[1]);
				setItemValue(0, getRow(0), "AccountName", returnValue.split("@")[2]);
				setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[3]);
				setItemValue(0, getRow(0), "MFCustomerID", returnValue.split("@")[4]);
			}
		}
		return true;
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"Status","0");
			setItemValue(0,0,"AccountIndicator","<%=accountIndicator%>");

		}
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
