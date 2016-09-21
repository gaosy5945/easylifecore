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
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String serialNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(serialNo == null) serialNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";

	
	String currency="",businessType ="", bcSerialNo="",productId="";
	double balance=0d,businesssum=0d;
	int businessterm=0;
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_DUEBILL" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo).getSingleResult(false);
	if(bo!=null){
		bcSerialNo=bo.getAttribute("CONTRACTSERIALNO").getString();
		currency=bo.getAttribute("BUSINESSCURRENCY").getString();	
		businessType=bo.getAttribute("BUSINESSTYPE").getString();
		balance=bo.getAttribute("Balance").getDouble();
		businesssum=bo.getAttribute("BusinessSum").getDouble();
		String maturityDate=bo.getAttribute("MATURITYDATE").getString();	
		String putoutDate=bo.getAttribute("PUTOUTDATE").getString();
		
		businessterm = DateHelper.getMonths(putoutDate, maturityDate);
	}
	BizObjectManager bc = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT" );
	BizObject bo1= bc.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bcSerialNo).getSingleResult(false);
	if(bo1!=null){
		productId=bo1.getAttribute("PRODUCTID").getString();
		//businessterm=bo1.getAttribute("BusinessTerm").getInt();
	}
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject loanchange = bom.loadBusinessObject(objectType, objectNo);
	String rptTermID = loanchange.getString("RPTTermID");
	String oldrptTermID = loanchange.getString("OLDRPTTERMID");

	String sTempletNo = "ChangeRepayType";//--模板号--
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TransSerialNo", transSerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.credit.dwhandler.ChangeRepayTypeProcess");
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	if("RPT-06".equals(rptTermID)){
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct PaymentFrequencyType,PaymentFrequencyTerm,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType=:ObjectType and ObjectNo=:ObjectNo and status<>'2' and RPTTermID='RPT-06'").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
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
	
	if("RPT-06".equals(oldrptTermID)){
		String oldPaymentFrequencyType="",oldPaymentFrequencyTerm="",oldDefaultDueDay="";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct PaymentFrequencyType,PaymentFrequencyTerm,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType=:ObjectType and ObjectNo=:ObjectNo and status='2' and RPTTermID='RPT-06'").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType));
		if(rs.next())
		{
			oldPaymentFrequencyType = rs.getString("PaymentFrequencyType");
			oldPaymentFrequencyTerm = rs.getString("PaymentFrequencyTerm");
			oldDefaultDueDay = rs.getString("DefaultDueDay");
		}
		rs.close();
		if(oldPaymentFrequencyType!=null&&oldPaymentFrequencyType.length()>0)
			doTemp.setDefaultValue("OldPaymentFrequencyType", oldPaymentFrequencyType);
		if(oldPaymentFrequencyTerm!=null&&oldPaymentFrequencyTerm.length()>0)
			doTemp.setDefaultValue("OldPaymentFrequencyTerm", oldPaymentFrequencyTerm);
		if(oldDefaultDueDay!=null&&oldDefaultDueDay.length()>0)
			doTemp.setDefaultValue("OldDefaultDueDay", oldDefaultDueDay);
	}
	
	doTemp.setDefaultValue("BUSINESSSUM", String.valueOf(balance));
	doTemp.setDefaultValue("BUSINESSTERM", String.valueOf(businessterm));
	
	dwTemp.Style="2";   

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<script type="text/javascript">
	var objectType="jbo.acct.ACCT_LOAN_CHANGE";
	var objectNo= getItemValue(0,getRow(),"SerialNo");
	
	function saveRecord(){
		if(checkRPTInfo())
			as_save();
	}
	
	function changeOldPaymentType(){
		var oldRpttermID = getItemValue(0,getRow(0),"OLDRPTTERMID");
		if(oldRpttermID=="RPT-06"){//组合还款时显示
			ALSObjectWindowFunctions.showItems(0,"oldPaymentFrequencyType,oldPaymentFrequencyTerm,oldDefaultDueDay");
		
			var paymentFrequencyType=getItemValue(0,getRow(0),"oldPaymentFrequencyType");
			if(typeof(paymentFrequencyType) == "undefined" || paymentFrequencyType == ""||paymentFrequencyType !="99"){
				ALSObjectWindowFunctions.hideItems(0,"oldPaymentFrequencyTerm");
				setItemValue(0, getRow(0), "oldPaymentFrequencyTerm", "");
				ALSObjectWindowFunctions.setItemsRequired(0,"oldPaymentFrequencyType,oldDefaultDueDay",true);
				ALSObjectWindowFunctions.setItemsRequired(0,"oldPaymentFrequencyTerm",false);
			}
			else{
				ALSObjectWindowFunctions.showItems(0,"oldPaymentFrequencyTerm");
				ALSObjectWindowFunctions.setItemsRequired(0,"oldPaymentFrequencyType,oldPaymentFrequencyTerm,oldDefaultDueDay",true);
			}
		}
		else
		{
			ALSObjectWindowFunctions.hideItems(0,"oldPaymentFrequencyType,oldPaymentFrequencyTerm,oldDefaultDueDay");
		}
		
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"OLDRPT");
		var paymentFrequencyType=getItemValue(subdwname,getRow(subdwname),"PaymentFrequencyType");
		if(typeof(paymentFrequencyType) == "undefined" || paymentFrequencyType == "" || paymentFrequencyType == null)return;
		if(paymentFrequencyType =="99"){
			ALSObjectWindowFunctions.showItems(subdwname,"PaymentFrequencyTerm");
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"PaymentFrequencyTerm", true);
		}else{
			ALSObjectWindowFunctions.hideItems(subdwname,"PaymentFrequencyTerm");
			ALSObjectWindowFunctions.setItemsRequired(subdwname,"PaymentFrequencyTerm", false);
		}	
		
	}
	
	$(document).ready(function(){
		changeOldPaymentType();
		changePaymentType();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
