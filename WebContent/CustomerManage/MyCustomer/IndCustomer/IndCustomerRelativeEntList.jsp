<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String customerType = CurPage.getParameter("CustomerType");
	if(customerType == null) customerType = "";
	String CustomerFlag = CurPage.getParameter("CustomerFlag");
	if(CustomerFlag == null) CustomerFlag = "";

	ASObjectModel doTemp = new ASObjectModel("IndCustomerRelativeEntList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","关系企业详情","关系企业详情","viewAndEdit()","","","","btn_icon_detail",""},
			//{"true","","Button","关系类型","关系类型","edit()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function add(){
		customerID = "<%=customerID%>";
		customerType = "<%=customerType%>";
		CustomerFlag = "<%=CustomerFlag%>";
		AsControl.PopPage("/CustomerManage/MyCustomer/IndCustomer/EntCustomerRelativeInfo.jsp","CustomerID="+customerID+"&CustomerType="+customerType+"&CustomerFlag="+CustomerFlag,"resizable=yes;dialogWidth=500px;dialogHeight=480px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function viewAndEdit(){
		var customerID = getItemValue(0,getRow(0),"RELATIVECUSTOMERID");
		var customerType = "01";
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("请选择一条信息！");
			return;
		}
		 CustomerManage.editCustomer(customerID,customerType);
	}
	function edit(){
		serialNo = getItemValue(0,getRow(),"SerialNo");
		customerID = "<%=customerID%>";
		customerType = "<%=customerType%>";
		if (typeof(serialNo)=="undefined" || serialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			AsControl.PopPage("/CustomerManage/MyCustomer/IndCustomer/EntCustomerRelativeInfo.jsp","SerialNo="+serialNo+"&CustomerID="+customerID+"&CustomerType="+customerType,"resizable=yes;dialogWidth=500px;dialogHeight=480px;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
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
