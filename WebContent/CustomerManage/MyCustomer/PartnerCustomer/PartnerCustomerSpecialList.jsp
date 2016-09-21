<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";	
	String CertType = CurComp.getParameter("CertType");
	if(CertType == null) CertType = "";
	String CertID = CurComp.getParameter("CertID");
	if(CertID == null) CertID = "";

	
	ASObjectModel doTemp = new ASObjectModel("IndCustomerSpecialList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("CertType", CertType);
	dwTemp.setParameter("CertID", CertID);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"false","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"false","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
