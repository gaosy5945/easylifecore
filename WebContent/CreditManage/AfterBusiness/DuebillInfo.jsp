<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String duebillSerialNo = CurPage.getParameter("DuebillSerialNo");
	if(duebillSerialNo == null) duebillSerialNo = "";
	CurPage.setAttribute("RightType", "ReadOnly");

	/* String sTempletNo = "QueryDuebillInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(duebillSerialNo); */
	
	String businessType = "",customerID = "",loanType = "",rptTermID="";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BusinessType,CustomerID,LoanType,RptTermID from BUSINESS_DUEBILL where SerialNo=:SerialNo").setParameter("SerialNo", duebillSerialNo));
	if(rs.next())
	{
		businessType = rs.getString("BusinessType");
		customerID = rs.getString("CustomerID");
		loanType = rs.getString("LoanType");
		rptTermID = rs.getString("RptTermID");
	}
	rs.close();
	
	String sTempletNo = "DuebillInfo";//--模板号--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SERIALNO", duebillSerialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	if("RPT-06".equals(rptTermID)){
		rs = Sqlca.getASResultSet(new SqlObject("select distinct PaymentFrequencyType,PaymentFrequencyTerm,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType='jbo.app.BUSINESS_DUEBILL' and ObjectNo=:ObjectNo").setParameter("ObjectNo", duebillSerialNo));
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
	
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	//doTemp.setVisible("RPT,FIN,ACT", true);

	dwTemp.Style="2";  
	dwTemp.ReadOnly = "-2";//只读模式

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "jbo.app.BUSINESS_DUEBILL";
	var objectNo = "<%=duebillSerialNo%>";
	
	function initRateFloat(){
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
	   	var rateFloatType = getItemValue(subdwname,getRow(subdwname),"RateFloatType");
	   	if(typeof(rateFloatType) == "undefined" || rateFloatType.length == 0){
	   		return;
	   	}
	   	var loanRate = getItemValue(subdwname,getRow(subdwname),"BusinessRate");
	   	var rateFloat = getItemValue(subdwname,getRow(subdwname),"RateFloat");
	   	
	   	var baseRate = parseFloat(loanRate)/(1+parseFloat(rateFloat)/100.0);
	   	setItemValue(subdwname,getRow(subdwname),"BaseRate",Math.round(baseRate*100)/100.0);
	}
	
	$(document).ready(function(){
		initRateFloat();
		setFineRateType();
		try{
		initATT();
		}catch(e){}
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
