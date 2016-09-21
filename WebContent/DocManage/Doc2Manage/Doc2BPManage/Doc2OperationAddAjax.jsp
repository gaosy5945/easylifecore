<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: ҵ�����ϲ�����¼
 			1��Ԥ�鵵��������������DFP��DFI��DO��Ϣ
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
	String sDOSerialNo = CurPage.getParameter("SerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	
	String sInsertSql = "";
	SqlObject so = null;
	
	String sReturnValue = "false";
	try{
		
		String sSelSql = "select SerialNo from doc_file_package dfp where dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo and dfp.packagetype='02' ";
		so = new SqlObject(sSelSql);
		so.setParameter("ObjectType", sObjectType);
		so.setParameter("ObjectNo", sObjectNo);
		String sDFPSerialNo = Sqlca.getString(so);
		if(null == sDFPSerialNo || "null".equalsIgnoreCase(sDFPSerialNo)){
			sDFPSerialNo = "";
		} 
		if("".equals(sDFPSerialNo) || "" == sDFPSerialNo){
			//��doc_File_Package����һ����Ϣ
			String sDFPSerialNo1 = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SerialNo",""); 
			
			String sSql = "insert into doc_file_package dfp (dfp.serialno,dfp.objecttype,dfp.objectno,dfp.packagetype,dfp.position,dfp.status,dfp.inputuserid,dfp.inputorgid,dfp.inputdate,dfp.updatedate,dfp.manageuserid,dfp.manageorgid,dfp.lastoperatedate)"+
					 " values(:SerialNo,:ObjectType,:ObjectNo,:PackageType,:Position,:Status,:InputUserId,:InputOrgId,:InputDate,:UpdateDate,:ManageUserId,:ManageOrgId,:LastOperateDate)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sDFPSerialNo1);
			so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("PackageType", "02");//���൵��
			so.setParameter("Position", "");
			so.setParameter("Status", "01");//�Ѿ�Ԥ�鵵
			so.setParameter("InputUserId", CurUser.getUserID());
			so.setParameter("InputOrgId",  CurUser.getOrgID());
			so.setParameter("InputDate", StringFunction.getToday());
			so.setParameter("UpdateDate",StringFunction.getToday());
			so.setParameter("ManageUserId",  CurUser.getUserID());
			so.setParameter("ManageOrgId",  CurUser.getOrgID());
			so.setParameter("LastOperateDate", StringFunction.getToday());
			sDFPSerialNo = sDFPSerialNo1;
		}else {
			String sSql = "update doc_file_package dfp set dfp.Status=:Status,dfp.lastoperatedate=dfp.updatedate,dfp.inputuserid=:InputUserId,dfp.inputorgid=:InputOrgId,dfp.updatedate=:UpdateDate  where dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo and dfp.packagetype='02' ";
			so = new SqlObject(sSql);
			so.setParameter("Status", "01");//�ѷ�������
			so.setParameter("InputUserId", CurUser.getUserID());
			so.setParameter("InputOrgId",  CurUser.getOrgID());
			so.setParameter("UpdateDate", StringFunction.getToday());
		}
		Sqlca.executeSQL(so); 
		
		//��doc_File_INFO����һ����Ϣ
		sSelSql = "select SerialNo from doc_file_info dfp where dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo ";
		so = new SqlObject(sSelSql);
		so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		so.setParameter("ObjectNo", sObjectNo);
		String sDFISerialNo = Sqlca.getString(so);
		if(null == sDFISerialNo || "null".equalsIgnoreCase(sDFISerialNo)){
			sDFISerialNo = "";
		} 
		if("".equals(sDFISerialNo) || "" == sDFISerialNo){
			//��doc_File_INFO����һ����Ϣ
			String sDFISerialNo1 = DBKeyHelp.getSerialNo("DOC_FILE_INFO","SerialNo",""); 
			
			String sSql = "insert into doc_file_info dfi (dfi.serialno,dfi.objecttype,dfi.objectno,dfi.status,dfi.packageserialno,dfi.fileformat,dfi.SUBMITDATE) "+
					 " values(:SERIALNO,:OBJECTTYPE,:OBJECTNO,:STATUS,:PACKAGESERIALNO,:FILEFORMAT,:SUBMITDATE)";
			so = new SqlObject(sSql);
			so.setParameter("SERIALNO", sDFISerialNo1);
			so.setParameter("OBJECTTYPE", "jbo.app.BUSINESS_CONTRACT");
			so.setParameter("OBJECTNO", sObjectNo);
			so.setParameter("STATUS", "01");//
			so.setParameter("PACKAGESERIALNO",sDFPSerialNo);
			so.setParameter("FILEFORMAT","");
			so.setParameter("SUBMITDATE", StringFunction.getToday());
			
			sDFISerialNo = sDFISerialNo1;
		}else {
			//����DOC_FILE_info ����״̬
			String sSql = "update doc_file_info dfi set dfi.status=:Status where  serialno=:serialno";
			so = new SqlObject(sSql);
			so.setParameter("Status", "01");//Ԥ�鵵
			so.setParameter("serialno", sDFISerialNo);
			so.setParameter("InputUserId", CurUser.getUserID());
		}
		Sqlca.executeSQL(so); 

		//����һ����������
		sInsertSql = "insert into doc_operation do (do.serialno,do.objecttype,do.objectno,do.transactioncode," + 
							" do.operateuserid,do.operatedate,do.inputuserid,do.status,do.operatedescription) " + 
							" values(:SerialNo,:ObjectType,:ObjectNo,:TransactionCode ,:OperateUserId,:OperateDate,:InputUserId,:OperationStatus,:OperationDescription) "; 
		so = new SqlObject(sInsertSql);
		so.setParameter("SerialNo", sDOSerialNo);
		so.setParameter("ObjectType", sObjectType);
		so.setParameter("OBJECTNO", sObjectNo);
		so.setParameter("TransactionCode", sOperationType);
		so.setParameter("OperateUserId", CurUser.getUserID());
		so.setParameter("OperateDate", StringFunction.getToday());
		so.setParameter("InputUserId", CurUser.getUserID());
		so.setParameter("OperationStatus", "01");
		so.setParameter("OperationDescription", "");
		Sqlca.executeSQL(so);
		
		String sDOFSerialNo = DBKeyHelp.getSerialNo("doc_operation_file","SerialNo",""); 
		sInsertSql = "insert into doc_operation_file DOF (DOF.SERIALNO,DOF.OPERATIONSERIALNO,DOF.FILESERIALNO,DOF.OPERATEMEMO) "+
						" VALUES(:SerialNo,:OperationSerialNo,:FileSerialNo,:OperateMemo)";
		so = new SqlObject(sInsertSql);
		so.setParameter("SerialNo", sDOFSerialNo);
		so.setParameter("OperationSerialNo", sDOSerialNo);
		so.setParameter("FileSerialNo", sDFISerialNo);
		so.setParameter("OperateMemo", "");
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