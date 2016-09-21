<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: 业务资料操作 移库  关联业务资料信息
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
	//批次号，关联类型，关联编号，
	String sOperationType = CurPage.getParameter("OperationType");
	if(sOperationType == null) sOperationType = "";
	String sPTISerialNo = CurPage.getParameter("PTISerialNo");
	if(sPTISerialNo == null) sPTISerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	
	String sInsertSql = "";
	SqlObject so = null;
	
	String sReturnValue = "false";
	try{
		//插入一条操作数据
		String sDOSerialNo = DBKeyHelp.getSerialNo("doc_operation","SerialNo",""); 
		sInsertSql = "insert into doc_operation do (do.serialno,taskserialNo,do.objecttype,do.objectno,do.transactioncode," + 
							" do.operateuserid,do.operatedate,do.inputuserid,do.status,do.operatedescription) " + 
							" values(:SerialNo,:TaskSerialNo,:ObjectType,:ObjectNo,:TransactionCode ,:OperateUserId,:OperateDate,:InputUserId,:OperationStatus,:OperationDescription) "; 
		so = new SqlObject(sInsertSql);
		so.setParameter("SerialNo", sDOSerialNo);
		so.setParameter("TaskSerialNo", sPTISerialNo);
		so.setParameter("ObjectType", sObjectType);
		so.setParameter("OBJECTNO", sObjectNo);
		so.setParameter("TransactionCode", "0080");//表示移库操作
		so.setParameter("OperateUserId", CurUser.getUserID());
		so.setParameter("OperateDate", StringFunction.getToday());
		so.setParameter("InputUserId", CurUser.getUserID());
		so.setParameter("OperationStatus", "01");
		so.setParameter("OperationDescription", "");
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