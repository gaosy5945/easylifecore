<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<style type="text/css">
    .style1{
		border:none;
		border-collapse:collapse; 

	}
    #planlist tbody tr.true1 td {
      background-color: #eee;
      height:1px;
    }
    #planlist tbody tr.false1  td {
      background-color: #fff;
      height:1px;
    }
	.th_btn3
	{
		background-color: #eee;
		font-size:13px;
		height:1px;
	} 
	@media   print   {  
    .xx   {display:none}  
  	}  
</style>
  
	<%
try
{
	String PG_TITLE = "还款计划"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//从上个页面得到传入的参数
	String DstrAmt = CurPage.getParameter("DstrAmt");//贷款金额 1
	
	String StartIntDate = DateHelper.getStringDate(CurPage.getParameter("StartIntDate"));//贷款起始日  1
	String ExpiredDate = DateHelper.getStringDate(CurPage.getParameter("ExpiredDate"));//贷款到期日 1
	int BusinessTerm = DateHelper.getMonths(CurPage.getParameter("StartIntDate"), CurPage.getParameter("ExpiredDate"));
	
	String IntRate = CurPage.getParameter("BusinessRate");//执行利率（年） 1
	if(IntRate == null) IntRate = "";
	String IntActualPrd = CurPage.getParameter("IntActualPrd");//计息周期 (还款周期) 1
	if(IntActualPrd == null) IntActualPrd = "";
	String FixedPeriod1 = CurPage.getParameter("FixedPeriod1"); //固定周期	1
	int FixedPeriod; 
	if(FixedPeriod1 == null||"".equals(FixedPeriod1))
		FixedPeriod = 1;
	else
		FixedPeriod = Integer.parseInt(FixedPeriod1);
	
	String DeductDate = CurPage.getParameter("DeductDate");//每月扣款日  1
	if(DeductDate == null||DeductDate.length()==0) {
		DeductDate = StartIntDate.substring(StartIntDate.length()-2);
	}
	String StartNum1 = CurPage.getParameter("StartNum1");//起始笔数 1
	if(StartNum1 == null) StartNum1 = "1";
	String QueryNum1 = CurPage.getParameter("QueryNum1");//查询笔数 1
	if(QueryNum1 == null) QueryNum1 = "99";
	String IncrDecAmt = CurPage.getParameter("IncrDecAmt"); //递变幅度 1
	double nIncrDecAmt;
	if(IncrDecAmt == null||IncrDecAmt.equals("")) 
		nIncrDecAmt = 0.0;
	else
		nIncrDecAmt =  Double.parseDouble(IncrDecAmt);	
	String IncrMode = "";  //递增递减方式
	if(nIncrDecAmt >= 0){  
		IncrMode = "1";
	}
	else{
		IncrMode = "2";
	}	
	nIncrDecAmt = Math.abs(nIncrDecAmt);		
	String IncrDecPrd = CurPage.getParameter("IncrDecPrd"); //递变周期 1
	if(IncrDecPrd == null) IncrDecPrd ="";
	
	//String FxdFlag = CurPage.getParameter("FxdFlag");//固定浮动标志
	String MoExpiredDate; 
	//期供计算期限(月供到期日)
	String PayCountTime = CurPage.getParameter("PayCountTime");
	if(PayCountTime == null||"".equals(PayCountTime)){
		MoExpiredDate = "";
	}
	else{		
		String putoutDate = SystemConfig.getBusinessDate(); 
		String date = DateHelper.getRelativeDate(putoutDate,DateHelper.TERM_UNIT_MONTH,Integer.parseInt(PayCountTime));
		MoExpiredDate = DateHelper.getStringDate(date);
	}
		
	//<!-------------->还款方式信息组
	String RepayMode = CurPage.getParameter("RepayMode");//还款方式 1
	if(RepayMode == null) RepayMode = "";
	//组合还款
	String FxdPrncpl = CurPage.getParameter("FxdPrncpl"); //固定本金金额  	
	double nFxdPrncpl;
	if(FxdPrncpl == null||"".equals(FxdPrncpl)){
		nFxdPrncpl = 0.0;
	}
	else{
		nFxdPrncpl = Double.parseDouble(FxdPrncpl);
	}
	
		
	String PrdStopTerm = CurPage.getParameter("PrdStopTerm"); //阶段截止期数
	if(PrdStopTerm == null) PrdStopTerm = "";
	String TermValue = CurPage.getParameter("TermValue"); //阶段截止期数
	if(TermValue == null) TermValue = "";
	
	//<!-------------->还贷利率信息组
	//组合利率
	String ExpiredDate1 = CurPage.getParameter("ExpiredDate1"); //阶段结束日期
	if(ExpiredDate1 == null) ExpiredDate1 ="";
	String RepayMode1 = RepayMode; 
	
	//浮动利率
	String SpclDate = CurPage.getParameter("RateChangeDate"); //利率调整日期 1 <!---------后改--------->
	if(SpclDate == null) SpclDate ="";
	if(!SpclDate.equals("")) SpclDate = SpclDate.substring(0,2)+SpclDate.substring(3);
	String FxdFlag = CurPage.getParameter("RateType"); //固定标志，利率类型  1
	if(FxdFlag == null) FxdFlag="";
	String FxdIntRate = CurPage.getParameter("BusinessRate"); //执行利率  1
	double nFxdIntRate;
	if(FxdIntRate == null||FxdIntRate.equals("")) 
		 nFxdIntRate = 0.0; 
	else 
		nFxdIntRate = Double.parseDouble(FxdIntRate);
	String FloatPercent = CurPage.getParameter("FloatRange"); //浮动比例(浮动幅度) 1
	double nFloatPercent;
	if(FloatPercent == null||FloatPercent.equals("")) 
		nFloatPercent= 0.0;
	else
		nFloatPercent = Double.parseDouble(FloatPercent);
	String IntRateAdjType1 = CurPage.getParameter("RateChangeType"); //利率调整方式 1
	if(IntRateAdjType1 == null) IntRateAdjType1 ="";
	
	//組件的轉化
	RepayMode = RepayMode.substring(RepayMode.length()-1);  //還款方式
	//调整方式的转化
	Item item = CodeCache.getItem("RepriceType",IntRateAdjType1);
	if(item!=null)IntRateAdjType1 = item.getAttribute1();
	//还款周期
	if("6".equals(RepayMode)&&(IntActualPrd==null||IntActualPrd.length()==0)){
		IntActualPrd = (((TermValue.split("~"))[0]).split("@"))[2];
	}
	Item item2 = CodeCache.getItem("PaymentFrequencyType",IntActualPrd);
	if(item2!=null)IntActualPrd = item2.getAttribute1();
	if(IntActualPrd == null) IntActualPrd = "";
	//利率类型的转换
	Item item3 = CodeCache.getItem("RateMode",FxdFlag);
	if(item3!=null)FxdFlag = item3.getAttribute2();
	
	%>


<html>
<body>
<%	
	ArrayList<Map<String,String>> list1 = new ArrayList<Map<String,String>>();
	ArrayList<Map<String,String>> list2 = new ArrayList<Map<String,String>>();
	
	Map tmp=new HashMap();	
	if("6".equals(RepayMode)){
		String [] TermValueList = TermValue.split("~");
		for(int i=0;i<TermValueList.length;i++){
			String [] result = TermValueList[i].split("@");
			Map tmp2=new HashMap();		
			tmp2.put("PrdStopTerm",result[2]);
			tmp2.put("FxdPrncpl",("5".equals(result[0]))?result[1].replaceAll(",", ""):0);
			tmp2.put("RepayMode1",result[0]);
			list1.add(tmp2);	
		}
	}
	
	Map tmp1=new HashMap();	
	tmp1.put("ExpiredDate1",ExpiredDate1);
	tmp1.put("FxdFlag",FxdFlag);
	tmp1.put("FxdIntRate",nFxdIntRate);
	tmp1.put("FloatPercent",nFloatPercent);
	tmp1.put("IntRateAdjType1",IntRateAdjType1);
	tmp1.put("SpclDate",SpclDate);
	//list2.add(tmp1);
	
	StringBuffer sJSScript = new StringBuffer();
	List<Message> imessage = new ArrayList<Message>();
	//調用接口
	while(true)
	{
		OCITransaction oci = CoreInstance.CorpMrtgOrPslLnPrdPymtMsr("92261005", "2261", Double.parseDouble(DstrAmt), RepayMode, Double.parseDouble(IntRate), IntActualPrd,FixedPeriod, StartIntDate, ExpiredDate, DeductDate, Integer.parseInt(StartNum1),Integer.parseInt(QueryNum1),nIncrDecAmt,IncrMode,IncrDecPrd, MoExpiredDate,"", list1, list2, Sqlca.getConnection());
		List<Message> ims = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("RepymtMsrInfo").getFieldArrayValue();
		
		imessage.addAll(ims);
		if(ims.size() >= Integer.parseInt(QueryNum1))
		{
			StartNum1 = String.valueOf(Integer.parseInt(StartNum1)+Integer.parseInt(QueryNum1));
		}
		else
		{
			break;
		}
	}
	
	if(imessage==null){
		%>
			<script>OpenPage("/CreditManage/CreditLoan/LoansTrialNull.jsp","_self",""); </script>
		<%
		return;
	}
	String[] aa = null;
	aa = new String[imessage.size()];
	double businessSum = Double.parseDouble(DstrAmt);
	double allTotAmt = 0.0d;
	double allPrnAmt = 0.0d;
	double allIntAmt = 0.0d;
	for(int i = 0; i < imessage.size() ; i ++){
		Message message = imessage.get(i);
		businessSum-=Double.parseDouble(message.getFieldValue("RepymtPrncpl"));
		allTotAmt += Double.parseDouble(message.getFieldValue("TotAmt"));
		allPrnAmt += Double.parseDouble(message.getFieldValue("RepymtPrncpl"));
		allIntAmt += Double.parseDouble(message.getFieldValue("RepymtIntAmt"));
		
		sJSScript.append("<tr>");
		sJSScript.append("<td align='center'>"+message.getFieldValue("PrdStopTerm")+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("TotAmt"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtPrncpl"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(message.getFieldValue("RepymtIntAmt"))+"</td>");
 	 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(businessSum)+"</td>");
 	 	sJSScript.append("</tr>");
	}
	
	sJSScript.append("<tr>");
	sJSScript.append("<td align='center'>合计</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allTotAmt)+"</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allPrnAmt)+"</td>");
 	sJSScript.append("<td align='right'>"+DataConvert.toMoney(allIntAmt)+"</td>");
 	sJSScript.append("<td align='right'></td>");
 	sJSScript.append("</tr>");
%>
<%/*~END~*/%>
<%-- <table width="100%" height=10px cellspacing="0" cellpadding="0" border="0">
    <tr>
	    <td class="buttonback" valign=top>
		    <table>
		    	<tr class="xx">	
					
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印期供列表","ExcelPrint()","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","关闭","关闭","self.close();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Excel中查看","Excel中查看","htmlToExcel();","")%></td>
					 <td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","Word中查看","Word中查看","htmlToWord();","")%></td>
				</tr>
			</table>
		</td>
	</tr>
</table> --%>

<!--MODIFY BY XJQIN 200908-->
<div id="elDiv" style="overflow:auto;width:100%;height:95%" > 
	<table id="PlanTable" width=100% height=50%>
	<tr>
	  <td>
		<table  width=70%  style="border-collapse:collapse;" id="planList" align="center" border="2" cellpadding="0" cellspacing="0"  bordercolor="#000000">
		    <tr  bordercolor="#FFFFFF">
			  <th colspan=6 style="border-bottom:1px solid #000000;"><h1>还款计划表<h1></th>
		   </tr>
<%-- 		   <tr >
			  <th width=16% class="th_btn3" align="right">客户名称:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sCustomerName)%></td>
			  <th width=16% class="th_btn3" align="right">业务品种:</th><td  align="center" width=16%><%=StringEscapeUtils.escapeHtml(sBusinessTypeName)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr> --%>
		  <%
		  		String repayMode = Sqlca.getString("select componentname from PRD_COMPONENT_LIBRARY where componentid= 'RPT-0"+RepayMode+"'");
		  %>
		   <tr >
			  <th width=25% class="th_btn3" align="right">贷款金额:</th><td align="center" width=25%>&nbsp;<%=DataConvert.toMoney(DstrAmt)%>元</td>
			  <th width=25% class="th_btn3" align="right">还款方式:</th><td  align="center" width=25%>&nbsp;<%=StringEscapeUtils.escapeHtml(repayMode)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr>
		  
		   <tr>
			  <th width=25% class="th_btn3" align="right">贷款年利率:</th><td align="center" width=25%><%=StringEscapeUtils.escapeHtml(IntRate+"%")%></td>
			  <th width=25% class="th_btn3" align="right">贷款期限:</th><td align="center" width=25%><%=StringEscapeUtils.escapeHtml(""+BusinessTerm)%>个月</td>
			  <th class="th_btn3"  colspan=2></td>
		  </tr>
 <%-- 		  <tr>
			  <th width=25% class="th_btn3" align="right">月收入:</th><td align="center" width=25%><%=DataConvert.toMoney(Revenue)%></td>
			  <th width=25% class="th_btn3" align="right">除本笔月债务支出:</th><td align="center" width=25%><%=DataConvert.toMoney(OtherDebt)%></td>
			  <th colspan=2 class="th_btn3" ></td>
		  </tr> --%>
