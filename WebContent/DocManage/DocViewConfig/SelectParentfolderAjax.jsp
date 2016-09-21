<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:YJHOU 2015.03.04
 * Tester:
 * Content:  
 *       用查询业务资料参数管理配置中的树图节点是否有对应的子节点
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//操作类型
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