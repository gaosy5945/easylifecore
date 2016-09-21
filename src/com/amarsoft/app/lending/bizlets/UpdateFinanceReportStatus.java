package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class UpdateFinanceReportStatus{
	
	private String customerID;
	private String reportStatus;
	private String reportDate;
	private String reportScope;
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getReportStatus() {
		return reportStatus;
	}

	public void setReportStatus(String reportStatus) {
		this.reportStatus = reportStatus;
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

	public String updateFinanceReportStatus(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FSRECORD");
		tx.join(bom);
		//�Զ���ô���Ĳ���ֵ	  
		String sSql="update O set reportstatus=:reportstatus where CustomerID=:CustomerID and reportdate=:reportdate and reportscope=:reportscope";
		BizObjectQuery boq = bom.createQuery(sSql)
				.setParameter("reportstatus", reportStatus)
				.setParameter("CustomerID", customerID)
				.setParameter("reportdate", reportDate)
				.setParameter("reportscope", reportScope);
		int i = boq.executeUpdate();
		if(i==0) return RunJavaMethodAssistant.SUCCESS_MESSAGE;
		/***************�ڴ˴��������ɲ��񱨱�Ԥ���źų���,begin**************************/
		/***************�ڴ˴��������ɲ��񱨱�Ԥ���źų���,end**************************/
		
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}

}
