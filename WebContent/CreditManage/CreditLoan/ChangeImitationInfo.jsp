<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "LoanChangeTrialInfo";//--ģ���--
	String date = DateHelper.getBusinessDate();
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","����","����","trial()","","","",""},
		//{"true","All","Button","ѡ���������","ѡ���������","select()","","","",""},
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
		
		var DuebillNo = getItemValue(0,getRow(),"DuebillNo");//��ݺ�
		if(DuebillNo == null || DuebillNo == "undefined") DuebillNo = "";
		
		/* var ChangeType = getItemValue(0,getRow(),"ChangeType"); //�������
		if(ChangeType == null|| ChangeType == "undefined") ChangeType =""; */
		
		var cRepayMode = getItemValue(0,getRow(),"cRepayMode");//�»��ʽ
		if(cRepayMode == null || cRepayMode == "undefined") cRepayMode = "";
		
		var TrialMode = getItemValue(0,getRow(),"TrialMode"); //���㷽ʽ
		if(TrialMode == null || TrialMode == "undefined") TrialMode = "";
		
		var aTranAmt = getItemValue(0,getRow(),"aTranAmt"); //��ǰ������
		if(aTranAmt == null || aTranAmt == "undefined") aTranAmt = 0;
		
		var RepayDate = getItemValue(0,getRow(),"RepayDate"); //���λ�������
		if(RepayDate == null || RepayDate == "undefined") RepayDate = "";
		
		var DstrAmt = getItemValue(0,getRow(),"DstrAmt"); //������
		
		var nowDate = "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate().replaceAll("/","")%>";  //���Ľ���ϵͳ�����ڣ����ܺ�����иĶ���������������
	
		if(DuebillNo == ""){
			alert("��ѡ��һ�ʴ�������");
			return;
		}

			if(cRepayMode == ""){
				alert("��ѡ����ǰ���ʽ");
				return;
			}
			if(RepayDate == ""){
				alert("��ѡ�񱾴λ�������");
				return;
			}
			//��ǰ�������ڲ���С�ں��Ľ�������
			if(parseInt(changeDate(RepayDate))<nowDate){
				alert("��ǰ�������ڲ���С�ں��Ľ�������");
				return;
			}
			if(cRepayMode == 1){ //��ǰ���ʽΪ���ֻ���ʱ
				if (aTranAmt == ""){
					alert("��������ǰ�����");
					return;
				}
				if(parseFloat(aTranAmt)<0){
					alert("��ǰ�������С��0");
					return;
				}
				if (parseFloat(aTranAmt) > parseFloat(DstrAmt)){
					alert("��ǰ������ɴ��ڴ�����");
					return;
				}
				if(TrialMode == ""){
					alert("��ѡ����㷽ʽ");
					return;
				}
			}
			else{ //��ǰ���ʽΪȫ���ʱ������ǰ��������Ϊ������
				var DstrAmt = getItemValue(0,0,"DstrAmt");
				aTranAmt = DstrAmt; 
			}
			AsControl.OpenView("/CreditManage/CreditLoan/AheadPayImitationTrialList.jsp","DuebillNo="+DuebillNo+"&RepayDate="+RepayDate+"&TranAmt="+aTranAmt+"&cRepayMode="+cRepayMode+"&TrialMode="+TrialMode,"_blank","");
	
}

	//�������в���Ҫ�ֶ�
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
