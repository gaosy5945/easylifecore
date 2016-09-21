<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: 一类业务资料  提交至出库审批阶段的相关操作 
 * Input Param:
 *		   
 *  
 * Output param:
 *		无	
 * History Log: yjhou 2015.02.28 整理
 *
 */
%>
<%!
//出库批复提交,1.更新DFP状态，2.更新DFI状态，3.更新DO状态
public boolean outOfWarehouseSubmit(Transaction Sqlca,String sDFIStatus,String sDFPStatus,String sDOSerialNo,String sDOStatus,String sUserID){
	try{
		updateDFI(Sqlca,sDFIStatus,sDOSerialNo);
		updateDFP(Sqlca,sDFPStatus,sDOSerialNo);
		//updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserID);
		return true;
	}catch(Exception e){
		e.printStackTrace();
		return false;
	}
}
/**
 * 根据DOSerialNo 更新 DFP
 * @return
 */
public boolean updateDFP(Transaction Sqlca,String sDFPStatus,String sDOSerialNo){
	boolean sReturn = false;
	StringBuffer sbSql = new StringBuffer();
	SqlObject so ;
	try{
		sbSql.append(" update doc_file_package dfp set dfp.status=:Status,dfp.lastoperatedate=dfp.updatedate, dfp.updatedate=:UpdateDate where dfp.serialno in(select dfi.packageserialno from doc_file_info dfi,doc_operation_file dof where dof.fileserialno=dfi.serialno and dof.operationserialno=:SerialNo "); 
		so = new SqlObject(sbSql.toString());
		so.setParameter("SerialNo", sDOSerialNo)
		.setParameter("Status", sDFPStatus) //包状态
		.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		Sqlca.executeSQL(so);
		sReturn = true ;
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}

/**
 * 根据DOSerialNo 更新 DFI
 * @return
 */
public boolean updateDFI(Transaction Sqlca,String sDFIStatus,String sDOSerialNo){
	boolean sReturn = false;
	StringBuffer sbSql = new StringBuffer();
	SqlObject so ;
	try{
		sbSql.append(" update doc_file_info dfi set dfi.status=:Status where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:SerialNo "); 
		so = new SqlObject(sbSql.toString());
		so.setParameter("SerialNo", sDOSerialNo)
		.setParameter("Status", sDFIStatus) ;//资料状态
		Sqlca.executeSQL(so);
		sReturn = true ;
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}
 
 /**
  * 在出库申请阶段提交审批时，根据doc_operation的SerialNo将表中的状态更新为 "审批中"
  * 在出库申批阶段审批通过时，根据doc_operation的SerialNo将表中的状态更新为 "已处理"
  * 在出库申批阶段审批退回时，根据doc_operation的SerialNo将表中的状态更新为 "待处理"、操作类型为""
  * @return
  * @param Sqlca
  * @param sDOStatus  操作状态
  * @param sDOSerialNo 申请流水号
  * @param sUserID  操作人
  * @param sDate 操作日期
  */ 
public boolean updateDO(Transaction Sqlca,String sDOStatus,String sDOSerialNo,String sUserID,String sDate,String sApplyType){
	boolean sReturn = false; 
	SqlObject so =null;
	try{   
	    	String sSql ="update doc_operation do set do.status=:Status,do.operateuserid=:OperateUserId,do.operatedate=:OperateDate"+ 
				     " where do.serialno =:SerialNo"; 
			so = new SqlObject(sSql);
			so.setParameter("Status", sDOStatus) //操作状态
			  .setParameter("OperateDate", sDate)//操作日期
			  .setParameter("OperateUserId", sUserID)//操作人
			  .setParameter("SerialNo", sDOSerialNo);//申请流水号 
		
		  //执行操作,若执行成功则返回值为 true 
		  if(Sqlca.executeSQL(so)>0){
			  sReturn = true ;
		  }
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}

%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//获取相关参数
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(sAISerialNo == null) sAISerialNo = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");//出库申请流水号
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sApplyType = CurPage.getParameter("ApplyType");  //阶段类型
	if(sApplyType == null) sApplyType = "";
	
	String sDFPStatus = "";
	String sDFIStatus = "";
	String sDOStatus = ""; //出库状态
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate =  StringFunction.getToday();
	boolean flag = false;
	String sReturnValue = "false";
	try{
		//申请阶段提交申请时
		if("01" == sApplyType || "01".equals(sApplyType)){
			
			sDOStatus = "02";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}//审批阶段
		else  if("02" == sApplyType || "02".equals(sApplyType)){
			/* sDFPStatus = "04";
			sDFIStatus = "04";
			sDOStatus = "03";
			outOfWarehouseSubmit(Sqlca,sDFIStatus,sDFPStatus,sDOSerialNo,sDOStatus,sUserId); */
			sDOStatus = "03";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}//申请审批退回
		else if("03" == sApplyType || "03".equals(sApplyType)){
			sDOStatus = "01";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}
		if(flag==true){
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