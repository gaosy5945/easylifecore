<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�����һ��->�������Ŷ����Ϣҳ��--%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
    //Double relativeSum = Sqlca.getDouble(new SqlObject("SELECT SUM(nvl(BUSINESSSUM,0.0)) FROM BUSINESS_CONTRACT WHERE (CUSTOMERID IN (SELECT RELATIVECUSTOMERID FROM CUSTOMER_RELATIVE WHERE RELATIONSHIP='2007' AND CUSTOMERID =:CustomerID))").setParameter("CustomerID",customerID)); //��ż�����ܶ�� 
    //Double businessSum = Sqlca.getDouble(new SqlObject("SELECT SUM(nvl(BUSINESSSUM,0.0)) FROM BUSINESS_CONTRACT WHERE CUSTOMERID =:CustomerID").setParameter("CustomerID",customerID)); //�ͻ������ܶ��
   // Double businessSum = Sqlca.getDouble(new SqlObject("select sum( (case when BC.Revolveflag = '1' and BC.MATURITYDATE >= '' then nvl(BC.BusinessSum,0) when BC.Revolveflag = '1' and BC.MATURITYDATE < '' then nvl(Balance,0) when BC.Contractstatus in('01','02') then nvl(BusinessSum,0) when BC.CONTRACTSTATUS = '03' then nvl(Balance,0) else 0 end)) as balance from BUSINESS_CONTRACT BC where CustomerID = :CustomerID and not exists(select 1 from CONTRACT_RELATIVE where ContractSerialNo=BC.SERIALNO and RelativeType = '06')").setParameter("CustomerID",customerID)); //�ͻ������ܶ��
   	//Double balance = Sqlca.getDouble(new SqlObject("select sum( (case when BC.Revolveflag = '1' and BC.MATURITYDATE >= '' then nvl(BC.Balance,0) when BC.Revolveflag = '1' and BC.MATURITYDATE < '' then nvl(Balance,0) when BC.Contractstatus in('01','02') then nvl(Balance,0) when BC.CONTRACTSTATUS = '03' then nvl(Balance,0) else 0 end)) as balance from BUSINESS_CONTRACT BC where CustomerID = :CustomerID and not exists(select 1 from CONTRACT_RELATIVE where ContractSerialNo=BC.SERIALNO and RelativeType = '06')").setParameter("CustomerID",customerID)); //���ö��
   	//Double availableSum = businessSum - balance; //���ö��
   	
	String sTempletNo = "IndCustomerCreditInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("INDCUSTOMERCREDITCLLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerCreditClList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("BUSINESSINGLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/CustomerBusinessInfo.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("APPLYLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/CustomerBusinessApplyList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("GUARANTYLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerGuarantyInfo.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	//dwTemp.replaceColumn("INDCUSTOMERCREDITALLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerCreditALList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","ȡ��","ȡ��","as_save(0)","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
