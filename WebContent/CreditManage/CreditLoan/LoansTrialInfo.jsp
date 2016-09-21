<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String sTempletNo = "LoanTrialInfo";//--ģ���--
	
	String sObjectType = "";  
	String sObjectNo ="";
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType",sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","����","����","trial()","","","",""}
	};
	//sButtonPosition = "south";
    
%>

<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditManage/js/credit_common.js"></script>
<script type="text/javascript">
	var rightType = "";
	var objectType = "jbo.app.BUSINESS_DUEBILL";
	var objectNo = "X000001";
	
	function trial(){
		
		if(!ALSObjectWindowFunctions.objectWindowMetaData||ALSObjectWindowFunctions.objectWindowMetaData.length<=0){
			return;
		}

		var checkResult = true;
		for(var i=0;i<ALSObjectWindowFunctions.objectWindowMetaData.length;i++){
				if(!iV_all(i)){//����У���Ƿ���Ա��棬����װ����
					checkResult=false;
					continue;
				}
		}
		if(!checkResult){
			ALSObjectWindowFunctions.showErrors();
			return;
		}
		
		if(!checkRPTInfo() || !checkRateInfo()) return;
		
		//������Ϣ
		var DstrAmt = getItemValue(0,getRow(),"BusinessSum");//������
		var BusinessTerm = getItemValue(0,getRow(),"BusinessTerm");//��������
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");//������ʼ��
		var ExpiredDate = getItemValue(0,getRow(),"ExpiredDate");//�������
		var StartNum1 = getItemValue(0,getRow(),"StartNum1");//��ʼ��������ѯ��ʼ������
		var QueryNum1 = getItemValue(0,getRow(),"QueryNum1");//��ѯ��������ѯ����������
		

		//---------߀�ʽ�M��----------
		var RepayMode = getItemValue(1,getRow(),"RPTTermID");//���ʽ
		if(RepayMode.length==0 || typeof(RepayMode) == "undefined") RepayMode = "";
				
		var FixedPeriod1 = getItemValue(1,getRow(),"PaymentFrequencyTerm"); //�̶�����<!-----������-------->
		if(FixedPeriod1 == null || typeof(FixedPeriod1) == "undefined" || FixedPeriod1.length == 0) FixedPeriod1 = getItemValue(0,getRow(),"PaymentFrequencyTerm");
		if(FixedPeriod1 == null || typeof(FixedPeriod1) == "undefined" || FixedPeriod1.length == 0) FixedPeriod1 = "";
		
		var IntActualPrd = getItemValue(1,getRow(),"PaymentFrequencyType");//��Ϣ����(��������)
		if(IntActualPrd == null || typeof(IntActualPrd) == "undefined" || IntActualPrd.length == 0) IntActualPrd = getItemValue(0,getRow(),"PaymentFrequencyType");
		if(IntActualPrd == null || typeof(IntActualPrd) == "undefined" || IntActualPrd.length == 0) IntActualPrd = "";
		
		var DeductDate = getItemValue(1,getRow(),"DefaultDueDay");//ÿ�¿ۿ��գ������գ�
		if(DeductDate == null || typeof(DeductDate) == "undefined" || DeductDate.length == 0) DeductDate = getItemValue(0,getRow(),"DefaultDueDay");
		if(DeductDate == null || typeof(DeductDate) == "undefined" || DeductDate.length == 0) DeductDate = "";
		
		var IncrDecPrd = getItemValue(1,getRow(),"GainCyc");//�����ݼ����ڣ��ݱ����ڣ�
		if(IncrDecPrd == null || typeof(IncrDecPrd) == "undefined" || IncrDecPrd.length == 0) IncrDecPrd = "";
		var IncrDecAmt = getItemValue(1,getRow(),"GainAmount");//�����ݼ���ݱ���ȣ�
		if(IncrDecAmt == null || typeof(IncrDecAmt) == "undefined" || IncrDecAmt.length == 0) IncrDecAmt = "";
		
		var PayCountTime = getItemValue(1,getRow(),"SegTerm");//�ڹ���������
		if(PayCountTime == null || typeof(PayCountTime) == "undefined" || PayCountTime.length == 0) PayCountTime = "";	
		
		//-------���ʽM��----------
		var RateType = getItemValue(2,getRow(),"RateType");	//������� <!-------������--------->
		if(RateType == null || typeof(RateType) == "undefined" || RateType.length == 0) RateType = ""; 

		var StandardRate = getItemValue(2,getRow(),"BaseRate");	//��������(�Ԅ��@ʾ)??????
		
		//���ӷ���
		var FloatRange = getItemValue(2,getRow(),"RateFloat");	//��������
		if(FloatRange == null || FloatRange == "undefined") FloatRange = "";
		//��������(�Զ���ʾ)
		var BusinessRate = 	getItemValue(2,getRow(),"BusinessRate"); //ִ������
		if(BusinessRate == null || BusinessRate == "undefined") BusinessRate = "";
		//�����{����ʽ
		var RateChangeType = getItemValue(2,getRow(),"RepriceType");
		if(RateChangeType == null || RateChangeType == "undefined") RateChangeType = "";	
		//�����{������
		var RateChangeDate = getItemValue(2,getRow(),"RepriceDate");
		if(RateChangeDate == null || RateChangeDate == "undefined") RateChangeDate = "";
		var repaylength="";
		if(RepayMode=="RPT-06"){
			var n = getRowCount(1);
			for(var i =0;i<n;i++){
				var SEGRPTTermID = getItemValue(1,i,"SEGRPTTermID");
				var SegRPTAmount = getItemValue(1,i,"SegRPTAmount");
				var SEGToStage = getItemValue(1,i,"SEGToStage");
				SegRPTAmount = SegRPTAmount.replace(",","");
				
				if(typeof(SegRPTAmount) == "undefined" || SegRPTAmount.length == 0) SegRPTAmount = 0;
				repaylength += SEGRPTTermID+"@"+SegRPTAmount+"@"+SEGToStage+"~";
			}
			if(repaylength.length>0)
				repaylength=repaylength.substring(0, repaylength.length-1);
			
		}
		
		
		
		AsControl.OpenView("/CreditManage/CreditLoan/LoansTrialList.jsp","DstrAmt="+DstrAmt+"&StartIntDate="+StartIntDate+"&ExpiredDate="+ExpiredDate+"&StartNum1="+StartNum1+"&QueryNum1="+QueryNum1
				+"&RepayMode="+RepayMode+"&FixedPeriod1="+FixedPeriod1+"&IntActualPrd="+IntActualPrd+"&DeductDate="+DeductDate+"&IncrDecPrd="+IncrDecPrd+"&IncrDecAmt="+IncrDecAmt+"&PayCountTime="+PayCountTime
				+"&RateType="+RateType+"&StandardRate="+StandardRate+"&FloatRange="+FloatRange+"&BusinessRate="+BusinessRate+"&RateChangeType="+RateChangeType+"&RateChangeDate="+RateChangeDate+"&TermValue="+repaylength,"_blank","");
		
	}
		 
	$(document).ready(function(){		 	 
		 //initRPT();
		 //initRate();		 
		changePaymentType();
		ALSObjectWindowFunctions.hideItems(0,"LoanRateTermID");
		setItemValue(0,getRow(),"LoanRateTermID","RAT01");
		initRate();
	 })
	 
	 function changeDate(date){
		 return parseInt(date.substring(0, 4) + date.substring(5, 7) + date.substring(8, 10));
	}
	
	function validateDate(date){
		var month = date.split("/")[0];
		var day = date.split("/")[1];
		if(month > 12 || month < 1){
			alert("����������");
			return false;
		}
		if(day > 31 || day < 1){
			alert("����������");	
			return false;
		}
		return true;
	}


	function getDate(date1,date2){
		
		var month1 = parseInt(date1.split("/")[1]);
		var year1 = parseInt(date1.split("/")[0]);
		var month2 = parseInt(date2.split("/")[1]);
		var year2 = parseInt(date2.split("/")[0]);
		
		var allMonth;
		if(month1 < month2){
			allMonth = (year2-year1)*12+month2-month1;
		}
		else{
			allMonth = (year2-year1-1)*12+month2+12-month1;
		}
		return allMonth;
	}
	
	function ChangeLoanTerm(){
		var ExpiredDate = "";
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");
		var LoanTerm = getItemValue(0,getRow(),"BusinessTerm");//�������� 
		if(LoanTerm !=0){
			  sLoanTermFlag ="020";
			  ExpiredDate = RunJavaMethod("com.amarsoft.app.lending.bizlets.CalcMaturity","calcMaturity","loanTermFlag="+sLoanTermFlag+",loanTerm="+LoanTerm+",putOutDate="+StartIntDate); 
			  setItemValue(0,getRow(),"ExpiredDate",ExpiredDate);
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
