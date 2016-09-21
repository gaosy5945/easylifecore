<%@page import="com.amarsoft.app.als.credit.approve.action.AddApproveInfo"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
    String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
    String objectNo = CurPage.getParameter("ObjectNo");
    String objectType = CurPage.getParameter("ObjectType");
    String phaseNo = CurPage.getParameter("PhaseNo");
    if(objectNo == null) objectNo = "";
    if(objectType == null) objectType = "";
    
    String approveSerialNo="";
    JBOTransaction tx = null;
    try
    {
    	tx = JBOFactory.createJBOTransaction();
	    AddApproveInfo approveInfo = new AddApproveInfo();
	    approveInfo.setApplySerialNo(objectNo);
	    approveInfo.setOrgID(CurUser.getOrgID());
	    approveInfo.setUserID(CurUser.getUserID());
	    approveInfo.setTaskSerialNo(taskSerialNo);
	    approveInfo.setPhaseNo(phaseNo);
	    approveInfo.setFlowSerialNo(flowSerialNo);
	    approveSerialNo = approveInfo.createContract(tx);
	    tx.commit();
    }catch(Exception ex)
    {
    	tx.rollback();
    	throw ex;
    }
    BusinessObjectManager bomananger = BusinessObjectManager.createBusinessObjectManager();
    BusinessObject businessApprove = bomananger.loadBusinessObject("jbo.app.BUSINESS_APPROVE", approveSerialNo);

    String productID="",businessType = "",loanType="";
    double businessSum = 0.0d;
    int businessTerm = 0,businessTermDay=0;
    String maturityDate = "",rptTermID = "",loanRateTermID = "";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ProductID,BusinessType,LoanType,BusinessSum,BusinessTerm,BusinessTermDay,MaturityDate,RPTTermID,LoanRateTermID from BUSINESS_APPLY where SerialNo=:SerialNo").setParameter("SerialNo", objectNo));
    if(rs.next())
    {
    	productID = rs.getString("ProductID");
    	businessApprove.setAttributeValue("ProductID", productID);
    	businessType = rs.getString("BusinessType");
    	businessApprove.setAttributeValue("BusinessType", businessType);
    	loanType = rs.getString("LoanType");
    	businessSum = rs.getDouble("BusinessSum");
    	businessTerm = rs.getInt("BusinessTerm");
    	businessTermDay = rs.getInt("BusinessTermDay");
    	maturityDate = rs.getString("MaturityDate");
    	if(maturityDate == null) maturityDate = "";
    	rptTermID = rs.getString("RPTTermID");
    	loanRateTermID = rs.getString("LoanRateTermID");
    }
    rs.close();
    
    //还款方式
    String gainCyc="",paymentFrequencyTerm="",segTerm="";
    String gainAmount = "",segRPTAmount="";
    String paymentFrequencyType = "",defaultDueDayType="",defaultDueDay="";
    
    rs = Sqlca.getASResultSet(new SqlObject("select * from ACCT_RPT_SEGMENT where ObjectNo=:ObjectNo and ObjectType=:ObjectType and TermID=:RPTTermID order by SegToStage").setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("RPTTermID", rptTermID));
    if(rs.next())
    {
    	gainCyc = DataConvert.toString(rs.getString("GainCyc"));
    	paymentFrequencyTerm = DataConvert.toString(rs.getString("PayFrequency"));
    	segTerm = DataConvert.toString(rs.getString("SegTerm"));
    	gainAmount = DataConvert.toString(rs.getString("GainAmount"));
    	segRPTAmount = DataConvert.toString(rs.getString("SegRPTAmount"));
    	paymentFrequencyType = DataConvert.toString(rs.getString("PayFrequencyType"));
    	defaultDueDay = DataConvert.toString(rs.getString("DefaultDueDay"));
    }
    rs.close();
    
    //利率信息
    String rateMode="",segToStage="",rateFloat = "",businessRate="",repriceType="",repriceDate="";
    rs = Sqlca.getASResultSet(new SqlObject("select * from ACCT_RATE_SEGMENT where ObjectNo=:ObjectNo and ObjectType=:ObjectType and RateType=:RateType and TermID=:RateTermID order by SegToStage").setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("RateType", "01").setParameter("RateTermID", loanRateTermID));
    if(rs.next())
    {
    	rateMode = DataConvert.toString(rs.getString("TERMID"));
    	segToStage = DataConvert.toString(rs.getString("SegToStage"));
    	rateFloat = DataConvert.toString(rs.getString("RateFloat"));
    	businessRate = DataConvert.toString(rs.getString("BusinessRate"));
    	repriceType = DataConvert.toString(rs.getString("RepriceType"));
    	repriceDate = DataConvert.toString(rs.getString("DefaultRepriceDate"));
    }
    rs.close();
    
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("TASKSERIALNO", taskSerialNo);
	inputParameter.setAttributeValue("APPLYSERIALNO", objectNo);
	inputParameter.setAttributeValue("LoanType", loanType);
	String sTempletNo = "";//--模板号--
	
	
	if("500".equals(businessType) || "502".equals(businessType) || "666".equals(businessType))
	{
		sTempletNo = "CreditApproveGroupInfo0030";
	}
	else if("555".equals(businessType))
	{
		sTempletNo = "CreditApproveGroupInfo0020";
	}
	else
	{
		sTempletNo = "CreditApproveGroupInfo0010";
	}
	
    
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	
	 if("RPT-06".equals(businessApprove.getString("RptTermID"))){
		String paymentFrequencyType1 = "",paymentFrequencyTerm1="",defaultDueDay1="";
		rs = Sqlca.getASResultSet(new SqlObject("select distinct PayFrequencyType,PaymentFrequency,DefaultDueDay from ACCT_RPT_SEGMENT WHERE ObjectType=:ObjectType and ObjectNo=:ObjectNo and TermID='RPT-06'").setParameter("ObjectType", businessApprove.getBizClassName()).setParameter("ObjectNo", businessApprove.getKeyString()));
		if(rs.next()){
			paymentFrequencyType1 = rs.getString("PayFrequencyType");
			paymentFrequencyTerm1 = rs.getString("PayFrequency");
			defaultDueDay1 = rs.getString("DefaultDueDay");
		}
		rs.close();
		if(paymentFrequencyType1!=null&&paymentFrequencyType1.length()>0)
			doTemp.setDefaultValue("PaymentFrequencyType", paymentFrequencyType1);
		if(paymentFrequencyTerm1!=null&&paymentFrequencyTerm1.length()>0)
			doTemp.setDefaultValue("PaymentFrequencyTerm", paymentFrequencyTerm1);
		if(defaultDueDay1!=null&&defaultDueDay1.length()>0)
			doTemp.setDefaultValue("DefaultDueDay", defaultDueDay1);
	}
	
	
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";   

	DefaultObjectWindowController dwcontroller = new DefaultObjectWindowController();
	dwcontroller.initDataWindow(dwTemp,businessApprove);
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	
	function saveRecord()
	{
		beforeSave();
		changeFlag();
		if(checkRPTInfo()&&checkRateInfo())
			as_save();
	}
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
				alert("请检查是否已经维护基准利率！");
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
	function back(){
		AsControl.OpenPage("/CreditManage/CreditApprove/CreditApproveGroupList.jsp","",'_self','');
	}
	function SelectPutoutClause(){
		var codeNo = "PutoutClause";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","0",getRow(),"","putOutClause");
	}
	function SelectAfterRequirement(){
		var codeNo = "AfterRequirement";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","0",getRow(),"","AfterRequirement");
	}
	function SelectSpecialArgeement(){
		var codeNo = "SpecialArgeement";
		AsCredit.setMultipleTreeValue("SelectCode", "CodeNo,"+codeNo, "", "","0",getRow(),"","SpecialArgeement");
	}
   	setItemValue(0,getRow(),"APPLYSERIALNO","<%=objectNo%>");
    setItemValue(0,getRow(),"TASKSERIALNO","<%=taskSerialNo%>");
    
    //判断输入信息变化情况
    function changeFlag()
    {
    	var businessSum = <%=businessSum%>;
    	var businessTerm = <%=businessTerm%>;
    	var businessTermDay = <%=businessTermDay%>;
    	var maturityDate = "<%=maturityDate%>";
    	var rptTermID = "<%=rptTermID%>";
    	var loanRateTermID = "<%=loanRateTermID%>";
    	
    	var nBusinessSum = getItemValue(0,getRow(),"BusinessSum");
    	var nBusinessTerm = getItemValue(0,getRow(),"BusinessTerm");
    	var nBusinessTermDay = getItemValue(0,getRow(),"BusinessTermDay");
    	var nmaturityDate = getItemValue(0,getRow(),"MaturityDate");
    	var nRPTTermID = getItemValue(0,getRow(),"RPTTermID");
    	var nLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
    	var style = "<span style=\"COLOR: #0000FF\">  <DELETED><B>已调整</B></DELETED></span>";
    	try{
	    	if(parseFloat(businessSum) != parseFloat(nBusinessSum))
	    	{
	    		setItemUnit(0,0,"BusinessSum",style);
	    	}
	    	else
	    	{
	    		setItemUnit(0,0,"BusinessSum","");
	    	}
    	}catch(e){}
    	
    	try{
	    	if(parseFloat(businessTerm) != parseFloat(nBusinessTerm) || parseFloat(businessTermDay) != parseFloat(nBusinessTermDay))
	    	{
	    		setItemUnit(0,0,"Day",style);
	    	}
	    	else
	    	{
	    		setItemUnit(0,0,"Day","");
	    	}
	    }catch(e){}
    	
	    try{
	    	if(maturityDate != nmaturityDate)
	    	{
	    		setItemUnit(0,0,"MaturityDate",style);
	    	}
	    	else
	    	{
	    		setItemUnit(0,0,"MaturityDate","");
	    	}
	    }catch(e){}
    	
	    try{
	    	if(rptTermID != nRPTTermID)
	    	{
	    		setItemUnit(0,0,"RPTTermID",style);
	    	}
	    	else
	    	{
	    		setItemUnit(0,0,"RPTTermID","");
	    		//还款方式比较
	    		var dw = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RPT");
	    		if(dw!=-1)
	    		{
	    			var gainCyc = "<%=gainCyc%>";
	    	    	var paymentFrequencyTerm = "<%=paymentFrequencyTerm%>";
	    	    	var segTerm = "<%=segTerm%>";
	    	    	var gainAmount = "<%=gainAmount%>";
	    	    	var segRPTAmount = "<%=segRPTAmount%>";
	    	    	var paymentFrequencyType = "<%=paymentFrequencyType%>";
	    	    	var defaultDueDayType = "<%=defaultDueDayType%>";
	    	    	var defaultDueDay = "<%=defaultDueDay%>";
	    			var nGainCyc = getItemValue(dw,0,"GainCyc");
	    			var nPaymentFrequencyTerm = getItemValue(dw,0,"PaymentFrequencyTerm");
	    			var nSegTerm = getItemValue(dw,0,"SegTerm");
	    			var nGainAmount = getItemValue(dw,0,"GainAmount");
	    			var nSegRPTAmount = getItemValue(dw,0,"SegRPTAmount");
	    			var nPaymentFrequencyType = getItemValue(dw,0,"PaymentFrequencyType");
	    			var nDefaultDueDayType = getItemValue(dw,0,"DefaultDueDayType");
	    			var nDefaultDueDay = getItemValue(dw,0,"DefaultDueDay");
	    			
	    			try{
	    		    	if(gainCyc != nGainCyc) ALSObjectWindowFunctions.setItemUnit(dw,"GainCyc",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"GainCyc","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(parseFloat(paymentFrequencyTerm) != parseFloat(nPaymentFrequencyTerm)) ALSObjectWindowFunctions.setItemUnit(dw,"PaymentFrequencyTerm",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"PaymentFrequencyTerm","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(parseFloat(segTerm) != parseFloat(nSegTerm)) ALSObjectWindowFunctions.setItemUnit(dw,"SegTerm",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"SegTerm","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(parseFloat(gainAmount) != parseFloat(nGainAmount)) ALSObjectWindowFunctions.setItemUnit(dw,"GainAmount",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"GainAmount","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(parseFloat(segRPTAmount) != parseFloat(nSegRPTAmount)) ALSObjectWindowFunctions.setItemUnit(dw,"SegRPTAmount",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"SegRPTAmount","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(paymentFrequencyType != nPaymentFrequencyType) ALSObjectWindowFunctions.setItemUnit(dw,"PaymentFrequencyType",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"PaymentFrequencyType","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(defaultDueDayType != nDefaultDueDayType) ALSObjectWindowFunctions.setItemUnit(dw,"DefaultDueDayType",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"DefaultDueDayType","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(defaultDueDay != nDefaultDueDay) ALSObjectWindowFunctions.setItemUnit(dw,"DefaultDueDay",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"DefaultDueDay","");
	    		    }catch(e){}
	    		}
	    	}
	    }catch(e){}
	    
    	
	    try{
	    	if(loanRateTermID != nLoanRateTermID)
	    	{
	    		setItemUnit(0,0,"LoanRateTermID",style);
	    	}
	    	else
	    	{
	    		setItemUnit(0,0,"LoanRateTermID","");
	    		//利率比较
	    		var dw = ALSObjectWindowFunctions.getSubObjectWindowName(0,"RAT");
	    		if(dw!=-1)
	    		{
	    			var rateMode = "<%=rateMode%>"
    				var segToStage = "<%=segToStage%>"
    				var rateFloat = "<%=rateFloat%>"
    				var businessRate = "<%=businessRate%>"
    				var repriceType = "<%=repriceType%>"
    				var repriceDate = "<%=repriceDate%>"
    				
    				var nRateMode = getItemValue(dw,0,"RateMode");
	    			var nSegToStage = getItemValue(dw,0,"SegToStage");
	    			var nRateFloat = getItemValue(dw,0,"RateFloat");
	    			var nBusinessRate = getItemValue(dw,0,"BusinessRate");
	    			var nRepriceType = getItemValue(dw,0,"RepriceType");
	    			var nRepriceDate = getItemValue(dw,0,"RepriceDate");
	    			
	    			try{
	    		    	if(rateMode != nRateMode) ALSObjectWindowFunctions.setItemUnit(dw,"RateMode",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"RateMode","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(segToStage != nSegToStage) ALSObjectWindowFunctions.setItemUnit(dw,"SegToStage",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"SegToStage","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(rateFloat == null || rateFloat == "") rateFloat = "0";
	    		    	if(nRateFloat == null || nRateFloat == "") nRateFloat = "0";
	    		    	if(parseFloat(rateFloat) != parseFloat(nRateFloat)) ALSObjectWindowFunctions.setItemUnit(dw,"RateFloat",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"RateFloat","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(parseFloat(businessRate) != parseFloat(nBusinessRate)) ALSObjectWindowFunctions.setItemUnit(dw,"BusinessRate",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"BusinessRate","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(repriceType != nRepriceType) ALSObjectWindowFunctions.setItemUnit(dw,"RepriceType",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"RepriceType","");
	    		    }catch(e){}
	    		    
	    		    try{
	    		    	if(repriceDate != nRepriceDate) ALSObjectWindowFunctions.setItemUnit(dw,"RepriceDateDay",style);
	    		    	else ALSObjectWindowFunctions.setItemUnit(dw,"RepriceDateDay","");
	    		    }catch(e){}
	    		}
	    	}
	    }catch(e){}
    }
</script>

<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>

<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>";
	var objectType = "jbo.app.BUSINESS_APPROVE";
	var objectNo = getItemValue(0,getRow(),"SERIALNO");
	var loanType = "<%=loanType%>";
	$(document).ready(function(){
		changePaymentType();
		initRepriceDate();
		initBusinessRate();
		changeFlag();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
