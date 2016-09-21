package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.finance.Report;

/**
 * @author �����Ŷ�
 * �����ı���ClassMethod--methodName=��BusinessManage��-className=��InitFinanceReport��
 * */
public class InitFinanceReport{
	//�Զ���ô���Ĳ���ֵ	   
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
		//����ֵת��Ϊ���ַ���
		if(objectNo == null) objectNo = "";
		if(objectType == null)	objectType = "";
		if(reportDate == null)	reportDate = "";
		if(reportScope == null) reportScope = "";
		if(recordNo == null) recordNo = "";
		if(where == null)	where = "";
		if(newReportDate == null)	newReportDate = "";
		if(actionType==null)	actionType = "";	
		where = StringFunction.replace(where,"^","=");
		SqlObject so ;//��������
		String sSql = "";
		if(actionType.equals("AddNew"))
		{
			// ����ָ��MODEL_CATALOG��where��������һ���±���		
			Report.newReports(objectType,objectNo,reportScope,where,reportDate,orgID,userID,Sqlca);
		}else if(actionType.equals("Delete"))
		{
			//ɾ���ñ�����ص���ҵӦ��Ӧ���ʿ���Ϣ��ENT_FOA�ļ�¼
			sSql = " delete from ENT_FOA " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص���ҵ�����Ϣ��ENT_INVENTORY�ļ�¼
			sSql = " delete from ENT_INVENTORY " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			// ɾ���ñ�����صĹ̶��ʲ���Ϣ��ENT_FIXEDASSETS�ļ�¼
			sSql = " delete from ENT_FIXEDASSETS " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص������ʲ���Ϣ��CUSTOMER_IMASSET�ļ�¼
			sSql = " delete from CUSTOMER_IMASSET " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			//ɾ���ñ�����ص���˰��Ϣ��CUSTOMER_TAXPAYING�ļ�¼
			sSql = " delete from CUSTOMER_TAXPAYING " +
			" where CustomerID =:CustomerID "+
			" and RecordNo =:RecordNo ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("RecordNo", recordNo);
			Sqlca.executeSQL(so);
			// ɾ��ָ��������������ڵ�һ������ 
			Report.deleteReports(objectType,objectNo,reportScope,reportDate,Sqlca);	
			sSql = " delete from CUSTOMER_FSRECORD "+
			" where CustomerID =:CustomerID "+
			" and ReportDate =:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql).setParameter("CustomerID", objectNo).setParameter("ReportDate", reportDate).setParameter("ReportScope", reportScope);
			Sqlca.executeSQL(so);
		}else if(actionType.equals("ModifyReportDate"))
		{
			// ����ָ������Ļ���·� 
			sSql = 	" update CUSTOMER_FSRECORD "+
			" set ReportDate=:ReportDateNew "+
			" where CustomerID=:CustomerID "+
			" and ReportDate=:ReportDate "+
			" and ReportScope =:ReportScope ";
			so = new SqlObject(sSql);
			so.setParameter("ReportDateNew", newReportDate).setParameter("CustomerID", objectNo).setParameter("ReportDate", reportDate).setParameter("ReportScope", reportScope);
			Sqlca.executeSQL(so);
			// ����ָ������Ļ���·�
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
