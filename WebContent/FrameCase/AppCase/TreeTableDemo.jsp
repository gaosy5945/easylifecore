<%@page import="com.amarsoft.app.als.sys.widget.TreeTable"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><% 
 	StringBuffer temp=new StringBuffer();
	String[][] header={
					{"",""},
 					{"Currency","����"},
 					{"LimitSum","������"},
 					{"ExpouseSum","���ڽ��"},
 					{"CycFlag","ѭ����־"},
 					{"ControlFlag","���Ʒ�ʽ"},
 					{"CalFlag","���㷽ʽ"},
 					{"ShareType","�������"},
 					{"btn",""}
	};
	String btn="<a>����</a> <a>ɾ��</a> <a>����</a>";
	TreeTable treeTable=new TreeTable(header);
	//temp.append(treeTable.getHtml());

 	String sButtons[][] = {
	   {"true","","Button","��ȷ���","��ȷ���","viewAndEdit()","","","",""},
	   {"true","","Button","����","����","viewAndEdit()","","","",""},
	   {"true","","Button","ɾ��","ɾ��","viewHistory()","","","",""}
 	};
%><%@ include file="/AppMain/resources/include/treetable_include.jsp"%>
<%
String stemp=treeTable.getHtml();
out.print(stemp);
%>
<script type="text/javascript">
	$(document).ready(function() {
	    table = $("table.<%=treeTable.tableId%>"); 
	    //����treeTable
	    table.treeTable({initialState:"expanded"});
	    //���������ı䱳�������������¼�
	    table.tableLight();
	 
	    return;
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>