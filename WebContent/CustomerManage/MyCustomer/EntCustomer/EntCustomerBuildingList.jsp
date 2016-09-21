<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	String industryType = "";
	ASObjectModel doTemp = new ASObjectModel("EntCustomerBuildingList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
 	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select IndustryType from ENT_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",customerID));
 	if(rs.next()){
			industryType=rs.getString("industryType");
			if(industryType == null) {
				industryType = "";
			}
		}
	rs.getStatement().close();

	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{ "E0000".equals(industryType)? "true":"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{ "E0000".equals(industryType)? "true":"false","All","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{ "E0000".equals(industryType)? "true":"false","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var customerID = "<%=customerID%>";
		AsControl.PopView("/CustomerManage/MyCustomer/EntCustomer/EntCustomerBuildingInfo.jsp","CustomerID="+customerID,"resizable=yes;dialogWidth=520px;dialogHeight=550px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.PopComp("/CustomerManage/MyCustomer/EntCustomer/EntCustomerBuildingInfo.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=520px;dialogHeight=550px;center:yes;status:no;statusbar:no");
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
