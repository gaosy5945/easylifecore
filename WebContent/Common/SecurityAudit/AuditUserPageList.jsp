<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*用户访问时间日志*/
	sASWizardHtml = "<font color=red>本页面数据量较大，请通过查询条件查询</font>";
	String sToday = StringFunction.getToday();
	ASObjectModel doTemp = new ASObjectModel("AuditUserPageList");
	doTemp.setJboWhereWhenNoFilter(" and 1 = 2 "); //数据量过大，屏蔽进入页面的时候自动查询
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); 	//服务器分页
	dwTemp.genHTMLObjectWindow(sToday);
				
	String sButtons[][] = {};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>