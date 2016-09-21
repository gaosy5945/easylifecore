
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%>

<%
	String treeNo=CurPage.getParameter("TreeNo");

	Item[] items=CodeManager.getItems("EntApplyTree");
	String[][] sTabStrip=new String[items.length][6];
	int iRowNum=0;
	for(Item item:items){
		sTabStrip[iRowNum][0]="true";
		sTabStrip[iRowNum][1]=item.getItemName();
		String url=item.getItemDescribe();
		if(url.indexOf("?")>0){
			sTabStrip[iRowNum][2]=url.split("?")[0];
			sTabStrip[iRowNum][3]=url.split("?")[1];
		}else{
			sTabStrip[iRowNum][2]=url;
			sTabStrip[iRowNum][3]="";
		}

		sTabStrip[iRowNum][4]="";
		sTabStrip[iRowNum][5]="";
		
		iRowNum++;
	}
%>
 
<%@ include file="/Resources/CodeParts/Tab01.jsp"%>

<%@ include file="/IncludeEnd.jsp"%>