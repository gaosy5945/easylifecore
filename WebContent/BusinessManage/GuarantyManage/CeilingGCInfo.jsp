<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "新增最高额担保合同";
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
	String contractType = CurPage.getParameter("ContractType");
	if(contractType == null)contractType = "";
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CeilingGCInfo",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp,CurPage, request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SerialNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		if(getItemValue(0,0,"GuarantyType") != "01030"){
			if(!checkCertInfo()) return ;
		}
		
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"InputDate","<%=DateHelper.getBusinessDate()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ContractStatus","01");   //待生效
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		
		as_save("refresh()");
	}
	
	function checkCertInfo(){
		var certType=getItemValue(0,getRow(),"CertType");
		var certId=getItemValue(0,getRow(),"CertID");

		var result = CustomerManage.checkCertID(certType,certId,"CHN");
		if(!result){
			alert("无效的证件号码，请重新输入！");
			return false;
		}
		return true;
	}
	
	function refresh(){
		var gcSerialNo = "";
		if("<%=objectNo%>" == ""){
			gcSerialNo = getItemValue(0,0,"SerialNo");
		}
		else{
			gcSerialNo = "<%=objectNo%>";
		}
		AsControl.OpenPage("/BusinessManage/GuarantyManage/CeilingGCInfo.jsp", "ObjectNo="+gcSerialNo,"_self");
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
	
	function changeGuarantyType(){
		var returnValue= setObjectValue('SelectGuarantyType','CodeNo,GuarantyType','@GuarantyType@0@GuarantyTypeName@1');
		if(typeof(returnValue)=="undefined" || returnValue.length==0) return;
		returnValue = returnValue.split("@");
		if(returnValue[0] == "01030"){//联贷联保保证
			ALSObjectWindowFunctions.setItemsRequired(0,"CertType",false);
			ALSObjectWindowFunctions.setItemsRequired(0,"CertID",false);
			hideItem(0,"CertType");
			hideItem(0,"CertID");
		}
		else{
			ALSObjectWindowFunctions.setItemsRequired(0,"GuarantorName",true);
			ALSObjectWindowFunctions.setItemsRequired(0,"CertType",true);
			ALSObjectWindowFunctions.setItemsRequired(0,"CertID",true);
			showItem(0,"GuarantorName");
			showItem(0,"CertType");
			showItem(0,"CertID");
		}
	}
	
	function init(){
		if (getRowCount(0)!=0){
			setItemDisabled(0,0,"ContractType",true);
			if(getItemValue(0,getRow(),"ContractStatus") != "01"){
				setItemDisabled(0,0,"GuarantyType",true);
				//setItemDisabled(0,0,"ContractStatus",true);
				setItemDisabled(0,0,"ContractNo",true);
				setItemDisabled(0,0,"SignDate",true);
				setItemDisabled(0,0,"ContractDate",true);
				setItemDisabled(0,0,"MaturityDate",true);
				setItemDisabled(0,0,"GuarantorID",true);
				setItemDisabled(0,0,"GuarantorName",true);
				setItemDisabled(0,0,"GuarantyValue",true);
				setItemDisabled(0,0,"GuarantyCurrency",true);
			}
		}
		else{
			setItemValue(0,getRow(),"ContractType","<%=contractType%>");	
		}

		//计算最高额担保合同余额
		var gcSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(gcSerialNo)=="undefined" || gcSerialNo.length==0) gcSerialNo="";
		var balance = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getCeilingGCBalance", "GCSerialNo="+gcSerialNo);
		if(balance!="false"){
			setItemValue(0,0,"CeilingBalance",balance);
		}
		
		if(getItemValue(0,0,"GuarantyType") == "01030"){//联贷联保保证
			ALSObjectWindowFunctions.setItemsRequired(0,"CertType",false);
			ALSObjectWindowFunctions.setItemsRequired(0,"CertID",false);
			hideItem(0,"CertType");
			hideItem(0,"CertID");
		} 

		if(getItemValue(0,0,"GuarantyType") != "01030"){//法人保证、自然人、其他、履约保险、抵质押
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
	}
	
	function selectCustomerList(){
		setGridValuePretreat("CustomerList","<%=CurUser.getUserID()%>","GuarantorID=CustomerID@GuarantorName=CustomerName@CertType=CertType@CertID=CertID","");
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
