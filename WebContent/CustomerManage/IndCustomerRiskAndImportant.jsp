<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String CustomerID = CurComp.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	ASObjectModel doTemp = new ASObjectModel("IndCustomerRiskAndImportant");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("RISKINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/IndCustomerRiskList.jsp?CustomerID="+CustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("IMPORTANTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/IndCustomerImportantInfoList.jsp?CustomerID="+CustomerID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
