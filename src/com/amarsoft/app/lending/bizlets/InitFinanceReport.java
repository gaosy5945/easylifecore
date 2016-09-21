package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.finance.Report;

/**
 * @author 核算团队
 * 方法改编于ClassMethod--methodName=‘BusinessManage’-className=‘InitFinanceReport’
 * */
public class InitFinanceReport{
	//自动获得传入的参数值	   
	private String objectNo;
	private String objectType;
	private String reportDate;
	private String reportScope;
	private String recordNo;
	private String where;
	private String newReportDate;
	private String actionType;
	private String orgID;
	private String userID;	
	
	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getReportDate() {
		return reportDate;
	}

	public void setReportDate(String reportDate) {
		this.reportDate = reportDate;
	}

	public String getReportScope() {
		return reportScope;
	}

	public void setReportScope(String reportScope) {
		this.reportScope = reportScope;
	}

	public String getRecordNo() {
		return recordNo;
	}

	public void setRecordNo(String recordNo) {
		this.recordNo = recordNo;
	}

	public String getWhere() {
		return where;
	}

	public void setWhere(String where) {
		this.where = where;
	}

	public String getNewReportDate() {
		return newReportDate;
	}

	public void setNewReportDate(String newReportDate) {
		this.newReportDate = newReportDate;
	}

	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public Object initFinanceReport(JBOTransaction tx) throws Exception{
		Transaction Sqlca = Transaction.createTransaction(tx);
		//将空值转化为空字符串
		if(objectNo == null) objectNo = "";
		if(objectType == null)	objectType = "";
		if(reportDate == null)	reportDate = "";
		if(reportScope == null) reportScope = "";
		if(recordNo == null) recordNo = "";
		if(where == null)	where = "";
		if(newReportDate == null)	newReportDate = "";
		if(actionType==null)	actionType = "";	
		where = StringFunction.replace(where,"^","=");
		SqlObject so ;//声明对象
		String sSql = "";
		if(actionType.equals("AddNew"))
		{
			// 根据指定MODEL_CATALOG的where条件增加一批新报表		
			Report.newReports(objectType,objectNo,reportScope,where,reportDate,orgID,userID,Sqlca);
		}else if(actionType.equals("Delete"))
		{
			//删除该报表相关的企业应收应付帐款信息表ENT_FOA的记录
			sSql = " delete from ENT_FOA " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的企业存货信息表ENT_INVENTORY的记录
			sSql = " delete from ENT_INVENTORY " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			// 删除该报表相关的固定资产信息表ENT_FIXEDASSETS的记录
			sSql = " delete from ENT_FIXEDASSETS " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的无形资产信息表CUSTOMER_IMASSET的记录
			sSql = " delete from CUSTOMER_IMASSET " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//删除该报表相关的纳税信息表CUSTOMER_TAXPAYING的记录
			sSql = " delete from CUSTOMER_TAXPAYING " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			// 删除指定关联对象和日期的一批报表 
			Report.deleteReports(objectType,objectNo,reportScope,reportDate,Sqlca);	
			sSql = " delete from CUSTOMER_FSRECORD "+
			" where CustomerID =:CustomerID "+
			" and ReportDate =:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("ReportDate", reportDate).setParameter("ReportScope", reportScope);
			Sqlca.executeSQL(so);
		}else if(actionType.equals("ModifyReportDate"))
		{
			// 更新指定报表的会计月份 
			sSql = 	" update CUSTOMER_FSRECORD "+
			" set ReportDate=:ReportDateNew "+
			" where CustomerID=:CustomerID "+
			" and ReportDate=:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql);
			so.setParameter("ReportDateNew", newReportDate).setParameter("CustomerID", objectNo).setParameter("ReportDate", reportDate).setParameter("ReportScope", reportScope);
			Sqlca.executeSQL(so);
			// 更新指定报表的会计月份
			sSql = " update REPORT_RECORD "+
			" set ReportDate=:ReportDateNew "+
			" where ObjectNo=:ObjectNo "+
			" and ReportDate=:ReportDate"+
			" and ReportScope =:ReportScope ";    	
			so.setParameter("ReportDateNew", newReportDate).setParameter("ObjectNo", objectNo).setParameter("ReportDate", reportDate).setParameter("ReportScope", reportScope);
			Sqlca.executeSQL(so);
		}
				
		return "ok";
	}		
}
