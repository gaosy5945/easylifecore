package com.amarsoft.app.als.formatdoc.financialreportdoc;

import java.io.Serializable;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_070 extends FormatDocData implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String reportDate="";//报表期次
	private String reportScope="";//报表口径
	private String financeBelong="";//报表类别
	private String reportCurrency="";//报表币种
	private String nearReportDate="";//最近一期年报期次
	private String auditFlag="";//是否经过审计(审计标志是否是1)
	private String auditOffice="";//审计事务所名称
	private String auditOpchoose="";//年报审计意见
	private String auditOpinion="";//年报审计意见详情
	private String isLianXu="";//提供的三年报表是否前后连续
	private String reportOpinion="";//财务报表注释 
	private String opinion1="";	 
	
	private DocExtClass extobj1;
	
    public CR_070(){
    	
    }
	
	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_070.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		BizObjectManager m=null;
		BizObjectQuery q=null;
		BizObject o=null;
		
		String sCustomerID="";
		
		try{
			
//			m=JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
//			q=m.createQuery("serialNo=:serialNo").setParameter("serialNo",sObjectNo);
//			o=q.getSingleResult();
//			if(o!=null){
//			    sCustomerID=o.getAttribute("customerID").getString();
//			}
            
			sCustomerID = getCustomerMsg(sObjectNo);
			FinanceDataManager fdm=new FinanceDataManager();
			CustomerFSRecord cfsr=fdm.getNewestReport(sCustomerID);
			CustomerFSRecord yearReport = fdm.getNewYearReport(sCustomerID);
			if(cfsr != null){
				reportDate=cfsr.getReportDate();
				reportScope=cfsr.getReportScope();
				financeBelong=CodeManager.getItemName("FinanceBelong",cfsr.getFinanceBelong());
				String sCurrency=cfsr.getReportCurrency();
				reportCurrency=CodeManager.getItemName("Currency", sCurrency);
				if(!StringX.isSpace(yearReport.getAuditOffice())&& !yearReport.getAuditOffice().equals("其他")){
					auditOffice=yearReport.getAuditOffice();
				}else{
					auditOffice = yearReport.getAccountAntOffice();
				}
				auditOpchoose=yearReport.getAuditOpchoose();
				auditOpinion=yearReport.getAuditOpinion();
				reportOpinion=yearReport.getReportOpinion();
				nearReportDate=yearReport.getReportDate();
				isLianXu=fdm.isLianXu(sCustomerID);
				auditFlag = yearReport.getAuditFlag();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
    
	
	public boolean initObjectForEdit() {
		extobj1 = new DocExtClass();
		return true;
	}
	
	private String getCustomerMsg(String sObjectNo){
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String customerID="";
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				customerID=bo.getAttribute("CustomerID").getString();
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
				q = m.createQuery("CustomerID=:customerID").setParameter("customerID", customerID);
				bo = q.getSingleResult();
				if(bo != null){
					String customerType = bo.getAttribute("CustomerType").getString();
					if("0210".equals(customerType)){
						m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
						q = m.createQuery("GroupID=:GroupID").setParameter("GroupID", customerID);
						BizObject bb = q.getSingleResult();
						if(bb != null){
							customerID = bb.getAttribute("FkeyMembercustomerID").getString();
						}
					}
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customerID;
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

	public String getFinanceBelong() {
		return financeBelong;
	}

	public void setFinanceBelong(String financeBelong) {
		this.financeBelong = financeBelong;
	}

	public String getReportCurrency() {
		return reportCurrency;
	}

	public void setReportCurrency(String reportCurrency) {
		this.reportCurrency = reportCurrency;
	}

	public String getNearReportDate() {
		return nearReportDate;
	}

	public void setNearReportDate(String nearReportDate) {
		this.nearReportDate = nearReportDate;
	}

	public String getAuditFlag() {
		return auditFlag;
	}

	public void setAuditFlag(String auditFlag) {
		this.auditFlag = auditFlag;
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

	public String getIsLianXu() {
		return isLianXu;
	}

	public void setIsLianXu(String isLianXu) {
		this.isLianXu = isLianXu;
	}

	public String getReportOpinion() {
		return reportOpinion;
	}

	public void setReportOpinion(String reportOpinion) {
		this.reportOpinion = reportOpinion;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getAuditOpchoose() {
		return auditOpchoose;
	}

	public void setAuditOpchoose(String auditOpchoose) {
		this.auditOpchoose = auditOpchoose;
	}
	
}