<%-- 		  <tr>
			  <th width=16% class="th_btn3" align="right">本笔月供收入比:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(sMainReturnTypeName)%></td>
			  <th width=16% class="th_btn3" align="right">总月供收入比:</th><td align="center" width=16%><%=StringEscapeUtils.escapeHtml(DataConvert.toMoney(0))%></td>
		  </tr>  --%>
	    </table>
	  </td>
	</tr>
	<tr><td>
	  <br>
		  <table class="style1" style="margin:0px" border=1px  bordercolor=black cellspacing=0 cellpadding=0 id=planlist align="center">
		   <tr class="false1">
		      <%
		      	 double columns = 7;
		      %>
			 
			 <th class="th_btn3" width=4%  align="center">期次</th>
			 <th class="th_btn3" width=15%  align="center">期供</th>
			 <th class="th_btn3" width=15%  align="center">本金</th>
			 <th class="th_btn3" width=15%  align="center">利息</th>
			 <th class="th_btn3" width=15%  align="center">本金余额</th>
		   </tr>
		  <tbody>
		    <!--输出表格-->
		   <%out.println(org.apache.commons.lang.StringEscapeUtils.escapeSql(sJSScript.toString()));%>
		  </tbody>
		</table>
		<tr><td>
	  </table>
	   </div>
<!---->
</body>
</html>


<%
}
catch(Exception ex)
{
	ex.printStackTrace();
%>
	<script language=javascript>
		alert("<%=ex.getMessage()%>");
		self.close();
	</script>
<%
}
%>



<%@ include file="/IncludeEnd.jsp"%>
