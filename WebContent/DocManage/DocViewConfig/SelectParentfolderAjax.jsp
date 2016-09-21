<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:YJHOU 2015.03.04
 * Tester:
 * Content:  
 *       �ò�ѯҵ�����ϲ������������е���ͼ�ڵ��Ƿ��ж�Ӧ���ӽڵ�
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//��������
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = ""; 
	String sSql = ""; 
	SqlObject so = null; 
	ASResultSet rs = null;
	 
	String sReturnValue = " ";
	try{
		 sSql =  "select dvc.parentfolder from doc_view_catalog dvc where dvc.folderid=:FolderId";
		 so = new SqlObject(sSql);
		 so.setParameter("FolderId", sFolderId); 
		 rs = Sqlca.getASResultSet(so);
		 String sParentFolder = "";
		 if(rs.next()){
			 sParentFolder = rs.getString("parentfolder");	 
		 }
		 rs.getStatement().close();
		 if("".equals(sParentFolder)||sParentFolder==null){
			 sReturnValue="false";
		 }else{	  
			 sReturnValue="true";
		 }
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