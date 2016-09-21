<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ObjectNo = CurPage.getParameter("ObjectNo");
	String CustomerID = CurPage.getParameter("CustomerID");
	String CustomerName = CurPage.getParameter("CustomerName");
	String BusinessType = CurPage.getParameter("BusinessType");
	ASObjectModel doTemp = new ASObjectModel("SelectCLAcountList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("CustomerID", CustomerID);
	dwTemp.setParameter("CustomerName", CustomerName);
	dwTemp.setParameter("ObjectNo", ObjectNo);
	dwTemp.setParameter("BusinessType", BusinessType);
	dwTemp.genHTMLObjectWindow(CustomerID+","+CustomerName+","+ObjectNo+","+BusinessType);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","确定","确定","save()","","","","",""},
			{"true","All","Button","取消","取消","returnList()","","","","",""},
		};
	//sButtonPosition = "south";
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function save(){
		var objectNo = getItemValue(0, getRow(0), "ObjectNo");
		top.returnValue = objectNo;
		top.close();
	}
	function returnList(){
		self.close();
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
