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
		customerID = bp.getAttribute("CUSTOMERID").getString();//�ͻ���
		mfCustomerID = Sqlca.getString(new SqlObject("select MFCUSTOMERID from CUSTOMER_INFO where customerid = :CustomerID").setParameter("CustomerID", customerID));
		customerName = bp.getAttribute("CUSTOMERNAME").getString();//����
		duebillSerialNo = bp.getAttribute("DuebillSerialNo").getString();//��ݺ�
		putoutDate = bp.getAttribute("PUTOUTDATE").getString();//��ݷ�������
		maturityDate = bp.getAttribute("MATURITYDATE").getString();//��ݵ�������
		businessTerm = bp.getAttribute("BUSINESSTERM").getInt();//������
		businessTermDay = bp.getAttribute("BUSINESSTERMDAY").getInt();//������
		businessSum = bp.getAttribute("BUSINESSSUM").getDouble();//Сд
		bigBusinessSum = StringFunction.numberToChinese(businessSum);//��д
		BusinessSumStr = DataConvert.toMoney(businessSum);
		year = putoutDate.substring(0, 4);//��
		month = putoutDate.substring(5, 7);//��
		day = putoutDate.substring(8, 10);//��
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
	
	if("0".equals(bp.getString("PaymentType")))//�տ���Ϊ����ˣ����ý�
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
			+"��"+ String.valueOf(businessTerm%12) +"��"
			+ String.valueOf(businessTermDay)+"��"
			;//��������
	
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
	<!-- �ͻ���-->
	<DIV STYLE="position: absolute; top: 10.5mm; left: 40mm; font: 9pt ����;"><%=map.get("CUSTNO")%></DIV>
	<!--���-->
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 82mm; font: 9pt ����;"><%=map.get("YEAR")%></DIV>
  	<!--�·�-->
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 97mm; font: 9pt ����;"><%=map.get("MONTH")%></DIV>
  	<!--����-->  	
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 110mm; font: 9pt ����;"><%=map.get("DATE")%></DIV>
  	<!--��ݺ�-->  	
  	<DIV STYLE="position: absolute; top: 10.5mm; left: 160mm; font: 9pt ����;"><%=map.get("CINO")%></DIV>
  	
  	<!-- ��������� -->
  	<DIV STYLE="position: absolute; top: 16.5mm; left: 50mm; font: 9pt ����;"><%=map.get("CUST_NAME")%></DIV>
  	
  	<!-- ����˿������� -->
  	<DIV STYLE="position: absolute; top: 28.5mm; left: 50mm; font: 9pt ����;">�Ϻ��ֶ���չ����</DIV>
  	
  	<!-- �տ������� -->
  	<DIV STYLE="position: absolute; top: 16.5mm; left: 143mm; width: 60mm; font: 9pt ����;"><%=coopName%></DIV>
  	
  	<!-- �տ��ʺ� -->
  	<DIV STYLE="position: absolute; top: 23mm; left: 145mm; font: 9pt ����;"><%=map.get("PAY_ACTNO")%></DIV>
  	
  	<!-- �տ��˿������� -->
  	<DIV STYLE="position: absolute; top: 28.5mm; left: 145mm; font: 9pt ����;">�Ϻ��ֶ���չ����</DIV>
  	
  	<!-- �������/��󻹿��� -->
  	<DIV STYLE="position: absolute; top: 36mm; left: 50mm; font: 9pt ����;"><%=map.get("TERM")%>(<%=map.get("TEDATE")%>)</DIV>

  	
	<!-- ִ������ -->
	<DIV STYLE="position: absolute; top: 36mm; left: 145mm; font: 9pt ����;"><%=map.get("INTRATE")%>%</DIV>  	
	
	<!-- ��д -->
	<DIV STYLE="position: absolute; top: 45mm; left: 60mm; font: 9pt ����;">�����<%=map.get("CAPITAL")%></DIV>  	
	<!-- Сд -->
	<DIV STYLE="position: absolute; top: 45mm; left: <%=String.valueOf(195-len*10/4)%>mm; font: 9pt ����;">��<%=map.get("LNAMT")%></DIV>

<%@ include file="/Frame/resources/include/include_end.jspf"%>  	