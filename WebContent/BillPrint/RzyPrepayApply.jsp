<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.common.util.DateHelper"%>
<%@ page import="com.amarsoft.app.oci.bean.Message" %>
<%@ page import="com.amarsoft.app.oci.bean.OCITransaction" %>
<%@ page import="com.amarsoft.app.oci.instance.CoreInstance" %>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache" %>
<%
	
	//交易流水
	String transSerialNo = DataConvert.toString(CurPage.getParameter("SerialNo"));
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	
	BusinessObject transaction = bom.loadBusinessObject("jbo.acct.ACCT_TRANSACTION", transSerialNo);
	
	BusinessObject bdChange = bom.loadBusinessObject(transaction.getString("DocumentObjectType"),transaction.getString("DocumentObjectNo"));
	
	BusinessObject bd = bom.loadBusinessObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));


	String CINO = bd.getObjectNo();
	if(CINO == null)     CINO = "";
	String CUSTNM = bd.getString("CustomerName");// 申请人
	if(CUSTNM == null)     CUSTNM = "";
	String contractSerialNo = bd.getString("ContractSerialNo");
	if(contractSerialNo == null)     contractSerialNo = "";
	String LNNAME = com.amarsoft.dict.als.manage.NameManager.getBusinessName(bd.getString("BusinessType"));//贷款品种	
	if(LNNAME == null)     LNNAME = "";
	String BRCODENO = bd.getString("MFOrgID");// 营业机构号
	if(BRCODENO == null)     BRCODENO = "";
	
	String TRANSAPPNO = transSerialNo.substring(2, 8)+transSerialNo.substring(10, 16);
	if(TRANSAPPNO == null) TRANSAPPNO = "";
	String RTNBAL = bdChange.getString("PAYAMT");
	if(RTNBAL == null){
		RTNBAL = "";
	}else {
		RTNBAL = RTNBAL + "元";	
	};
	String TXDATE = transaction.getString("accountingdate");//交易日期
	if(TXDATE == null)     TXDATE = "";
	String DATE = StringFunction.getToday();
	if(DATE == null)     DATE = "";
	String ACTNO = Sqlca.getString(new SqlObject("select ACCOUNTNO from ACCT_BUSINESS_ACCOUNT where objectno = :CINO and objectType = 'jbo.app.BUSINESS_DUEBILL' and ACCOUNTINDICATOR = '01'").setParameter("CINO", CINO));//专户账号
	if(ACTNO == null)     ACTNO = "";
	String AcctType = Sqlca.getString(new SqlObject("select AccountType from ACCT_BUSINESS_ACCOUNT where objectno = :CINO and objectType = 'jbo.app.BUSINESS_DUEBILL' and ACCOUNTINDICATOR = '01'").setParameter("CINO", CINO));//专户账号
	if(AcctType == null)     AcctType = "0";
	AcctType = CodeCache.getItem("AccountType", AcctType).getAttribute1();
	OCITransaction oci = CoreInstance.CrnAcctBalQry("92261005", "2261", "1",AcctType,"","",ACTNO,"01","0",1,10,"0005", Sqlca.getConnection());
	List<Message> message = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("CrnBalDtlInfo").getFieldArrayValue();
	String ClientAcctNo = message.get(0).getFieldValue("ClientAcctNo");
%>

<style>
*{
font-size: 15px
}
</style>

<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>



<div class=Section1 style='layout-grid:15.6pt' align="center">



<p class=MsoNormal style='margin-left:-35.9pt;text-indent:35.9pt'><span

lang=EN-US>&nbsp;<o:p></o:p></span></p>



