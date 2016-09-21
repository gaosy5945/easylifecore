package com.amarsoft.app.als.formatdoc.financialreportdoc;

import java.io.Serializable;
import java.util.List;
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
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;

/**
 * 财务指标表
 * @author Administrator
 *
 */
public class CR_074 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
	private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
//    private DocExtClass extobj3;
    private DocExtClass extobj4;
//    private DocExtClass extobj5;
    private DocExtClass extobj6;
    private DocExtClass extobj7;
    private DocExtClass extobj8;
    private DocExtClass extobj9;
    private DocExtClass extobj10;
    private DocExtClass extobj11;
    private DocExtClass extobj12;
    private DocExtClass extobj13;
    private DocExtClass extobj14;
    private DocExtClass extobj15;
    private DocExtClass extobj16;
    private DocExtClass extobj17;
    private DocExtClass extobj18;
    private DocExtClass extobj19;
    private DocExtClass extobj20;
    private DocExtClass extobj21;
    private DocExtClass extobj22;
    private DocExtClass extobj23;
    private DocExtClass extobj24;
    private DocExtClass extobj25;
    
    private DocExtClass[] extobj26;
    private String totals="";
    
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";
    private String opinion4="";
    private String opinion5="";
    private String opinion6="";

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_074.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		if("".equals(opinion4))opinion4="";
		if("".equals(opinion5))opinion5="";
		if("".equals(opinion6))opinion6="";
		
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
			
			sCustomerID = getCustomerMsg(sObjectNo);
			extobj0 = new DocExtClass();
			extobj1 = new DocExtClass();
			extobj2 = new DocExtClass();
//			extobj3 = new DocExtClass();
			extobj4 = new DocExtClass();
