<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: �����ϰ�������ɾ�� �����ʼ��Ϣ
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
	//������š��������͡����е����ϵ�λ
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String  sLawCaseType= DataConvert.toRealString(iPostChange,(String)request.getParameter("LawCaseType"));
	String sReturnValue="";
	// CasePhase=010��ʾ��ǰ
	try{
		String sSql="";
		SqlObject so = null;
		/* sSql = "delete LawCase_Book where LawCaseSerialNo=:SerialNo";//ɾ������̨����Ϣ��
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sSql = "delete LawCase_Relative where LawCaseSerialNo=:SerialNo";//ɾ������������Ϣ��
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so); */
		sSql = "delete LawCase_Info where SerialNo=:SerialNo";//���ɾ��������Ϣ��
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sReturnValue="TRUE";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="FALSE";
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