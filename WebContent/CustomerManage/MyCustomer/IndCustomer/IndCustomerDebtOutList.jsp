<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
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
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�������Ϣ->��ծ���(��ϵͳ��)ҳ��--%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("IndCustomerDebtOutList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary = "1";
	doTemp.setDefaultValue("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","����","����","saveRecord()","","","","btn_icon_save",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){		
		
	}
	
	function saveRecord()
	{
		as_save("reloadPage()");
	}
	function reloadPage(){
		reloadSelf();
	}
	function del(){
		if(confirm('ȷʵҪɾ����?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
