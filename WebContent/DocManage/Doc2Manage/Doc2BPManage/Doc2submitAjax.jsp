<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: 业务资料操作 预归档的提交操作。
 				1.新增一条操作信息DO（doc_operation）
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
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//1,额度，2.贷款，3。合作项目
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	String sPosition = CurPage.getParameter("Position");
	if(sPosition == null) sPosition = "";
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate = StringFunction.getToday();
	String sDFPSerialNo = "";
	String sTransactionCode = "";
	String sDFPNextStatus = "";
	String sDFINextStatus = "";

	String sInsertSql = "";
	String sSelSql = "";
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs = null;
	//对应的下一阶段 DO对应的操作阶段
	if("0011".equals(sOperationType) || "0011" == sOperationType){//预归档
		sTransactionCode = "0010";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0010".equals(sOperationType) || "0010" == sOperationType){//入库 只更改当前status
		//sTransactionCode = "0020";
		sDFPNextStatus = "03";
		sDFINextStatus = "03";
	}else	if("0020".equals(sOperationType) || "0020" == sOperationType){//出库申请--出库（含部分出库）
		sTransactionCode = "0070";
		sDFPNextStatus = "03";
		sDFINextStatus = "03";
	}else	if("0030".equals(sOperationType) || "0030" == sOperationType){//出库申请--出借（借用）
		sTransactionCode = "0070";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0040".equals(sOperationType) || "0040" == sOperationType){//归还
		sTransactionCode = "0010";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0050".equals(sOperationType) || "0050" == sOperationType){//销毁
		//sTransactionCode = "0060";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0060".equals(sOperationType) || "0060" == sOperationType){//调阅
		//sTransactionCode = "0070";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0070".equals(sOperationType) || "0070" == sOperationType){//领取
		sTransactionCode = "0040";
		sDFPNextStatus = "04";
		sDFINextStatus = "07";
	}
	
	
	String sReturnValue = "false";
	try{
		
		if("0070".equals(sOperationType) || "0070" == sOperationType){//领取
			sSql = "  update doc_operation do2 set do2.status='04' where serialno=( select do.serialno from doc_operation do where do.objecttype=:ObjectType and do.objectno=:ObjectNo and do.operatedate = (select max(do1.operatedate) from doc_operation do1 where do.objecttype=:ObjectType1 and do.objectno=:ObjectNo1 and do1.transactioncode in('0020','0030') and do1.status='03'))";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("ObjectType1", sObjectType);
			so.setParameter("ObjectNo1", sObjectNo);
			Sqlca.executeSQL(so);//更新出库 的状态：已审批 为 已出库
		}
		String sDO1SerialNo =  "";
		if(!"0011".equals(sOperationType) && "0011" != sOperationType){//预归档
			sDO1SerialNo =  DBKeyHelp.getSerialNo("doc_operation","SerialNo",""); 
			sInsertSql = "insert into doc_operation do "+
					  " (do.serialno,do.taskserialno,do.objecttype,do.objectno,do.transactioncode,do.operatedate,do.operateuserid, do.inputuserid,do.status,do.operatedescription) "+
					  " (select :SerialNo,do1.taskserialno,do1.objecttype,do1.objectno, :TransactionCode, "+
							  " :OperateDate,:OperateUserId, :InputUserId,:Status,do1.operatedescription "+
						" from doc_operation do1 where do1.serialno = :DOSerialNo)";
			so = new SqlObject(sInsertSql);
			so.setParameter("SerialNo", sDO1SerialNo);
			so.setParameter("TransactionCode", sTransactionCode);
			so.setParameter("OperateDate", sDate);
			so.setParameter("OperateUserId", sUserId);
			so.setParameter("InputUserId", sUserId);
			so.setParameter("Status", "01");//待处理
			so.setParameter("DOSerialNo", sDOSerialNo);
			Sqlca.executeSQL(so);//新增 下一阶段 一条操作信息（doc_operation）
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
					so.setParameter("OperationSerialNo",sDO1SerialNo);//下一阶段的 操作流水号
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
			
		}
		
		//更新 关联的dfi为借出
		sSql = "update doc_file_info dfi set dfi.status=:Status where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:DOSerialNo )";
		so = new SqlObject(sSql);
		so.setParameter("Status", sDFINextStatus);
		so.setParameter("DOSerialNo", sDOSerialNo);
		Sqlca.executeSQL(so);
		//更新dfp为已出库 或 部分出库
		sSql = "update doc_file_package dfp set dfp.status=:Status ,dfp.updatedate=:UpdateDate where dfp.packagetype='02' and dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo ";
		so = new SqlObject(sSql);
		so.setParameter("Status", sDFPNextStatus);
		so.setParameter("UpdateDate", StringFunction.getToday());
		so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		so.setParameter("ObjectNo", sObjectNo);
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