<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=639

 style='width:479.25pt;margin-left:5.4pt;border-collapse:collapse;mso-padding-alt:

 0cm 0cm 0cm 0cm' height=727>

 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:51.75pt'>

  <td width=639 colspan=4 style='width:479.25pt;border:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;background:#AAAAAA;padding:0cm 5.4pt 0cm 5.4pt;

  height:51.75pt'>

  <p class=MsoNormal align=center style='text-align:center'><b><span

  style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>个人融资易转账退汇资金提前还款通知书

  </span></b><span lang=EN-US style='font-size:12.0pt;font-family:宋体;

  mso-bidi-font-family:宋体'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:1;height:16.5pt'>

  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:16.5pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>&nbsp;</span><span

  lang=EN-US style='font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:2;height:33.0pt'>

  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:33.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span lang=EN-US

  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>__________</span><span

  style='font-size:11.0pt;font-family:宋体;mso-bidi-font-family:宋体'>（部）会计部门：<span

  lang=EN-US>&nbsp;</span></span><span lang=EN-US style='font-size:12.0pt;

  font-family:宋体;mso-bidi-font-family:宋体'><o:p></o:p></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:3;height:62.25pt'>

  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:62.25pt'>

  <p class=MsoNormal><u><span lang=EN-US style='font-family:宋体'><%=CUSTNM%></span></u><span

  style='font-family:宋体'>（申请人）的<u><span lang=EN-US>个人融资易转账退汇资金</span></u>提前还款申请</span></p>

  <p class=MsoNormal><span style='font-family:宋体'>已经按我行业务审批程序报经有权审批人审批同意，请你部按照本通知书要求，办理融资易转账退汇提前还款手续：</span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:4;height:15.0pt'>

  <td width=639 colspan=4 style='width:479.25pt;border-top:none;border-left:

  solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;border-right:

  solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal align=left style='text-align:left'><span style='font-size:

  12.0pt;font-family:宋体;mso-bidi-font-family:宋体'>　<span lang=EN-US><o:p></o:p></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:5;height:15.0pt'>

  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>借据号</span></p>

  </td>

  <td width=157 style='width:118.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'><%=CINO%></span></p>

  </td>

  <td width=133 style='width:99.55pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>退汇金额</span></p>

  </td>

  <td width=213 style='width:159.75pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'><%=RTNBAL%></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:5;height:15.0pt'>

  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>审核业务编号</span></p>

  </td>

  <td width=157 style='width:118.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'><%=TRANSAPPNO%></span></p>

  </td>

  <td width=133 style='width:99.55pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>申请日期</span></p>

  </td>

  <td width=213 style='width:159.75pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'><%=TXDATE%></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:6;height:15.0pt'>

  <td width=136 style='width:101.85pt;border-top:none;border-left:solid windowtext 1.5pt;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'>专户账号</span></p>

  </td>

  <td width=157 style='width:118.1pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'><%=ClientAcctNo%></span></p>

  </td>

  <td width=133 style='width:99.55pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span style='font-family:宋体'></span></p>

  </td>

  <td width=213 style='width:159.75pt;border-top:none;border-left:none;

  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.5pt;

  padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='mso-ascii-font-family:楷体_GB2312;

  mso-fareast-font-family:楷体_GB2312'>&nbsp;</span><span lang=EN-US

  style='font-family:楷体_GB2312'></span></p>

  </td>

 </tr>



 <tr style='mso-yfti-irow:8;height:15.0pt'>

  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;

  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;

  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:15.0pt'>

  <p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:

  楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:9;height:169.5pt'>

  <td width=639 colspan=4 valign=top style='width:479.25pt;border-top:none;

  border-left:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;

  border-right:solid windowtext 1.5pt;padding:0cm 5.4pt 0cm 5.4pt;height:169.5pt'>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;

  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;

  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>

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

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体'>经办人签字：<span

  lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span></span><span lang=EN-US style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span><!--span style='font-size:11pt;font-family:宋体'>审批人员签字：</span--></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US

  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  &nbsp;&nbsp;&nbsp;&nbsp;</span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;

  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;

  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span style='font-family:宋体;

  mso-ascii-font-family:"Times New Roman";mso-hansi-font-family:"Times New Roman"'>　</span></p>

  <p class=MsoNormal style='margin-left:9.0pt'><span lang=EN-US

  style='font-size:11.0pt;font-family:宋体'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

  </span><span style='font-size:11.0pt;font-family:宋体'>日期：<span lang=EN-US><%=DATE%></span></span></p>

  </td>

 </tr>

 <tr style='mso-yfti-irow:10;mso-yfti-lastrow:yes;height:80.25pt'>

  <td width=639 colspan=4 style='width:479.25pt;border:solid windowtext 1.5pt;

  border-top:none;padding:0cm 5.4pt 0cm 5.4pt;height:80.25pt'>

  <p class=MsoNormal><span style='font-size:10.0pt;font-family:宋体;color:black'>（此通知书共三联，交客户经理、会计和文档管理员各一份）</span></p>

  </td>

 </tr>

</table>



<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;mso-ascii-font-family:

楷体_GB2312;mso-fareast-font-family:楷体_GB2312'>&nbsp;</span></p>



</div>

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




