<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%	String serialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));//出账流水	if(serialNo == null)   serialNo = "";		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();	BusinessObject bp = bom.loadBusinessObject("jbo.app.BUSINESS_PUTOUT", serialNo);			String contractSerialNo = bp.getString("ContractSerialNo");//合同流水号	String customerName = bp.getString("CustomerName");//申请人姓名	String loanType = bp.getString("LoanType");//贷款类型（小类）	String businessTypeName = com.amarsoft.app.als.prd.config.loader.ProductConfig.getProduct(bp.getString("BusinessType")).getString("ProductName");//业务品种	String customerID = bp.getAttribute("CUSTOMERID").toString();//客户号	String mfCustomerID = Sqlca.getString(new SqlObject("select MFCUSTOMERID from CUSTOMER_INFO where customerid = :CustomerID").setParameter("CustomerID", customerID));			String duebillSerialNo = bp.getString("DuebillSerialNo");//借据流水号	String accountingOrgID = bp.getString("AccountingOrgID");//入账机构编号（账务机构号）	String contractArtificialNo = bp.getString("ContractArtificialNo");//合同号	String businessType = bp.getString("BusinessType");//(转换成贷款类型）	String businessCurrency = bp.getString("BusinessCurrency");//币种（转）	String paymentType = bp.getString("PaymentType");//支付方式	//发展商账号、保证金账号、结算账号、凭证类型、		String rptTermID = bp.getString("RptTermID");//还款方式（查RPT）	double businessSum = bp.getDouble("BusinessSum");//发放金额	String putoutDate = bp.getString("PutOutDate");//起息日期	String maturityDate = bp.getString("MaturityDate");//到期日期		String businessTermUnit = bp.getString("BusinessTermUnit");	int businessTerm = bp.getInt("BusinessTerm");	int businessTermDay = bp.getInt("BusinessTermDay");		int term = businessTerm + businessTermDay/30 + (businessTermDay%30>0 ? 1 : 0);		String loanRateTermID = bp.getString("LoanRateTermID");//关于利息（查RAT）		String loanTerm = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))			+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))			+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))			;			double bailrate = 0;//保证金金额	String purposeDescription = bp.getString("PurposeDescription");//贷款用途描述		String currencyID = com.amarsoft.dict.als.cache.CodeCache.getItem("Currency", businessCurrency).getItemName();		ArrayList<Map<String,String>> rptArray = new ArrayList<Map<String,String>>();		List<BusinessObject> rptList = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RPTTermID=:RPTTermID order by SegToStage", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RPTTermID="+bp.getString("RPTTermID"));	String defaultDueDay="",paymentFrequencyType="",incrDecPrd="",incrMode="",segTermUnit="",moExpiredDate = "",fixedPeriod="";	double incrDecAmt=0d;	int segTerm=0;	int cnt = 0;	for(BusinessObject rpt:rptList)	{		cnt++;		defaultDueDay = rpt.getString("DEFAULTDUEDAY");//还款日GAINAMOUNT				if(defaultDueDay == null || "".equals(defaultDueDay)) defaultDueDay = putoutDate.substring(8);				paymentFrequencyType = rpt.getString("PaymentFrequencyType");//计息方式				if("03".equals(paymentFrequencyType)) defaultDueDay = "";//一次性还款				if("99".equals(paymentFrequencyType))  fixedPeriod = rpt.getInt("PAYMENTFREQUENCYTERM")+"月";//固定周期				if(paymentFrequencyType != null && !"".equals(paymentFrequencyType))		{			paymentFrequencyType = com.amarsoft.dict.als.cache.CodeCache.getItem("PaymentFrequencyType", paymentFrequencyType).getItemName();		}				incrDecAmt = rpt.getDouble("GAINAMOUNT");//递变幅度		incrDecPrd = rpt.getString("GAINCYC");//递变周期				if(incrDecAmt > 0) incrMode = "递增";		else if(incrDecAmt < 0) incrMode = "递减";						if("RPT-06".equals(bp.getString("RPTTermID")))		{			Map tmp=new HashMap();					tmp.put("RPTTerm",String.valueOf(rpt.getInt("SegToStage")));//阶段截止期数			tmp.put("RPTAmount",String.valueOf(rpt.getDouble("SegRPTAmount")));//固定本金金额			tmp.put("RPTTermName",com.amarsoft.dict.als.cache.CodeCache.getItem("SEGRPTTermID",rpt.getString("SEGRPTTermID")).getItemName());//还款方式1			rptArray.add(tmp);		}	}		if(defaultDueDay != null && !"".equals(defaultDueDay) && defaultDueDay.length()<=1 ) defaultDueDay = "0"+defaultDueDay;		String rptTermName = "";	BusinessObject component = com.amarsoft.app.als.businesscomponent.config.BusinessComponentConfig.getComponentDefinition(bp.getString("RPTTermID"));	if(component != null) rptTermName = component.getString("ComponentName");		ArrayList<Map<String,String>> rateArray = new ArrayList<Map<String,String>>();		List<BusinessObject> rateList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and RateTermID=:RateTermID order by SegToStage", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=01;RateTermID="+bp.getString("LoanRateTermID"));	double businessRate = 0d;	String repriceType="",repriceDate="";	int num = 0;	String beginDate = putoutDate;	for(BusinessObject rate:rateList)	{		//利率实时更新		String rateMode = rate.getString("RateMode");//利率模式		if(num == 0)		{			businessRate = rate.getDouble("BUSINESSRATE");//执行利率			repriceType = rate.getString("REPRICETYPE");//利率调整方式			repriceType = com.amarsoft.dict.als.cache.CodeCache.getItem("RepriceType", repriceType).getItemName();			repriceDate = rate.getString("REPRICEDATE");//指定调整日期			if(repriceDate != null) repriceDate = repriceDate.replaceAll("/", "");					}				if("RAT03".equals(bp.getString("LoanRateTermID")))		{			String rateMode1 = com.amarsoft.dict.als.cache.CodeCache.getItem("RateMode", rateMode).getItemName();			String repriceType1 = com.amarsoft.dict.als.cache.CodeCache.getItem("RepriceType", rate.getString("REPRICETYPE")).getItemName();			String repriceDate1 = rate.getString("REPRICEDATE");//指定调整日期			if(repriceDate1 != null) repriceDate1 = repriceDate1.replaceAll("/", "");			repriceType = "结构性固定利率";			repriceDate="";						beginDate = DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, rate.getInt("SegToStage"));						if(beginDate.compareTo(maturityDate) > 0) beginDate = maturityDate;						Map tmp1=new HashMap();				tmp1.put("EndDate",beginDate.replaceAll("/", ""));//到期日期1			tmp1.put("RateMode",rateMode1);//固定标志			tmp1.put("BusinessRate",String.valueOf(rate.getDouble("BUSINESSRATE")));//固定利率			tmp1.put("RateFloat",String.valueOf(rate.getString("RATEFLOAT")));//浮动比例			tmp1.put("repriceType",repriceType1);//利率调整方式1			tmp1.put("repriceDate",repriceDate1);//利率调整日期			rateArray.add(tmp1);		}				num ++;	}		//罚息利率	List<BusinessObject> fineList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo()+";RateType=02");	String PnyIntType = "0",PenaltyIntFlotRate = "";	for(BusinessObject fine:fineList)	{				PnyIntType = fine.getString("RateMode");		if("1".equals(PnyIntType)){			PenaltyIntFlotRate = String.valueOf(fine.getDouble("RateFloat"))+"%";		}		PnyIntType = com.amarsoft.dict.als.cache.CodeCache.getItem("RateMode", PnyIntType).getItemName();	}		//发展商账号,保证金账号,结算账号,结算账号凭证类型	String dvlprAcctNo = "",marginAcctNo = "",settleAcctNo = "",vchrType = "";		List<BusinessObject> accountList = bom.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType="+bp.getObjectType()+";ObjectNo="+bp.getObjectNo());	for(BusinessObject account:accountList)	{		if("01".equals(account.getString("AccountIndIcator")))		{			vchrType = account.getString("ACCOUNTTYPE");			vchrType = com.amarsoft.dict.als.cache.CodeCache.getItem("AccountType", vchrType).getItemName();			settleAcctNo = account.getString("ACCOUNTNO1");			if(settleAcctNo == null || "".equals(settleAcctNo))				settleAcctNo = account.getString("ACCOUNTNO");		}		else if("04".equals(account.getString("AccountIndIcator")))		{			dvlprAcctNo = account.getString("ACCOUNTNO1");			if(dvlprAcctNo == null || "".equals(dvlprAcctNo))				dvlprAcctNo = account.getString("ACCOUNTNO");		}		else if("06".equals(account.getString("AccountIndIcator")))		{			marginAcctNo = account.getString("ACCOUNTNO1");			if(marginAcctNo == null || "".equals(marginAcctNo) || "null".equals(marginAcctNo))				marginAcctNo = account.getString("ACCOUNTNO");			bailrate = account.getDouble("AccountAmt");		}	}		if("0".equals(paymentType))//收款人为借款人（备用金）	{		dvlprAcctNo=settleAcctNo;	}%>

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
  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>个人贷款放款通知书 </span></b><span
  lang=EN-US style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
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
  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>__________</span><span
  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>（部）会计部门：<span
  lang=EN-US>&nbsp;</span></span><span lang=EN-US style='font-size:12.0pt;
  font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:48.0pt'>
  <td width=621 colspan=4 style='width:465.75pt;border-top:none;border-left:
  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:48.0pt;font-size: 15px'>
  <p class=MsoNormal><u><span lang=EN-US style='font-family:宋体'><%=customerName%></span></u><span
  style='font-family:宋体'>（申请人）的<u><span lang=EN-US><%=businessTypeName%></span></u></span><span
  lang=EN-US><o:p></o:p></span></p>
  <p class=MsoNormal><span style='font-family:宋体'>已经按我行业务审批程序报经有权审批人审批同意，并通过放款审核，请你部按照本通知书要求，办理记账手续：<span
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
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>借据号</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=143 style='width:107.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=duebillSerialNo%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>客户号</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=mfCustomerID%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>贷款类型</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=445 colspan=3 style='width:333.75pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=businessTypeName+"-"+loanType%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>利率调整方式</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=repriceType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>指定日期</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=repriceDate%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>发展商帐号</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=dvlprAcctNo%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>发展商保证金帐号</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=marginAcctNo%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>还款方式</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=rptTermName%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>扣款周期</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=paymentFrequencyType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>固定月数</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=fixedPeriod%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>发放金额</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=DataConvert.toMoney(businessSum)%>元</span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>发展商保证金金额</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=DataConvert.toMoney(bailrate)%>元</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>扣款日期</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=defaultDueDay%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>期限</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=loanTerm%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>到期日</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=maturityDate%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>执行利率</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=445 colspan=3 style='width:333.75pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=businessRate%>%</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span class=GramE><span style='font-size:9.0pt;font-family:
  宋体'>帐户</span></span><span style='font-size:9.0pt;font-family:宋体'>种类</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=vchrType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>客户帐号</span><span lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=settleAcctNo%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>逾期利率浮动方式</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=PnyIntType%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>逾期浮动利率</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=PenaltyIntFlotRate%></span><span
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
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>递增、递减方式</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=incrMode%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>递增、递减周期</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'><%=incrDecPrd%></span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:18;height:15.0pt'>
  <td width=132 style='width:99.0pt;border-top:none;border-left:solid windowtext 1.5pt;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>本金递增、递减金额</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=153 style='width:114.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
  style='font-size:9.0pt;font-family:楷体_GB2312'> <%=Math.abs(incrDecAmt)%></span><span lang=EN-US
  style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=129 style='width:96.75pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;font-family:宋体'>&nbsp;</span><span
  lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
  </td>
  <td width=163 style='width:122.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>
  <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
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
    <p class=MsoNormal style1><span style='font-size:9.0pt;font-family:宋体'>本阶段还款方式</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:115.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:楷体_GB2312'><%=map.get("RPTTermName")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:105.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>本阶段截止期数</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:90.00pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:楷体_GB2312'><%=map.get("RPTTerm")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:105.0pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:1.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span style='font-size:9.0pt;font-family:宋体'>固定本金金额</span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
    <td width=140 style='width:90.00pt;border-top:0.0pt solid windowtext;border-bottom:1.0pt solid windowtext;
  border-left:0.0pt solid windowtext;border-right:0.0pt solid windowtext;padding-left:5.4pt;height:13.05pt'>
    <p class=MsoNormal><span lang=EN-US style='font-size:9.0pt;mso-ascii-font-family:
    楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US
    style='font-size:9.0pt;font-family:楷体_GB2312'><%=map.get("RPTAmount")%></span><span
    lang=EN-US style='font-size:9.0pt'><o:p></o:p></span></p>
    </td>
   </tr><%} %>

  </table>
  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US
  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>
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
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;
  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;font-size: 14px ' >放款监督人签字：</span></p>
  <p class=MsoNormal><span lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:
  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:14.0pt;mso-ascii-font-family:楷体_GB2312;mso-fareast-font-family:
  楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:14.0pt;font-family:楷体_GB2312'> </span><span
  lang=EN-US style='font-size:14.0pt;mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
  lang=EN-US style='font-size:11.0pt;mso-ascii-font-family:楷体_GB2312;
  mso-fareast-font-family:楷体_GB2312'>&nbsp;&nbsp;</span><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:宋体'>放款专用章：</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>
  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US
  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </span><span style='font-size:11.0pt;font-family:宋体'>日期：<span lang=EN-US><%=putoutDate%></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23;mso-yfti-lastrow:yes;height:24.2pt'>
  <td width=621 colspan=4 style='width:465.75pt;border:solid windowtext 1.5pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:24.2pt'>
  <p class=MsoNormal><span style='font-size:10.0pt;font-family:宋体;color:black'>（此通知书共三联，交客户经理、会计和文档管理员各一份）</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:
楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>
</div>    <table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
