<%@page import="com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions"%>
<%@page import="com.amarsoft.app.als.prd.config.loader.ProductConfig"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   ������  2014/11/12
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//���������SQL���
	String sSql = "";
	//�����������ʾģ�����ơ��������͡��ݴ��־
	
	
	//���ҳ�����
	String objectType = CurPage.getParameter("ObjectType");//jbo.app.BUSINESS_APPLY
	String objectNo = CurPage.getParameter("ObjectNo");
	//����ֵת���ɿ��ַ���
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	
	BusinessObjectManager bomananger = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject businessApply = bomananger.keyLoadBusinessObject(objectType, objectNo);
	String businessType=businessApply.getString("BusinessType");
	String productID=businessApply.getString("ProductID");
	if(StringX.isEmpty(productID)) productID=businessType;
	BusinessObject product = ProductConfig.getProduct(businessType);
	String productType2 = product.getString("ProductType2");
	
	BusinessObject customer=bomananger.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", businessApply.getString("CustomerID"));
	List<BusinessObject> clcontractlist=bomananger.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", 
			"SerialNo in (select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.RelativeType in('06'))","ApplySerialNo",objectNo);
	BusinessObject clcontract=null;
	if(clcontractlist.size()>0) clcontract=clcontractlist.get(0);

	String templetNo = ProductAnalysisFunctions.getProductDefaultValues(businessApply, "CreditApplyObjectWindow", "", "02");
	if(StringX.isEmpty(templetNo)) throw new Exception("��Ʒ{"+productID+"}δ����¼��ģ�壡");
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("LoanType", businessApply.getString("LoanType"));
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	 if("RPT-06".equals(businessApply.getString("RptTermID"))){
		 ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct PayFrequencyType,PayFrequency,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:ObjectNo and RPTTermID='RPT-06'").setParameter("ObjectNo", objectNo));
		if(rs.next()){
			paymentFrequencyType = rs.getString("PayFrequencyType");
			paymentFrequencyTerm = rs.getString("PayFrequency");
			defaultDueDay = rs.getString("DefaultDueDay");
		}
		rs.close();
		if(paymentFrequencyType!=null&&paymentFrequencyType.length()>0)
			doTemp.setDefaultValue("PayFrequencyType", paymentFrequencyType);
		if(paymentFrequencyTerm!=null&&paymentFrequencyTerm.length()>0)
			doTemp.setDefaultValue("PayFrequency", paymentFrequencyTerm);
		if(defaultDueDay!=null&&defaultDueDay.length()>0)
			doTemp.setDefaultValue("DefaultDueDay", defaultDueDay);
	}
	
	dwTemp.Style="2";
	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();
	dwcontroller.initDataWindow(dwTemp,businessApply);
	if(clcontract != null){
		doTemp.setDDDWCode("VouchType", "VouchType");
		doTemp.setReadOnly("VouchType", true);
	}
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
		{"true","All","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()","","","",""}, 
		{"555".equals(businessType)? "false" : "true","All","Button","����ƻ�����","����ƻ�����","viewPayment()","","","",""}, 
		{"false","","Button","��ӡ������","��ӡ������","print()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>


<script type="text/javascript">
	function beforeSave(){
		if(rightType == "ReadOnly") return;
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		var currency = getItemValue(0,getRow(0),"BusinessCurrency");
		var termUnit = getItemValue(0,getRow(0),"BusinessTermUnit");
		var termMonth = getItemValue(0,getRow(0),"BusinessTerm");
		var termDay = getItemValue(0,getRow(0),"BusinessTermDay");
		var sum = getRowCount(subdwname);
		for(var i=0;i<sum;i++){
			var LoanRateTermID = getItemValue(0, getRow(0), "LoanRateTermID");
			var baseRateType = getItemValue(subdwname,i,"BaseRateType");
			var rateUnit = getItemValue(subdwname,i,"RateUnit");
			
			if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
			
			var baseRateGrade = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRateGrade","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
			if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
			setItemValue(subdwname,i,"BaseRateGrade",baseRateGrade);
			
			var baseRate = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.common.action.RateAction","getBaseRate","BaseRateType="+baseRateType+",RateUnit="+rateUnit+",Currency="+currency+",TermUnit="+termUnit+",TermMonth="+termMonth+",TermDay="+termDay);
			if(baseRate==0 || baseRate.length==0){
				alert("�����Ƿ��Ѿ�ά����׼���ʣ�");
				return;
			}
			setItemValue(subdwname,i,"BaseRate",baseRate);
			if(LoanRateTermID == "RAT03"){
				LoanRateTermID = getItemValue(subdwname,i,"RateMode");
			}
			var BusinessRate = getItemValue(subdwname,i,"BusinessRate");
			var RateFloat = getItemValue(subdwname,i,"RateFloat");
			if(LoanRateTermID == "RAT01" || LoanRateTermID == "1"){
				BusinessRate = baseRate*(1+RateFloat/100.0);
				setItemValue(subdwname, i, "BusinessRate", BusinessRate);
			}else if(LoanRateTermID == "RAT02" || LoanRateTermID == "2"){
				RateFloat = ((BusinessRate-baseRate)/baseRate)*100.0;
				setItemValue(subdwname, i, "RateFloat", RateFloat);
			}
		}
	}
	function print(){
		var ContractArtificialNo = getItemValue(0, getRow(), "ContractArtificialNo");
		AsControl.PopPage("/CreditManage/CreditApply/PrintSerialNo.jsp","ObjectNo="+ContractArtificialNo,"dialogWidth:400px;dialogHeight:80px;");
	}
	//ȫ�ֱ�����JS����Ҫ
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//¼��������Ч�Լ��
		if ( !ValidityCheck() ){
			return;	
		}
		var creditHLFlag = getItemValue(0, getRow(0), "CreditHLFlag");
		var HLRateFloat = getItemValue(0, getRow(0), "HLRATEFLOAT");
 		if(HLRateFloat == "") HLRateFloat=0;
 		if(creditHLFlag == "1" && parseFloat(HLRateFloat) < 20 ){
 			alert("ͬ�������Ӵ�ʱ�����ʸ������Ȳ��ܵ���20%");
			return;
		}
		beforeSave();
		beforeUpdate();
		setItemValue(0,getRow(),"TempSaveFlag","0"); //�ݴ��־��1���ǣ�0����
		if(checkRPTInfo()&&checkRateInfo())
			as_save();
	}

 	function checkMFCustomerID(){
		var businessType = getItemValue(0,getRow(0),"BUSINESSTYPE");
		var PaymentType = getItemValue(0, getRow(0), "PaymentType");
		if(businessType == "500" || businessType == "502" || businessType == "666"){
			var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ACT");
			var mfCustomerID = getItemValue(subdwname,getRow(0),"MFCustomerID");
			if(mfCustomerID != "<%=customer.getString("MFCustomerID")%>"){
				alert("������Ŀ��Ų��������������п��ţ�");
				setItemValue(subdwname, getRow(0), "AccountNo", "");
				setItemValue(subdwname, getRow(0), "AccountName", "");
				setItemValue(subdwname, getRow(0), "AccountNo1", "");
				setItemValue(subdwname, getRow(0), "MFCustomerID", "");
				return false;
			}
			
			if("502" == businessType)
			{
				var accountIndicator = getItemValue(subdwname, getRow(), "AccountIndicator");
				var accountType = getItemValue(subdwname, getRow(), "AccountType");
				var accountNo = getItemValue(subdwname, getRow(), "AccountNo");
				var accountName = getItemValue(subdwname, getRow(), "AccountName");
				var accountCurrency = getItemValue(subdwname, getRow(), "AccountCurrency");
				if(typeof(accountType) != "undefined" && accountType.length != 0 
					&& typeof(accountNo) != "undefined" && accountNo.length != 0){
					var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency+",0005");
					if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != "Null"){
						if(returnValue.split("@")[0] == "false"){
							alert("�ÿ���δ��ͨ����ר��������ʹ�á�");
							return false;
						}
					}
				}
			}
		}else if(PaymentType == "3"){ //����ר�������ǿͻ��Լ����˻�
			var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ATT");
			var mfCustomerID = getItemValue(subdwname,getRow(0),"MFCustomerID");
			if(mfCustomerID != "<%=customer.getString("MFCustomerID")%>" && mfCustomerID != ""){
				alert("������ķſ��˻���Ϣ�����ǽ���˱����˻���");
				setItemValue(subdwname, getRow(0), "AccountNo", "");
				setItemValue(subdwname, getRow(0), "AccountName", "");
				setItemValue(subdwname, getRow(0), "AccountNo1", "");
				setItemValue(subdwname, getRow(0), "MFCustomerID", "");
				return false;
			}
		}else if(PaymentType == "2") //ָ���˺� �����ǽ���˱����˻�
		{
			var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"ATT");
			var mfCustomerID = getItemValue(subdwname,getRow(0),"MFCustomerID");
			if(mfCustomerID == "<%=customer.getString("MFCustomerID")%>" && mfCustomerID != ""){
				alert("������ķſ��˻���Ϣ�����ǽ���˱��ˡ�");
				setItemValue(subdwname, getRow(0), "AccountNo", "");
				setItemValue(subdwname, getRow(0), "AccountName", "");
				setItemValue(subdwname, getRow(0), "AccountNo1", "");
				setItemValue(subdwname, getRow(0), "MFCustomerID", "");
				return false;
			}
		}
		return true;
	}
 	
 	function ChangeCreditHLFlag(){
 		var creditHLFlag = getItemValue(0, getRow(0), "CreditHLFlag");
 		if(creditHLFlag == "1"){
 			showItem(0,"HLRATEFLOAT");
 			setItemRequired("myiframe0", "HLRATEFLOAT", true);
 			setItemValue(0,getRow(),"HLRATEFLOAT","20");
		}else{
			hideItem(0,"HLRATEFLOAT");
			setItemRequired("myiframe0", "HLRATEFLOAT", false);
			setItemValue(0,getRow(),"HLRATEFLOAT","");
		}
 	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
			setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
			checkRPTInfo();checkRateInfo();
			as_saveTmp("myiframe0");   //�ݴ�
	}		
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getBusinessDate()%>");	
		var year = getItemValue(0, getRow(0), "BusinessTermYear");
		if(parseFloat(year) < 1 ){
			setItemValue(0,0,"CreditHLFlag","0");
			setItemValue(0,0,"HLRATEFLOAT","0");
		}else{
			setItemValue(0,0,"CreditHLFlag","1");
			setItemValue(0,0,"HLRATEFLOAT","20");
		}
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		if(!checkMFCustomerID()) return false;
		return true;
	}
	function changeMaturityDate(){
		var maturityDate = getItemValue(0, getRow(0), "MATURITYDATE");
		if(maturityDate<="<%=DateHelper.getBusinessDate()%>"){
			alert("��ȵ����ձ������ڵ�ǰ���ڣ�");
			setItemValue(0,0,"MATURITYDATE", "");
		}
		<%if(clcontract!=null){%>
			if(maturityDate>="<%=clcontract.getString("MaturityDate")%>"){
				alert("��ȵ����ձ������ڹ�����ȵ����գ�");
				setItemValue(0,0,"MATURITYDATE", "");
			}
		<%}%>
	}
	
	function viewPayment(){
		saveRecord();
		var tempSaveFlag = getItemValue(0, getRow(0), "TempSaveFlag");
		if(tempSaveFlag == "0"){
			var serialNo = getItemValue(0, getRow(0), "SERIALNO");
			AsControl.PopComp("/Accounting/Simulation/ApplySimulation.jsp","ApplySerialNo="+serialNo);
		}else
			alert("����ǰ���ȱ�������!");
	}
	ChangeCreditHLFlag();
</script>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "<%=objectType%>";
	var objectNo = "<%=objectNo%>";
	var loanType = "<%=businessApply.getString("LoanType")%>";
	$(document).ready(function(){
		calcExceptReason();
		calcBillMail();
		changePaymentType();

		initRepriceType();
		initBusinessRate();
		setFineRateType();
		initATT();
		showReverseFund();
		setFineRateType();
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
