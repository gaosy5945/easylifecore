<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%-- 页面说明: 客户信息详情->客户授信一览->该客户为本行额度或贷款提供保证情况页面--%>
<%	
 	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
/*	ASObjectModel doTemp = new ASObjectModel("IndCustomerForGuarantyList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request); */
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("CustomerID", customerID);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("IndCustomerForGuarantyList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	//dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"true","","Button","关联申请详情","关联申请详情","editApply()","","","","btn_icon_detail",""},
		{"true","","Button","关联合同详情","关联合同详情","editContract()","","","","btn_icon_detail",""},
	};
	sASWizardHtml = "<p><font color='red' size='2'>该客户为本行额度或贷款提供保证情况：</font></p>" ; 
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function editApply(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		 AsControl.PopComp("/CustomerManage/MyCustomer/IndCustomer/GuarantyApplyList.jsp","SerialNo="+SerialNo,"resizable=yes;dialogWidth=850px;dialogHeight=500px;center:yes;status:no;statusbar:no");
	}
	function editContract(){
		 var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		 if(typeof(SerialNo)=="undefined" || SerialNo.length==0 ){
			alert("请选择一条信息！");
			return ;
		 }
		 AsControl.PopComp("/CustomerManage/MyCustomer/IndCustomer/ContractRelativeList.jsp","SerialNo="+SerialNo,"resizable=yes;dialogWidth=800px;dialogHeight=500px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
