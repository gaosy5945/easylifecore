<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "LoanTrialInfo2";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","试算","试算","trial()","","","",""},
		{"true","All","Button","选择存量贷款","选择存量贷款","select()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
    setItemValue(0,0,"IntActualPrd",'0');
    setItemValue(0,0,"FxdFlag",'0');
	function select(){
		var returnValue =AsDialog.SelectGridValue("SelectBusinessDuebill", "", "SERIALNO@CUSTOMERNAME@BALANCE@RPTTERMID@RATEFLOATTYPE@ACTUALBUSINESSRATE@LASTDUEDATE@MATURITYDATE@TOTALPERIOD@CURRENTPERIOD@REPAYDATE", "");
		if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
		setItemValue(0,0,"DuebillNo",returnValue.split("@")[0]);
		setItemValue(0,0,"CustomerName",returnValue.split("@")[1]);
		setItemValue(0,0,"DstrAmt",returnValue.split("@")[2]);
		setItemValue(0,0,"RepayMode",returnValue.split("@")[3]);
		//setItemValue(0,0,"FxdFlag",returnValue.split("@")[4]);
		setItemValue(0,0,"IntRate",returnValue.split("@")[5]);
		//setItemValue(0,0,"IntActualPrd",'0');
		setItemValue(0,0,"StartIntDate",returnValue.split("@")[6]);
		setItemValue(0,0,"ExpiredDate",returnValue.split("@")[7]);
		setItemValue(0,0,"MoExpiredDate",returnValue.split("@")[8]-returnValue.split("@")[9]);
		setItemValue(0,0,"DeductDate",returnValue.split("@")[10]);
	
	}
	function trial(){
		var DstrAmt = getItemValue(0,getRow(),"DstrAmt");//贷款金额
		if(DstrAmt == null || DstrAmt == "undefined") DstrAmt = "";
		var RepayMode = getItemValue(0,getRow(),"RepayMode");//还款方式
		if(RepayMode == null || RepayMode == "undefined") RepayMode = "";
		var IntRate = getItemValue(0,getRow(),"IntRate");//执行利率（年）
		if(IntRate == null || IntRate == "undefined") IntRate = "";
		var IntActualPrd = getItemValue(0,getRow(),"IntActualPrd");//计息周期
		if(IntActualPrd == null || IntActualPrd == "undefined") IntActualPrd = "";
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");//贷款起始日
		if(StartIntDate == null || StartIntDate == "undefined") StartIntDate = "";
		var ExpiredDate = getItemValue(0,getRow(),"ExpiredDate");//贷款到期日
		if(ExpiredDate == null || ExpiredDate == "undefined") ExpiredDate = "";
		var DeductDate = getItemValue(0,getRow(),"DeductDate");//每月扣款日
		if(DeductDate == null || DeductDate == "undefined") DeductDate = "";
		var StartNum1 = getItemValue(0,getRow(),"StartNum1");//起始笔数
		if(StartNum1 == null || StartNum1 == "undefined") StartNum1 = "";
		var QueryNum1 = getItemValue(0,getRow(),"QueryNum1");//查询笔数
		if(QueryNum1 == null || QueryNum1 == "undefined") QueryNum1 = "";
		var IncrDecAmt = getItemValue(0,getRow(),"IncrDecAmt");//递增递减额
		if(IncrDecAmt == null || IncrDecAmt == "undefined") IncrDecAmt = "";
		var IncrMode = getItemValue(0,getRow(),"IncrMode");//递增方式
		if(IncrMode == null || IncrMode == "undefined") IncrMode = "";
		var IncrDecPrd = getItemValue(0,getRow(),"IncrDecPrd");//递增递减周期
		if(IncrDecPrd == null || IncrDecPrd == "undefined") IncrDecPrd = "";
		var MoExpiredDate = getItemValue(0,getRow(),"MoExpiredDate");//贷款期限
		if(MoExpiredDate == null || MoExpiredDate == "undefined") MoExpiredDate = "";
		var FxdFlag = getItemValue(0,getRow(),"FxdFlag");//固定浮动标志
		if(FxdFlag == null || FxdFlag == "undefined") FxdFlag = "";
		var Revenue = getItemValue(0,getRow(),"Revenue");//月收入
		if(Revenue == null || Revenue == "undefined") Revenue = "";
		var OtherDebt = getItemValue(0,getRow(),"OtherDebt");//除本笔月债务
		if(OtherDebt == null || OtherDebt == "undefined") OtherDebt = "";
	
		if (DstrAmt==""){
		    alert("请输入贷款金额！");
		    return;
		}	
		if (RepayMode==""){
		    alert("请选择还款方式！");
		    return;
		}	
		if (IntRate==""){
		    alert("请输入执行利率（年）！");
		    return;
		}
		if (StartIntDate==""){
		    alert("请选择贷款起始日！");
		    return;
		}
		if (MoExpiredDate==""){
		    alert("请输入贷款期限！");
		    return;
		}
		if (ExpiredDate==""){
		    alert("请输入贷款到期日！");
		    return;
		}
		if (DeductDate==""){
		    alert("请输入每月扣款日！");
		    return;
		}
		if (DeductDate > 31){
			alert("每月扣款日不得大于31！");
			return;
		}
		if (IncrMode==""){
			alert("请选择递增递减方式！");
			return;
		}
		if (IncrDecAmt==""){
			alert("请输入递增递减额！");
			return;
		}
		if (IncrDecPrd==""){
			alert("请输入递增递减周期！");
			return;
		}
		if (Revenue==""){
			alert("请输入月收入！");
			return;
		}
		if (OtherDebt==""){
			alert("请输入除本笔月债务！");
			return;
		}
		if (StartNum1==""){
			alert("请输入起始笔数！");
			return;
		}
		if (QueryNum1==""){
			alert("请输入查询笔数！");
			return;
		}
		AsControl.OpenView("/CreditManage/CreditLoan/LoansTrialList.jsp","MoExpiredDate="+MoExpiredDate+"&ExpiredDate="+ExpiredDate+"&DstrAmt="+DstrAmt+"&RepayMode="+RepayMode+"&IntRate="+IntRate+"&IntActualPrd="+IntActualPrd+"&StartIntDate="+StartIntDate+"&DeductDate="+DeductDate+"&StartNum1="+StartNum1+"&QueryNum1="+QueryNum1+"&IncrDecAmt="+IncrDecAmt+"&IncrMode="+IncrMode+"&IncrDecPrd="+IncrDecPrd+"&FxdFlag="+FxdFlag+"&Revenue="+Revenue+"&OtherDebt="+OtherDebt+"&randp="+randomNumber(),"rightdown","");
	}
	 function ChangeLoanTerm(){
			var ExpiredDate = "";
			var StartIntDate = getItemValue(0,getRow(),"StartIntDate");
			var LoanTerm = getItemValue(0,getRow(),"MoExpiredDate");//贷款期限 
			if(LoanTerm !=0){
				  sLoanTermFlag ="020";
				  ExpiredDate = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","CalcMaturity","LoanTermFlag="+sLoanTermFlag+",LoanTerm="+LoanTerm+",PutOutDate="+StartIntDate);
				  setItemValue(0,getRow(),"ExpiredDate",ExpiredDate);
			}
		}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
