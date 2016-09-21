package com.amarsoft.app.als.finance.analyse.model;

import com.amarsoft.are.jbo.BizObject;

public class CustomerFSRecord {
	
	private String customerID = null;                 //�ͻ� ���
	private String recordNo = null;                   //������ˮ
	private String reportDate = null;                 //�����ڴ�
	private String reportScope = null;                //����ھ�
	private String reportPeriod = null;               //��������
	private String auditFlag = null;                  //��Ʊ�ʾ
	private String auditOffice = "";                    //��Ƶ�λ
	private String financeBelong = null;              //�������ͣ����ࣩ
	private String subFinanceBelong = null;           //�������ͣ����ࣩ
	private String reportCurrency = null;             //�������
	private String reportUnit = null;                 //����λ
	private String auditOpinion = "";                 //���ѡ��
	private String reportOpinion = "";                //����ע��
	private String auditOpchoose = "";                //������ѡ��
	private String accountAntOffice = null;           //������Ƶ�λ
	
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	public String getRecordNo() {
		return recordNo;
	}
	public void setRecordNo(String recordNo) {
		this.recordNo = recordNo;
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
	public String getReportPeriod() {
		return reportPeriod;
	}
	public void setReportPeriod(String reportPeriod) {
		this.reportPeriod = reportPeriod;
	}
	public String getAuditFlag() {
		return auditFlag;
	}
	public void setAuditFlag(String auditFlag) {
		this.auditFlag = auditFlag;
	}
	public String getFinanceBelong() {
		return financeBelong;
	}
	public void setFinanceBelong(String financeBelong) {
		this.financeBelong = financeBelong;
	}
	public String getSubFinanceBelong() {
		return subFinanceBelong;
	}
	public void setSubFinanceBelong(String subFinanceBelong) {
		this.subFinanceBelong = subFinanceBelong;
	}
	public String getReportCurrency() {
		return reportCurrency;
	}
	public void setReportCurrency(String reportCurrency) {
		this.reportCurrency = reportCurrency;
	}
	public String getReportUnit() {
		return reportUnit;
	}
	public void setReportUnit(String reportUnit) {
		this.reportUnit = reportUnit;
	}
	public String getAuditOffice() {
		return auditOffice;
	}
	public void setAuditOffice(String auditOffice) {
		this.auditOffice = auditOffice;
	}
	public String getAuditOpinion() {
		return auditOpinion;
	}
	public void setAuditOpinion(String auditOpinion) {
		this.auditOpinion = auditOpinion;
	}
	public String getReportOpinion() {
		return reportOpinion;
	}
	public void setReportOpinion(String reportOpinion) {
		this.reportOpinion = reportOpinion;
	}
	
	public void setValue(BizObject o) throws Exception{
		this.setRecordNo(o.getAttribute("RecordNo").getString());
		this.setCustomerID(o.getAttribute("CustomerID").getString());
		this.setReportDate(o.getAttribute("ReportDate").getString());
		this.setReportScope(o.getAttribute("ReportScope").getString());
		this.setReportPeriod(o.getAttribute("ReportPeriod").getString());
		this.setAuditFlag(o.getAttribute("AuditFlag").getString());
		this.setAuditOffice(o.getAttribute("AuditOffice").getString());
		this.setFinanceBelong(o.getAttribute("FinanceBelong").getString());
		this.setSubFinanceBelong(o.getAttribute("SubFinanceBelong").getString());
		this.setAuditOpinion(o.getAttribute("AuditOpinion").getString());
		this.setReportCurrency(o.getAttribute("ReportCurrency").getString());
		this.setReportUnit(o.getAttribute("ReportUnit").getString());
		this.setReportOpinion(o.getAttribute("ReportOpinion").getString());
		this.setAuditOpchoose(o.getAttribute("AuditOpchoose").getString());
		this.setAccountAntOffice(o.getAttribute("AccountAntOffice").getString());
	}
	
	public String getAuditOpchoose() {
		return auditOpchoose;
	}
	
	public void setAuditOpchoose(String auditOpchoose) {
		this.auditOpchoose = auditOpchoose;
	}
	
	public String getAccountAntOffice() {
		return accountAntOffice;
	}
	
	public void setAccountAntOffice(String accountAntOffice) {
		this.accountAntOffice = accountAntOffice;
	}
}
