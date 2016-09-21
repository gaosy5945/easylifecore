<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sReportSN = CurPage.getParameter("ReportSN");
	if(sReportSN == null) sReportSN = "";
	
	Double LoanCount = Sqlca.getDouble(new SqlObject("SELECT (SUM(HouseLoanCount+OtherLoanCount)) FROM ICRP_CreditSC WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN)); // �����ܱ���=ס���������+�����������
    Double Balance = Sqlca.getDouble(new SqlObject("SELECT SUM(Balance) FROM ICRP_FellbackDS WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN)); //���д��������=������Ϣ������
	Double OverdueCount12M = Sqlca.getDouble(new SqlObject("SELECT SUM(Count) FROM ICRP_LoanSum WHERE ReportSN =:ReportSN AND (select to_char(months,'yyyymm')-0 from ICRP_LoanSum)>(select to_char(sysdate,'yyyymm')-100 from dual)").setParameter("ReportSN",sReportSN)); //���12�������д����ۼ����ڴ���
	Double HighestOverdue12M = Sqlca.getDouble(new SqlObject("SELECT MAX(LastMonths) FROM ICRP_lcard_ODR WHERE ReportSN =:ReportSN AND (select to_char(month,'yyyymm')-0 from ICRP_lcard_ODR)>(select to_char(sysdate,'yyyymm')-100 from dual)").setParameter("ReportSN",sReportSN));//���12�������д��������������
	Double HighestOverdue = Sqlca.getDouble(new SqlObject("SELECT MAX(months) FROM ICRP_LoanSum WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN));//��ʷ���д���������������������壩
	Double HighestOverdueNow = Sqlca.getDouble(new SqlObject("SELECT MAX(CurrOverdueCyc) FROM ICRP_loan_COD WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN));//��ǰ������д�����������
	Double HighestOverdueBalance = Sqlca.getDouble(new SqlObject("SELECT CurrOverdueAmount FROM ICRP_loan_COD WHERE (ReportSN =:ReportSN) and (CurrOverdueCyc IN (SELECT MAX(CurrOverdueCyc) FROM ICRP_loan_COD WHERE ReportSN=:ReportSN))").setParameter("ReportSN",sReportSN));//��ǰ���д����������������Ӧ���
	Double MonthRepayment = Sqlca.getDouble(new SqlObject("SELECT SUM(ActualPaymentAmount) FROM ICRP_loan_CAI WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN));//�����д����»����
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("SELECT Creditlimitamount,CURRENCY FROM ICRP_lcard_ACI WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN)) ;//���ǿ����ծ��
	Double DCMaxDebt = 0.0;
	while(rs.next())
	{
		double CreditLimitAmount = rs.getDouble(1);
		String currency = rs.getString(2);
		
		com.amarsoft.dict.als.object.Item[] items = com.amarsoft.dict.als.cache.CodeCache.getItems("Currency");
		for(com.amarsoft.dict.als.object.Item item:items)
		{
			if(item.getItemName().equals(currency))
			{
				DCMaxDebt+=com.amarsoft.app.accounting.config.loader.RateConfig.getExchangeRate(item.getItemNo(),"CNY") * CreditLimitAmount;
			}
		}
		
	}
	rs.close();
	ASResultSet rs2 = Sqlca.getASResultSet(new SqlObject("SELECT Creditlimitamount,CURRENCY FROM ICRP_slcard_ACI WHERE ReportSN =:ReportSN").setParameter("ReportSN",sReportSN)) ;//׼���ǿ����ծ��
	while(rs2.next())
	{
		double CreditLimitAmount = rs2.getDouble(1);
		String currency = rs2.getString(2);
		
		com.amarsoft.dict.als.object.Item[] items = com.amarsoft.dict.als.cache.CodeCache.getItems("Currency");
		for(com.amarsoft.dict.als.object.Item item:items)
		{
			if(item.getItemName().equals(currency))
			{
				DCMaxDebt+=com.amarsoft.app.accounting.config.loader.RateConfig.getExchangeRate(item.getItemNo(),"CNY") * CreditLimitAmount;
			}
		}
		
	}
	rs2.close();
	Double DCDefaultCount = Sqlca.getDouble(new SqlObject("SELECT (SUM(ILC.CURROVERDUECYC+ISC.CURROVERDUECYC)) FROM ICRP_lcard_COD ILC,ICRP_slcard_COD ISC WHERE ILC.REPORTSN=ISC.REPORTSN AND ISC.ReportSN =:ReportSN").setParameter("ReportSN",sReportSN));//���ÿ���ǰ��Ƿ����
    Double DCLowestRepaymentCount = Sqlca.getDouble(new SqlObject("SELECT (COUNT(ICO.ITEMNO2)+COUNT(ISO.ITEMNO2)) FROM  ICRP_lcard_ODR ICO,ICRP_slcard_ODR ISO WHERE ICO.REPORTSN=ISO.REPORTSN AND ISO.ReportSN =:ReportSN").setParameter("ReportSN",sReportSN));//���ÿ�δ����ͻ�������

	String sTempletNo = "ICRP_KeyField";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"","","","","","","","","","",""}
	};
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=sReportSN%>", "_self");
	}	
	function initRow(){
		setItemValue(0,0,"LoanCount","<%=LoanCount%>");
		setItemValue(0,0,"Balance","<%=Balance%>");
		setItemValue(0,0,"OverdueCount12M","<%=OverdueCount12M%>");
		setItemValue(0,0,"HighestOverdue12M","<%=HighestOverdue12M%>");
		setItemValue(0,0,"HighestOverdue","<%=HighestOverdue%>");
		setItemValue(0,0,"HighestOverdueNow","<%=HighestOverdueNow%>");
		setItemValue(0,0,"HighestOverdueBalance","<%=HighestOverdueBalance%>");
		setItemValue(0,0,"MonthRepayment","<%=MonthRepayment%>");
		setItemValue(0,0,"DCMaxDebt","<%=DCMaxDebt%>");
		setItemValue(0,0,"DCDefaultCount","<%=DCDefaultCount%>");
		setItemValue(0,0,"DCLowestRepaymentCount","<%=DCLowestRepaymentCount%>");
    }
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
