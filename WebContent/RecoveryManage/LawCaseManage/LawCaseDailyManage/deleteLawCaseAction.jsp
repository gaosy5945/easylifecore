<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: 在诉讼案件表中删除 插入初始信息
 * Input Param:
 *		   
 *  
 * Output param:
 *		无	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//案件编号、案件类型、我行的诉讼地位
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String  sLawCaseType= DataConvert.toRealString(iPostChange,(String)request.getParameter("LawCaseType"));
	String sReturnValue="";
	// CasePhase=010表示诉前
	try{
		String sSql="";
		SqlObject so = null;
		/* sSql = "delete LawCase_Book where LawCaseSerialNo=:SerialNo";//删除案件台账信息表
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sSql = "delete LawCase_Relative where LawCaseSerialNo=:SerialNo";//删除案件关联信息表
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so); */
		sSql = "delete LawCase_Info where SerialNo=:SerialNo";//最后删除案件信息表
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sReturnValue="TRUE";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="FALSE";
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>