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
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�������Ϣ->�ʲ����ҳ��--%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("IndCustomerAssetList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	dwTemp.ReadOnly="0";
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
<script type="text/javascript">

	var frame = "myiframe0";
	function add(){
		
	}
	
	function saveRecord(){
		ChangeConvAmount();
		as_save("reloadPage()");
	}
	function reloadPage(){
		reloadSelf();
	}
	
	var selectedRowNum = -1;
	function mySelectRow(){
		if(selectedRowNum>=0){
			ChangeConvAmount();
		}
		selectedRowNum=getRow();
	}
	
	function ChangeConvAmount(){

		var amountTemp = getItemValue(0,selectedRowNum,"Amount");
		var convRatioTemp = getItemValue(0,selectedRowNum,"ConvRatio");
		if(typeof(amountTemp) == "undefined" || amountTemp.length == 0){
			return;
		}
		if(typeof(convRatioTemp) == "undefined" || convRatioTemp.length == 0){
			return;
		}
		var amount = amountTemp.replace(/,/g, "");
		var convRatio = convRatioTemp.replace(/,/g, "");

		if(typeof(amount) == "undefined" || amount.length == 0){
			return;
		}
		if(typeof(convRatio) == "undefined" || convRatio.length == 0){
			return;
		}
		if(amount < 0 || convRatio < 0) {
			alert("��������Ϊ���������������룡");
			return;
		};
		var convAmount = FormatKNumber(parseFloat(convRatio)*parseFloat(amount)/100.00,2);
		setItemValue(0,selectedRowNum,"CONVAMOUNT",convAmount);
	}
	function del(){
		if(confirm('ȷʵҪɾ����?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
	}
	
	function changeEvent(){
		var financialItem = getItemValue(0,0,"FINANCIALITEM");
		if(financialItem == "101001"){
			setItemDisabled(0,0,"DESCRIBE",true);
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
