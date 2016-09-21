<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><% 
 	StringBuffer temp=new StringBuffer();
	String[][] header={
					{"",""},
 					{"Currency","币种"},
 					{"LimitSum","名义金额"},
 					{"ExpouseSum","敞口金额"},
 					{"CycFlag","循环标志"},
 					{"ControlFlag","控制方式"},
 					{"CalFlag","计算方式"},
 					{"ShareType","共享规则"},
 					{"btn",""}
	};
	String btn="<a>详情</a> <a>删除</a> <a>分配</a>";
	TreeTable treeTable=new TreeTable(header);
	//temp.append(treeTable.getHtml());

 	String sButtons[][] = {
	   {"true","","Button","额度分配","额度分配","viewAndEdit()","","","",""},
	   {"true","","Button","详情","详情","viewAndEdit()","","","",""},
	   {"true","","Button","删除","删除","viewHistory()","","","",""}
 	};
%><%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<%
String stemp=treeTable.getHtml();
out.print(stemp);
%>
<script type="text/javascript">
	$(document).ready(function() {
	    table = $("table.<%=treeTable.tableId%>"); 
	    //生成treeTable
	    table.treeTable({initialState:"expanded"});
	    //给表绑定移入改变背景，单击高亮事件
	    table.tableLight();
	 
	    return;
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>