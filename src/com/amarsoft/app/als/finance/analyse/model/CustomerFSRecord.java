package com.amarsoft.app.als.finance.analyse.model;

import com.amarsoft.are.jbo.BizObject;

public class CustomerFSRecord {
	
	private String customerID = null;                 //客户 编号
	private String recordNo = null;                   //报表流水
	private String reportDate = null;                 //报表期次
	private String reportScope = null;                //报表口径
	private String reportPeriod = null;               //报表周期
	private String auditFlag = null;                  //审计标示
	private String auditOffice = "";                    //审计单位
	private String financeBelong = null;              //报表类型（父类）
	private String subFinanceBelong = null;           //报表类型（子类）
	private String reportCurrency = null;             //报表币种
	private String reportUnit = null;                 //报表单位
	private String auditOpinion = "";                 //审计选择
	private String reportOpinion = "";                //报表注释
	private String auditOpchoose = "";                //审计意见选择
	private String accountAntOffice = null;           //其他审计单位
	
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
