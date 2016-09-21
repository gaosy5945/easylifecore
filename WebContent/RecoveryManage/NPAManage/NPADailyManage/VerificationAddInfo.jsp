<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sPrevUrl = CurPage.getParameter("PrevUrl");
	if(sPrevUrl == null) sPrevUrl = "";

	String sTempletNo = "VerificationAddInfo";//--模板号--
	//ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo==null) serialNo="";
	String businessStatus = CurPage.getParameter("BusinessStatus");
	if(businessStatus==null) businessStatus="";
	
	// 查询借据表借据余额、表内外欠息余额、终结日期，反显到核销本金金额、核销利息金额、核销日期
	String balance = "",finishDate="",interestBalance="";
	String writeOffPrincipalAmount="",writeOffInterestAmount="",saleDate="";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BALANCE,INTERESTBALANCE1,INTERESTBALANCE2,FINISHDATE from BUSINESS_DUEBILL where SerialNo=:SerialNo").setParameter("SerialNo", serialNo));
    if(rs.next())
    {
    	balance = DataConvert.toString(rs.getString("BALANCE"));
    	interestBalance = DataConvert.toString(rs.getDouble("INTERESTBALANCE1") + rs.getDouble("INTERESTBALANCE1"));
    	finishDate = DataConvert.toString(rs.getString("FINISHDATE"));
    }
    rs.close();
    BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
    ASValuePool para = new ASValuePool();
    para.setAttribute("ObjectType", "jbo.app.BUSINESS_DUEBILL");
    para.setAttribute("ObjectNo", serialNo);
    String selectSql = " relativeobjectno=:ObjectNo and relativeobjecttype=:ObjectType and transactioncode='3001' ";
    List<BusinessObject> transList = bom.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", selectSql, para);
    int transNum = 0;
    if(transList!=null)transNum = transList.size();
    
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SERIALNO", serialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	
	doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	//dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{String.valueOf(!com.amarsoft.are.lang.StringX.isSpace(sPrevUrl)),"All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	var rightType = "<%=CurPage.getParameter("RightType")%>"

	function saveRecord()
	{
		var balance = getItemValue(0,getRow(0),"BALANCE");
		var writeOffPrincipalAmount = getItemValue(0,getRow(0),"WRITEOFFPRINCIPALAMOUNT");
		if(parseFloat(balance) < parseFloat(writeOffPrincipalAmount)){
			if(confirm("核销本金金额应小于等于借据余额，是否保存？")){
				as_save();
			}
		} else {
			as_save();
		}
	}

	function initRow(){
		setItemValue(0,0,"BUSINESSSTATUS","<%=businessStatus%>");
		var subdwname = ALSObjectWindowFunctions.getSubObjectWindowName(0,"AT");
		setItemValue(subdwname,0,"RELATIVEOBJECTNO","<%=serialNo%>");
		
		var writeOffPrincipalAmount = getItemValue(0,getRow(0),"WRITEOFFPRINCIPALAMOUNT");
		if(writeOffPrincipalAmount == "" && writeOffPrincipalAmount.length == 0 ) {
			setItemValue(0,getRow(0),"WRITEOFFPRINCIPALAMOUNT","<%=balance%>");
		}
		
		var writeOffInterestAmount = getItemValue(0,getRow(0),"WRITEOFFINTERESTAMOUNT");
		if(writeOffInterestAmount == "" && writeOffInterestAmount.length == 0 ) {
			setItemValue(0,getRow(0),"WRITEOFFINTERESTAMOUNT","<%=interestBalance%>");
		}
		
		var saleDate = getItemValue(0,getRow(0),"SALEDATE");
		if(saleDate == "" && saleDate.length == 0 ) {
			setItemValue(0,getRow(0),"SALEDATE","<%=finishDate%>");
		}
		
		if("<%=transNum%>"==0){
			setItemValue(subdwname,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(subdwname,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(subdwname,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(subdwname,0,"INPUTORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(subdwname,0,"OCCURDATE","<%=StringFunction.getToday()%>");
			setItemValue(subdwname,0,"INPUTTIME","<%=StringFunction.getTodayNow()%>");
			setItemValue(subdwname,0,"ACCOUNTINGDATE","<%=DateHelper.getBusinessDate()%>");
		}
	}
	function returnList(){
		OpenPage("<%=sPrevUrl%>", "_self");
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
