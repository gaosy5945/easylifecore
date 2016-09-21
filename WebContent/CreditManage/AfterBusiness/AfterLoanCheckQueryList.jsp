<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String creditInspectType = DataConvert.toString(CurPage.getParameter("CreditInspectType"));
	String flag = DataConvert.toString(CurPage.getParameter("Flag"));
	String orgID = CurUser.getOrgID();
	String operateUserID = CurUser.getUserID();
	ASObjectModel doTemp = new ASObjectModel("AfterLoanCheckQueryList");
	if("0".equals(flag)){
		doTemp.appendJboWhere( "O.status in ('1','2','5','6')" );
	}else{
		doTemp.appendJboWhere( "O.status in ('3','4')" );
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(creditInspectType+","+operateUserID+","+orgID);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","�������","����","edit()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
		 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
		 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
		 var creditInspectType = "<%=creditInspectType%>";
		 var customerID = getItemValue(0, getRow(0), 'CustomerID');
	
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 if(creditInspectType == "02"){
			 AsCredit.openFunction("FundPurposeInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
			 reloadSelf();
			 return;
		 }else if(creditInspectType == "03"){
			 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType=ReadOnly");
			 reloadSelf();
			 return;
		 }
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
