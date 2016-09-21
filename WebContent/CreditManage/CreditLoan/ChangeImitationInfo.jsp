<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "LoanChangeTrialInfo";//--模板号--
	String date = DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","试算","试算","trial()","","","",""},
		//{"true","All","Button","选择存量贷款","选择存量贷款","select()","","","",""},
	};
	//sButtonPosition = "south"; 

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
    //insert();

	function select(){
		setGridValuePretreat('SelectBusinessDuebillSS','<%=CurUser.getOrgID()%>','DuebillNo=SERIALNO@CustomerName=CUSTOMERNAME@DstrAmt=BALANCE@RepayMode=RPTTERMID@IntRate=ACTUALBUSINESSRATE@StartIntDate=PUTOUTDATE@ExpiredDate=MATURITYDATE@DeductDate=REPAYDATE','','1');
	}
	function trial(){
		
		if(!iV_all(0)) return;
		
		var DuebillNo = getItemValue(0,getRow(),"DuebillNo");//借据号
		if(DuebillNo == null || DuebillNo == "undefined") DuebillNo = "";
		
		/* var ChangeType = getItemValue(0,getRow(),"ChangeType"); //变更类型
		if(ChangeType == null|| ChangeType == "undefined") ChangeType =""; */
		
		var cRepayMode = getItemValue(0,getRow(),"cRepayMode");//新还款方式
		if(cRepayMode == null || cRepayMode == "undefined") cRepayMode = "";
		
		var TrialMode = getItemValue(0,getRow(),"TrialMode"); //测算方式
		if(TrialMode == null || TrialMode == "undefined") TrialMode = "";
		
		var aTranAmt = getItemValue(0,getRow(),"aTranAmt"); //提前还款金额
		if(aTranAmt == null || aTranAmt == "undefined") aTranAmt = 0;
		
		var RepayDate = getItemValue(0,getRow(),"RepayDate"); //本次还款日期
		if(RepayDate == null || RepayDate == "undefined") RepayDate = "";
		
		var DstrAmt = getItemValue(0,getRow(),"DstrAmt"); //贷款金额
		
		var nowDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate().replaceAll("/","")%>";  //核心交易系统的日期，可能后面会有改动。。。。。。。
	
		if(DuebillNo == ""){
			alert("请选择一笔存量贷款");
			return;
		}

			if(cRepayMode == ""){
				alert("请选择提前还款方式");
				return;
			}
			if(RepayDate == ""){
				alert("请选择本次还款日期");
				return;
			}
			//提前还款日期不得小于核心交易日期
			if(parseInt(changeDate(RepayDate))<nowDate){
				alert("提前还款日期不得小于核心交易日期");
				return;
			}
			if(cRepayMode == 1){ //提前还款方式为部分还款时
				if (aTranAmt == ""){
					alert("请输入提前还款金额！");
					return;
				}
				if(parseFloat(aTranAmt)<0){
					alert("提前还款金额不得小于0");
					return;
				}
				if (parseFloat(aTranAmt) > parseFloat(DstrAmt)){
					alert("提前还款金额不可大于贷款余额！");
					return;
				}
				if(TrialMode == ""){
					alert("请选择测算方式");
					return;
				}
			}
			else{ //提前还款方式为全额还款时，将提前还款金额置为贷款金额
				var DstrAmt = getItemValue(0,0,"DstrAmt");
				aTranAmt = DstrAmt; 
			}
			AsControl.OpenView("/CreditManage/CreditLoan/AheadPayImitationTrialList.jsp","DuebillNo="+DuebillNo+"&RepayDate="+RepayDate+"&TranAmt="+aTranAmt+"&cRepayMode="+cRepayMode+"&TrialMode="+TrialMode,"_blank","");
	
}

	//隐藏所有不需要字段
	function insert(){
		hideItem("myiframe0","aTranAmt");
		hideItem("myiframe0","bFxdFlag");
		hideItem("myiframe0","bIntRate");
		hideItem("myiframe0","bFloatRate");
		hideItem("myiframe0","bIntMode");
		hideItem("myiframe0","bDeductDate");
		hideItem("myiframe0","cRepayMode");
	}
	
	function changeDate(date){
		 return parseInt(date.substring(0, 4) + date.substring(5, 7) + date.substring(8, 10));
	}
	
	function setAmount()
	{
		var cRepayMode = getItemValue(0,getRow(),"cRepayMode");
		if(cRepayMode == "2")
		{
			hideItem("myiframe0","aTranAmt");
			hideItem("myiframe0","TrialMode");
			setItemValue(0,getRow(),"aTranAmt","");
			setItemValue(0,getRow(),"TrialMode","1");
			setItemRequired("myiframe0","aTranAmt",false);
			setItemRequired("myiframe0","TrialMode",false);
		}
		else
		{
			showItem("myiframe0","aTranAmt");
			showItem("myiframe0","TrialMode");
			setItemRequired("myiframe0","aTranAmt",true);
			setItemRequired("myiframe0","TrialMode",true);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
