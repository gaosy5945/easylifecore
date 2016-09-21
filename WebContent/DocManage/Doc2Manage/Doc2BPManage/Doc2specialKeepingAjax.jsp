<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: 业务资料专夹保管 操作
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
	//操作类型
	String sOperationType = CurPage.getParameter("OperationType");
	if(sOperationType == null) sOperationType = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//1,额度，2.贷款，3。合作项目
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	String sPosition = CurPage.getParameter("Position");
	if(sPosition == null) sPosition = "";
	String sKeepingType = CurPage.getParameter("KeepingType");
	if(sKeepingType == null) sKeepingType = "";
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate = StringFunction.getToday();
	
	String sInsertSql = "";
	String sSelSql = "";
	SqlObject so = null;
	String sSql = "";
	String sDFPSerialNo = "";
	
	String sReturnValue = "false";
	try{
		sSelSql = "select SerialNo from doc_file_package dfp where dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo and dfp.packagetype='02' ";
		so = new SqlObject(sSelSql);
		so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		so.setParameter("ObjectNo", sObjectNo);
		sDFPSerialNo = Sqlca.getString(so);
		if(null == sDFPSerialNo || "null".equalsIgnoreCase(sDFPSerialNo)){
			sDFPSerialNo = "";
		} 
		if("".equals(sDFPSerialNo) || "" == sDFPSerialNo){
			//在doc_File_Package新增一条信息
			String sDFPSerialNo1 = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SerialNo",""); 
			
			sSql = "insert into doc_file_package dfp (dfp.serialno,dfp.objecttype,dfp.objectno,dfp.packagetype,dfp.position,dfp.inputuserid,dfp.inputorgid,dfp.inputdate,dfp.updatedate,dfp.manageuserid,dfp.manageorgid,dfp.lastoperatedate)"+
					 " values(:SerialNo,:ObjectType,:ObjectNo,:PackageType,:Position,:InputUserId,:InputOrgId,:InputDate,:UpdateDate,:ManageUserId,:ManageOrgId,:LastOperateDate)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sDFPSerialNo1);
			so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("PackageType", "02");//二类档案
			so.setParameter("Position", sPosition);
			so.setParameter("InputUserId", sUserId);
			so.setParameter("InputOrgId", sOrgId);
			so.setParameter("InputDate", sDate);
			so.setParameter("UpdateDate", sDate);
			so.setParameter("ManageUserId", sUserId);
			so.setParameter("ManageOrgId", sOrgId);
			so.setParameter("LastOperateDate", sDate);
			
		}else {
			sSql = "update doc_file_package dfp set dfp.position=:Position,dfp.lastoperatedate=dfp.updatedate,dfp.inputuserid=:InputUserId,dfp.inputorgid=:InputOrgId,dfp.updatedate=:UpdateDate  where SerialNo=:SerialNo ";
			so = new SqlObject(sSql);
			so.setParameter("Position", sPosition);	
			so.setParameter("InputUserId", sUserId);
			so.setParameter("InputOrgId", sOrgId);
			so.setParameter("UpdateDate", sDate);
			so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("SerialNo", sDFPSerialNo);
		}
		Sqlca.executeSQL(so); 
		if("0201".equals(sKeepingType) || "0201" == sKeepingType){
			sSql = "update doc_file_package dfp set dfp.Status=:Status  where Serialno=:SerialNo";
			so = new SqlObject(sSql);
			so.setParameter("Status", "02");
			so.setParameter("SerialNo", sDFPSerialNo);
			Sqlca.executeSQL(so); 
		}
		if("0101".equals(sKeepingType) || "0101" == sKeepingType){
			sSql = "update doc_file_package dfp set dfp.Status=:Status  where Serialno=:SerialNo";
			so = new SqlObject(sSql);
			so.setParameter("Status", "01");
			so.setParameter("SerialNo", sDFPSerialNo);
			Sqlca.executeSQL(so); 
		}
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