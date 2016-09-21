<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	ASObjectModel doTemp = new ASObjectModel("EntCustomerClList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","额度详情","额度详情","CLView()","","","","",""},
			{"true","","Button","额度项下贷款详情","额度项下贷款详情","BDView()","","","","",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function CLView(){
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		 var sUrl = "/CustomerManage/MyCustomer/EntCustomer/EntCustomerClInfo.jsp";
		 AsControl.OpenPage(sUrl,'_self','');
	}
	function BDView(){
		 var sUrl = "/CustomerManage/MyCustomer/EntCustomer/EntCustomerAlList.jsp";
		 var serialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		AsControl.PopView(sUrl,'SerialNo=' +sPara ,'resizable=yes;dialogWidth=60;dialogHeight=40;center:yes;status:no;statusbar:no');
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
