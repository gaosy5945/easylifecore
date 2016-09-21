<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";

	//String sTempletNo = "ContractInfo0010";//--ģ���--
	String sTempletNo = "";
	
	
	//��������Ϣ
	String CLType = Sqlca.getString(new SqlObject("select CLType from CL_INFO where ObjectType = :ObjectType and ObjectNo = :ObjectNo and CLType IN('0101','0102','0103','0104','0107','0108')").setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo));
	
	if(CLType != null)
	{
		com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", CLType);
		String className = item.getItemDescribe();
		if(className != null)
		{
			Class c = Class.forName(className);
			com.amarsoft.app.als.cl.CreditObject co = (com.amarsoft.app.als.cl.CreditObject)c.newInstance();
			co.load(Sqlca.getConnection(), objectType, objectNo);
			co.calcBalance();
			co.saveData(Sqlca.getConnection());
			Sqlca.commit();
		}
	}

	String CLContractNo = Sqlca.getString(new SqlObject("select ObjectNo as CLObjectNo,ObjectType as CLObjectType from CONTRACT_RELATIVE where ContractSerialNo=:ContractSerialNo and ObjectType = 'jbo.app.BUSINESS_CONTRACT_HS' and RelativeType in('06')").setParameter("ContractSerialNo", objectNo));
	
	String businessType="",loanType="",rptTermID="",dataSource = "";
	ASResultSet rs= Sqlca.getASResultSet(new SqlObject("select BusinessType,LoanType,RptTermID,DataSource from BUSINESS_CONTRACT_HS where SerialNo=:SerialNo").setParameter("SerialNo", objectNo));
	if(rs.next())
	{
		businessType = rs.getString("BusinessType");
		loanType = rs.getString("LoanType");
		rptTermID = rs.getString("RptTermID");
		dataSource = rs.getString("DataSource");
	}
	rs.close();
	
 	rs = Sqlca.getASResultSet(new SqlObject("select ProductType2 as ProductType2,ProductType3 as ProductType3 from PRD_PRODUCT_LIBRARY WHERE Status in('1','0') and ProductID=:ProductID").setParameter("ProductID", businessType));
	String productType2 = "",productType3="";
	if(rs.next())
	{
		productType2 = rs.getString("ProductType2");
		productType3 = rs.getString("ProductType3");
	}
	rs.close();
	
	
	if("01".equals(productType3))
	{
		if("2".equals(productType2))
		{
			sTempletNo = "HistoryContractCLInfo0010";
		}
		else
		{
			sTempletNo = "HistoryContractInfo0030";
		}
	}else{
		sTempletNo = "HistoryContractInfo0020";
	}
	if("500".equals(businessType))
	{
		sTempletNo = "HistoryContractRZInfo0010";
	}
	if("502".equals(businessType))
	{
		sTempletNo = "HistoryContractRZInfo0020";
	}
	if("666".equals(businessType))
	{
		sTempletNo = "HistoryContractCLInfo0020";
	}
	if("888".equals(businessType))
	{
		sTempletNo = "HistoryContractCLInfo888";
	}
	
	//���ڷ�����ҵ���ģ��ѡ��
	if("001,002,100,034,035,101,102,032,033,100".indexOf(businessType)>=0){
		sTempletNo = "HistoryContractInfo0040";
	}
	if("301".equals(businessType)){
		sTempletNo = "HistoryContractInfoPOS";
	}
	//��ȡ��ͬ��Ӧ�����Ϣ
	ASResultSet deRS = Sqlca.getASResultSet(new SqlObject("select BusinessStatus from BUSINESS_DUEBILL_HS where ContractSerialNo=:ContractSerialNo").setParameter("ContractSerialNo", objectNo));
	String businessStatus = "B0";
	if(deRS.next())
	{
		businessStatus = deRS.getString("BusinessStatus");
	}
	deRS.close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType",objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("SerialNo", objectNo);
	inputParameter.setAttributeValue("LoanType", loanType);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	if("RPT-06".equals(rptTermID)){
		rs = Sqlca.getASResultSet(new SqlObject("select distinct PaymentFrequencyType,PaymentFrequencyTerm,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType='jbo.app.BUSINESS_CONTRACT_HS' and ObjectNo=:ObjectNo").setParameter("ObjectNo", objectNo));
		if(rs.next())
		{
			paymentFrequencyType = rs.getString("PaymentFrequencyType");
			paymentFrequencyTerm = rs.getString("PaymentFrequencyTerm");
			defaultDueDay = rs.getString("DefaultDueDay");
		}
		rs.close();
		if(paymentFrequencyType!=null&&paymentFrequencyType.length()>0)
			doTemp.setDefaultValue("PaymentFrequencyType", paymentFrequencyType);
		if(paymentFrequencyTerm!=null&&paymentFrequencyTerm.length()>0)
			doTemp.setDefaultValue("PaymentFrequencyTerm", paymentFrequencyTerm);
		if(defaultDueDay!=null&&defaultDueDay.length()>0)
			doTemp.setDefaultValue("DefaultDueDay", defaultDueDay);
	}
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("AccountInfo","<iframe type='iframe' id=\"AccountsPart\" name=\"AccountsPart\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?Status=0&ObjectType="+objectType+"&ObjectNo="+objectNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
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
		beforeUpdate();
		setItemValue(0,getRow(),"TempSaveFlag","0"); //�ݴ��־��1���ǣ�0����
		as_save();
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�0����
		as_saveTmp("myiframe0");   //�ݴ�
	}		
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getToday()%>");					
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		return true;
	}
</script>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "<%=objectType%>";
	var objectNo = "<%=objectNo%>";
	$(document).ready(function(){
		calcExceptReason();
		calcBillMail();
		changePaymentType();

		initRepriceType();
		initBusinessRate();
		setFineRateType();
		initATT();
		showReverseFund();
		//checkAccount('ACT','AccountIndicator','AccountType','AccountNo','AccountName','AccountCurrency','AccountNo1','CustomerID','MFCustomerID');

		
		try{
			if("GD" != "<%=dataSource%>"){
			hideItem(0, "JYCLSUM");
			hideItem(0, "JYCLSUMUSE");
			hideItem(0, "XFCLSUM");
			hideItem(0, "XFCLSUMUSE");
			}
		}catch(e){}
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
