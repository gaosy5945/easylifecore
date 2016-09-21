<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
    	if(customerID == null) customerID = "";
    	
    Double businessSum = Sqlca.getDouble(new SqlObject("SELECT SUM(BUSINESSSUM) FROM BUSINESS_CONTRACT WHERE CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID)); //客户授信总额度
   	Double balance = Sqlca.getDouble(new SqlObject("SELECT SUM(BALANCE) FROM BUSINESS_CONTRACT WHERE CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID)); //已用额度
    Double availableSum = Sqlca.getDouble(new SqlObject("SELECT (SUM(BUSINESSSUM-BALANCE)) AS AVAILABLESUM FROM BUSINESS_CONTRACT WHERE CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID)); //可用额度
    if("null".equals(businessSum) || "".equals(businessSum)){
     	businessSum = 0.00;
    }
    if("null".equals(balance) || "".equals(balance)){
      	balance = 0.00;
    }
    if("null".equals(availableSum) || "".equals(availableSum)){
      	availableSum = 0.00;
     }
    	
	String sTempletNo = "EntCustomerCreditInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("ENTCUSTOMERCLLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/EntCustomer/EntCustomerClList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function goBack(){ 
		self.close();
	}
	function initRow(){
		setItemValue(0,0,"BUSINESSSUM","<%=businessSum%>");
		setItemValue(0,0,"BALANCE","<%=balance%>");
		setItemValue(0,0,"AVAILABLESUM","<%=availableSum%>");
    }

	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
