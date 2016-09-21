<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String putOutDate = CurPage.getParameter("PutOutDate");
	String creditInspectType = CurPage.getParameter("creditInspectType");
	if(creditInspectType==null) creditInspectType="";
	if(objectNo == null) objectNo = "";
	
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject bdInfo = bom.loadBusinessObject("jbo.app.BUSINESS_DUEBILL", objectNo);
	String accountCurrency = bdInfo.getString("BusinessCurrency");
	
	ASObjectModel doTemp = new ASObjectModel("AfterAccountList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
		};
	//sASWizardHtml = "<p><font color='red' size='3'>\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n�ʻ���Ϣ</font></p>";
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		var accountType = getItemValue(0,getRow(),"AccountType");
		var accountNo = getItemValue(0,getRow(),"AccountNo");
		var putOutDate = "<%=putOutDate%>";
		var creditInspectType = "<%=creditInspectType%>";
		var framelistNo = "frame_list1";
		if(creditInspectType=="01"){
			framelistNo = "frame_list1"; 
		}else if(creditInspectType=="02"){
			framelistNo = "frame_list4"; 
		}
		if(typeof(accountNo)=="undefined" || accountNo.length==0) {
			return;
		}else{
			//AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency="+accountCurrency,framelistNo);
			//AsControl.OpenComp("/CreditManage/AfterBusiness/PayMessageList.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency="+accountCurrency,"frame_list1","");
			AsControl.OpenComp("/CreditManage/AfterBusiness/SelectPayMessageInfo.jsp","PutOutDate="+putOutDate+"&AccountType="+accountType+"&AccountNo="+accountNo+"&AccountCurrency=<%=accountCurrency%>",framelistNo);
		}
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
