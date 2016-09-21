<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%
//传入的参数如果是合同流水号
String contractserialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));
if(contractserialNo == null) contractserialNo = "";//11712012300100111101
//额度流水号
String CINO = Sqlca.getString("select serialno from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and status = '20' and objectno='"+contractserialNo+"'");
if(CINO == null) CINO = "";
//还款方式
String RPTTermID = Sqlca.getString(new SqlObject("select rpttermid from BUSINESS_CONTRACT where SerialNo = :SerialNo").setParameter("SerialNo", contractserialNo));
if(RPTTermID == null) RPTTermID = "";
//利率类型
String loanratetermid = Sqlca.getString(new SqlObject("select loanratetermid from BUSINESS_CONTRACT where SerialNo = :SerialNo").setParameter("SerialNo", contractserialNo));
if(loanratetermid == null) loanratetermid = "";
//客戶號
String custno = Sqlca.getString("select customerid from business_contract where serialno = '"+contractserialNo+"'");
if(custno == null) custno = "";
String mfcustno = Sqlca.getString("select MFCUSTOMERID from customer_info where customerid = '"+custno+"'");
if(mfcustno == null) mfcustno = "";
String custnm = Sqlca.getString("select customername from business_contract where serialno = '"+contractserialNo+"'"); //客戶名稱
if(custnm == null) custnm = "";
String brcode = Sqlca.getString("select OPERATEORGID from business_contract where serialno = '"+contractserialNo+"'"); //机构号 
if(brcode == null) brcode = "";
String contractno = Sqlca.getString("select CONTRACTARTIFICIALNO from business_contract where serialno = '"+contractserialNo+"'"); //授信合同号
if(contractno == null) contractno = "";
String cardno = Sqlca.getString("select accountno from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'"); //融资易卡号
if(cardno == null) cardno = "";
//关联合同号
String COCONTRACTNO = Sqlca.getString("select CONTRACTARTIFICIALNO from business_contract where serialno in (select objectno from cl_info where serialno in (select parentserialno from cl_info where serialno = '"+CINO+"'))"); 
if(COCONTRACTNO == null) COCONTRACTNO = "";
//融资易备用金账号
String rtnactno = Sqlca.getString("select accountno1 from ACCT_BUSINESS_ACCOUNT where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno = '"+contractserialNo+"'");
if(rtnactno == null) rtnactno = "";
//融资易授信额度
String totbal = DataConvert.toMoney(Sqlca.getString("select BUSINESSAPPAMT from cl_info where serialno ='"+CINO+"'")); 
if(totbal == null) totbal = "0.00";
String tedate = Sqlca.getString("select MATURITYDATE from cl_info where serialno = '"+CINO+"'");
if(tedate == null) tedate = "";
String avbal = DataConvert.toMoney(Sqlca.getString("select NVL(BUSINESSAVABALANCE,BUSINESSAPPAMT) from cl_info where serialno ='"+CINO+"'")); //可用额度
if(avbal == null) avbal = "0.00";
String freezeamt = DataConvert.toMoney(Sqlca.getString("select BUSINESSAPPAMT from cl_info where objecttype= 'jbo.app.BUSINESS_CONTRACT' and CLType in ('0103','0104') and status = '40' and objectno='"+contractserialNo+"'")); //冻结额度
if(freezeamt == null || "".equals(freezeamt)) freezeamt = "0.00";
//融资易占用额度
String lnamt = DataConvert.toMoney(Sqlca.getString("select nvl(Balance,0) from business_contract where serialno = '"+contractserialNo+"'"));
if(lnamt == null) lnamt = "0.00";
String R_TYPE_SNAME = "";
String r_type_name = Sqlca.getString("select getitemname('CLType',CLType) from cl_info where serialno = '"+CINO+"'");
if(r_type_name == null) r_type_name = "";
else R_TYPE_SNAME = r_type_name.substring(3, 5);
String dispose_flg = Sqlca.getString("select itemname from code_library where codeno = 'CLLoanGenerateType' and itemno in (select LOANGENERATETYPE from cl_info where serialno ='"+CINO+"')"); //贷款生成处理方式
if(dispose_flg == null) dispose_flg = "";
String businessTermStr = Sqlca.getString("select CLTERM from cl_info where serialno = '"+CINO+"'");
int businessTerm=0;
if(businessTermStr != null){
	businessTerm = Integer.parseInt(businessTermStr) ;
}
String businessTermDayStr = Sqlca.getString("select CLTERMDAY from cl_info where serialno = '"+CINO+"'");
int businessTermDay=0;
if(businessTermDayStr != null){
	businessTermDay = Integer.parseInt(businessTermDayStr) ;
}
String con_term = (businessTerm/12 < 10 ? "0"+String.valueOf(businessTerm/12) : String.valueOf(businessTerm/12))//融资易贷款期限
+ (businessTerm%12 < 10 ? "0"+String.valueOf(businessTerm%12) : String.valueOf(businessTerm%12))
+ (businessTermDay < 10 ? "0"+String.valueOf(businessTermDay) : String.valueOf(businessTermDay))
;

