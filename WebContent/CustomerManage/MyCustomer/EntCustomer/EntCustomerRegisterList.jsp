<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	ASObjectModel doTemp = new ASObjectModel("EntCustomerRegisterList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.OpenPage("/CustomerManage/MyCustomer/EntCustomer/EntCustomerRegisterInfo.jsp","CustomerID="+"<%=customerID%>","_self","");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.OpenPage("/CustomerManage/MyCustomer/EntCustomer/EntCustomerRegisterInfo.jsp","SerialNo="+serialNo,"_self","");
		reloadSelf();
	}
	function del(){
			var serialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			    alert(getHtmlMessage('1'));//请选择一条信息！
			    return;
			}
			if(confirm('确实要删除吗?')){
				as_delete(0);
			}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
