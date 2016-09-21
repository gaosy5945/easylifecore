package com.amarsoft.app.als.formatdoc.financialreportdoc;

import java.io.Serializable;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

/**
 * 财务简表
 * @author Administrator
 *
 */
public class LER_040 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    
    private String opinion1="";

	public LER_040() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("LER_040.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
	
		try {
//			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
//			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
//			bo = q.getSingleResult();
//			if(bo != null){
//				sCustomerID=bo.getAttribute("CustomerID").getString();
//			}
			extobj2 = new DocExtClass();
			sCustomerID = getCustomerMsg(sObjectNo);
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				String reportNo = "";
				FinanceDataManager fdm = new FinanceDataManager();
				CustomerFSRecord cfs = fdm.getNewestReport(sCustomerID);
				if(cfs != null){
					reportNo = fdm.getDetailNo(cfs);
					Map simpleMap = fdm.getSimpleMap(cfs);
					ReportSubject rs = null;
					String reportDate = cfs.getReportDate();
					if(!StringX.isSpace(reportDate)){
						extobj2.setAttr10("("+reportDate+")");
					}
					if(simpleMap.size()>0){
//					rs = (ReportSubject) simpleMap.get("贷方发生额（总计）");
//					extobj1.setAttr1(rs.getCol2IntString());
//					rs = (ReportSubject) simpleMap.get("进出口贸易结算量（美元）");
//					extobj1.setAttr2(rs.getCol2IntString());
//					rs = (ReportSubject) simpleMap.get("水费");
//					extobj1.setAttr3(rs.getCol2IntString());
//					rs = (ReportSubject) simpleMap.get("电费");
//					extobj1.setAttr4(rs.getCol2IntString());
//					rs = (ReportSubject) simpleMap.get("纳税金额");
//					extobj1.setAttr5(rs.getCol2IntString());
//					rs = (ReportSubject) simpleMap.get("发票金额");
//					extobj1.setAttr6(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("资产总额");
						extobj2.setAttr1(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("应收账款");
						extobj2.setAttr2(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("存货");
						extobj2.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("固定资产净额");
						extobj2.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("负债总额");
						extobj2.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("销售收入");
						extobj2.setAttr6(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("净利润");
						extobj2.setAttr7(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("净利润率(%)");
						extobj2.setAttr8(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("资产负债率(%)");
						extobj2.setAttr9(rs.getCol2IntString());
						rs = (ReportSubject) simpleMap.get("应收账款周转天数");
						extobj2.setAttr0(rs.getCol2IntString());
					}
				}
				
//				m = JBOFactory.getFactory().getManager("jbo.finasys.OTHERBANK_SETTLE");
//				q = m.createQuery("REPORTNO=:reportNo and BUSINESSTYPE='1'").setParameter("reportNo",reportNo);
//				List<BizObject> settles = q.getResultList();
//				if(settles.size()>0){
//					extobj3 = new DocExtClass[settles.size()];
//					for(int i=0;i<settles.size();i++){
//						BizObject settle = settles.get(i);
//						extobj3[i] = new DocExtClass();
//						extobj3[i].setAttr1(settle.getAttribute("BANKNAME").getString());
//						String businessType = settle.getAttribute("BUSINESSTYPE").getString();
//						extobj3[i].setAttr2(CodeManager.getItemName("SettleType", businessType));
//						String currency = settle.getAttribute("CURRENCY").getString();
//						extobj3[i].setAttr3(CodeManager.getItemName("Currency", currency));
//						extobj3[i].setAttr4(settle.getAttribute("BALANCE").getString());
//					}
//				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		extobj1 = new DocExtClass();
		extobj3 = new DocExtClass();
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
	
	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}
	
}
