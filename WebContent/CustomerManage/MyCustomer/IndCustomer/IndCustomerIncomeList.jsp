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
 /*ҳ��С����ʽ*/
.list_div_pagecount{
	font-weight:bold;
}
/*�ܼ���ʽ*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�������Ϣ->������ϢListҳ��--%>
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
	
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.ShowSummary = "1";
	doTemp.setDefaultValue("Currency", "CNY");
	doTemp.setDefaultValue("CustomerID", customerID);
	doTemp.setDefaultValue("OccurDate", DateHelper.getBusinessDate());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","����","����","saveRecord()","","","","btn_icon_save",""},
			{"fasle","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
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
		if(confirm('ȷʵҪɾ����?')){
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
