<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>

<META HTTP-EQUIV="expires" CONTENT="-1">

<%
	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));
	if(serialNo == null) serialNo = ""; 
	String customerID = "",mfCustomerID="",customerName="",putoutDate="",maturityDate="",bigBusinessSum="",year="",month="",day="",duebillSerialNo="";
	int businessTerm=0,businessTermDay=0;
	double businessSum=0d;
	String BusinessSumStr = "";
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject bp = bom.loadBusinessObject("jbo.app.BUSINESS_PUTOUT", serialNo);
	if(bp != null)
	{
		customerID = bp.getAttribute("CUSTOMERID").getString();//客户号
		mfCustomerID = Sqlca.getString(new SqlObject("select MFCUSTOMERID from CUSTOMER_INFO where customerid = :CustomerID").setParameter("CustomerID", customerID));
		customerName = bp.getAttribute("CUSTOMERNAME").getString();//名称
		duebillSerialNo = bp.getAttribute("DuebillSerialNo").getString();//借据号
		putoutDate = bp.getAttribute("PUTOUTDATE").getString();//借据发放日期
		maturityDate = bp.getAttribute("MATURITYDATE").getString();//借据到期日期
		businessTerm = bp.getAttribute("BUSINESSTERM").getInt();//期限月
		businessTermDay = bp.getAttribute("BUSINESSTERMDAY").getInt();//期限月
		businessSum = bp.getAttribute("BUSINESSSUM").getDouble();//小写
		bigBusinessSum = StringFunction.numberToChinese(businessSum);//大写
		BusinessSumStr = DataConvert.toMoney(businessSum);
		year = putoutDate.substring(0, 4);//年
		month = putoutDate.substring(5, 7);//月
		day = putoutDate.substring(8, 10);//日
	}
	
	String settleAcctNo = "",settleAcctName="",dvlprAcctNo = "",dvlprAcctName="";
	List<BusinessObject> accountList = bom.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo());
	for(BusinessObject account:accountList)
	{
		
		if("01".equals(account.getString("AccountIndIcator")))
		{
			settleAcctNo = account.getString("ACCOUNTNO1");
			if(settleAcctNo == null || "".equals(settleAcctNo))
				settleAcctNo = account.getString("ACCOUNTNO");
			settleAcctName = account.getString("ACCOUNTNAME");
		}
		else if("04".equals(account.getString("AccountIndIcator")))
		{
			dvlprAcctNo = account.getString("ACCOUNTNO1");
			if(dvlprAcctNo == null || "".equals(dvlprAcctNo))
				dvlprAcctNo = account.getString("ACCOUNTNO");
			dvlprAcctName = account.getString("ACCOUNTNAME");
		}
	}
	
	if("0".equals(bp.getString("PaymentType")))//收款人为借款人（备用金）
	{
		dvlprAcctNo=settleAcctNo;
		dvlprAcctName = settleAcctName;
	}
	
	if(dvlprAcctName == null || "".equals(dvlprAcctName))
	{
		try{
			com.amarsoft.app.oci.bean.OCITransaction oci = com.amarsoft.app.oci.instance.CoreInstance.CorpCrnClntNameQryByAcctNo("92261005", "2261", dvlprAcctNo, "01", Sqlca.getConnection());
			dvlprAcctName = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ClientCHNName");
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	String term = String.valueOf(businessTerm/12)
			+"年"+ String.valueOf(businessTerm%12) +"月"
			+ String.valueOf(businessTermDay)+"天"
			;//贷款期限
	
	double intRate = 0d;
	List<BusinessObject> rateList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and RateTermID=:RateTermID order by SegToStage", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=01;RateTermID="+bp.getString("LoanRateTermID"));
	for(BusinessObject rate:rateList)
	{
		intRate = rate.getDouble("BUSINESSRATE");
		break;
	}
	
	Map map = new HashMap();
	map.put("CUSTNO",mfCustomerID);	
    map.put("YEAR",year);
    map.put("MONTH",month);
    map.put("DATE",day);
    map.put("CINO",duebillSerialNo);    
    map.put("CUST_NAME",customerName);
    map.put("COOP_NAME",dvlprAcctName);
    map.put("PAY_ACTNO",dvlprAcctNo);
    map.put("TERM",term);
    map.put("TEDATE",maturityDate);
    map.put("INTRATE",String.valueOf(intRate));
    map.put("CAPITAL",bigBusinessSum);
    map.put("LNAMT",BusinessSumStr);    
    
    /*
    height1 = (75.5)*i*2;
	height2 = height1 + 75.5;
	*/
	
	
	String minusAmt = (String)map.get("LNAMT");
	int len = minusAmt.length();
	
	String coopName = (String)map.get("COOP_NAME");
	if ( null == coopName ) coopName = "";
	/*if ( coopName.length() > 20 ){
		coopName = coopName.substring(0,20);
	}*/
	
	if ( coopName.length() > 36 ){
		coopName = coopName.substring(0,36);
	}
%>
	<!-- 客户号-->
	<DIV STYLE="position: absolute; top: 10.5mm; left: 40mm; font: 9pt 宋体;"><%=map.get("CUSTNO")%></DIV>
	<!--年份-->
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 82mm; font: 9pt 宋体;"><%=map.get("YEAR")%></DIV>
  	<!--月份-->
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 97mm; font: 9pt 宋体;"><%=map.get("MONTH")%></DIV>
  	<!--日期-->  	
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 110mm; font: 9pt 宋体;"><%=map.get("DATE")%></DIV>
  	<!--借据号-->  	
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 160mm; font: 9pt 宋体;"><%=map.get("CINO")%></DIV>
  	
  	<!-- 借款人名称 -->
  	<DIV STYLE="position: absolute; top: 16.5mm; left: 50mm; font: 9pt 宋体;"><%=map.get("CUST_NAME")%></DIV>
  	
  	<!-- 借款人开户银行 -->
  	<DIV STYLE="position: absolute; top: 28.5mm; left: 50mm; font: 9pt 宋体;">上海浦东发展银行</DIV>
  	
  	<!-- 收款人名称 -->
  	<DIV STYLE="position: absolute; top: 16.5mm; left: 143mm; width: 60mm; font: 9pt 宋体;"><%=coopName%></DIV>
  	
  	<!-- 收款帐号 -->
  	<DIV STYLE="position: absolute; top: 23mm; left: 145mm; font: 9pt 宋体;"><%=map.get("PAY_ACTNO")%></DIV>
  	
  	<!-- 收款人开户银行 -->
  	<DIV STYLE="position: absolute; top: 28.5mm; left: 145mm; font: 9pt 宋体;">上海浦东发展银行</DIV>
  	
  	<!-- 借款期限/最后还款日 -->
  	<DIV STYLE="position: absolute; top: 36mm; left: 50mm; font: 9pt 宋体;"><%=map.get("TERM")%>(<%=map.get("TEDATE")%>)</DIV>

  	
	<!-- 执行利率 -->
	<DIV STYLE="position: absolute; top: 36mm; left: 145mm; font: 9pt 宋体;"><%=map.get("INTRATE")%>%</DIV>  	
	
	<!-- 大写 -->
	<DIV STYLE="position: absolute; top: 45mm; left: 60mm; font: 9pt 宋体;">人民币<%=map.get("CAPITAL")%></DIV>  	
	<!-- 小写 -->
	<DIV STYLE="position: absolute; top: 45mm; left: <%=String.valueOf(195-len*10/4)%>mm; font: 9pt 宋体;">￥<%=map.get("LNAMT")%></DIV>

<%@ include file="/Frame/resources/include/include_end.jspf"%>  	