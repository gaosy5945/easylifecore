<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%><%@ page import="com.amarsoft.app.als.common.util.DateHelper"%><%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%><%@ page import="com.amarsoft.app.als.common.util.NumberHelper"%><%		String APPLYSERIALNO = DataConvert.toString(CurPage.getParameter("SerialNo"));//��ȡҳ�洫�����������	if(APPLYSERIALNO == null)    APPLYSERIALNO = "";//6501202110082701	BizObject babiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("O.SERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO",APPLYSERIALNO).getSingleResult(false);	String CUSTOMERID = babiz.getAttribute("CUSTOMERID").getString();//����˱��	if(CUSTOMERID == null)    CUSTOMERID = "";	String NAME = babiz.getAttribute("CUSTOMERNAME").getString();//���������	if(NAME == null)    NAME = "";	String CONTRACTSERIALNO = babiz.getAttribute("CONTRACTARTIFICIALNO").getString();//������ͬ��ˮ��	if(CONTRACTSERIALNO == null)    CONTRACTSERIALNO = "";	String SEX = Sqlca.getString("select itemname from code_library where codeno = 'Sex' and itemno = (select SEX from ind_info where CUSTOMERID = '"+CUSTOMERID+"')");//�Ա�	if(SEX == null)    SEX = "";	String BIRTHDAY = Sqlca.getString("select BIRTHDAY from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");	if(BIRTHDAY == null)    BIRTHDAY = "";	String thisDay = StringFunction.getToday();	if(thisDay == null)    thisDay = "";	int AGE = DateHelper.getYears(BIRTHDAY, thisDay);//����	String COMPANY = Sqlca.getString("select EMPLOYMENT from ind_resume where CUSTOMERID = '"+CUSTOMERID+"'");//��˾	if(COMPANY == null)    COMPANY = "";	String DUTYID = Sqlca.getString("select HEADSHIP from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");//ְλ	if(DUTYID == null)    DUTYID = "";	String DUTY = "";	if(DUTYID!=null && DUTYID.length()>0){		DUTY = com.amarsoft.dict.als.cache.CodeCache.getItem("HeadShip", DUTYID).getItemName();	}	if(DUTY==null)DUTY="";	String MARRIAGE = Sqlca.getString("select getItemName('MaritalStatus',MARRIAGE) from ind_info where CUSTOMERID = '"+CUSTOMERID+"'");// ����	if(MARRIAGE == null)    MARRIAGE = "";	String HAVECHILDREN = Sqlca.getString(new SqlObject("select HAVECHILDREN from ind_info where customerid = :CustoemrId").setParameter("CustoemrId", CUSTOMERID));	String ChildrenOrNot = "";	if("�ѻ�".equals(MARRIAGE)){		if("1".equals(HAVECHILDREN)){			ChildrenOrNot = "����Ů ";		}else if ("2".equals(HAVECHILDREN)){			ChildrenOrNot = "����Ů ";		}	}		String mateid = Sqlca.getString("select RELATIVECUSTOMERID from customer_relative where relationship = '2007' and CUSTOMERID = '"+CUSTOMERID+"'");//��ż�û����	String MATEINFO = "";	if(mateid == null)    mateid = "";	else {		String MATENAME = Sqlca.getString("select CUSTOMERNAME from customer_info where CUSTOMERID = '"+mateid+"'");//��ż		int MATEAGE = (int)DataConvert.toDouble(StringFunction.getToday().substring(0, 4)) - Sqlca.getDouble("select substr(BIRTHDAY,0,4) from ind_info where CUSTOMERID = '"+mateid+"'").intValue();		String MATECOMPANY = Sqlca.getString("select EMPLOYMENT from ind_resume where CUSTOMERID = '"+mateid+"'");//��˾		if(MATECOMPANY == null)    MATECOMPANY = "";		String MATEDUTYID = Sqlca.getString("select HEADSHIP from ind_info where CUSTOMERID = '"+mateid+"'");//ְλ		if(MATEDUTYID == null)    MATEDUTYID = "";		String MATEDUTY = "";		if(MATEDUTYID!=null&&MATEDUTYID.length()>0){			MATEDUTY = com.amarsoft.dict.als.cache.CodeCache.getItem("HeadShip", MATEDUTYID).getItemName();		}		if(MATEDUTY==null)MATEDUTY="";		MATEINFO = ",��ż�� "+ MATENAME + ", ���䣺" + Integer.toString(MATEAGE) + "��, ϵ"+MATECOMPANY + MATEDUTY;	}	if(MATEINFO == null)    MATEINFO = "";	String FINANCE_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1010' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//�����ʲ�	if(FINANCE_ASSETS == null)    FINANCE_ASSETS = "";	String FIXED_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1020' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));// �̶��ʲ� 	if(FIXED_ASSETS == null)    FIXED_ASSETS = "";	String OTHER_ASSETS = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '1090' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//�����ʲ���Ͷ��	if(OTHER_ASSETS == null)    OTHER_ASSETS = "";	String DEBT = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where financialItem like '20%' and financialItem <> '20' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//��ծ�����и�ծ	if(DEBT == null)    DEBT = "";	/* double DEBT = Double.parseDouble(DEBTs);	DEBT = NumberHelper.keepTwoDecimalFormat(DEBT); */	String INVEST_MODE = DataConvert.toMoney(Sqlca.getString("select getItemName('SystemChannel',CHANNEL) from customer_finance where CUSTOMERID = '"+CUSTOMERID+"' and FINANCIALITEM = '3010'"));//���鷽ʽ	if(INVEST_MODE == null)    INVEST_MODE = "";	String SALARY_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3050' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//�ȶ�����	if(SALARY_INCOME == null)    SALARY_INCOME = "";	String RENT_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3020' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//�������	if(RENT_INCOME == null)    RENT_INCOME = "";	String MELON_CUTTING = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3030' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//Ͷ������	if(MELON_CUTTING == null)    MELON_CUTTING = "";	String OTHER_INCOME = DataConvert.toMoney(Sqlca.getString("select nvl(sum(AMOUNT),'0.00') from customer_finance where FINANCIALITEM = '3040' and (CUSTOMERID = '"+CUSTOMERID+"' or CUSTOMERID = '"+mateid+"')"));//��������	if(OTHER_INCOME == null)    OTHER_INCOME = "";	BizObject bibiz = null;	String PBC_INQUIRY_RESULT = "";	String PBC_INQUIRY = "";	String YJJ_INQUIRY = "";	String OTHER_INQUIRY = "";	String COMPANY_MANAGEMENT = "";		String LOAN_BENEFIT = "";	String GRANT_CONDITION = "";	String OTHER_DESC = "";	String CONTRIBUTE_DEGREE = "";	String TYGH_INQUIRY = "";	String PROJECT_RISK = "";	bibiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_INVEST").createQuery("O.OBjectType = 'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :OBJECTNO").setParameter("OBJECTNO",APPLYSERIALNO).getSingleResult(false);	if(bibiz != null){		PBC_INQUIRY_RESULT = bibiz.getAttribute("PBCINQUIRYRESULT").toString();//������������ϵͳ��ѯ���		PBC_INQUIRY = bibiz.getAttribute("PBCINQUIRY").toString();		YJJ_INQUIRY = bibiz.getAttribute("YJJINQUIRY").toString();//����ֲ�����Ϣ��ѯ���		OTHER_INQUIRY = bibiz.getAttribute("OTHERINQUIRY").toString();//���������˽���Ϣ		COMPANY_MANAGEMENT = bibiz.getAttribute("COMPANYMANAGEMENT").toString();//��������˿��ƵĹ�˾��Ӫ״��		/* GUAT_RISK = bibiz.getAttribute("GUATRISK").toString(); *///�ñʴ���ĵ�������		LOAN_BENEFIT = bibiz.getAttribute("LOANBENEFIT").toString();//�ۺ�Ч�����		GRANT_CONDITION = bibiz.getAttribute("GRANTCONDITION").toString();//���������		OTHER_DESC = bibiz.getAttribute("REMARK").toString();//������Ҫ˵��������		CONTRIBUTE_DEGREE = bibiz.getAttribute("CONTRIBUTEDEGREE").toString();//����˶Ա��е�ҵ���׶�		TYGH_INQUIRY = bibiz.getAttribute("TYGHINQUIRY").toString();//ͬҵ�����ѯ���		PROJECT_RISK = bibiz.getAttribute("PROJECTRISK").toString();//��������������Ŀ��������	}	if(PBC_INQUIRY_RESULT == null)    PBC_INQUIRY_RESULT = "";	if(PBC_INQUIRY == null)    PBC_INQUIRY = "";	if(YJJ_INQUIRY == null)    YJJ_INQUIRY = "";	if(OTHER_INQUIRY == null)    OTHER_INQUIRY = "";	if(COMPANY_MANAGEMENT == null)    COMPANY_MANAGEMENT = "";	if(LOAN_BENEFIT == null)    LOAN_BENEFIT = "";	if(GRANT_CONDITION == null)    GRANT_CONDITION = "";	if(OTHER_DESC == null)    OTHER_DESC = "";	if(CONTRIBUTE_DEGREE == null)    CONTRIBUTE_DEGREE = "";	if(TYGH_INQUIRY == null)    TYGH_INQUIRY = "";	if(PROJECT_RISK == null)    PROJECT_RISK = "";		String loantype = Sqlca.getString("select loantype from business_apply where SERIALNO = '"+APPLYSERIALNO+"'");	if(loantype == null)   loantype = "";	String BUSINESSTYPE = Sqlca.getString("select typename from business_type where typeno in (select BUSINESSTYPE from business_apply where SERIALNO = '"+APPLYSERIALNO+"') ");	if(BUSINESSTYPE == null)   BUSINESSTYPE = "";	String LNID = loantype +"-"+ BUSINESSTYPE ;	if( "-".equals(LNID))    LNID = ""; 	String BUSINESSTYPE1 = Sqlca.getString("select productName from prd_product_library where PRODUCTID in (select BUSINESSTYPE from business_apply where SERIALNO = '"+APPLYSERIALNO+"')");	if(BUSINESSTYPE1 == null)   BUSINESSTYPE1 = "";	String USAGENO = Sqlca.getString("select getItemName('CreditPurposeType',PURPOSETYPE) from business_apply where SERIALNO = '"+APPLYSERIALNO+"'");//����	if(USAGENO == null)    USAGENO = "";	String USAGE = babiz.getAttribute("PURPOSEDESCRIPTION").getString();//��;	if(USAGE == null)    USAGE = "";	//������ͬ���	List<BizObject> list = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE").createQuery("objecttype = 'jbo.guaranty.GUARANTY_CONTRACT' and applyserialno = :APPLYSERIALNO").setParameter("APPLYSERIALNO", APPLYSERIALNO).getResultList(true);	int i = 0;    String GCSERIALNO[]=new String[list.size()];//������ͬ��ˮ��	String GUATCODE[]=new String[list.size()];//������ʽ	String GUATRATE[] = new String[list.size()];//��������	String GUATPERSON[] = new String[list.size()];//������    String GUATSTATUS[]=new String[list.size()];//����״̬    String GUATINFO[]=new String[list.size()];//������Ϣ    String[] GUAT_RISK = new String[list.size()];    for(BizObject biz: list){    	GCSERIALNO[i]=biz.getAttribute("OBJECTNO").toString(); 		GUATCODE[i] = Sqlca.getString("select getITemName('GuarantyType',GUARANTYTYPE) from guaranty_contract where SerialNo = '"+GCSERIALNO[i]+"'");//�ñʴ���ĵ����������£�������ʽ		if(GUATCODE[i] == null)    GUATCODE[i] = "";		GUATRATE[i] = Sqlca.getString("select sum(GUARANTYPERCENT) from guaranty_relative where GCSERIALNO = '"+GCSERIALNO[i]+"'");		GUATPERSON[i] = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SERIALNO = '"+GCSERIALNO[i]+"'");		GUATSTATUS[i] = Sqlca.getString("select getItemName('GuarantyStatus',STATUS) from guaranty_relative where GCSERIALNO = '"+GCSERIALNO[i]+"'");		GUATINFO[i] = ",����Ѻ����Ϊ"+GUATRATE[i]+"%,����Ѻ�ﹲ����Ϊ"+GUATPERSON[i]+";��Ѻ��"+	GUATSTATUS[i];		GUAT_RISK[i] = "";		i++;	}	//������	String ASSURER1 = Sqlca.getString("select GUARANTORNAME from guaranty_contract where SerialNo = '"+GCSERIALNO+"'");	if(ASSURER1 == null)    ASSURER1 = "";	//ҵ�����ͻ��ͬ��	String CONTRACTNAME1 = Sqlca.getString("select typename from business_type where typeno = (select BUSINESSTYPE from business_apply where SerialNo = '"+APPLYSERIALNO+"')");	if(CONTRACTNAME1 == null)    CONTRACTNAME1 = "";		String VIP_FLAG = Sqlca.getString("select substr(MISCFLGS,1) from business_invest where objecttype = 'jbo.app.BUSINES_APPLY' and objectno = '"+APPLYSERIALNO+"'" );   //û�ж�Ӧ�ֶ�	if(VIP_FLAG == null)    VIP_FLAG = "";	String TOTAMT = DataConvert.toMoney(babiz.getAttribute("BUSINESSSUM").getDouble());//�������������鷢�Ž��Ϊ	if(TOTAMT == null)    TOTAMT = "";	int businessTerm = babiz.getAttribute("BUSINESSTERM").getInt();//����	int businessTermDay = babiz.getAttribute("BUSINESSTERMDAY").getInt();	String loanTERM = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))			+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))			+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))			;	//if(TERM == null)    TERM = 0;	String INTRATE = Sqlca.getString("select BUSINESSRATE from acct_rate_segment where objecttype = 'jbo.app.BUSINESS_APPLY' and objectno = '"+APPLYSERIALNO+"' and RATETERMID = '"+babiz.getAttribute("LOANRATETERMID").getString()+"'");//����	if(INTRATE == null)    INTRATE = "";	String tempRTN_TYPE = babiz.getAttribute("RPTTERMID").getString();	if(tempRTN_TYPE == null)    tempRTN_TYPE = "";	String RTN_TYPE = SYSNameManager.getTermName(tempRTN_TYPE);//���ʽ	if(RTN_TYPE == null)    RTN_TYPE = "";	String YJHFLAG = "";//�޴��ֶ� 	String RiskInfo = ""; 	String exists = Sqlca.getString("select 1 from customer_list cl where cl.customerid = '"+CUSTOMERID+"' and cl.listtype = '1040'");	if(exists == null){		RiskInfo = "ΥԼ��Ϣ����û�иÿͻ���Ϣ";	}else{		RiskInfo = "ΥԼ��Ϣ�����иÿͻ���Ϣ";	}  %>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=Section1 style='layout-grid:15.6pt' align="center">

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width="93%"
 style='width:93.26%;margin-left:5.4pt;border-collapse:collapse;mso-yfti-tbllook:
 480;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width="100%" colspan=2 valign=top style='width:100.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a align=center style='text-align:center'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:14.0pt;font-family:����_GB2312;color:black'>������鱨��<span
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
  <p class=a><span style='font-family:����_GB2312;color:black'>һ��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>���������<span
  lang=EN-US><%=NAME%></span>���Ա�<span lang=EN-US><%=SEX%></span>������<span lang=EN-US><%=AGE%></span>�꣬ϵ<span
  lang=EN-US><%=COMPANY%><%=DUTY%></span>��<span lang=EN-US><%=MARRIAGE%><%=ChildrenOrNot%><%=MATEINFO%></span>��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>����˼�ͥ����״̬���������£�<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>�����ʲ�������<span
  lang=EN-US><%=FINANCE_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>�̶��ʲ�������<span
  lang=EN-US><%=FIXED_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>�����ʲ���Ͷ�ʰ�����<span
  lang=EN-US><%=OTHER_ASSETS%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>��ծ�����и�ծ������<span
  lang=EN-US><%=DEBT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>����˼�ͥ��Ҫ������Դ���£�<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>���鷽ʽ��<span
  lang=EN-US><%=INVEST_MODE%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ȶ����룺<span
  lang=EN-US><%=SALARY_INCOME%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>������룺<span
  lang=EN-US><%=RENT_INCOME%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>Ͷ�����棺<span
  lang=EN-US><%=MELON_CUTTING%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>�������룺<span
  lang=EN-US><%=OTHER_INCOME%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;height:62.65pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:62.65pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ġ�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:62.65pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�����й����Ż�����ѯ��������������µ����ü�¼���£�<span
  lang=EN-US><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>������������ϵͳ��ѯ���Ϊ��<span
  lang=EN-US><%=PBC_INQUIRY_RESULT%></span><span lang=EN-US><%=PBC_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>����ֲ�����Ϣ��ѯ���Ϊ��<span
  lang=EN-US><%=YJJ_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>ͬҵ�����ѯ���Ϊ��<span
  lang=EN-US><%=TYGH_INQUIRY%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>���������˽���ϢΪ��<span
  lang=EN-US><%=OTHER_INQUIRY%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�塢<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>���������������Ϊ<span
  lang=EN-US><%=BUSINESSTYPE1%></span>������<span lang=EN-US><%=USAGENO%></span>��<span lang=EN-US><%=USAGE%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>��������������Ŀ��������Ϊ��<span
  lang=EN-US><%=PROJECT_RISK%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ߡ�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>��������˿��ƵĹ�˾��Ӫ״�����£�<span
  lang=EN-US><%=COMPANY_MANAGEMENT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ˡ�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ñʴ���ĵ����������£�  <%for(int j=0;j<list.size();j++){ %>  <span lang=EN-US>������ʽΪ<%=GUATCODE[j]%><%=GUATINFO[j]%></span>��<span lang=EN-US><%=GUAT_RISK[j]%><o:p></o:p></span></span></p>  <%} %>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�š�<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�ۺ�Ч�������<span
  lang=EN-US><%=LOAN_BENEFIT%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;height:10.0pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:10.0pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>ʮ��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:10.0pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�����������<span
  lang=EN-US><%=GRANT_CONDITION%><o:p></o:p></span></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>ʮһ��<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>������Ҫ˵��������У�<span
  lang=EN-US><%=OTHER_DESC%><o:p></o:p></span></span></p>
  <p class=a><span style='font-family:����_GB2312;color:black'>����˶Ա��е�ҵ���׶ȣ�<span
  lang=EN-US><%=CONTRIBUTE_DEGREE%><o:p></o:p></span></span></p>
  <%=VIP_FLAG%>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13;mso-yfti-lastrow:yes;height:3.5pt'>
  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>ʮ����<span
  lang=EN-US><o:p></o:p></span></span></p>
  </td>
  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;
  height:3.5pt'>
  <p class=a><span style='font-family:����_GB2312;color:black'>�������������鷢�Ž��Ϊ<span
  lang=EN-US><%=TOTAMT%></span>Ԫ������Ϊ<span lang=EN-US><%=loanTERM%></span>������Ϊ<span
  lang=EN-US><%=INTRATE%></span>����<span lang=EN-US><%=LNID%></span>�����ʽΪ<span
  lang=EN-US><%=RTN_TYPE%></span>��<span lang=EN-US><o:p></o:p></span></span></p>
  </td>
 </tr>  <tr style='mso-yfti-irow:14;mso-yfti-lastrow:yes;height:3.5pt'>  <td width="11%" valign=top style='width:11.0%;padding:0cm 5.4pt 0cm 5.4pt;  height:3.5pt'>  <p class=a><span style='font-family:����_GB2312;color:black'>ʮ����<span  lang=EN-US><o:p></o:p></span></span></p>  </td>  <td width="89%" valign=top style='width:89.0%;padding:0cm 5.4pt 0cm 5.4pt;  height:3.5pt'>  <p class=a><span style='font-family:����_GB2312;color:black'>Ԥ����Ϣ�� <%=RiskInfo %>   ��<span lang=EN-US><o:p></o:p></span></span></p>  </td> </tr>     <%=YJHFLAG%>
</table>

<p class=MsoNormal><span lang=EN-US style='color:black'><o:p>&nbsp;</o:p></span></p>
</div>
<table align="center">	<tr>			<td id="print"><%=HTMLControls.generateButton("��ӡ", "��ӡ", "printPaper()", "") %></td>	</tr></table></body><script>   function printPaper(){	   var print = document.getElementById("print");	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){		   //��ӡ	  		   print.style.display = "none";		   window.print();			   window.close();	   }   }</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
