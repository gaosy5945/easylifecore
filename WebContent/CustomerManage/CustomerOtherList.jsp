<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String logType = CurPage.getParameter("LogType");
	String customerID = CurPage.getParameter("CustomerID");
	if(logType == null) logType = "";
	if(customerID == null) customerID = "";
	
	ASObjectModel doTemp = new ASObjectModel("CustomerOtherList");
	
	if("1".equals(logType)){//管户变更记录
		doTemp.setHeader("UserName", "新管户人");
		doTemp.setHeader("OrgName", "新管户机构");
		doTemp.setHeader("InputDate", "变更日期");
	}else if("2".equals(logType)){
		doTemp.setVisible("OldUserName", false);
		doTemp.setVisible("OldOrgName", false);
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(25);
	dwTemp.genHTMLObjectWindow(customerID+","+logType);
	
	String sButtons[][] = {};
%> 
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
