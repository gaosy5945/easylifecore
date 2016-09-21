package com.amarsoft.app.als.formatdoc.medicaldoc;

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
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

/**
 * 医疗类客户收支总表
 * @author Administrator
 *
 */
public class MED_072 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
	private String opinion="";
	private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;
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
    
    private String opinion1="";

	public boolean initObjectForRead() {
		ARE.getLog().trace("MED_072.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
	
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				sCustomerID=bo.getAttribute("CustomerID").getString();
			}
			extobj0 = new DocExtClass();
			extobj1 = new DocExtClass();
			extobj2 = new DocExtClass();
			extobj3 = new DocExtClass();
			extobj4 = new DocExtClass();
			extobj5 = new DocExtClass();
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
				String reportType = cfs.getFinanceBelong();
				if(cfs != null){
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = financedata.getLossMap(cfs);
					rs = (ReportSubject) reportMap.get("财政补助收入");
					extobj1.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其中：专项补助");
					extobj2.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("上级补助收入");
					extobj3.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("医疗收入");
					extobj4.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("药品收入");
					extobj5.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他收入");
					extobj6.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("拨入专款");
					extobj7.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("收入合计");
					extobj8.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("医疗支出");
					extobj9.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("药品支出");
					extobj10.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("对附属单位补助");
					extobj11.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("财政专项支出");
					extobj12.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("拨出专款");
					extobj13.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他支出");
					extobj14.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("自筹基建支出");
					extobj15.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("支出合计");
					extobj16.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("收支结余");
					extobj17.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
					extobj18.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
					extobj19.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("结余分配");
					extobj20.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：应缴超收款");
					extobj21.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("加：年初待分配结余");
					extobj22.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
					extobj23.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：转入事业基金");
					extobj24.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("期末待分配结余");
					extobj25.setAttr1(rs.getCol2IntString());
					
					CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
					if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)){
						double d1;
						if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
						reportMap = financedata.getLossMap(cfs1);
						rs = (ReportSubject) reportMap.get("财政补助收入");
						extobj1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj1.setAttr6(String.format("%.2f",d1));
						}else {
							extobj1.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("其中：专项补助");
						extobj2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj2.setAttr6(String.format("%.2f",d1));
						}else {
							extobj2.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("上级补助收入");
						extobj3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj3.setAttr6(String.format("%.2f",d1));
						}else {
							extobj3.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("医疗收入");
						extobj4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj4.setAttr6(String.format("%.2f",d1));
						}else {
							extobj4.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("药品收入");
						extobj5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj5.setAttr6(String.format("%.2f",d1));
						}else {
							extobj5.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("其他收入");
						extobj6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj6.setAttr6(String.format("%.2f",d1));
						}else {
							extobj6.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("拨入专款");
						extobj7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj7.setAttr6(String.format("%.2f",d1));
						}else {
							extobj7.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("收入合计");
						extobj8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj8.setAttr6(String.format("%.2f",d1));
						}else {
							extobj8.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("医疗支出");
						extobj9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj9.setAttr6(String.format("%.2f",d1));
						}else {
							extobj9.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("药品支出");
						extobj10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj10.setAttr6(String.format("%.2f",d1));
						}else {
							extobj10.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("对附属单位补助");
						extobj11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj11.setAttr6(String.format("%.2f",d1));
						}else {
							extobj11.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("财政专项支出");
						extobj12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj12.setAttr6(String.format("%.2f",d1));
						}else {
							extobj12.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("拨出专款");
						extobj13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj13.setAttr6(String.format("%.2f",d1));
						}else {
							extobj13.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("其他支出");
						extobj14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj14.setAttr6(String.format("%.2f",d1));
						}else {
							extobj14.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("自筹基建支出");
						extobj15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj15.setAttr6(String.format("%.2f",d1));
						}else {
							extobj15.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("支出合计");
						extobj16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj16.setAttr6(String.format("%.2f",d1));
						}else {
							extobj16.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("收支结余");
						extobj17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj17.setAttr6(String.format("%.2f",d1));
						}else {
							extobj17.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
						extobj18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj18.setAttr6(String.format("%.2f",d1));
						}else {
							extobj18.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
						extobj19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj19.setAttr6(String.format("%.2f",d1));
						}else {
							extobj19.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("结余分配");
						extobj20.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj20.setAttr6(String.format("%.2f",d1));
						}else {
							extobj20.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("减：应缴超收款");
						extobj21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj21.setAttr6(String.format("%.2f",d1));
						}else {
							extobj21.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("加：年初待分配结余");
						extobj22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj22.setAttr6(String.format("%.2f",d1));
						}else {
							extobj22.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
						extobj23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj23.setAttr6(String.format("%.2f",d1));
						}else {
							extobj23.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("减：转入事业基金");
						extobj24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj24.setAttr6(String.format("%.2f",d1));
						}else {
							extobj24.setAttr6("");
						}
						rs = (ReportSubject) reportMap.get("期末待分配结余");
						extobj25.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj25.setAttr6(String.format("%.2f",d1));
						}else {
							extobj25.setAttr6("");
						}
					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
					if(cfs2 != null&& cfs2.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
						reportMap = financedata.getLossMap(cfs2);
						rs = (ReportSubject) reportMap.get("财政补助收入");
						extobj1.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其中：专项补助");
						extobj2.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("上级补助收入");
						extobj3.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗收入");
						extobj4.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品收入");
						extobj5.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他收入");
						extobj6.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨入专款");
						extobj7.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收入合计");
						extobj8.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗支出");
						extobj9.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品支出");
						extobj10.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("对附属单位补助");
						extobj11.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("财政专项支出");
						extobj12.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨出专款");
						extobj13.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他支出");
						extobj14.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("自筹基建支出");
						extobj15.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("支出合计");
						extobj16.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收支结余");
						extobj17.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
						extobj18.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
						extobj19.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("结余分配");
						extobj20.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：应缴超收款");
						extobj21.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：年初待分配结余");
						extobj22.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
						extobj23.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：转入事业基金");
						extobj24.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("期末待分配结余");
						extobj25.setAttr3(rs.getCol2IntString());
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
					if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
						reportMap = financedata.getLossMap(cfs3);
						rs = (ReportSubject) reportMap.get("财政补助收入");
						extobj1.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其中：专项补助");
						extobj2.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("上级补助收入");
						extobj3.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗收入");
						extobj4.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品收入");
						extobj5.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他收入");
						extobj6.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨入专款");
						extobj7.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收入合计");
						extobj8.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗支出");
						extobj9.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品支出");
						extobj10.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("对附属单位补助");
						extobj11.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("财政专项支出");
						extobj12.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨出专款");
						extobj13.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他支出");
						extobj14.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("自筹基建支出");
						extobj15.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("支出合计");
						extobj16.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收支结余");
						extobj17.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
						extobj18.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
						extobj19.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("结余分配");
						extobj20.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：应缴超收款");
						extobj21.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：年初待分配结余");
						extobj22.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
						extobj23.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：转入事业基金");
						extobj24.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("期末待分配结余");
						extobj25.setAttr4(rs.getCol2IntString());
					}
					
					CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
					if(cfs4 != null&& cfs4.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
						reportMap = financedata.getLossMap(cfs4);
						rs = (ReportSubject) reportMap.get("财政补助收入");
						extobj1.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其中：专项补助");
						extobj2.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("上级补助收入");
						extobj3.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗收入");
						extobj4.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品收入");
						extobj5.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他收入");
						extobj6.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨入专款");
						extobj7.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收入合计");
						extobj8.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("医疗支出");
						extobj9.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("药品支出");
						extobj10.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("对附属单位补助");
						extobj11.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("财政专项支出");
						extobj12.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("拨出专款");
						extobj13.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("其他支出");
						extobj14.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("自筹基建支出");
						extobj15.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("支出合计");
						extobj16.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("收支结余");
						extobj17.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
						extobj18.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
						extobj19.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("结余分配");
						extobj20.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：应缴超收款");
						extobj21.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("加：年初待分配结余");
						extobj22.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
						extobj23.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("减：转入事业基金");
						extobj24.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap.get("期末待分配结余");
						extobj25.setAttr5(rs.getCol2IntString());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		return true;
	}
	
	public String getOpinion() {
		return opinion;
	}

	public void setOpinion(String opinion) {
		this.opinion = opinion;
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

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}

	public DocExtClass getExtobj5() {
		return extobj5;
	}

	public void setExtobj5(DocExtClass extobj5) {
		this.extobj5 = extobj5;
	}

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

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
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

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
    
	
}
