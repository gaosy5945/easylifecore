<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	ASObjectModel doTemp = new ASObjectModel("SelectAllApplyCustomer");
	doTemp.setJboWhereWhenNoFilter("1=2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定","保存所有修改","save()","","","",""},
			{"true","All","Button","取消","返回","returnList()","","","",""},
	};

%>
<title>请输入查询条件选择客户</title>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		var customerID = getItemValue(0, getRow(0), "CustomerID");
		var customerName = getItemValue(0, getRow(0), "CustomerName");
		var certType = getItemValue(0, getRow(0), "CertType");
		var certID = getItemValue(0, getRow(0), "CertID");
		var customerType = getItemValue(0, getRow(0), "CustomerType");
		top.returnValue = "true@"+customerID+"@"+customerName+"@"+certType+"@"+certID+"@"+customerType;
		top.close();
	}
	function returnList(){
		top.returnValue = "false";
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>

