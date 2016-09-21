<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*安全选项变更情况*/
 	ASObjectModel doTemp = new ASObjectModel("AuditOptionLogList");
 	doTemp.setJboWhereWhenNoFilter(" and BeginTime like '"+StringFunction.getToday()+"%'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); 	//服务器分页
	dwTemp.genHTMLObjectWindow("");
				
	String sButtons[][] = {};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>