<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transStatus = CurPage.getParameter("TransStatus");
	String applyType = CurPage.getParameter("ApplyType");
	String sTempletNo = CurPage.getParameter("TempletNo");
	
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	
	doTemp.appendJboWhere(" and AT.TransStatus in('"+transStatus.replaceAll(",", "','")+"')");
	doTemp.setJboOrder(" AT.INPUTTIME");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ִ�н���","ִ�н���","runTransaction()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'RELATIVEOBJECTNO');
		 var transSerialNo = getItemValue(0,getRow(0),'SERIALNO');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		 }
		 AsCredit.openFunction("PostLoanChangeTab","serialNo="+serialNo+"&transSerialNo="+transSerialNo+"&RightType=ReadOnly");
		 reloadSelf();
	}
	
	function runTransaction(){
		var transactionSerialno = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(transactionSerialno) == "undefined" || transactionSerialno.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//com.amarsoft.app.als.afterloan.change.AfterChangeRun
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterChangeRun","runTransaction","TransactionSerialno="+transactionSerialno);
		if(result=="success"){
			alert("����ִ�гɹ���");
			reloadSelf();
		}else{
			alert(result);
			return;
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
