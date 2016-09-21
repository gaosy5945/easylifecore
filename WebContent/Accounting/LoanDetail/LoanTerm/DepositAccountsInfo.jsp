<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.app.als.businessobject.*"%> 
 
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数
	String SerialNo =  CurPage.getParameter("SERIALNO");
	String sObjectNo =  CurPage.getParameter("OBJECTNO");
	String sObjectType = CurPage.getParameter("OBJECTTYPE");
	String sStatus = CurPage.getParameter("STATUS");
	String sAccountIndicator = CurPage.getParameter("ACCOUNTINDICATOR");

	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sStatus == null) sStatus = "";
	if(sAccountIndicator == null) sAccountIndicator = "";
		
	ASObjectModel doTemp = new ASObjectModel("DepositAccountsInfo");
	if(sAccountIndicator == null || "".equals(sAccountIndicator) || "null".equals(sAccountIndicator))
	{
		doTemp.setDDDWJbo("AccountIndicator","jbo.sys.CODE_LIBRARY,itemno,itemname,codeno = 'AccountIndicator' ");
	}
	else if(sAccountIndicator.indexOf("@")==-1)
	{
		doTemp.setReadOnly("AccountIndicator",true);
		doTemp.setVisible("AccountIndicator",false);
		
		doTemp.setDefaultValue("AccountIndicator",sAccountIndicator);
	}
	else
	{
		doTemp.setDDDWJbo("AccountIndicator","jbo.sys.CODE_LIBRARY,itemno,itemname,codeno = 'AccountIndicator' and itemno in ('" + sAccountIndicator.replaceAll("@", "','") + "')");
	}

	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp, request);
	dwTemp.Style = "2"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow(SerialNo);

	String sButtons[][] = {
			{"true", "All", "Button", "保存", "新增一条信息","saveRecord()",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script language=javascript>
	//保存
	function saveRecord(){
		
		if(!checkAccount()) return;
		
		if(!iV_all(0)) return;
		
		as_save(0);
		
	}
	
	//账户校验
	function checkAccount()
	{
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
	
	//返回
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?STATUS=<%=sStatus%>&OBJECTNO=<%=sObjectNo%>&OBJECTTYPE=<%=sObjectType%>&ACCOUNTINDICATOR=<%=sAccountIndicator%>","_self","");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"Status","0");
			bIsInsert = true;
		}else{
			bIsInsert = false;
		}
		initATT();
	}
	
	
	function initATT(){
		var accountIndicator = getItemValue(0, getRow(), "AccountIndicator");
		var accountType = getItemValue(0, getRow(), "AccountType");
		
		
		
		if("0" == accountType || "1" == accountType || "7" == accountType)
		{
			
			setItemDisabled(0,getRow(),"AccountName",true);
		}
		else
		{
			setItemDisabled(0,getRow(),"AccountName",false);
		}
		
		if("5" == accountType)
		{
			showItem(0,"AccountBankName");
			setItemRequired(0,"AccountBankName", true);
		}
		else
		{
			hideItem(0,"AccountBankName");
			setItemRequired(0,"AccountBankName", false);
		}
		
		if("5" == accountType || "7" == accountType)
		{
			hideItem(0,"AccountNo1");
			setItemHeader(0,getRow(),"AccountNo","账户账号");
		}
		else
		{
			showItem(0,"AccountNo1");
			setItemHeader(0,getRow(),"AccountNo","账户（卡号/一本通等）");
		}
		
		/*
		if("07" == accountIndicator)
		{
			showItem(0,"AccountAmt");
			setItemRequired(0,"AccountAmt", true);
		}
		else
		{
			hideItem(0,"AccountAmt");
			setItemRequired(0,"AccountAmt", false);
		}*/
	}
</script>

<script language=javascript>
	//初始化
	$(document).ready(function(){
		initRow();
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>