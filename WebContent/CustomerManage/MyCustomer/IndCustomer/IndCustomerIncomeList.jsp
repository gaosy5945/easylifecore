<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.customer.action.JudgeIncomeType"%>
<%@page import="com.amarsoft.app.als.customer.action.CreateCustomerInfo"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
 <style>
 /*页面小计样式*/
.list_div_pagecount{
	font-weight:bold;
}
/*总计样式*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%-- 页面说明: 客户信息详情->客户基本信息->收入信息List页面--%>
<%	
	String customerID =  CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String serialNo =  CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String rightType = CurPage.getParameter("RightType");
	if(rightType == null) rightType = "";
	if(!"ReadOnly".equals(rightType)){
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			JudgeIncomeType JIE = new JudgeIncomeType();
			CreateCustomerInfo CCI = new CreateCustomerInfo();
			CCI.CreateCustomerIncome(customerID,CurOrg.getOrgID(),CurUser.getUserID(),DateHelper.getBusinessDate(),tx);
			tx.commit();
		}catch(Exception ex)
		{
			tx.rollback();
			throw ex;
		}
	}
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("IndCustomerIncomeList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.ShowSummary = "1";
	doTemp.setDefaultValue("Currency", "CNY");
	doTemp.setDefaultValue("CustomerID", customerID);
	doTemp.setDefaultValue("OccurDate", DateHelper.getBusinessDate());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新增","新增","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_save",""},
			{"fasle","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<script type="text/javascript">
	function add(){	

	}
	function saveRecord()
	{
		as_save("reloadPage()");
	}
	function reloadPage(){
		CustomerManage.updateIncome("<%=customerID%>","<%=DateHelper.getBusinessDate()%>");
		reloadSelf();
		initDocumentType();
	}
	function del(){
		if(confirm('确实要删除吗?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
	}
	function initDocumentType(){
		for(var i=0;i<getRowCount(0);i++){
			var financialItem = getItemValue(0,i,"FINANCIALITEM");
 			var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetFinancialItem", "getFinancialItem", "financialItem="+financialItem);
 			var aCode = result.split(",");
			var data = {};
			for(var j = 0; j < aCode.length-1; j += 2){
				data[aCode[j]] = aCode[j+1];
			}
			ALSObjectWindowFunctions.setSelectOptions(0,i,"DOCUMENTTYPE",data);
		}
	}
	
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript" >
$(document).ready(function(){
	if("ReadOnly" != "<%=CurPage.getParameter("RightType")%>")
	{
		initDocumentType(); 
	}
});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
