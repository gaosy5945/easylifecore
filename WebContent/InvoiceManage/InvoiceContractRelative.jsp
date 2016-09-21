<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
        Author: undefined 2016-01-13
        Tester:
        Content: 
        Input Param:
        Output param:
        History Log: 
    */
    String serialNo = CurPage.getParameter("InvoiceSerialNo");
	if(serialNo == null) serialNo = "";
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String invoiceObject = CurPage.getParameter("InvoiceObject");
	if(invoiceObject == null) invoiceObject = "";
	String purpose = CurPage.getParameter("Purpose");
	if(purpose == null) purpose = "";
	
	String objectType = "";
	String templetNo = "";
	if("02".equals(invoiceObject)){
		objectType = "jbo.app.BUSINESS_CONTRACT";
		templetNo = "InvioceContractRelative";
	}else if("01".equals(invoiceObject)){
		objectType = "jbo.acct.ACCT_PAYMENT_SCHEDULE";
		templetNo = "InvoicePSRelative";
	}
	
    
	ASObjectModel doTemp = new ASObjectModel(templetNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	//dwTemp.MultiSelect = true;	 //��ѡ
	//dwTemp.ShowSummary="1";	 	 //����
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","All","Button","����ҵ��","����ҵ��","relative()","","","","btn_icon_add",""},
			{"false","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 AsControl.OpenView(sUrl,'','_self','');
	}
	function edit(){
		 var sUrl = "";
		 var sPara = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(sPara)=="undefined" || sPara.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		AsControl.OpenView(sUrl,'SerialNo=' +sPara ,'_self','');
	}
	function relative(){
		var returnValue = null;
		if("<%=invoiceObject%>" == "02"){
			returnValue = AsDialog.SelectGridValue("SelectInvoiceContractRelative","<%=serialNo%>"+","+"<%=serialNo%>","SerialNo@BusinessSum","",true,"","","1");	
			if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
				return ;
			returnValue = returnValue.split("~");
			var ObjectNo = "";
			var sum = 0;
			for(var i in returnValue){
				if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
					var parameter = returnValue[i].split("@");
					ObjectNo = parameter[0];
					sum += Number(parameter[1].replace(",",""));
					RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceRelative","SerialNo="+"<%=serialNo%>"+",ObjectNo="+ObjectNo+",ObjectType="+"<%=objectType%>"); 
				}
			}
			RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+sum+",InvoiceContext="+"��ͬ����ܼ�");
			parent.reloadPage();
		}else if("<%=invoiceObject%>" == "01"){
			returnValue = AsDialog.SelectGridValue("SelectInvoiceRelativePS","<%=serialNo%>"+","+"<%=serialNo%>","SerialNo@ActualPayPrincipalAMT@ActualPayInterestAMT","",true,"","","1");
			var principalSum = 0;
			var interestSum = 0;
			if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
				return ;
			returnValue = returnValue.split("~");
			var ObjectNo = "";
			for(var i in returnValue){
				if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
					var parameter = returnValue[i].split("@");
					ObjectNo = parameter[0];
					principalSum += Number(parameter[1].replace(",",""));
					interestSum += Number(parameter[2].replace(",",""));
					RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceRelative","SerialNo="+"<%=serialNo%>"+",ObjectNo="+ObjectNo+",ObjectType="+"<%=objectType%>"); 
				}
			}
			if("<%=purpose%>" == "P01"){
				RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+principalSum+",InvoiceContext="+"ʵ�ʱ��𻹿���ܼ�");
			}else if ("<%=purpose%>" == "P02"){
				RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+interestSum+",InvoiceContext="+"ʵ����Ϣ������ܼ�");
			}
			parent.reloadPage();
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>