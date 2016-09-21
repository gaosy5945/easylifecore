<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
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
<%-- 页面说明: 客户信息详情->客户基本信息->资产情况页面--%>
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
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","ALSObjectWindowFunctions.addRow(0,'','add()')","","","","btn_icon_add",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","btn_icon_save",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
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
			alert("参数不可为负数！请重新输入！");
			return;
		};
		var convAmount = FormatKNumber(parseFloat(convRatio)*parseFloat(amount)/100.00,2);
		setItemValue(0,selectedRowNum,"CONVAMOUNT",convAmount);
	}
	function del(){
		if(confirm('确实要删除吗?')){
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
