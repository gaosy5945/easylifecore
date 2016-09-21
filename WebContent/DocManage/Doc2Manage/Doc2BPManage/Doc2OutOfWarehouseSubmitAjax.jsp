<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: 业务资料操作  出库  
 				1.修改申请状态DO（doc_operation） status
 				2.将当前阶段的DOF（doc_operation_file） 关系 全都复制到下一个操作阶段
 				3.将当前阶段status 置为 已处理
 				4.DO表状态的变化会引发DFP（DOC_FILE_PACKAGE）状态的变化
 				5.DFP状态和DFI（DOC_FILE_INFO）会互相影响
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
	String sOperationStatus = CurPage.getParameter("OperationStatus");//operationtype=0020出库时，01,申请；02，审批；03审批通过，04:领取，05，退回
	if(sOperationStatus == null) sOperationStatus = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//1,额度，2.贷款，3。合作项目
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	String sStatus = CurPage.getParameter("Status");
	if(sStatus == null) sStatus = "";
	String sApproveSubmitStatus = CurPage.getParameter("ApproveSubmitStatus");//审批--提交，退回
	if(sApproveSubmitStatus == null) sApproveSubmitStatus = "";
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate = StringFunction.getToday();
	String sDFPSerialNo = "";
	String sTransactionCode = "";
	
	String sInsertSql = "";
	String sUpdateSql = "";
	String sSelSql = "";
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs = null;
	//对应的下一阶段 DO对应的操作阶段
	String sNextStatus = "";
	//出库状态变换
	if("01".equals(sStatus) || "01"==sStatus){//申请待提交
		sNextStatus = "02";//申请提交待审批中
	}
	if("02".equals(sStatus) || "02"==sStatus){//申请提交待审批中
		sNextStatus = "03";//申请已审批待处理（领取）中
	}
	if("03".equals(sStatus) || "03"==sStatus){//申请已审批待处理（领取）中 sApproveSubmitStatus

		if("01".equals(sApproveSubmitStatus) || "01"==sApproveSubmitStatus){
			sNextStatus = "04";//已处理--领用（出库，借用） 
		}else if("02".equals(sApproveSubmitStatus) || "02"==sApproveSubmitStatus){
			sNextStatus = "05";//已处理--退回
		}
	}
	if("05".equals(sStatus) || "05"==sStatus){//已处理--退回
		sNextStatus = "02";//退回 重新提交
	}
	
	if(("0020".equals(sOperationType) || "0020" == sOperationType) && ("03".equals(sStatus) || "03"==sStatus)){//出库申请--出库（含部分出库）
		sTransactionCode = "0070";
	}else	if(("0030".equals(sOperationType) || "0030" == sOperationType) && ("03".equals(sStatus) || "03"==sStatus)){//出库申请--出借（借用）
		sTransactionCode = "0070";
	}
	String sReturnValue = "false";
	try{
		if(("03".equals(sStatus) || "03"==sStatus) && ("01".equals(sApproveSubmitStatus) || "01"==sApproveSubmitStatus)){
			//当是审批通过的时候  新建一条待处理（领取的信息）
			//插入一条操作数据
			String sDOSerialNo1 = DBKeyHelp.getSerialNo("DOC_operation","SerialNo",""); 
				
			sInsertSql = "insert into doc_operation do (do.serialno,do.objecttype,do.objectno,do.transactioncode," + 
								" do.operateuserid,do.operatedate,do.inputuserid,do.status,do.operatedescription) " + 
								" values(:SerialNo,:ObjectType,:ObjectNo,:TransactionCode ,:OperateUserId,:OperateDate,:InputUserId,:OperationStatus,:OperationDescription) "; 
			so = new SqlObject(sInsertSql);
			so.setParameter("SerialNo", sDOSerialNo1);
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("TransactionCode", "0070");
			so.setParameter("OperateUserId", CurUser.getUserID());
			so.setParameter("OperateDate", StringFunction.getToday());
			so.setParameter("InputUserId", CurUser.getUserID());
			so.setParameter("OperationStatus", "01");
			so.setParameter("OperationDescription", "");
			Sqlca.executeSQL(so);

			//查询当前阶段的关联关系
			sSelSql = "select serialno,operationserialno,fileserialno,operatememo from doc_operation_file dof where dof.operationserialno=:DOSerialNo ";
			so = new SqlObject(sSelSql);
			so.setParameter("DOSerialNo", sDOSerialNo);
			//Sqlca.executeSQL(so);
			rs = Sqlca.getASResultSet(so);
			while(rs.next()){
				try{
					///复制关联关系 doc_operation_File 到下一个阶段
					String sDOFSerialNo = DBKeyHelp.getSerialNo("doc_operation_file","SerialNo",""); 
					sInsertSql = "insert into doc_operation_file DOF (DOF.SERIALNO,DOF.OPERATIONSERIALNO,DOF.FILESERIALNO,DOF.OPERATEMEMO) "+
							" VALUES(:SerialNo,:OperationSerialNo,:FileSerialNo,:OperateMemo)";
					so = new SqlObject(sInsertSql);
					so.setParameter("SerialNo", sDOFSerialNo);
					so.setParameter("OperationSerialNo",sDOSerialNo1);//下一阶段的 操作流水号
					so.setParameter("FileSerialNo", rs.getString("fileserialno"));
					so.setParameter("OperateMemo", rs.getString("operatememo"));
					//插入一条操作数据
					Sqlca.executeSQL(so);
				}catch(Exception e){
					rs.getStatement().close();
					e.fillInStackTrace();
					sReturnValue="false";
				}
			}
			rs.getStatement().close();
			//更新 关联的dfi为借出
			sUpdateSql = "update doc_file_info dfi set dfi.status='04' where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:DOSerialNo )";
			so = new SqlObject(sUpdateSql);
			so.setParameter("DOSerialNo", sDOSerialNo);
			Sqlca.executeSQL(so);
			//更新dfp为已出库 或 部分出库
			sUpdateSql = "update doc_file_package dfp set dfp.status=:Status ,dfp.updatedate=:UpdateDate where  dfp.packagetype='02' and dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo ";
			so = new SqlObject(sUpdateSql);
			so.setParameter("Status", "04");//已出库
			so.setParameter("UpdateDate", StringFunction.getToday());
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			Sqlca.executeSQL(so);
			
		}
		
		sUpdateSql = "update doc_operation do set do.status=:Status where do.serialno=:SerialNo";
		so = new SqlObject(sUpdateSql);
		so.setParameter("Status", sNextStatus);
		so.setParameter("SerialNo", sDOSerialNo);
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