<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String putOutDate = CurPage.getParameter("PutOutDate");
	String creditInspectType = CurPage.getParameter("creditInspectType");
	if(creditInspectType==null) creditInspectType="";
	if(objectNo == null) objectNo = "";
	
	putOutDate = putOutDate.replace("/", "");
	String accountType = "";
	String accountNo = "";
	String accountCurrency = "";
	
	ASResultSet ars = Sqlca.getASResultSet(new SqlObject("select * from ACCT_BUSINESS_ACCOUNT where OBJECTTYPE = 'jbo.app.BUSINESS_DUEBILL' and STATUS = '1' and ACCOUNTINDICATOR in ('01') and objectno=:ObjectNo ").setParameter("ObjectNo", objectNo));
	if(ars.next()){
		accountType = ars.getString("AccountType");
		accountNo = ars.getString("AccountNo");
		accountCurrency = ars.getString("AccountCurrency");
	}
	ars.close();
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject bdInfo = bom.loadBusinessObject("jbo.app.BUSINESS_DUEBILL", objectNo);
	if(accountCurrency==null||accountCurrency.length()==0) accountCurrency = bdInfo.getString("BusinessCurrency");
	
	String sTempletNo = "SelectPayMessageInfo";//--模板号--
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	doTemp.setDefaultValue("AccountNo", accountNo);
	doTemp.setDefaultValue("QueryStartDate", putOutDate);
	doTemp.setUnit("QueryStartDate", "(日期输入格式:yyyyMMDD)&nbsp;&nbsp;<input type='button' value='查询' onclick='selectAccount()'/>");

	dwTemp.Style="2";  

	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("AccountDetail", "<iframe type='iframe' id=\"AccountDetail\" name=\"AccountDetail\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript">

	function selectAccount(){
		var startdate = getItemValue(0,getRow(),"QueryStartDate");
		if(startdate.length!=8){
			alert("查询日期输入格式不正确");
			return;
		}
		
		AsControl.OpenComp("/CreditManage/AfterBusiness/QueryAccountDetailList.jsp","StartDate="+startdate+"&AccountType=<%=accountType%>&AccountNo=<%=accountNo%>&Currency=<%=accountCurrency%>","AccountDetail");
	}

</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
