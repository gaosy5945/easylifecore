<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: 二类资料类型 操作
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
	String sViewId = CurPage.getParameter("ViewId");
	if(sViewId == null) sViewId = "";
	String sFolderId = CurPage.getParameter("FolderId");
	if(sFolderId == null) sFolderId = "";
	String sFolderName = CurPage.getParameter("FolderName");
	if(sFolderName == null) sFolderName = "";
	String sFileId = CurPage.getParameter("FileId");
	if(sFileId == null) sFileId = "";
	String sStatus = CurPage.getParameter("Status");
	if(sStatus == null) sStatus = "";
	String sParentFoler = CurPage.getParameter("ParentFoler");
	if(sParentFoler == null) sParentFoler = "";
	String sReturnValue = "false";
	//ViewId="+sViewId+'&FolderId='+sFolderId+'&FolderName='+sFolderName+'&FileId='+sFileId+'&Status='+sStatus+'&ParentFoler='+sParentFoler+""
	//CaseStatus=001表示不属于任何诉讼进程、CasePhase=010表示诉前
	try{
		SqlObject so = null;
		String sRunSql1 = "insert into doc_view_catalog dvc (dvc.viewid,dvc.folderid,dvc.foldername,dvc.parentfolder,dvc.status) values" +
							" ( :ViewId,:FolderId,:sFolderName,:ParentFoler,:Status )";
		String sRunSql2 = "insert into doc_view_file dvf  (dvf.viewid,dvf.folderid,dvf.fileid) values (:ViewId,:FolderId,:FileId)";
		so = new SqlObject(sRunSql1);
		so.setParameter("ViewId", sViewId);
		so.setParameter("FolderId", sFolderId);
		so.setParameter("sFolderName", sFolderName);
		so.setParameter("ParentFoler", sParentFoler);
		so.setParameter("Status", sStatus);
		Sqlca.executeSQL(so);
		so = new SqlObject(sRunSql2);
		so.setParameter("ViewId", sViewId);
		so.setParameter("FolderId", sFolderId);
		so.setParameter("FileId", sFileId);
		Sqlca.executeSQL(so);
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
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