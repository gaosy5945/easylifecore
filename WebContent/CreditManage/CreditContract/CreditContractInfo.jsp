<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions"%>
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

	
	//处理额度信息
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

	String CLContractNo = Sqlca.getString(new SqlObject("select ObjectNo as CLObjectNo,ObjectType as CLObjectType from CONTRACT_RELATIVE where ContractSerialNo=:ContractSerialNo and ObjectType = 'jbo.app.BUSINESS_CONTRACT' and RelativeType in('06')").setParameter("ContractSerialNo", objectNo));
	
	BusinessObjectManager bomananger = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject businessContract = bomananger.keyLoadBusinessObject(objectType, objectNo);
	String businessType = businessContract.getString("BusinessType");
	String loanType = businessContract.getString("LoanType");
	String rptTermID = businessContract.getString("RptTermID");
	String dataSource = businessContract.getString("DataSource");
	String productID=businessContract.getString("ProductID");
	if(StringX.isEmpty(productID)) productID=businessType;
	
	String templetNo = ProductAnalysisFunctions.getProductDefaultValues(businessContract, "CreditContractObjectWindow", "", "02");
	if(StringX.isEmpty(templetNo)) throw new Exception("产品{"+productID+"}未定义录入模板！");
	
	
	
	
	//获取合同对应借据信息
	ASResultSet deRS = Sqlca.getASResultSet(new SqlObject("select BusinessStatus from BUSINESS_DUEBILL where ContractSerialNo=:ContractSerialNo").setParameter("ContractSerialNo", objectNo));
	String businessStatus = "B0";
	if(deRS.next())
	{
		businessStatus = deRS.getString("BusinessStatus");
	}
	deRS.close();
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType",objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("SerialNo", objectNo);
	inputParameter.setAttributeValue("LoanType", loanType);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	if("RPT-06".equals(rptTermID)){
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct PayFrequencyType,PayFrequency,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType='jbo.app.BUSINESS_CONTRACT' and ObjectNo=:ObjectNo").setParameter("ObjectNo", objectNo));
		if(rs.next())
		{
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
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("AccountInfo","<iframe type='iframe' id=\"AccountsPart\" name=\"AccountsPart\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?Status=0&ObjectType="+objectType+"&ObjectNo="+objectNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">
	//全局变量，JS中需要
	var userId="<%=CurUser.getUserID()%>";
	var orgId="<%=CurUser.getOrgID()%>";
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//录入数据有效性检查
		if ( !ValidityCheck() ){
			return;	
		}
		beforeUpdate();
		setItemValue(0,getRow(),"TempSaveFlag","0"); //暂存标志（1：是；0：否）
		as_save();
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp()
	{
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；0：否）
		as_saveTmp("myiframe0");   //暂存
	}		
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateDate","<%=DateHelper.getBusinessDate()%>");					
	}
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		return true;
	}
	function ChangeCreditHLFlag(){
 		var creditHLFlag = getItemValue(0, getRow(0), "CreditHLFlag");
 		if(creditHLFlag == "1"){
 			showItem(0,"HLRATEFLOAT");
		}else{
			hideItem(0,"HLRATEFLOAT");
		}
 	}
	ChangeCreditHLFlag();
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
		if("B0" != "<%=businessStatus%>"  && "GD" == "<%=dataSource%>")
		{
			AsCredit.hideOWGroupItem("0030");
			AsCredit.hideOWGroupItem("0020");
		}
		
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
