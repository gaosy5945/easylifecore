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
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.MultiSelect = true;	 //多选
	//dwTemp.ShowSummary="1";	 	 //汇总
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","All","Button","关联业务","关联业务","relative()","","","","btn_icon_add",""},
			{"false","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
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
			alert("参数不能为空！");
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
			RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+sum+",InvoiceContext="+"合同金额总计");
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
				RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+principalSum+",InvoiceContext="+"实际本金还款额总计");
			}else if ("<%=purpose%>" == "P02"){
				RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","InvoiceDetailRelative","SerialNo="+"<%=serialNo%>"+",Sum="+interestSum+",InvoiceContext="+"实际利息还款额总计");
			}
			parent.reloadPage();
		}
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>