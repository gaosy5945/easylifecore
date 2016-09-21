<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: ҵ�����ϲ��� ���ҵ�������嵥
 * Input Param:
 *		   
 *  
 * Output param:
 *		��	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//��������
	String sOperationType = CurPage.getParameter("OperationType");
	if(sOperationType == null) sOperationType = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sDFISerialNo = CurPage.getParameter("DFISerialNo");
	if(sDFISerialNo == null) sDFISerialNo = "";
	String sOperateMemo = CurPage.getParameter("OperateMemo");
	if(sOperateMemo == null) sOperateMemo = "";
	String sDOFSerialNo = "";
	String sInsertSql = "";
	SqlObject so = null;
	
	String sReturnValue = "false";
	try{
		sDOFSerialNo = DBKeyHelp.getSerialNo("doc_operation_file","SerialNo",""); 
		sInsertSql = "insert into doc_operation_file DOF (DOF.SERIALNO,DOF.OPERATIONSERIALNO,DOF.FILESERIALNO,DOF.OPERATEMEMO) "+
						" VALUES(:SerialNo,:OperationSerialNo,:FileSerialNo,:OperateMemo)";
		so = new SqlObject(sInsertSql);
		so.setParameter("SerialNo", sDOFSerialNo);
		so.setParameter("OperationSerialNo", sDOSerialNo);
		so.setParameter("FileSerialNo", sDFISerialNo);
		so.setParameter("OperateMemo", sOperateMemo);
		//����һ����������
		Sqlca.executeSQL(so);
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>