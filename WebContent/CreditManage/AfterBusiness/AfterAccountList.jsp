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
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
	//sASWizardHtml = "<p><font color='red' size='3'>\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n帐户信息</font></p>";
	
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
