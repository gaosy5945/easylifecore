<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String projectSerialNo = CurPage.getParameter("SerialNo");
	if(projectSerialNo == null) projectSerialNo = "";
	String buildingSerialNo = CurPage.getParameter("ObjectNo");
	if(buildingSerialNo == null) buildingSerialNo = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CLRMaginInfo",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("ObjectNo", projectSerialNo);
	dwTemp.setParameter("ObjectType","jbo.prj.PRJ_BASIC_INFO");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","保证金账户余额查询","保证金账户余额查询","QueryAccount()","","","",""},
		{"true","","Button","保证金账户明细查询","保证金账户明细查询","QueryDetail()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
			as_save(0);
	}
	
	function initRow(){
		setItemValue(0,0,"ObjectType","jbo.prj.PRJ_BASIC_INFO");
		setItemValue(0,0,"ObjectNo","<%=projectSerialNo%>");
		var MarginSerialNo = getItemValue(0,0,"SERIALNO");
		var sReturn = ProjectManage.selectPaymentMoney(MarginSerialNo);
		setItemValue(0,0,"PaymentMoney",sReturn);
		var flag = ProjectManage.selectMarginSerialNo(MarginSerialNo);
		if(flag == "1"){
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateHelper.getBusinessDate()%>");
		}else{
			setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
		}
		
	}
	//校验账户信息
	function checkAccount(ai,at,an,ana,ac,an1,acid,amfcid,subdw)
	{
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,subdw);
		var accountIndicator = getItemValue(subdwname, getRow(subdwname), ai);
		var accountType = getItemValue(subdwname, getRow(subdwname), at);
		var accountNo = getItemValue(subdwname, getRow(subdwname), an);
		var accountName = getItemValue(subdwname, getRow(subdwname), ana);
		var accountCurrency = getItemValue(subdwname, getRow(subdwname), ac);
		
		if(typeof(accountNo) == "undefined" || accountNo.length == 0) return;
		
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(subdwname), ana, "");
			setItemValue(subdwname, getRow(subdwname), an1, "");
			setItemValue(subdwname, getRow(subdwname), an, "");
			return false;
		}else{
			setItemValue(subdwname, getRow(subdwname), an1, returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(subdwname), ana, returnValue.split("@")[2]);
			setItemValue(subdwname, getRow(subdwname), acid, returnValue.split("@")[3]);
			setItemValue(subdwname, getRow(subdwname), amfcid, returnValue.split("@")[4]);
		}
		return true;
	}
	function QueryAccount1(){//停用
		var ProjectSerialNo = "<%=projectSerialNo%>";
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AAI");
		var AccountNo = getItemValue(subdwname, getRow(subdwname), "ACCOUNTNO");
		var MFCustomerID = getItemValue(subdwname, getRow(subdwname), "MFCUSTOMERID");
		if(typeof(AccountNo) == "undefined" || AccountNo.length == 0){
			alert("请输入保证金账户账号！");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectNewApply/MarginAcctSelect.jsp","ProjectSerialNo="+ProjectSerialNo+"&AccountNo="+AccountNo+"&MFCustomerID="+MFCustomerID,"resizable=yes;dialogWidth=460px;dialogHeight=100px;center:yes;status:no;statusbar:no");
	}
	function QueryDetail(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AAI");
		var AccountNo = getItemValue(subdwname, getRow(subdwname), "ACCOUNTNO");
		if(typeof(AccountNo) == "undefined" || AccountNo.length == 0){
			alert("请输入保证金账户账号！");
			return;
		}
		AsControl.PopView("/ProjectManage/ProjectNewApply/SelectClrDate.jsp","AccountNo="+AccountNo+"&RightType="+"","resizable=yes;dialogWidth=520px;dialogHeight=320px;center:yes;status:no;statusbar:no","");
	}
	function QueryAccount(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AAI");
		var AccountNo = getItemValue(subdwname, getRow(subdwname), "ACCOUNTNO");
		if(typeof(AccountNo) == "undefined" || AccountNo.length == 0){
			alert("请输入保证金账户账号！");
			return;
		}
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.QueryAccountBalance", "queryAccountBalance", "AccountNo="+AccountNo);
		var flag = result.split("@")[0];
		if(flag == "1"){
			AsControl.PopPage("/ProjectManage/ProjectNewApply/QueryCMIBalance.jsp","MarginBalance="+result.split("@")[1],"resizable=yes;dialogWidth=460px;dialogHeight=100px;center:yes;status:no;statusbar:no");
		}else{
			alert(result.split("@")[1]);
			return;
		}	
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