//			extobj5 = new DocExtClass();
			extobj6 = new DocExtClass();
			extobj7 = new DocExtClass();
			extobj8 = new DocExtClass();
			extobj9 = new DocExtClass();
			extobj10 = new DocExtClass();
			extobj11 = new DocExtClass();
			extobj12 = new DocExtClass();
			extobj13 = new DocExtClass();
			extobj14 = new DocExtClass();
			extobj15 = new DocExtClass();
			extobj16 = new DocExtClass();
			extobj17 = new DocExtClass();
			extobj18 = new DocExtClass();
			extobj19 = new DocExtClass();
			extobj20 = new DocExtClass();
			extobj21 = new DocExtClass();
			extobj22 = new DocExtClass();
			extobj23 = new DocExtClass();
			extobj24 = new DocExtClass();
			extobj25 = new DocExtClass();
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				ReportSubject rs = null;
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);//本期
				if(cfs != null){
//					extobj0.setAttr1(cfs.getReportDate());
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = financedata.getGuideMap(cfs);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("流动比率(倍)");
						extobj1.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("速动比率(倍)");
						extobj2.setAttr1(rs.getCol2ValueString());
//						rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//						extobj3.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("现金比率(倍)");
						extobj4.setAttr1(rs.getCol2ValueString());
//						rs = (ReportSubject) reportMap.get("营运资本");
//						extobj5.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("资产负债率(%)");
						extobj6.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
						extobj7.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
						extobj8.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("产权比率(%)");
						extobj9.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
						extobj10.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
						extobj11.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售毛利率(%)");
						extobj12.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("营业利润率(%)");
						extobj13.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("税前利润率(%)");
						extobj14.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售净利率(%)");
						extobj15.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
						extobj16.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产收益率(%)");
						extobj17.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净资产收益率(%)");
						extobj18.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
						extobj19.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("存货周转率(次)");
						extobj20.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
						extobj21.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净营业周期(天)");
						extobj22.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
						extobj23.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
						extobj24.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产周转率(次)");
						extobj25.setAttr1(rs.getCol2ValueString());
					}
					
					CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
					if(cfs1 != null){
//						extobj0.setAttr2(cfs1.getReportDate());
						if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs1);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("流动比率(倍)");
							extobj1.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("速动比率(倍)");
							extobj2.setAttr2(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//							extobj3.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("现金比率(倍)");
							extobj4.setAttr2(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("营运资本");
//							extobj5.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("资产负债率(%)");
							extobj6.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
							extobj7.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
							extobj8.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("产权比率(%)");
							extobj9.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
							extobj10.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
							extobj11.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售毛利率(%)");
							extobj12.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("营业利润率(%)");
							extobj13.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("税前利润率(%)");
							extobj14.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售净利率(%)");
							extobj15.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
							extobj16.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产收益率(%)");
							extobj17.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净资产收益率(%)");
							extobj18.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
							extobj19.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("存货周转率(次)");
							extobj20.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
							extobj21.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净营业周期(天)");
							extobj22.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
							extobj23.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
							extobj24.setAttr2(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产周转率(次)");
							extobj25.setAttr2(rs.getCol2ValueString());
						}
					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
					if(cfs2 != null){
//						extobj0.setAttr3(cfs2.getReportDate());
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs2);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("流动比率(倍)");
							extobj1.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("速动比率(倍)");
							extobj2.setAttr3(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//							extobj3.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("现金比率(倍)");
							extobj4.setAttr3(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("营运资本");
//							extobj5.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("资产负债率(%)");
							extobj6.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
							extobj7.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
							extobj8.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("产权比率(%)");
							extobj9.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
							extobj10.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
							extobj11.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售毛利率(%)");
							extobj12.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("营业利润率(%)");
							extobj13.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("税前利润率(%)");
							extobj14.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售净利率(%)");
							extobj15.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
							extobj16.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产收益率(%)");
							extobj17.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净资产收益率(%)");
							extobj18.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
							extobj19.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("存货周转率(次)");
							extobj20.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
							extobj21.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净营业周期(天)");
							extobj22.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
							extobj23.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
							extobj24.setAttr3(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产周转率(次)");
							extobj25.setAttr3(rs.getCol2ValueString());
						}
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年末
					if(cfs3 != null){
//						extobj0.setAttr4(cfs3.getReportDate());
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs3);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("流动比率(倍)");
							extobj1.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("速动比率(倍)");
							extobj2.setAttr4(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//							extobj3.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("现金比率(倍)");
							extobj4.setAttr4(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("营运资本");
//							extobj5.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("资产负债率(%)");
							extobj6.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
							extobj7.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
							extobj8.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("产权比率(%)");
							extobj9.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
							extobj10.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
							extobj11.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售毛利率(%)");
							extobj12.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("营业利润率(%)");
							extobj13.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("税前利润率(%)");
							extobj14.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售净利率(%)");
							extobj15.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
							extobj16.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产收益率(%)");
							extobj17.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净资产收益率(%)");
							extobj18.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
							extobj19.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("存货周转率(次)");
							extobj20.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
							extobj21.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净营业周期(天)");
							extobj22.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
							extobj23.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
							extobj24.setAttr4(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产周转率(次)");
							extobj25.setAttr4(rs.getCol2ValueString());
						}
					}
					
					CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年末
					if(cfs4 != null){
//						extobj0.setAttr5(cfs4.getReportDate());
						if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs4);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("流动比率(倍)");
							extobj1.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("速动比率(倍)");
							extobj2.setAttr5(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//							extobj3.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("现金比率(倍)");
							extobj4.setAttr5(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("营运资本");
//							extobj5.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("资产负债率(%)");
							extobj6.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
							extobj7.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
							extobj8.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("产权比率(%)");
							extobj9.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
							extobj10.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
							extobj11.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售毛利率(%)");
							extobj12.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("营业利润率(%)");
							extobj13.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("税前利润率(%)");
							extobj14.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("销售净利率(%)");
							extobj15.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
							extobj16.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产收益率(%)");
							extobj17.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净资产收益率(%)");
							extobj18.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
							extobj19.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("存货周转率(次)");
							extobj20.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
							extobj21.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("净营业周期(天)");
							extobj22.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
							extobj23.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
							extobj24.setAttr5(rs.getCol2ValueString());
							rs = (ReportSubject) reportMap.get("总资产周转率(次)");
							extobj25.setAttr5(rs.getCol2ValueString());
						}
					}
				}
				//纳税情况
				m = JBOFactory.getFactory().getManager("jbo.finasys.TAX_PAY");
				String reportNo = financedata.getDetailNo(cfs);
				q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
				List<BizObject> taxPays = q.getResultList();
				extobj26 = new DocExtClass[taxPays.size()];
				if(taxPays.size()>0){
					for(int i=0;i<taxPays.size();i++){
						BizObject taxPay = taxPays.get(i);
						extobj26[i] = new DocExtClass();
						String taxType = taxPay.getAttribute("TAXTYPE").getString();
						extobj26[i].setAttr0(CodeManager.getItemName("TaxType", taxType));
						String taxBased = taxPay.getAttribute("TAXBASED").getString();
						extobj26[i].setAttr1(CodeManager.getItemName("RateElements", taxBased));
						extobj26[i].setAttr2(taxPay.getAttribute("TAXPAYDATE").getString());
						extobj26[i].setAttr3(taxPay.getAttribute("BAILRATE").getString());
						extobj26[i].setAttr4(DataConvert.toMoney(taxPay.getAttribute("BALANCE").getDouble()));
					}
				}
				//查询合计结果
				q = m.createQuery("select sum(BALANCE) as v.sumBal from o where ReportNo = :reportNo").setParameter("reportNo", reportNo);
				bo = q.getSingleResult();
				if(bo != null){
					totals = DataConvert.toMoney(bo.getAttribute("sumBal").getDouble());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
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

//	public DocExtClass getExtobj3() {
//		return extobj3;
//	}
//
//	public void setExtobj3(DocExtClass extobj3) {
//		this.extobj3 = extobj3;
//	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}

//	public DocExtClass getExtobj5() {
//		return extobj5;
//	}
//
//	public void setExtobj5(DocExtClass extobj5) {
//		this.extobj5 = extobj5;
//	}

	public DocExtClass getExtobj6() {
		return extobj6;
	}

	public void setExtobj6(DocExtClass extobj6) {
		this.extobj6 = extobj6;
	}

	public DocExtClass getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass extobj7) {
		this.extobj7 = extobj7;
	}

	public DocExtClass getExtobj8() {
		return extobj8;
	}

	public void setExtobj8(DocExtClass extobj8) {
		this.extobj8 = extobj8;
	}

	public DocExtClass getExtobj9() {
		return extobj9;
	}

	public void setExtobj9(DocExtClass extobj9) {
		this.extobj9 = extobj9;
	}

	public DocExtClass getExtobj10() {
		return extobj10;
	}

	public void setExtobj10(DocExtClass extobj10) {
		this.extobj10 = extobj10;
	}

	public DocExtClass getExtobj11() {
		return extobj11;
	}

	public void setExtobj11(DocExtClass extobj11) {
		this.extobj11 = extobj11;
	}

	public DocExtClass getExtobj12() {
		return extobj12;
	}

	public void setExtobj12(DocExtClass extobj12) {
		this.extobj12 = extobj12;
	}

	public DocExtClass getExtobj13() {
		return extobj13;
	}

	public void setExtobj13(DocExtClass extobj13) {
		this.extobj13 = extobj13;
	}

	public DocExtClass getExtobj14() {
		return extobj14;
	}

	public void setExtobj14(DocExtClass extobj14) {
		this.extobj14 = extobj14;
	}

	public DocExtClass getExtobj15() {
		return extobj15;
	}

	public void setExtobj15(DocExtClass extobj15) {
		this.extobj15 = extobj15;
	}

	public DocExtClass getExtobj16() {
		return extobj16;
	}

	public void setExtobj16(DocExtClass extobj16) {
		this.extobj16 = extobj16;
	}

	public DocExtClass getExtobj17() {
		return extobj17;
	}

	public void setExtobj17(DocExtClass extobj17) {
		this.extobj17 = extobj17;
	}

	public DocExtClass getExtobj18() {
		return extobj18;
	}

	public void setExtobj18(DocExtClass extobj18) {
		this.extobj18 = extobj18;
	}

	public DocExtClass getExtobj19() {
		return extobj19;
	}

	public void setExtobj19(DocExtClass extobj19) {
		this.extobj19 = extobj19;
	}

	public DocExtClass getExtobj20() {
		return extobj20;
	}

	public void setExtobj20(DocExtClass extobj20) {
		this.extobj20 = extobj20;
	}

	public DocExtClass getExtobj21() {
		return extobj21;
	}

	public void setExtobj21(DocExtClass extobj21) {
		this.extobj21 = extobj21;
	}

	public DocExtClass getExtobj22() {
		return extobj22;
	}

	public void setExtobj22(DocExtClass extobj22) {
		this.extobj22 = extobj22;
	}

	public DocExtClass getExtobj23() {
		return extobj23;
	}

	public void setExtobj23(DocExtClass extobj23) {
		this.extobj23 = extobj23;
	}

	public DocExtClass getExtobj24() {
		return extobj24;
	}

	public void setExtobj24(DocExtClass extobj24) {
		this.extobj24 = extobj24;
	}

	public DocExtClass getExtobj25() {
		return extobj25;
	}

	public void setExtobj25(DocExtClass extobj25) {
		this.extobj25 = extobj25;
	}

	public DocExtClass[] getExtobj26() {
		return extobj26;
	}

	public void setExtobj26(DocExtClass[] extobj26) {
		this.extobj26 = extobj26;
	}

	public String getTotals() {
		return totals;
	}

	public void setTotals(String totals) {
		this.totals = totals;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	public String getOpinion3() {
		return opinion3;
	}

	public void setOpinion3(String opinion3) {
		this.opinion3 = opinion3;
	}

	public String getOpinion4() {
		return opinion4;
	}

	public void setOpinion4(String opinion4) {
		this.opinion4 = opinion4;
	}

	public String getOpinion5() {
		return opinion5;
	}

	public void setOpinion5(String opinion5) {
		this.opinion5 = opinion5;
	}

	public String getOpinion6() {
		return opinion6;
	}

	public void setOpinion6(String opinion6) {
		this.opinion6 = opinion6;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
    
	
}
