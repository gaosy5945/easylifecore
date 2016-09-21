<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = CurPage.getParameter("TransSerialNo");
	if(sObjectNo == null) sObjectNo = "";
	
	
	//显示模版编号
	String sTempletNo = "LoanDetailList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectNo);
	

	String sButtons[][] = {
	};
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	//初始化
// 	AsOne.AsInit();
// 	init();
// 	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>