<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%><%@ page import="com.amarsoft.app.als.common.util.NumberHelper"%><%		String APPLYSERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//获取页面传过来的申请号	if(APPLYSERIALNO == null)    APPLYSERIALNO = "";//6501202110082701	BizObject babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("O.SERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",APPLYSERIALNO).getSingleResult(false);	String CUSTOMERID = babiz.getAttribute("CUSTOMERID").getString();//借款人编号	if(CUSTOMERID == null)    CUSTOMERID = "";	String NAME = babiz.getAttribute("CUSTOMERNAME").getString();//借款申请人	if(NAME == null)    NAME = "";	String CONTRACTSERIALNO = babiz.getAttribute("CONTRACTARTIFICIALNO").getString();//关联合同流水号	if(CONTRACTSERIALNO == null)    CONTRACTSERIALNO = "";	String SEX = Sqlca.getString("select itemname from code_library where codeno = 'Sex' and itemno = (select SEX from ind_info where CUSTOMERID = '"+CUSTOMERID+"')");//性别	if(SEX == null)    SEX = "";	String BIRTHDAY = Sqlca.getString("select BIRTHDAY from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");	if(BIRTHDAY == null)    BIRTHDAY = "";	String thisDay = StringFunction.getToday();	if(thisDay == null)    thisDay = "";	int AGE = DateHelper.getYears(BIRTHDAY, thisDay);//年龄	String COMPANY = Sqlca.getString("select EMPLOYMENT from ind_resume where CUSTOMERID = '"+CUSTOMERID+"'");//公司	if(COMPANY == null)    COMPANY = "";	String DUTYID = Sqlca.getString("select HEADSHIP from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");//职位	if(DUTYID == null)    DUTYID = "";	String DUTY = "";	if(DUTYID!=null && DUTYID.length()>0){		DUTY = com.amarsoft.dict.als.cache.CodeCache.getItem("HeadShip", DUTYID).getItemName();	}	if(DUTY==null)DUTY="";	String MARRIAGE = Sqlca.getString("select getItemName('MaritalStatus',MARRIAGE) from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");// 婚姻	if(MARRIAGE == null)    MARRIAGE = "";	String HAVECHILDREN = Sqlca.getString(new SqlObject("select HAVECHILDREN from ind_info where customerid = :CustoemrId").setParameter("CustoemrId", CUSTOMERID));	String ChildrenOrNot = "";	if("已婚".equals(MARRIAGE)){		if("1".equals(HAVECHILDREN)){			ChildrenOrNot = "有子女 ";		}else if ("2".equals(HAVECHILDREN)){			ChildrenOrNot = "无子女 ";		}	}		String mateid = Sqlca.getString("select RELATIVECUSTOMERID from customer_relative where relationship = '2007' and CUSTOMERID = '"+CUSTOMERID+"'");//配偶用户编号	String MATEINFO = "";	if(mateid == null)    mateid = "";	else {		String MATENAME = Sqlca.getString("select CUSTOMERNAME from customer_info where CUSTOMERID = '"+mateid+"'");//配偶		int MATEAGE = (int)DataConvert.toDouble(StringFunction.getToday().substring(0, 4)) - Sqlca.getDouble("select substr(BIRTHDAY,0,4) from ind_info where CUSTOMERID = '"+mateid+"'").intValue();		String MATECOMPANY = Sqlca.getString("select EMPLOYMENT from ind_resume where CUSTOMERID = '"+mateid+"'");//公司		if(MATECOMPANY == null)    MATECOMPANY = "";		String MATEDUTYID = Sqlca.getString("select HEADSHIP from ind_info where CUSTOMERID = '"+mateid+"'");//职位		if(MATEDUTYID == null)    MATEDUTYID = "";		String MATEDUTY = "";		if(MATEDUTYID!=null&&MATEDUTYID.length()>0){			MATEDUTY = com.amarsoft.dict.als.cache.CodeCache.getItem("HeadShip", MATEDUTYID).getItemName();		}		if(MATEDUTY==null)MATEDUTY="";		MATEINFO = ",配偶： "+ MATENAME + ", 年龄：" + Integer.toString(MATEAGE) + "岁, 系"+MATECOMPANY + MATEDUTY;	}	if(MATEINFO == null)    MATEINFO = "";	String FINANCE_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1010' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//金融资产	if(FINANCE_ASSETS == null)    FINANCE_ASSETS = "";	String FIXED_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1020' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));// 固定资产 	if(FIXED_ASSETS == null)    FIXED_ASSETS = "";	String OTHER_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1090' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//其他资产及投资	if(OTHER_ASSETS == null)    OTHER_ASSETS = "";	String DEBT = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where financialItem like '20%' and financialItem <> '20' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//负债及或有负债	if(DEBT == null)    DEBT = "";	/* double DEBT = Double.parseDouble(DEBTs);	DEBT = NumberHelper.keepTwoDecimalFormat(DEBT); */	String INVEST_MODE = DataConvert.toMoney(Sqlca.getString("select getItemName('SystemChannel',CHANNEL) from customer_finance where CUSTOMERID = '"+CUSTOMERID+"' and FINANCIALITEM = '3010'"));//调查方式	if(INVEST_MODE == null)    INVEST_MODE = "";	String SALARY_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3050' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//稳定收入	if(SALARY_INCOME == null)    SALARY_INCOME = "";	String RENT_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3020' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//租金收入	if(RENT_INCOME == null)    RENT_INCOME = "";	String MELON_CUTTING = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3030' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//投资收益	if(MELON_CUTTING == null)    MELON_CUTTING = "";	String OTHER_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3040' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//其他收入	if(OTHER_INCOME == null)    OTHER_INCOME = "";	BizObject bibiz = null;	String PBC_INQUIRY_RESULT = "";	String PBC_INQUIRY = "";	String YJJ_INQUIRY = "";	String OTHER_INQUIRY = "";	String COMPANY_MANAGEMENT = "";		String LOAN_BENEFIT = "";	String GRANT_CONDITION = "";	String OTHER_DESC = "";	String CONTRIBUTE_DEGREE = "";	String TYGH_INQUIRY = "";	String PROJECT_RISK = "";	bibiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_INVEST").createQuery("O.OBjectType = 'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :OBJECTNO").setParameter("OBJECTNO",APPLYSERIALNO).getSingleResult(false);	if(bibiz != null){		PBC_INQUIRY_RESULT = bibiz.getAttribute("PBCINQUIRYRESULT").toString();//人民银行征信系统查询结果		PBC_INQUIRY = bibiz.getAttribute("PBCINQUIRY").toString();		YJJ_INQUIRY = bibiz.getAttribute("YJJINQUIRY").toString();//银监局不良信息查询结果		OTHER_INQUIRY = bibiz.getAttribute("OTHERINQUIRY").toString();//其他渠道了解信息		COMPANY_MANAGEMENT = bibiz.getAttribute("COMPANYMANAGEMENT").toString();//借款申请人控制的公司经营状况		/* GUAT_RISK = bibiz.getAttribute("GUATRISK").toString(); *///该笔贷款的担保风险		LOAN_BENEFIT = bibiz.getAttribute("LOANBENEFIT").toString();//综合效益分析		GRANT_CONDITION = bibiz.getAttribute("GRANTCONDITION").toString();//贷款发放条件		OTHER_DESC = bibiz.getAttribute("REMARK").toString();//其他需要说明的事项		CONTRIBUTE_DEGREE = bibiz.getAttribute("CONTRIBUTEDEGREE").toString();//借款人对本行的业务贡献度		TYGH_INQUIRY = bibiz.getAttribute("TYGHINQUIRY").toString();//同业公会查询结果		PROJECT_RISK = bibiz.getAttribute("PROJECTRISK").toString();//所购房产所属项目风险评价	}	if(PBC_INQUIRY_RESULT == null)    PBC_INQUIRY_RESULT = "";	if(PBC_INQUIRY == null)    PBC_INQUIRY = "";	if(YJJ_INQUIRY == null)    YJJ_INQUIRY = "";	if(OTHER_INQUIRY == null)    OTHER_INQUIRY = "";	if(COMPANY_MANAGEMENT == null)    COMPANY_MANAGEMENT = "";	if(LOAN_BENEFIT == null)    LOAN_BENEFIT = "";	if(GRANT_CONDITION == null)    GRANT_CONDITION = "";	if(OTHER_DESC == null)    OTHER_DESC = "";	if(CONTRIBUTE_DEGREE == null)    CONTRIBUTE_DEGREE = "";	if(TYGH_INQUIRY == null)    TYGH_INQUIRY = "";	if(PROJECT_RISK == null)    PROJECT_RISK = "";		String loantype = Sqlca.getString("select loantype from business_apply where SERIALNO = '"+APPLYSERIALNO+"'");	if(loantype == null)   loantype = "";	String BUSINESSTYPE = Sqlca.getString("select typename from business_type where typeno in (select BUSINESSTYPE from business_apply where SERIALNO = '"+APPLYSERIALNO+"') ");	if(BUSINESSTYPE == null)   BUSINESSTYPE = "";	String LNID = loantype +"-"+ BUSINESSTYPE ;	if( "-".equals(LNID))    LNID = ""; 	String BUSINESSTYPE1 = Sqlca.getString("select productName from prd_product_library where PRODUCTID in (select BUSINESSTYPE from business_apply where SERIALNO = '"+APPLYSERIALNO+"')");	if(BUSINESSTYPE1 == null)   BUSINESSTYPE1 = "";	String USAGENO = Sqlca.getString("select getItemName('CreditPurposeType',PURPOSETYPE) from business_apply where SERIALNO = '"+APPLYSERIALNO+"'");//用于	if(USAGENO == null)    USAGENO = "";	String USAGE = babiz.getAttribute("PURPOSEDESCRIPTION").getString();//用途	if(USAGE == null)    USAGE = "";	//担保合同编号	List<BizObject> list = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE").createQuery("objecttype = 'jbo.guaranty.GUARANTY_CONTRACT' and applyserialno = :APPLYSERIALNO").setParameter("APPLYSERIALNO", APPLYSERIALNO).getResultList(true);	int i = 0;    String GCSERIALNO[]=new String[list.size()];//担保合同流水号	String GUATCODE[]=new String[list.size()];//担保方式	String GUATRATE[] = new String[list.size()];//担保比例	String GUATPERSON[] = new String[list.size()];//担保人    String GUATSTATUS[]=new String[list.size()];//担保状态    String GUATINFO[]=new String[list.size()];//担保信息    String[] GUAT_RISK = new String[list.size()];    for(BizObject biz: list){    	GCSERIALNO[i]=biz.getAttribute("OBJECTNO").toString(); 		GUATCODE[i] = Sqlca.getString("select getITemName('GuarantyType',GUARANTYTYPE) from guaranty_contract where SerialNo = '"+GCSERIALNO[i]+"'");//该笔贷款的担保风险如下：担保方式		if(GUATCODE[i] == null)    GUATCODE[i] = "";		GUATRATE[i] = Sqlca.getString("select sum(GUARANTYPERCENT) from guaranty_relative where GCSERIALNO = '"+GCSERIALNO[i]+"'");		GUATPERSON[i] = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SERIALNO = '"+GCSERIALNO[i]+"'");		GUATSTATUS[i] = Sqlca.getString("select getItemName('GuarantyStatus',STATUS) from guaranty_relative where GCSERIALNO = '"+GCSERIALNO[i]+"'");		GUATINFO[i] = ",抵质押比例为"+GUATRATE[i]+"%,抵质押物共有人为"+GUATPERSON[i]+";抵押物"+	GUATSTATUS[i];		GUAT_RISK[i] = "";		i++;	}	//出质人	String ASSURER1 = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SerialNo = '"+GCSERIALNO+"'");	if(ASSURER1 == null)    ASSURER1 = "";	//业务类型或合同名	String CONTRACTNAME1 = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_apply where SerialNo = '"+APPLYSERIALNO+"')");	if(CONTRACTNAME1 == null)    CONTRACTNAME1 = "";		String VIP_FLAG = Sqlca.getString("select substr(MISCFLGS,1) from business_invest where objecttype = 'jbo.app.BUSINES_APPLY' and objectno = '"+APPLYSERIALNO+"'" );   //没有对应字段	if(VIP_FLAG == null)    VIP_FLAG = "";	String TOTAMT = DataConvert.toMoney(babiz.getAttribute("BUSINESSSUM").getDouble());//综上所述，建议发放金额为	if(TOTAMT == null)    TOTAMT = "";	int businessTerm = babiz.getAttribute("BUSINESSTERM").getInt();//期限	int businessTermDay = babiz.getAttribute("BUSINESSTERMDAY").getInt();	String loanTERM = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))			+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))			+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))			;	//if(TERM == null)    TERM = 0;	String INTRATE = Sqlca.getString("select BUSINESSRATE from acct_rate_segment where objecttype = 'jbo.app.BUSINESS_APPLY' and objectno = '"+APPLYSERIALNO+"' and RATETERMID = '"+babiz.getAttribute("LOANRATETERMID").getString()+"'");//利率	if(INTRATE == null)    INTRATE = "";	String tempRTN_TYPE = babiz.getAttribute("RPTTERMID").getString();	if(tempRTN_TYPE == null)    tempRTN_TYPE = "";	String RTN_TYPE = SYSNameManager.getTermName(tempRTN_TYPE);//还款方式	if(RTN_TYPE == null)    RTN_TYPE = "";	String YJHFLAG = "";//无此字段 	String RiskInfo = ""; 	String exists = Sqlca.getString("select 1 from customer_list cl where cl.customerid = '"+CUSTOMERID+"' and cl.listtype = '1040'");	if(exists == null){		RiskInfo = "违约信息库中没有该客户信息";	}else{		RiskInfo = "违约信息库中有该客户信息";	}  %>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width="93%"
 style='width:93.26%;margin-left:5.4pt;border-collapse:collapse;mso-yfti-tbllook:
 480;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width="100%" colspan=2 valign=top style='width:100.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a align=center style='text-align:center'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:14.0pt;font-family:楷体_GB2312;color:black'>贷款调查报告<span
  lang=EN-US><o:p></o:p></span></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width="100%" colspan=2 valign=top style='width:100.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a align=center style='text-align:center'><span lang=EN-US
  style='color:black'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>一、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>借款申请人<span
  lang=EN-US><%=NAME%></span>，性别<span lang=EN-US><%=SEX%></span>，年龄<span lang=EN-US><%=AGE%></span>岁，系<span
  lang=EN-US><%=COMPANY%><%=DUTY%></span>，<span lang=EN-US><%=MARRIAGE%><%=ChildrenOrNot%><%=MATEINFO%></span>。<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>二、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>借款人家庭财务状态调查结果如下：<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>金融资产包括：<span
  lang=EN-US><%=FINANCE_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>固定资产包括：<span
  lang=EN-US><%=FIXED_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>其他资产及投资包括：<span
  lang=EN-US><%=OTHER_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>负债及或有负债包括：<span
  lang=EN-US><%=DEBT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>三、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>借款人家庭主要收入来源如下：<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>调查方式：<span
  lang=EN-US><%=INVEST_MODE%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>稳定收入：<span
  lang=EN-US><%=SALARY_INCOME%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>租金收入：<span
  lang=EN-US><%=RENT_INCOME%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>投资收益：<span
  lang=EN-US><%=MELON_CUTTING%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>其他收入：<span
  lang=EN-US><%=OTHER_INCOME%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:62.65pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:62.65pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>四、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:62.65pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>经向有关征信机构查询，借款申请人最新的信用记录如下：<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>人民银行征信系统查询结果为：<span
  lang=EN-US><%=PBC_INQUIRY_RESULT%></span><span lang=EN-US><%=PBC_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>银监局不良信息查询结果为：<span
  lang=EN-US><%=YJJ_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>同业公会查询结果为：<span
  lang=EN-US><%=TYGH_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>其他渠道了解信息为：<span
  lang=EN-US><%=OTHER_INQUIRY%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>五、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>本次申请贷款类型为<span
  lang=EN-US><%=BUSINESSTYPE1%></span>，用于<span lang=EN-US><%=USAGENO%></span>，<span lang=EN-US><%=USAGE%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>六、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>所购房产所属项目风险评价为：<span
  lang=EN-US><%=PROJECT_RISK%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>七、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>借款申请人控制的公司经营状况如下：<span
  lang=EN-US><%=COMPANY_MANAGEMENT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>八、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>该笔贷款的担保风险如下：  <%for(int j=0;j<list.size();j++){ %>  <span lang=EN-US>担保方式为<%=GUATCODE[j]%><%=GUATINFO[j]%></span>；<span lang=EN-US><%=GUAT_RISK[j]%><o:p></o:p></span></span></p>  <%} %>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>九、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>综合效益分析：<span
  lang=EN-US><%=LOAN_BENEFIT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;height:10.0pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:10.0pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>十、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:10.0pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>贷款发放条件：<span
  lang=EN-US><%=GRANT_CONDITION%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>十一、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>其他需要说明的事项还有：<span
  lang=EN-US><%=OTHER_DESC%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>借款人对本行的业务贡献度：<span
  lang=EN-US><%=CONTRIBUTE_DEGREE%><o:p></o:p></span></span></p>
  <%=VIP_FLAG%>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13;mso-yfti-lastrow:yes;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>十二、<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:仿宋_GB2312;color:black'>综上所述，建议发放金额为<span
  lang=EN-US><%=TOTAMT%></span>元，期限为<span lang=EN-US><%=loanTERM%></span>，利率为<span
  lang=EN-US><%=INTRATE%></span>％的<span lang=EN-US><%=LNID%></span>，还款方式为<span
  lang=EN-US><%=RTN_TYPE%></span>。<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>  <tr style='mso-yfti-irow:14;mso-yfti-lastrow:yes;height:3.5pt'>  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;  height:3.5pt'>  <p class=a><span style='font-family:仿宋_GB2312;color:black'>十三、<span  lang=EN-US><o:p></o:p></span></span></p>  </td>  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;  height:3.5pt'>  <p class=a><span style='font-family:仿宋_GB2312;color:black'>预警信息： <%=RiskInfo %>   。<span lang=EN-US><o:p></o:p></span></span></p>  </td> </tr>     <%=YJHFLAG%>
</table>

<p class=MsoNormal><span lang=EN-US style='color:black'><o:p>&nbsp;</o:p></span></p>
</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("是否确定要打印？")){		   //打印	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
