<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String PG_TITLE = "担保方案信息"; 
	String templateNo = "GuarantyContractChangeInfo";
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String documentObjectType = CurPage.getParameter("DocumentObjectType");if(documentObjectType == null) documentObjectType = "";
	String projectSerialNo = CurPage.getParameter("ProjectSerialNo");if(projectSerialNo == null) projectSerialNo = "";
	
	
	String guarantyType = CurPage.getParameter("GuarantyType");
	String guarantyTypeName = "";
	if(guarantyType == null) {
		guarantyType = "";
	}
	else{
		Item item = CodeManager.getItem("GuarantyType",guarantyType);
		templateNo = item.getAttribute5();
		guarantyTypeName = item.getItemName();
	}
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(templateNo,BusinessObject.createBusinessObject(),CurPage);
	
	/* if(projectSerialNo!=null&&projectSerialNo.length()>0){
		doTemp.setReadOnly("*", true);
		doTemp.setReadOnly("ContractType,MI_CONTRACTAMOUNT,MI_CURRENCY", false);
	} */
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);

	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("GCCSerialNo", serialNo);
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject gccInfo = bom.loadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT_CHANGE", serialNo);
	String relativeGCSerialNo = gccInfo.getString("RelativeGCSerialNo");
	BusinessObject gcInfo = bom.loadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", relativeGCSerialNo);
	double oldGuarantyValue = gcInfo.getDouble("GuarantyValue");
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		
		var guarantyValue = getItemValue(0,getRow(),"GuarantyValue");
		var checkResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "checkGCAmount", "GCCSerialNo=<%=serialNo%>,GCCGuarantyValue="+guarantyValue);
		if("true"!=checkResult){
			alert(checkResult.split("@")[1]);
			return
		}
		
		var guarantyMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		var checkDateResult = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.GuarantyContractChange", "checkGCMaturityDate", "GCCSerialNo=<%=serialNo%>,GCCMaturityDate="+guarantyMaturityDate);
		if("true"!=checkDateResult){
			alert(checkDateResult.split("@")[1]);
			return
		}
		
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		
		if(getItemValue(0,getRow(),"ContractType") == "020"){
			as_save("refresh()");
		}
		else{
			as_save("0");
		}
	}
	
	function refresh(){
		var serialNo = getItemValue(0,0,"SerialNo");
		var guarantyType = getItemValue(0,0,"GuarantyType");
		AsControl.OpenPage("/BusinessManage/GuarantyManage/CeilingGCChangeInfo.jsp", "SerialNo="+serialNo+"&GuarantyType="+guarantyType,"_self");
	}
	
	function itemsControl(){
		var contractType = getItemValue(0,getRow(),"ContractType");
		if(contractType == "010"){
			setItemRequired(0,"RELATIVEAMOUNT",false);
			hideItem(0,"RELATIVEAMOUNT");
			hideItem(0,"CEILINGBALANCE");
		}
		else if(contractType == "020"){
			showItem(0,"RELATIVEAMOUNT");
			setItemRequired(0,"RELATIVEAMOUNT",true);
			showItem(0,"CEILINGBALANCE");
		}
		else{
			//hideItem(0,"CEILINGBALANCE");
		}
	}
		
	function changeGuarantyType(){//根据担保方式调整页面
		var oldGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		var returnValue= setObjectValue('SelectGuarantyType','CodeNo,GuarantyType','@GuarantyType@0@GuarantyTypeName@1');

		if(typeof(returnValue)=="undefined" || returnValue.length==0) return;
		returnValue = returnValue.split("@");
		if(returnValue[0] != oldGuarantyType){
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if(typeof(serialNo)=="undefined" || serialNo.length==0)
				serialNo = "<%=serialNo%>";
			<%-- AsControl.OpenView("/CreditManage/CreditApply/GuarantyInfo.jsp","SerialNo="+serialNo+"&ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&GuarantyType="+returnValue[0],"_self",""); --%>
		}
	}
	
	function changeGuarantyTermType(){
		var guarantyTermType = getItemValue(0,getRow(),"GuarantyTermType");
		if(guarantyTermType == null || guarantyTermType.length == 0 || typeof(guarantyTermType) == "undefined")
			return;
		if(guarantyTermType == "01"){//全程担保
			hideItem(0,"GuarantyPeriodFlag");
			//setItemValue(0,0,"GuarantyPeriodFlag","");
		}
		if(guarantyTermType == "02"){//阶段性担保
			showItem(0,"GuarantyPeriodFlag");
		}
	}
	
	function selectGuarantor(){
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");
		var selectSource = "CustomerList";
		if(guarantyType == "01010" || guarantyType == "01020"){
			selectSource = "CustomerList1";//法人客户
		}
		else if(guarantyType == "01030" || guarantyType == "01080"){
			selectSource = "CustomerList2";//个人客户
		}
		else{}
		setGridValuePretreat(selectSource,'<%=CurUser.getUserID()%>,','GuarantorID=CustomerID@GuarantorName=CustomerName@CertType=CertType@CertID=CertID','');
	}
	
	function showProjectNo(){
		//法人保证时展现合作项目信息
		var vouchType = getItemValue(0,getRow(),"GuarantyType");
		if(vouchType == "01010"){
			showItem(0,"ProjectSerialNo");
		}
		else{
			hideItem(0,"ProjectSerialNo");
		}
	}
	
	//根据录入的CertType和CertID查询是否有该客户，若存在则更新页面的客户编号和名称，不存在则插入
	function checkCustomer(){
		var certType = getItemValue(0,getRow(),"CertType");
		var certID = getItemValue(0,getRow(),"CertID");
		if(typeof(certType) == "undefined" || certType.length == 0) return;
		if(typeof(certID) == "undefined" || certID.length == 0) return;
		
		var customer = AsControl.RunASMethod("BusinessManage","KeyCustomer",certType+","+certID);
		if(typeof(customer) == "undefined" || customer.length == 0){
			setItemValue(0,getRow(),"GuarantorID","");
			//setItemValue(0,getRow(),"GuarantorName","");
		}
		else{
			var customerID = customer.split("@")[0];
			var customerName = customer.split("@")[1];			
			setItemValue(0,getRow(),"GuarantorID",customerID);
			setItemValue(0,getRow(),"GuarantorName",customerName);
		}
	}
	
	function getCeilingGCBalance(gcSerialNo){
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getCeilingGCBalance", "GCSerialNo="+gcSerialNo);
		return returnValue;
	}
	
	function init(){
		//融资易申请只能最高额担保
		<%-- var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getProduct", "ObjectType=<%=objectType%>,ObjectNo=<%=objectNo%>");
		if(returnValue!="false"){
			returnValue = returnValue.split("@");
			if(returnValue[2] == "500" || returnValue[2] == "502"){
				setItemValue(0,0,"ContractType","020");
				setItemDisabled(0,0,"ContractType",true);
			}
		} --%>
		
		if("<%=guarantyType%>" != ""){
			setItemValue(0,getRow(),"GuarantyType","<%=guarantyType%>");
			setItemValue(0,getRow(),"GuarantyTypeName","<%=guarantyTypeName%>");

			var gt = getItemValue(0,0,"GuarantyType");
			if("<%=guarantyType%>".substring(0, 3) == "020" || gt.substring(0, 3) == "020"){
				setItemHeader(0,0,"GuarantorName","抵押人名称");
			}
			if("<%=guarantyType%>" == "040" || gt == "040"){
				setItemHeader(0,0,"GuarantorName","出质人名称");
			}
		}
		

		//计算最高额担保合同余额
		var gcSerialNo = getItemValue(0,getRow(),"RelativeGCSerialNo");
		if(typeof(gcSerialNo)=="undefined" || gcSerialNo.length==0) gcSerialNo="";
		var balance = getCeilingGCBalance(gcSerialNo);
		if(balance!="false"){
			var oldGuarantyValue = "<%=oldGuarantyValue%>";
			var newGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");
			setItemValue(0,0,"CeilingBalance",parseFloat(balance)+parseFloat(newGuarantyValue)-parseFloat(oldGuarantyValue));
		}
		
		//itemsControl();

		
		if("<%=guarantyType%>" == "01030" || getItemValue(0,0,"GuarantyType") == "01030"){//联贷联保保证
			setItemRequired(0,"CertType",false);
			setItemRequired(0,"CertID",false);
			hideItem(0,"CertType");
			hideItem(0,"CertID");
		} 

		if("<%=guarantyType%>" != "01030" && getItemValue(0,0,"GuarantyType") != "01030"){
			//除联贷联保
			var guarantorID = getItemValue(0,0,"GuarantorID");
			if(guarantorID != null && typeof(guarantorID) != "undefined" && guarantorID.length != 0){
				var guarantorInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CustInfoQuery", "getCertInfo", "CustomerID="+guarantorID);
				if(guarantorInfo != null && typeof(guarantorInfo) != "undefined" && guarantorInfo.length != 0){
					guarantorInfo = guarantorInfo.split("@");
					setItemValue(0,0,"CertType",guarantorInfo[1]);
					setItemValue(0,0,"CertID",guarantorInfo[2]);
				}
			}
		}
		
		if("<%=guarantyType%>" == "01010" || getItemValue(0,0,"GuarantyType") == "01010"){//法人保证
			showItem(0,"GuarantyTermType");
			showItem(0,"GuarantyPeriodFlag");
		} 
		else{
			hideItem(0,"GuarantyTermType");
			hideItem(0,"GuarantyPeriodFlag");
		}
		changeGuarantyTermType();
		
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"MI");
		if(subdwname>=0){
			var accountNo = getItemValue(subdwname, getRow(), "AccountNo");
			if(typeof(accountNo)=="undefined"||accountNo.length==0)return;
			var accountName = getItemValue(subdwname, getRow(), "AccountName");
			if(typeof(accountName)=="undefined"||accountName.length==0){
				checkAccount();
			}
		}
	}
	//setDialogTitle("最高额担保合同变更");
	//init();
	
	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;
		var guarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if (guarantyType == "01020") {//履约保证保险
			AsControl.OpenPage("/BusinessManage/GuarantyManage/InsuranceGuaranty.jsp","ObjectType=jbo.guaranty.GUARANTY_CONTRACT&ObjectNo="+serialNo,"rightdown","");
			return ;
		}
		else if(guarantyType == "01030"){//联贷联保
			AsControl.OpenPage("/Blank.jsp", "", "rightdown", "");
			return;
		}
		else if(guarantyType.substring(0,3) == "020" || guarantyType.substring(0,3) == "040"){//抵质押担保
			AsControl.OpenPage("/CreditManage/CreditApply/GCChangeCollateralList.jsp","GCSerialNo="+serialNo+"&VouchType="+guarantyType,"rightdown","");
		}
		/* else{
			AsControl.OpenPage("/CreditManage/CreditApply/GuarantyCLRInfo.jsp", "RightType=ReadOnly&ObjectType=jbo.guaranty.GUARANTY_CONTRACT_CHANGE&ObjectNo="+serialNo, "rightdown", "");
		} */
	}
	
	//校验保证金账户信息
	function checkAccount(subdwname,an,ana,ac,an1,acid,amfcid)
	{
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"MI");
		var accountNo = getItemValue(subdwname, getRow(), "AccountNo");
		var accountName = getItemValue(subdwname, getRow(), "AccountName");
		var accountCurrency = getItemValue(subdwname, getRow(), "AccountCurrency");

		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName","06,"+accountNo+",7,"+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return false;
		}else{
			setItemValue(subdwname, getRow(0), "AccountNo1", returnValue.split("@")[1]);
			setItemValue(subdwname, getRow(0), "AccountName", returnValue.split("@")[2]);
			setItemValue(subdwname, getRow(0), "CustomerID", returnValue.split("@")[3]);
			setItemValue(subdwname, getRow(0), "MFCustomerID", returnValue.split("@")[4]);
		}
		
		return true;
	}
	
	$(document).ready(function(){
		//setDialogTitle("担保信息详情");
		init();
		mySelectRow();
	});
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>