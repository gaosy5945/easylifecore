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
	String serialNo = CurPage.getParameter("RelativeObjectNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
	
	String currency="",businessType ="", bcSerialNo="",productId="",businessTermUnit="",loanType="";
	int termMonth = 0,termDay=0;
	BizObjectManager bm = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_DUEBILL" );
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo).getSingleResult(false);
	if(bo!=null){
		bcSerialNo=bo.getAttribute("CONTRACTSERIALNO").getString();
		currency=bo.getAttribute("BUSINESSCURRENCY").getString();	
		businessType=bo.getAttribute("BUSINESSTYPE").getString();
		String marutriydate = bo.getAttribute("MATURITYDATE").getString();
		String putoutdate = bo.getAttribute("PUTOUTDATE").getString();
		loanType = bo.getAttribute("LOANTYPE").getString();
		termMonth = DateHelper.getMonths(putoutdate, marutriydate);
		termDay = DateHelper.getDays(DateHelper.getRelativeDate(putoutdate, DateHelper.TERM_UNIT_MONTH, termMonth), marutriydate);
	}
	BizObjectManager bc = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT" );
	BizObject bo1= bc.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bcSerialNo).getSingleResult(false);
	if(bo1!=null){
		productId=bo1.getAttribute("PRODUCTID").getString();
		businessTermUnit=bo1.getAttribute("BUSINESSTERMUNIT").getString();
	}
	

	String sTempletNo = "ChangeLoanRate";//--ģ���--
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TransSerialNo", transSerialNo);
	inputParameter.setAttributeValue("LoanType", bo.getAttribute("LoanType").getString());
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.als.credit.dwhandler.ChangeLoanRateProcess");


	dwTemp.Style="2";   

	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	/*
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setHtmlEvent("LOANRATETERMID", "onClick", "onChangeRate", "");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("TransSerialNo", transSerialNo);
	
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.replaceColumn("OLDLOANRATETERMINFO","<iframe type='iframe' id=\"OldRatePart\" name=\"OldRatePart\" width=\"100%\" height=\"100\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>",CurPage.getObjectWindowOutput());
	
	//dwTemp.replaceColumn("LOANRATETERMINFO","<iframe type='iframe' id=\"RatePart\" name=\"RatePart\" width=\"100%\" height=\"100\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>",CurPage.getObjectWindowOutput());
	*/
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<script type="text/javascript">

	function saveRecord(){
		if(checkRateInfo())
			as_save(0);
	}
	
	//�����׼���ʣ���ҳ��¼�뿪ʼʱ�䡢����ʱ�䡢��׼��������
	function initBaseRate(){
		var currency = "<%=currency%>";
		var termUnit = "<%=businessTermUnit%>";
		var termMonth = "<%=termMonth%>";
		var termDay = "<%=termDay%>";

		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
		if(subdwname==-1)return;
		
		var subdwname1 = ALSObjectWindowFunctions.getSubObjectWindowName(0,"OLDRAT");
		if(subdwname1==-1)return;
		
		var businessRate = getItemValue(subdwname1,getRow(subdwname1),"BusinessRate");
		var ratefloat = getItemValue(subdwname1,getRow(subdwname1),"RateFloat");
		var baseRate = Math.round(parseFloat(businessRate)/(1+parseFloat(ratefloat)/100.0) * 1000000.0)/1000000.0;
		setItemValue(subdwname,getRow(subdwname),"BaseRate",baseRate);
	}

	var rightType="<%=CurPage.getParameter("RightType")%>";
	var objectType="jbo.acct.ACCT_LOAN_CHANGE";
	var objectNo= getItemValue(0,getRow(),"SerialNo");
	var loanType = "<%=loanType%>";
	$(document).ready(function(){
		setItemValue(0,getRow(0),"BusinessTerm","<%=termMonth%>");
		setItemValue(0,getRow(0),"BusinessTermDay","<%=termDay%>");
		setItemValue(0,getRow(0),"BusinessTermUnit","<%=businessTermUnit%>");
		setItemValue(0,getRow(0),"BusinessCurrency","<%=currency%>");
		initRepriceType();
		initBusinessRate();
		initFinbaseRateType(loanType);
		setFineRateType();
	});
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
