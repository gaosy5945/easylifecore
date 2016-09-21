<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.DateX"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<style>
	.modify_div{
		position: absolute;
		top:10px;
		right:15px;
	}
</style>
<%
	//获得页面参数	
	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");

	//将空值转化成空字符串
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	
	String bcSerialNo="",maturityDate="",rptTermID="",productID = "";
	BizObjectManager bp = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_PUTOUT" );
	BizObject bo= bp.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", objectNo).getSingleResult(false);
	if(bo!=null){
		bcSerialNo=bo.getAttribute("CONTRACTSERIALNO").getString();
		rptTermID=bo.getAttribute("RptTermID").getString();
		productID = bo.getAttribute("ProductID").getString();
		if(StringX.isEmpty(productID)) productID = bo.getAttribute("BusinessType").getString();
	}
	BizObjectManager bc = JBOFactory.getBizObjectManager( "jbo.app.BUSINESS_CONTRACT" );
	BizObject bo1= bc.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bcSerialNo).getSingleResult(false);
	if(bo1!=null){
		maturityDate=bo1.getAttribute("MATURITYDATE").getString();
	}
	
	
	String templetNo = ProductAnalysisFunctions.getProductDefaultValues(BusinessObject.convertFromBizObject(bo), "CreditPutoutObjectWindow", "", "02");
	if(StringX.isEmpty(templetNo)) throw new Exception("产品{"+productID+"}未定义录入模板！");
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("SerialNo", objectNo);
	inputParameter.setAttributeValue("LoanType", bo.getAttribute("LoanType").getString());
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	String paymentFrequencyType = "",paymentFrequencyTerm="",defaultDueDay="";
	if("RPT-06".equals(rptTermID)){
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select distinct PayFrequencyType,PayFrequency,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType='jbo.app.BUSINESS_PUTOUT' and ObjectNo=:ObjectNo").setParameter("ObjectNo", objectNo));
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
	
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	doTemp.setVisible("RPT,RAT,FIN,SPT,FEE,ATT,HZXM,ATZ,ACT", true);
	dwTemp.Style="2";
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");

	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},

	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var BusinessSum = getItemValue(0,getRow(0),"BusinessSum");
		if(parseFloat(BusinessSum) <= 0.00){
			alert("放款金额必须大于0！");
			return;
		}
		var maturityDate = getItemValue(0, getRow(0), "MATURITYDATE");
		var PutOutDate = getItemValue(0, getRow(0), "PutOutDate");
		if(maturityDate<="<%=DateHelper.getBusinessDate()%>"){
			alert("额度到期日必须晚于当前日期！");
			setItemValue(0,0,"MATURITYDATE", "");
			return;
		}else if(maturityDate<=PutOutDate){
			alert("贷款到期日必须晚于贷款起始日！");
			setItemValue(0,0,"MATURITYDATE", "");
			return;
		}
		var ContractArtificialNo = getItemValue(0,getRow(0),"ContractArtificialNo");
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckBusinessSum",ContractArtificialNo+","+SerialNo+","+BusinessSum);
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return;
		}
		as_save();
	}
</script>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "<%=objectType%>";
	var objectNo = "<%=objectNo%>";
	$(document).ready(function(){
		var putOutDate = getItemValue(0,getRow(),"PutOutDate");
		if(putOutDate == "" || putOutDate == null){
			setItemValue(0,0,"PutOutDate","<%=DateHelper.getBusinessDate()%>");
		}
		var maturityDate = "<%=maturityDate%>";
		if(maturityDate != "" && maturityDate != null && !maturityDate ){

			setItemValue(0,0,"MaturityDate",maturityDate);
		}
		changePaymentType();
		initTerm();
		//initATT();
		initMaturity();
		initRepriceType();
		initBusinessRate();
		setFineRateType();
		checkAccount('ACT','AccountIndicator','AccountType','AccountNo','AccountName','AccountCurrency','AccountNo1','CustomerID','MFCustomerID');
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
