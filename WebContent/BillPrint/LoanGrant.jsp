<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//������ˮ	if(serialNo == null)   serialNo = "";		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();	BusinessObject bp = bom.loadBusinessObject("jbo.app.BUSINESS_PUTOUT", serialNo);			String contractSerialNo = bp.getString("ContractSerialNo");//��ͬ��ˮ��	String customerName = bp.getString("CustomerName");//����������	String loanType = bp.getString("LoanType");//�������ͣ�С�ࣩ	String businessTypeName = com.amarsoft.app.als.prd.config.loader.ProductConfig.getProduct(bp.getString("BusinessType")).getString("ProductName");//ҵ��Ʒ��	String customerID = bp.getAttribute("CUSTOMERID").toString();//�ͻ���	String mfCustomerID = Sqlca.getString(new SqlObject("select MFCUSTOMERID from CUSTOMER_INFO where customerid = :CustomerID").setParameter("CustomerID", customerID));			String duebillSerialNo = bp.getString("DuebillSerialNo");//�����ˮ��	String accountingOrgID = bp.getString("AccountingOrgID");//���˻�����ţ���������ţ�	String contractArtificialNo = bp.getString("ContractArtificialNo");//��ͬ��	String businessType = bp.getString("BusinessType");//(ת���ɴ������ͣ�	String businessCurrency = bp.getString("BusinessCurrency");//���֣�ת��	String paymentType = bp.getString("PaymentType");//֧����ʽ	//��չ���˺š���֤���˺š������˺š�ƾ֤���͡�		String rptTermID = bp.getString("RptTermID");//���ʽ����RPT��	double businessSum = bp.getDouble("BusinessSum");//���Ž��	String putoutDate = bp.getString("PutOutDate");//��Ϣ����	String maturityDate = bp.getString("MaturityDate");//��������		String businessTermUnit = bp.getString("BusinessTermUnit");	int businessTerm = bp.getInt("BusinessTerm");	int businessTermDay = bp.getInt("BusinessTermDay");		int term = businessTerm + businessTermDay/30 + (businessTermDay%30>0 ? 1 : 0);		String loanRateTermID = bp.getString("LoanRateTermID");//������Ϣ����RAT��		String loanTerm = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))			+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))			+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))			;			double bailrate = 0;//��֤����	String purposeDescription = bp.getString("PurposeDescription");//������;����		String currencyID = com.amarsoft.dict.als.cache.CodeCache.getItem("Currency", businessCurrency).getItemName();		ArrayList<Map<String,String>> rptArray = new ArrayList<Map<String,String>>();		List<BusinessObject> rptList = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RPTTermID=:RPTTermID order by SegToStage", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RPTTermID="+bp.getString("RPTTermID"));	String defaultDueDay="",paymentFrequencyType="",incrDecPrd="",incrMode="",segTermUnit="",moExpiredDate = "",fixedPeriod="";	double incrDecAmt=0d;	int segTerm=0;	int cnt = 0;	for(BusinessObject rpt:rptList)	{		cnt++;		defaultDueDay = rpt.getString("DEFAULTDUEDAY");//������GAINAMOUNT				if(defaultDueDay == null || "".equals(defaultDueDay)) defaultDueDay = putoutDate.substring(8);				paymentFrequencyType = rpt.getString("PaymentFrequencyType");//��Ϣ��ʽ				if("03".equals(paymentFrequencyType)) defaultDueDay = "";//һ���Ի���				if("99".equals(paymentFrequencyType))  fixedPeriod = rpt.getInt("PAYMENTFREQUENCYTERM")+"��";//�̶�����				if(paymentFrequencyType != null && !"".equals(paymentFrequencyType))		{			paymentFrequencyType = com.amarsoft.dict.als.cache.CodeCache.getItem("PaymentFrequencyType", paymentFrequencyType).getItemName();		}				incrDecAmt = rpt.getDouble("GAINAMOUNT");//�ݱ����		incrDecPrd = rpt.getString("GAINCYC");//�ݱ�����				if(incrDecAmt > 0) incrMode = "����";		else if(incrDecAmt < 0) incrMode = "�ݼ�";						if("RPT-06".equals(bp.getString("RPTTermID")))		{			Map tmp=new HashMap();					tmp.put("RPTTerm",String.valueOf(rpt.getInt("SegToStage")));//�׶ν�ֹ����			tmp.put("RPTAmount",String.valueOf(rpt.getDouble("SegRPTAmount")));//�̶�������			tmp.put("RPTTermName",com.amarsoft.dict.als.cache.CodeCache.getItem("SEGRPTTermID",rpt.getString("SEGRPTTermID")).getItemName());//���ʽ1			rptArray.add(tmp);		}	}		if(defaultDueDay != null && !"".equals(defaultDueDay) && defaultDueDay.length()<=1 ) defaultDueDay = "0"+defaultDueDay;		String rptTermName = "";	BusinessObject component = com.amarsoft.app.als.businesscomponent.config.BusinessComponentConfig.getComponentDefinition(bp.getString("RPTTermID"));	if(component != null) rptTermName = component.getString("ComponentName");		ArrayList<Map<String,String>> rateArray = new ArrayList<Map<String,String>>();		List<BusinessObject> rateList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and RateTermID=:RateTermID order by SegToStage", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=01;RateTermID="+bp.getString("LoanRateTermID"));	double businessRate = 0d;	String repriceType="",repriceDate="";	int num = 0;	String beginDate = putoutDate;	for(BusinessObject rate:rateList)	{		//����ʵʱ����		String rateMode = rate.getString("RateMode");//����ģʽ		if(num == 0)		{			businessRate = rate.getDouble("BUSINESSRATE");//ִ������			repriceType = rate.getString("REPRICETYPE");//���ʵ�����ʽ			repriceType = com.amarsoft.dict.als.cache.CodeCache.getItem("RepriceType", repriceType).getItemName();			repriceDate = rate.getString("REPRICEDATE");//ָ����������			if(repriceDate != null) repriceDate = repriceDate.replaceAll("/", "");					}				if("RAT03".equals(bp.getString("LoanRateTermID")))		{			String rateMode1 = com.amarsoft.dict.als.cache.CodeCache.getItem("RateMode", rateMode).getItemName();			String repriceType1 = com.amarsoft.dict.als.cache.CodeCache.getItem("RepriceType", rate.getString("REPRICETYPE")).getItemName();			String repriceDate1 = rate.getString("REPRICEDATE");//ָ����������			if(repriceDate1 != null) repriceDate1 = repriceDate1.replaceAll("/", "");			repriceType = "�ṹ�Թ̶�����";			repriceDate="";						beginDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, rate.getInt("SegToStage"));						if(beginDate.compareTo(maturityDate) > 0) beginDate = maturityDate;						Map tmp1=new HashMap();				tmp1.put("EndDate",beginDate.replaceAll("/", ""));//��������1			tmp1.put("RateMode",rateMode1);//�̶���־			tmp1.put("BusinessRate",String.valueOf(rate.getDouble("BUSINESSRATE")));//�̶�����			tmp1.put("RateFloat",String.valueOf(rate.getString("RATEFLOAT")));//��������			tmp1.put("repriceType",repriceType1);//���ʵ�����ʽ1			tmp1.put("repriceDate",repriceDate1);//���ʵ�������			rateArray.add(tmp1);		}				num ++;	}		//��Ϣ����	List<BusinessObject> fineList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=02");	String PnyIntType = "0",PenaltyIntFlotRate = "";	for(BusinessObject fine:fineList)	{				PnyIntType = fine.getString("RateMode");		if("1".equals(PnyIntType)){			PenaltyIntFlotRate = String.valueOf(fine.getDouble("RateFloat"))+"%";		}		PnyIntType = com.amarsoft.dict.als.cache.CodeCache.getItem("RateMode", PnyIntType).getItemName();	}		//��չ���˺�,��֤���˺�,�����˺�,�����˺�ƾ֤����	String dvlprAcctNo = "",marginAcctNo = "",settleAcctNo = "",vchrType = "";		List<BusinessObject> accountList = bom.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo());	for(BusinessObject account:accountList)	{		if("01".equals(account.getString("AccountIndIcator")))		{			vchrType = account.getString("ACCOUNTTYPE");			vchrType = com.amarsoft.dict.als.cache.CodeCache.getItem("AccountType", vchrType).getItemName();			settleAcctNo = account.getString("ACCOUNTNO1");			if(settleAcctNo == null || "".equals(settleAcctNo))				settleAcctNo = account.getString("ACCOUNTNO");		}		else if("04".equals(account.getString("AccountIndIcator")))		{			dvlprAcctNo = account.getString("ACCOUNTNO1");			if(dvlprAcctNo == null || "".equals(dvlprAcctNo))				dvlprAcctNo = account.getString("ACCOUNTNO");		}		else if("06".equals(account.getString("AccountIndIcator")))		{			marginAcctNo = account.getString("ACCOUNTNO1");			if(marginAcctNo == null || "".equals(marginAcctNo) || "null".equals(marginAcctNo))				marginAcctNo = account.getString("ACCOUNTNO");			bailrate = account.getDouble("AccountAmt");		}	}		if("0".equals(paymentType))//�տ���Ϊ����ˣ����ý�	{		dvlprAcctNo=settleAcctNo;	}%>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt'>
<div align=center>
<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span
lang=EN-US>&nbsp;<o:p></o:p></span></p>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=639
 style='width:479.25pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:
 0cm 0cm 0cm 0cm' height=727>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.75pt'>
  <td width=621 colspan=4 style='width:465.75pt;border:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;background:#AAAAAA;padding:0cm 5.4pt 0cm 5.4pt;
  height:51.75pt'>
  <p class=MsoNormal align=center style='text-align:center'><b><span
  style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'>���˴���ſ�֪ͨ�� </span></b><span
  lang=EN-US style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:4.95pt'>
  <td width=621 colspan=4 style='width:465.75pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:4.95pt'>
  <p class=MsoNormal align=left style='text-align:left'></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:27.05pt'>
  <td width=621 colspan=4 style='width:465.75pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:27.05pt'>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:11.0pt;font-family:����;mso-bidi-font-family:����'>__________</span><span
  style='font-size:11.0pt;font-family:����;mso-bidi-font-family:����'>��������Ʋ��ţ�<span
  lang=EN-US>&nbsp;</span></span><span lang=EN-US style='font-size:12.0pt;
  font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:48.0pt'>
  <td width=621 colspan=4 style='width:465.75pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:48.0pt;font-size: 15px'>
  <p class=MsoNormal><u><span lang=EN-US style='font-family:����'><%=customerName%></span></u><span
  style='font-family:����'>�������ˣ���<u><span lang=EN-US><%=businessTypeName%></span></u></span><span
  lang=EN-US><o:p></o:p></span></p>
  <p class=MsoNormal><span style='font-family:����'>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ���ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������<span
  lang=EN-US> &nbsp;</span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:7.85pt'>
  <td width=621 colspan=4 style='width:465.75pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:4.95pt'>
  <p class=MsoNormal align=left style='text-align:left'></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:15.0pt'>
  <td width=173 style='width:130.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>��ݺ�</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=143 style='width:107.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=duebillSerialNo%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�ͻ���</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=mfCustomerID%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>��������</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=445 colspan=3 style='width:333.75pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=businessTypeName+"-"+loanType%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>���ʵ�����ʽ</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=repriceType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>ָ������</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=repriceDate%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>��չ���ʺ�</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=dvlprAcctNo%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>��չ�̱�֤���ʺ�</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=marginAcctNo%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>���ʽ</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=rptTermName%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�ۿ�����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=paymentFrequencyType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�̶�����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=fixedPeriod%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>���Ž��</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=DataConvert.toMoney(businessSum)%>Ԫ</span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>��չ�̱�֤����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=DataConvert.toMoney(bailrate)%>Ԫ</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�ۿ�����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=defaultDueDay%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=loanTerm%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>������</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=maturityDate%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>ִ������</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=445 colspan=3 style='width:333.75pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=businessRate%>%</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span class=GramE><span style='font-size:9.0pt;font-family:
  ����'>�ʻ�</span></span><span style='font-size:9.0pt;font-family:����'>����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=vchrType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�ͻ��ʺ�</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=settleAcctNo%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�������ʸ�����ʽ</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=PnyIntType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>���ڸ�������</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=PenaltyIntFlotRate%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:16;height:3.6pt'>
  <td width=621 colspan=4 valign=top style='width:465.75pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:4.95pt'>
  <p class=MsoNormal></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:17;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�������ݼ���ʽ</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=incrMode%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�������ݼ�����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'><%=incrDecPrd%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:18;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>����������ݼ����</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:����_GB2312'> <%=Math.abs(incrDecAmt)%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;font-family:����'>&nbsp;</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>  <%if(rptArray.size() > 0){ %>
 <tr style='mso-yfti-irow:19;height:5.0pt'>
  <td width=621 colspan=4 valign=top style='width:465.75pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:4.95pt'>
  <p class=MsoNormal></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:20'>
  <td colspan=4 style='border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;'> 
  <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width="100%"
   style='width:100.0%;mso-cellspacing:0cm;mso-padding-alt:0cm 0cm 0cm 0cm;
   mso-border-insideh:1.0pt solid windowtext;mso-border-insidev:.25pt solid windowtext; margin-top:-1px'
   height="100%">   <% for(Map<String,String> map:rptArray){ %>
   <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:13.05pt'>
    <td width=140 style='width:105.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal style1><span style='font-size:9.0pt;font-family:����'>���׶λ��ʽ</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:115.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:����_GB2312'><%=map.get("RPTTermName")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:105.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>���׶ν�ֹ����</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:90.00pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:����_GB2312'><%=map.get("RPTTerm")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:105.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span style='font-size:9.0pt;font-family:����'>�̶�������</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:90.00pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:0.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:����_GB2312'><%=map.get("RPTAmount")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
   </tr><%} %>

  </table>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:12.0pt;font-family:����;mso-bidi-font-family:����'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21;height:15.0pt'>
  <td width=621 colspan=4 valign=top style='width:465.75pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:4.95pt'>
  <p class=MsoNormal></p>
  </td>
 </tr> <%}  %>
 <tr style='mso-yfti-irow:22;height:154.5pt'>
  <td width=621 colspan=4 valign=top style='width:465.75pt;border-top:none;
  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:140.0pt'>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>��</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:����;font-size: 14px ' >�ſ�ල��ǩ�֣�</span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:
  ����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;mso-ascii-font-family:����_GB2312;mso-fareast-font-family:
  ����_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:14.0pt;font-family:����_GB2312'> </span><span
  lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11.0pt;mso-ascii-font-family:����_GB2312;
  mso-fareast-font-family:����_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:����'>�ſ�ר���£�</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:����'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:����'>���ڣ�<span lang=EN-US><%=putoutDate%></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23;mso-yfti-lastrow:yes;height:24.2pt'>
  <td width=621 colspan=4 style='width:465.75pt;border:solid windowtext 1.5pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:24.2pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;font-family:����;color:black'>����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
����_GB2312;mso-fareast-font-family:����_GB2312'>&nbsp;</span></p>
</div>    <table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
