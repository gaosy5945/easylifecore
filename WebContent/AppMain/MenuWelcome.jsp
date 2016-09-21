<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
ASResultSet rs = null;
ArrayList<String[]> tabs = new ArrayList<String[]>();
try{
	String sSqlTab = "select ItemName, ItemDescribe, ItemAttribute from CODE_LIBRARY CL "+
			"where CodeNo = 'WelcomeTab'  and IsInUse = '1' "+
			"order by SortNo";
	rs = Sqlca.getResultSet(new SqlObject(sSqlTab));
	while(rs.next()){
		tabs.add(new String[]{"true", rs.getString("ItemName"), rs.getString("ItemDescribe"), rs.getString("ItemAttribute")});
	}
}finally{
	if(rs != null) rs.close();
}

String sTabStrip[][] = tabs.toArray(new String[0][]);
%>
<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>