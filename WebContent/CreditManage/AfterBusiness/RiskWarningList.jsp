<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String objectType = DataConvert.toString(CurPage.getParameter("ObjectType"));
	String objectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));
	String customerID = DataConvert.toString(CurPage.getParameter("CustomerID"));
	ASObjectModel doTemp = new ASObjectModel("RWSignalHistoryList2");//RWSignalHistoryList1
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setParameter("ObjectType",objectType);
	dwTemp.setParameter("ObjectNo",objectNo);
	dwTemp.setParameter("CustomerID",customerID);
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(objectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
