<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
/*
 * Content: 获取流水号
 * Input Param:
 *			表名:	TableName
 *			列名:	ColumnName
 			格式：	SerialNoFormate
 * Output param:
 *		  流水号:	SerialNo
 */
	//获取表名、列名和格式
	String	sTableName		 = CurPage.getParameter("TableName");
	String	sColumnName 	 = CurPage.getParameter("ColumnName");
	String	sSerialNoFormate = CurPage.getParameter("SerialNoFormate");
	String sPrefix		 = CurPage.getParameter("Prefix");
	if (sSerialNoFormate == null) sSerialNoFormate="";
	if (sPrefix == null) sPrefix = "";

	String	sSerialNo = ""; //流水号

	if(sSerialNoFormate.equals("")){
		if (sPrefix.equals(""))	sSerialNo = DBKeyHelp.getSerialNo(sTableName,sColumnName,Sqlca);
		else sSerialNo = DBKeyHelp.getSerialNo(sTableName,sColumnName,sPrefix,Sqlca);
	}else{
		sSerialNo = DBKeyHelp.getSerialNo(sTableName,sColumnName,sSerialNoFormate,Sqlca);
	}
	out.print(sSerialNo); 
%><%@ include file="/IncludeEndAJAX.jsp"%>