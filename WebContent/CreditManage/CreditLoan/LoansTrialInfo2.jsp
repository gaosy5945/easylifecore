<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "LoanTrialInfo2";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","����","trial()","","","",""},
		{"true","All","Button","ѡ���������","ѡ���������","select()","","","",""},
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
		var DstrAmt = getItemValue(0,getRow(),"DstrAmt");//������
		if(DstrAmt == null || DstrAmt == "undefined") DstrAmt = "";
		var RepayMode = getItemValue(0,getRow(),"RepayMode");//���ʽ
		if(RepayMode == null || RepayMode == "undefined") RepayMode = "";
		var IntRate = getItemValue(0,getRow(),"IntRate");//ִ�����ʣ��꣩
		if(IntRate == null || IntRate == "undefined") IntRate = "";
		var IntActualPrd = getItemValue(0,getRow(),"IntActualPrd");//��Ϣ����
		if(IntActualPrd == null || IntActualPrd == "undefined") IntActualPrd = "";
		var StartIntDate = getItemValue(0,getRow(),"StartIntDate");//������ʼ��
		if(StartIntDate == null || StartIntDate == "undefined") StartIntDate = "";
		var ExpiredDate = getItemValue(0,getRow(),"ExpiredDate");//�������
		if(ExpiredDate == null || ExpiredDate == "undefined") ExpiredDate = "";
		var DeductDate = getItemValue(0,getRow(),"DeductDate");//ÿ�¿ۿ���
		if(DeductDate == null || DeductDate == "undefined") DeductDate = "";
		var StartNum1 = getItemValue(0,getRow(),"StartNum1");//��ʼ����
		if(StartNum1 == null || StartNum1 == "undefined") StartNum1 = "";
		var QueryNum1 = getItemValue(0,getRow(),"QueryNum1");//��ѯ����
		if(QueryNum1 == null || QueryNum1 == "undefined") QueryNum1 = "";
		var IncrDecAmt = getItemValue(0,getRow(),"IncrDecAmt");//�����ݼ���
		if(IncrDecAmt == null || IncrDecAmt == "undefined") IncrDecAmt = "";
		var IncrMode = getItemValue(0,getRow(),"IncrMode");//������ʽ
		if(IncrMode == null || IncrMode == "undefined") IncrMode = "";
		var IncrDecPrd = getItemValue(0,getRow(),"IncrDecPrd");//�����ݼ�����
		if(IncrDecPrd == null || IncrDecPrd == "undefined") IncrDecPrd = "";
		var MoExpiredDate = getItemValue(0,getRow(),"MoExpiredDate");//��������
		if(MoExpiredDate == null || MoExpiredDate == "undefined") MoExpiredDate = "";
		var FxdFlag = getItemValue(0,getRow(),"FxdFlag");//�̶�������־
		if(FxdFlag == null || FxdFlag == "undefined") FxdFlag = "";
		var Revenue = getItemValue(0,getRow(),"Revenue");//������
		if(Revenue == null || Revenue == "undefined") Revenue = "";
		var OtherDebt = getItemValue(0,getRow(),"OtherDebt");//��������ծ��
		if(OtherDebt == null || OtherDebt == "undefined") OtherDebt = "";
	
		if (DstrAmt==""){
		    alert("����������");
		    return;
		}	
		if (RepayMode==""){
		    alert("��ѡ�񻹿ʽ��");
		    return;
		}	
		if (IntRate==""){
		    alert("������ִ�����ʣ��꣩��");
		    return;
		}
		if (StartIntDate==""){
		    alert("��ѡ�������ʼ�գ�");
		    return;
		}
		if (MoExpiredDate==""){
		    alert("������������ޣ�");
		    return;
		}
		if (ExpiredDate==""){
		    alert("�����������գ�");
		    return;
		}
		if (DeductDate==""){
		    alert("������ÿ�¿ۿ��գ�");
		    return;
		}
		if (DeductDate > 31){
			alert("ÿ�¿ۿ��ղ��ô���31��");
			return;
		}
		if (IncrMode==""){
			alert("��ѡ������ݼ���ʽ��");
			return;
		}
		if (IncrDecAmt==""){
			alert("����������ݼ��");
			return;
		}
		if (IncrDecPrd==""){
			alert("����������ݼ����ڣ�");
			return;
		}
		if (Revenue==""){
			alert("�����������룡");
			return;
		}
		if (OtherDebt==""){
			alert("�������������ծ��");
			return;
		}
		if (StartNum1==""){
			alert("��������ʼ������");
			return;
		}
		if (QueryNum1==""){
			alert("�������ѯ������");
			return;
		}
		AsControl.OpenView("/CreditManage/CreditLoan/LoansTrialList.jsp","MoExpiredDate="+MoExpiredDate+"&ExpiredDate="+ExpiredDate+"&DstrAmt="+DstrAmt+"&RepayMode="+RepayMode+"&IntRate="+IntRate+"&IntActualPrd="+IntActualPrd+"&StartIntDate="+StartIntDate+"&DeductDate="+DeductDate+"&StartNum1="+StartNum1+"&QueryNum1="+QueryNum1+"&IncrDecAmt="+IncrDecAmt+"&IncrMode="+IncrMode+"&IncrDecPrd="+IncrDecPrd+"&FxdFlag="+FxdFlag+"&Revenue="+Revenue+"&OtherDebt="+OtherDebt+"&randp="+randomNumber(),"rightdown","");
	}
	 function ChangeLoanTerm(){
			var ExpiredDate = "";
			var StartIntDate = getItemValue(0,getRow(),"StartIntDate");
			var LoanTerm = getItemValue(0,getRow(),"MoExpiredDate");//�������� 
			if(LoanTerm !=0){
				  sLoanTermFlag ="020";
				  ExpiredDate = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CalcMaturity","CalcMaturity","LoanTermFlag="+sLoanTermFlag+",LoanTerm="+LoanTerm+",PutOutDate="+StartIntDate);
				  setItemValue(0,getRow(),"ExpiredDate",ExpiredDate);
			}
		}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