//还款流水号
String replySerialNo = Sqlca.getString("select serialno from acct_rpt_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno='"+contractserialNo+"' and RPTTermID = '"+RPTTermID+"'");
if(replySerialNo == null) replySerialNo = "";
String rtn_type = Sqlca.getString("select componentname from PRD_COMPONENT_LIBRARY where componenttype like 'PRD0301%' and status='1' and componentid in (select RPTTERMID from acct_rpt_segment where serialno = '"+replySerialNo+"')"); //偿还方式
if(rtn_type == null) rtn_type = "";
String rtn_interval = Sqlca.getString("select getitemname('PaymentFrequencyType',PAYMENTFREQUENCYTYPE) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); //还款间隔
if(rtn_interval == null) rtn_interval = "";
//还款日确定方式
String rtn_date_type = Sqlca.getString("select getitemname('DefaultDueDayType',DefaultDueDayType) from acct_rpt_segment where serialNo='"+replySerialNo+"'"); // 0－借款日为还款日 1－指定还款日期 
String rtn_date = Sqlca.getString("select DEFAULTDUEDAY from acct_rpt_segment where serialNo='"+replySerialNo+"'");//还款日
if(rtn_date == null) rtn_date = "";
if(rtn_date_type == null){
	if(rtn_date == ""){
		rtn_date_type = "借款日为还款日";
	}else{
		rtn_date_type = "指定还款日期";
	}
}
//利率编号
String rateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and ratetype='01' and objectno='"+contractserialNo+"'  and RATETERMID = '"+loanratetermid+"'"); 
if(rateSerialNo == null) rateSerialNo = "";
String intrate_adj = Sqlca.getString("select getitemname('RepriceType',repricetype) from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整方式
if(intrate_adj == null) intrate_adj = "";
String int_year_adj_date = Sqlca.getString("select REPRICEDATE from acct_rate_segment where serialno  ='"+rateSerialNo+"'"); //利率调整日期
if(int_year_adj_date == null) int_year_adj_date = "";
String fltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+rateSerialNo+"'");
if(fltintrate == null){
	fltintrate = "";
}else{
	fltintrate += "%";
}
//罚息利率流水号
String prateSerialNo = Sqlca.getString("select serialno from acct_rate_segment where objecttype='jbo.app.BUSINESS_CONTRACT' and ratetype='02' and objectno='"+contractserialNo+"'");
if(prateSerialNo == null) prateSerialNo = "";
String pfltintrate_opt = Sqlca.getString("select getitemname('RateMode',RATEMODE) from acct_rate_segment where serialno  ='"+prateSerialNo+"'"); //罚息浮动选项
if(pfltintrate_opt == null) pfltintrate_opt = "";
String pfltintrate = Sqlca.getString("select RATEFLOAT from acct_rate_segment where serialno  ='"+prateSerialNo+"'");
if(pfltintrate == null){
	pfltintrate = "";
}else{
	pfltintrate += "%"; 
}
String mgrnm = Sqlca.getString("select OPERATEUSERID from business_contract where serialno = '"+contractserialNo+"'");// 客户经理
if(mgrnm == null) mgrnm = "";
//打印时间
SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd HH:mm");
String txdate = sdfTemp.format(new Date());
if(txdate == null) txdate = "";

%>

<head>

<title>融资易额度及生成贷款规则信息表</title>

<script language="javascript">
	function domReady() {

		//融资易转账时隐藏贷款生成处理方式

		var rzyType = "@RZY_TYPE";

		if (rzyType == "2") {

			document.getElementById('loanGenTr').style.display = "none";

		}

	}
</script>

<!--[if gte mso 9]><xml>

 <w:WordDocument>

  <w:Zoom>110</w:Zoom>

  <w:TrackMoves>false</w:TrackMoves>

  <w:TrackFormatting/>

  <w:ValidateAgainstSchemas/>

  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>

  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>

  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>

  <w:DoNotPromoteQF/>

  <w:LidThemeOther>EN-US</w:LidThemeOther>

  <w:LidThemeAsian>ZH-CN</w:LidThemeAsian>

  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>

  <w:Compatibility>

   <w:BreakWrappedTables/>

   <w:SnapToGridInCell/>

   <w:WrapTextWithPunct/>

   <w:UseAsianBreakRules/>

   <w:DontGrowAutofit/>

   <w:SplitPgBreakAndParaMark/>

   <w:DontVertAlignCellWithSp/>

   <w:DontBreakConstrainedForcedTables/>

   <w:DontVertAlignInTxbx/>

   <w:Word11KerningPairs/>

   <w:CachedColBalance/>

   <w:UseFELayout/>

  </w:Compatibility>

  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>

  <m:mathPr>

   <m:mathFont m:val="Cambria Math"/>

   <m:brkBin m:val="before"/>

   <m:brkBinSub m:val="&#45;-"/>

   <m:smallFrac m:val="off"/>

   <m:dispDef/>

   <m:lMargin m:val="0"/>

   <m:rMargin m:val="0"/>

   <m:defJc m:val="centerGroup"/>

   <m:wrapIndent m:val="1440"/>

   <m:intLim m:val="subSup"/>

   <m:naryLim m:val="undOvr"/>

  </m:mathPr></w:WordDocument>

</xml><![endif]-->
<!--[if gte mso 9]><xml>

 <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="false"

  DefSemiHidden="false" DefQFormat="false" LatentStyleCount="267">

  <w:LsdException Locked="false" QFormat="true" Name="Normal"/>

  <w:LsdException Locked="false" QFormat="true" Name="heading 1"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 2"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 3"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 4"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 5"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 6"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 7"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 8"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="heading 9"/>

  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"

   QFormat="true" Name="caption"/>

  <w:LsdException Locked="false" QFormat="true" Name="Title"/>

  <w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"/>

  <w:LsdException Locked="false" QFormat="true" Name="Subtitle"/>

  <w:LsdException Locked="false" QFormat="true" Name="Strong"/>

  <w:LsdException Locked="false" QFormat="true" Name="Emphasis"/>

  <w:LsdException Locked="false" Priority="99" Name="No List"/>

  <w:LsdException Locked="false" Priority="99" SemiHidden="true"

   Name="Placeholder Text"/>

  <w:LsdException Locked="false" Priority="1" QFormat="true" Name="No Spacing"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 1"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 1"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 1"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 1"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 1"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 1"/>

  <w:LsdException Locked="false" Priority="99" SemiHidden="true" Name="Revision"/>

  <w:LsdException Locked="false" Priority="34" QFormat="true"

   Name="List Paragraph"/>

  <w:LsdException Locked="false" Priority="29" QFormat="true" Name="Quote"/>

  <w:LsdException Locked="false" Priority="30" QFormat="true"

   Name="Intense Quote"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 1"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 1"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 1"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 1"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 1"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 1"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 1"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 1"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 2"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 2"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 2"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 2"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 2"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 2"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 2"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 2"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 2"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 2"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 2"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 2"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 2"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 2"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 3"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 3"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 3"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 3"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 3"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 3"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 3"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 3"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 3"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 3"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 3"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 3"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 3"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 3"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 4"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 4"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 4"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 4"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 4"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 4"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 4"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 4"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 4"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 4"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 4"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 4"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 4"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 4"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 5"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 5"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 5"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 5"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 5"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 5"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 5"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 5"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 5"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 5"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 5"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 5"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 5"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 5"/>

  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 6"/>

  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 6"/>

  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 6"/>

  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 6"/>

  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 6"/>

  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 6"/>

  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 6"/>

  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 6"/>

  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 6"/>

  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 6"/>

  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 6"/>

  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 6"/>

  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 6"/>

  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 6"/>

  <w:LsdException Locked="false" Priority="19" QFormat="true"

   Name="Subtle Emphasis"/>

  <w:LsdException Locked="false" Priority="21" QFormat="true"

   Name="Intense Emphasis"/>

  <w:LsdException Locked="false" Priority="31" QFormat="true"

   Name="Subtle Reference"/>

  <w:LsdException Locked="false" Priority="32" QFormat="true"

   Name="Intense Reference"/>

  <w:LsdException Locked="false" Priority="33" QFormat="true" Name="Book Title"/>

  <w:LsdException Locked="false" Priority="37" SemiHidden="true"

   UnhideWhenUsed="true" Name="Bibliography"/>

  <w:LsdException Locked="false" Priority="39" SemiHidden="true"

   UnhideWhenUsed="true" QFormat="true" Name="TOC Heading"/>

 </w:LatentStyles>

</xml><![endif]-->

<style>
<!-- /* Font Definitions */
@font-face {
	font-family: 宋体;
	panose-1: 2 1 6 0 3 1 1 1 1 1;
	mso-font-alt: SimSun;
	mso-font-charset: 134;
	mso-generic-font-family: auto;
	mso-font-pitch: variable;
	mso-font-signature: 3 135135232 16 0 262145 0;
}

@font-face {
	font-family: "Cambria Math";
	panose-1: 2 4 5 3 5 4 6 3 2 4;
	mso-font-charset: 1;
	mso-generic-font-family: roman;
	mso-font-format: other;
	mso-font-pitch: variable;
	mso-font-signature: 0 0 0 0 0 0;
}

@font-face {
	font-family: Calibri;
	panose-1: 2 15 5 2 2 2 4 3 2 4;
	mso-font-charset: 0;
	mso-generic-font-family: swiss;
	mso-font-pitch: variable;
	mso-font-signature: -1610611985 1073750139 0 0 159 0;
}

@font-face {
	font-family: 楷体_GB2312;
	panose-1: 2 1 6 9 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: modern;
	mso-font-pitch: fixed;
	mso-font-signature: 1 135135232 16 0 262144 0;
}

@font-face {
	font-family: "\@宋体";
	panose-1: 2 1 6 0 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: auto;
	mso-font-pitch: variable;
	mso-font-signature: 3 135135232 16 0 262145 0;
}

@font-face {
	font-family: "\@楷体_GB2312";
	panose-1: 2 1 6 9 3 1 1 1 1 1;
	mso-font-charset: 134;
	mso-generic-font-family: modern;
	mso-font-pitch: fixed;
	mso-font-signature: 1 135135232 16 0 262144 0;
}

/* Style Definitions */
p.MsoNormal,li.MsoNormal,div.MsoNormal {
	mso-style-unhide: no;
	mso-style-qformat: yes;
	mso-style-parent: "";
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: justify;
	text-justify: inter-ideograph;
	mso-pagination: widow-orphan;
	font-size: 10.5pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

p.MsoHeader,li.MsoHeader,div.MsoHeader {
	mso-style-unhide: no;
	mso-style-link: "页眉 Char";
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: center;
	mso-pagination: widow-orphan;
	tab-stops: center 207.65pt right 415.3pt;
	layout-grid-mode: char;
	border: none;
	mso-border-bottom-alt: solid windowtext .75pt;
	padding: 0cm;
	mso-padding-alt: 0cm 0cm 1.0pt 0cm;
	font-size: 9.0pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

p.MsoFooter,li.MsoFooter,div.MsoFooter {
	mso-style-unhide: no;
	mso-style-link: "页脚 Char";
	margin: 0cm;
	margin-bottom: .0001pt;
	mso-pagination: widow-orphan;
	tab-stops: center 207.65pt right 415.3pt;
	layout-grid-mode: char;
	font-size: 9.0pt;
	font-family: "Times New Roman", "serif";
	mso-fareast-font-family: 宋体;
}

span.MsoCommentReference {
	mso-style-unhide: no;
	color: fuchsia;
}

span.sodafield {
	mso-style-name: sodafield;
	mso-style-unhide: no;
	color: blue;
}

span.msonormal0 {
	mso-style-name: msonormal;
	mso-style-unhide: no;
}

span.Char {
	mso-style-name: "页眉 Char";
	mso-style-unhide: no;
	mso-style-locked: yes;
	mso-style-link: 页眉;
	mso-ansi-font-size: 9.0pt;
	mso-bidi-font-size: 9.0pt;
	font-family: 宋体;
	mso-fareast-font-family: 宋体;
}

span.Char0 {
	mso-style-name: "页脚 Char";
	mso-style-unhide: no;
	mso-style-locked: yes;
	mso-style-link: 页脚;
	mso-ansi-font-size: 9.0pt;
	mso-bidi-font-size: 9.0pt;
	font-family: 宋体;
	mso-fareast-font-family: 宋体;
}

.MsoChpDefault {
	mso-style-type: export-only;
	mso-default-props: yes;
	font-size: 10.0pt;
	mso-ansi-font-size: 10.0pt;
	mso-bidi-font-size: 10.0pt;
	mso-ascii-font-family: "Times New Roman";
	mso-hansi-font-family: "Times New Roman";
	mso-font-kerning: 0pt;
}

/* Page Definitions */
@page {
	mso-footnote-separator: url("RzyApplyPass.files/header.htm") fs;
	mso-footnote-continuation-separator:
		url("RzyApplyPass.files/header.htm") fcs;
	mso-endnote-separator: url("RzyApplyPass.files/header.htm") es;
	mso-endnote-continuation-separator: url("RzyApplyPass.files/header.htm")
		ecs;
}

@page Section1 {
	size: 595.3pt 841.9pt;
	margin: 72.0pt 90.0pt 72.0pt 81.0pt;
	mso-header-margin: 42.55pt;
	mso-footer-margin: 49.6pt;
	mso-paper-source: 0;
	layout-grid: 15.6pt;
}

div.Section1 {
	page: Section1;
}
-->
</style>

<!--[if gte mso 10]>

<style>

 /* Style Definitions */

 table.MsoNormalTable

	{mso-style-name:普通表格;

	mso-tstyle-rowband-size:0;

	mso-tstyle-colband-size:0;

	mso-style-noshow:yes;

	mso-style-priority:99;

	mso-style-qformat:yes;

	mso-style-parent:"";

	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;

	mso-para-margin:0cm;

	mso-para-margin-bottom:.0001pt;

	mso-pagination:widow-orphan;

	font-size:10.0pt;

	font-family:"Times New Roman","serif";}

</style>

<![endif]-->

<meta http-equiv=expires content=-1>

<!--[if gte mso 9]><xml>

 <o:shapedefaults v:ext="edit" spidmax="16386"/>

</xml><![endif]-->
<!--[if gte mso 9]><xml>

 <o:shapelayout v:ext="edit">

  <o:idmap v:ext="edit" data="1"/>

 </o:shapelayout></xml><![endif]-->

</head>



<body lang=ZH-CN
	style='tab-interval: 21.0pt; text-justify-trim: punctuation'
	onload="domReady();">



	<div class=Section1 style='layout-grid: 15.6pt' align="center">



		<p class=MsoNormal style='margin-left: -35.9pt; text-indent: 35.9pt'>
			<span lang=EN-US>&nbsp;<o:p></o:p></span>
		</p>



		<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
			width=639
			style='width: 479.25pt; margin-left: 5.4pt; border-collapse: collapse; mso-yfti-tbllook: 1184; mso-padding-alt: 0cm 0cm 0cm 0cm'
			height=727>

			<tr style='mso-yfti-irow: 0; mso-yfti-firstrow: yes; height: 51.75pt'>

				<td width=633 colspan=4
					style='width: 474.45pt; border: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; background: #AAAAAA; padding: 0cm 5.4pt 0cm 5.4pt; height: 51.75pt'>

					<p class=MsoNormal align=center style='text-align: center'>
						<b>融资易额度及生成贷款规则信息表</b><span lang=EN-US
							style='font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体'><o:p></o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 1; height: 62.25pt'>

				<td width=633 colspan=4
					style='width: 474.45pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 62.25pt'>

					<p class=MsoNormal>
						<span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体; color: black'>客户号为</span><u><span
							lang=EN-US
							style='font-size: 12.0pt; font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体; color: black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span
								style='mso-spacerun: yes'>&nbsp; </span><%=mfcustno%><span
								style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span>&nbsp;&nbsp;
						</span></u><span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体; color: black'>的</span><u><span
							lang=EN-US
							style='font-size: 12.0pt; font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体; color: black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><u><span
							lang=EN-US
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体; color: black'><span
								style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							</span><%=custnm %><span style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							</span></span></u><u><span lang=EN-US
							style='font-size: 12.0pt; font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体; color: black'>&nbsp;
						</span></u><span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体; color: black'>客户名下卡号为</span><u><span
							lang=EN-US
							style='font-size: 12.0pt; font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体; color: black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span
								style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							</span><%=cardno %><span style='mso-spacerun: yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							</span>&nbsp;<span style='mso-spacerun: yes'>&nbsp; </span></span></u><span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体; color: black'>的当前融资易额度及生成融资易贷款规则等信息如下：</span><span
							class=msonormal0><span lang=EN-US
							style='font-family: "Calibri", "sans-serif"; mso-bidi-font-family: 宋体; color: black'><o:p></o:p></span></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 2; height: 15.0pt'>

				<td width=633 colspan=4
					style='width: 474.45pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体'>
							<span lang=EN-US><o:p></o:p></span>
						</span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 3; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>客户号</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=mfcustno %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>客户姓名</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=custnm %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 4; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>机构号</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=brcode %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 5; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易<%=R_TYPE_SNAME %>授信合同号</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=contractno %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>关联合同号</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=COCONTRACTNO %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 6; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>融资易卡号</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=cardno %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>融资易备用金账号</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=rtnactno %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 10; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易额度类型</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=r_type_name %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 7; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style="font-family: 宋体">融资易</span>授信额度
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 宋体'>&yen;</span><span
							lang=EN-US style='font-family: 楷体_GB2312'><%=totbal %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'><span style="font-family: 宋体">融资易额度到期日</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=tedate %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 8; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易可用额度</span><span lang=EN-US><o:p></o:p></span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 宋体'>&yen;</span><span
							lang=EN-US style='font-family: 楷体_GB2312'><%=avbal %></span><span
							lang=EN-US style='font-family: 宋体'><o:p></o:p></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易冻结额度<span lang=EN-US><o:p></o:p></span></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 宋体'>&yen;</span><span
							lang=EN-US style='font-family: 楷体_GB2312'><%=freezeamt %></span><span
							lang=EN-US style='font-family: 宋体'><o:p></o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 10; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易占用额度</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 宋体'>&yen;</span><span
							lang=EN-US style='font-family: 楷体_GB2312'><%=lnamt %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>融资易贷款期限</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=con_term %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr id='loanGenTr' style='mso-yfti-irow: 10; height: 15.0pt;'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>贷款生成处理方式</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=dispose_flg %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 11; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>还款方式</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=rtn_type %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>还款间隔</span><span lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p></o:p></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=rtn_interval%></span><span
							lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p></o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 12; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>还款日确定方式</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=rtn_date_type %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>还款日</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=rtn_date %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 13; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>利率调整方式</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=intrate_adj %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>利率调整日期</span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=int_year_adj_date %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 14; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>利率浮动率<span lang=EN-US>%</span></span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=fltintrate %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'></td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'></td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 15; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>罚息浮动选项</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=pfltintrate_opt %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>罚息浮动率<span lang=EN-US>%</span></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=pfltintrate %></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 16; height: 15.0pt'>

				<td width=148
					style='width: 110.85pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span style='font-family: 宋体'>客户经理</span>
					</p>

				</td>

				<td width=135
					style='width: 100.9pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 楷体_GB2312'><%=mgrnm %></span>
					</p>

				</td>

				<td width=153
					style='width: 115.1pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td width=197
					style='width: 147.6pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal>
						<span lang=EN-US
							style='font-size: 10.0pt; mso-fareast-font-family: "Times New Roman"'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 17; height: 15.0pt'>

				<td width=633 colspan=4
					style='width: 474.45pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span
							style='font-size: 12.0pt; font-family: 宋体; mso-bidi-font-family: 宋体'>
							<span lang=EN-US><o:p></o:p></span>
						</span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 15.0pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

			<tr style='mso-yfti-irow: 18; mso-yfti-lastrow: yes; height: 120.9pt'>

				<td width=633 colspan=4 valign=top
					style='width: 474.45pt; border-top: none; border-left: solid windowtext 1.5pt; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt; height: 120.9pt'>

					<p class=MsoNormal>
						<span
							style='font-family: 宋体; mso-hansi-font-family: "Times New Roman"; mso-bidi-font-family: 宋体; color: black; mso-ansi-language: ZH-CN'>备注：相关额度均为截止上一日情况。</span><span
							style='font-family: 宋体'> <span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p>
						</span></span>
					</p>

					<p class=MsoNormal align=right
						style='margin-right: 6.75pt; text-align: right'>
						<span lang=EN-US style='font-family: 宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p>
						</span>
					</p>

					<p class=MsoNormal align=right
						style='margin-right: 24.75pt; text-align: right'>
						<span style='font-family: 宋体'>打印时间：</span><span lang=EN-US>
							<%=txdate %></span><span lang=EN-US style='font-family: 宋体'><o:p></o:p></span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span lang=EN-US style='font-family: 宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p>
						</span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span style='font-family: 宋体'> <span lang=EN-US><o:p></o:p></span></span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span style='font-family: 宋体'> <span lang=EN-US><o:p></o:p></span></span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span style='font-family: 宋体'> <span lang=EN-US><o:p></o:p></span></span>
					</p>

					<p class=MsoNormal>
						<span lang=EN-US style='font-family: 宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							<o:p></o:p>
						</span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span lang=EN-US style='font-family: 宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							<o:p></o:p>
						</span>
					</p>

					<p class=MsoNormal style='margin-left: 9.0pt'>
						<span lang=EN-US style='font-family: 宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

						</span><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; </span><span
							lang=EN-US style='font-family: 宋体'><o:p></o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 120.9pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 120.9pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 120.9pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

				<td style='padding: 0cm 0cm 0cm 0cm; height: 120.9pt'>

					<p class=MsoNormal align=left style='text-align: left'>
						<span lang=EN-US style='font-size: 10.0pt'><o:p>&nbsp;</o:p></span>
					</p>

				</td>

			</tr>

		</table>



		<p class=MsoNormal>
			<span lang=EN-US
				style='font-size: 12.0pt; mso-ascii-font-family: 楷体_GB2312; mso-fareast-font-family: 楷体_GB2312'>&nbsp;</span>
		</p>



<table align="center">
	<tr>	
		<td id="print"><%=HTMLControls.generateButton("打印", "打印", "printPaper()", "") %></td>
	</tr>
</table>

</body>

<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   if(window.confirm("是否确定要打印？")){
		   //打印	  
		   print.style.display = "none";
		   window.print();	
		   window.close();
	   }
   }
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>