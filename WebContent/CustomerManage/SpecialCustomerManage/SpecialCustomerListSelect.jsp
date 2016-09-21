<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("SelectCustomerList");
	doTemp.setJboWhereWhenNoFilter(" and 1<>1 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","查看详情","查看详情","edit()","","","","btn_icon_detail",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function edit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");

		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条信息！");
			return;
		}
		var result = CustomerManage.selectCustomer(customerID);
		if(result == "SUCCEED"){
			var customerType = CustomerManage.selectCustomerType(customerID);
			CustomerManage.editCustomer(customerID,customerType);
		}else{
			alert("本行无该客户信息！");
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
