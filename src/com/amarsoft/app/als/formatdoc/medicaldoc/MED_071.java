package com.amarsoft.app.als.formatdoc.medicaldoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 医疗类客户资产负债表
 * @author Administrator
 *
 */
public class MED_071 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

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
    private DocExtClass extobj26;
    private DocExtClass extobj27;
    private DocExtClass extobj28;
    private DocExtClass extobj29;
    private DocExtClass extobj30;
    private DocExtClass extobj31;
    private DocExtClass extobj32;
    private DocExtClass extobj33;
    private DocExtClass extobj34;
    private DocExtClass extobj35;
    private DocExtClass extobj36;
    private DocExtClass extobj37;
    private DocExtClass extobj38;
    private DocExtClass extobj39;
    private DocExtClass extobj40;
    private DocExtClass extobj41;
    private DocExtClass extobj42;
    private DocExtClass extobj43;
    private DocExtClass extobj44;
    private DocExtClass extobj45;
    private DocExtClass extobj46;
    private DocExtClass extobj47;

    private String opinion1="";

	public MED_071() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("MED_071.initObject()");
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
			extobj26 = new DocExtClass();
			extobj27 = new DocExtClass();
			extobj28 = new DocExtClass();
			extobj29 = new DocExtClass();
			extobj30 = new DocExtClass();
			extobj31 = new DocExtClass();
			extobj32 = new DocExtClass();
			extobj33 = new DocExtClass();
			extobj34 = new DocExtClass();
			extobj35 = new DocExtClass();
			extobj36 = new DocExtClass();
			extobj37 = new DocExtClass();
			extobj38 = new DocExtClass();
			extobj39 = new DocExtClass();
			extobj40 = new DocExtClass();
			extobj41 = new DocExtClass();
			extobj42 = new DocExtClass();
			extobj43 = new DocExtClass();
			extobj44 = new DocExtClass();
			extobj45 = new DocExtClass();
			extobj46 = new DocExtClass();
			extobj47 = new DocExtClass();
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				ReportSubject rs = null;
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);//本期
				String reportType = cfs.getFinanceBelong();
				if(cfs != null){
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = financedata.getAssetMap(cfs);
					rs = (ReportSubject) reportMap.get("现金");
					extobj1.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("银行存款");
					extobj2.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他货币资金");
					extobj3.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("货币资金合计");
					extobj4.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应收在院病人医药费");
					extobj5.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应收医疗款");
					extobj6.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：坏账准备");
					extobj7.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他应收款");
					extobj8.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("药品");
					extobj9.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("减：药品进销差价");
					extobj10.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("库存物资");
					extobj11.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("在加工材料");
					extobj12.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("待摊费用");
					extobj13.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("待处理流动资产净损失");
					extobj14.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("流动资产合计");
					extobj15.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("对外投资");
					extobj16.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("固定资产");
					extobj17.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("在建工程");
					extobj18.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("待处理固定资产净损失");
					extobj19.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("固定资产合计");
					extobj20.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("无形资产");
					extobj21.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("开办费");
					extobj22.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("无形资产及开办费合计");
					extobj23.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("资产合计");
					extobj24.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("短期借款");
					extobj25.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应付账款");
					extobj26.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("预收医疗款");
					extobj27.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应付工资");
					extobj28.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应付社会保障费");
					extobj29.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他应付款");
					extobj30.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("应缴超收款");
					extobj31.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("预提费用");
					extobj32.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("流动负债合计");
					extobj33.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("长期借款");
					extobj34.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("长期应付款");
					extobj35.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("长期负债合计");
					extobj36.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("负债合计");
					extobj37.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("事业基金");
					extobj38.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其中：投资基金");
					extobj39.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其中：一般基金");
					extobj40.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("固定基金");
					extobj41.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("专用基金");
					extobj42.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("财政专项补助结余");
					extobj43.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("待分配结余");
					extobj44.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("其他净资产");
					extobj45.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("净资产合计");
					extobj46.setAttr1(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("负债和净资产合计");
					extobj47.setAttr1(rs.getCol2IntString());
					
					CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
					if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)) {
						double d1;
						if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
						Map reportMap1 = financedata.getAssetMap(cfs1);
						rs = (ReportSubject) reportMap1.get("现金");
						extobj1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj1.setAttr6(String.format("%.2f",d1));
						}else {
							extobj1.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("银行存款");
						extobj2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj2.setAttr6(String.format("%.2f",d1));
						}else {
							extobj2.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其他货币资金");
						extobj3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj3.setAttr6(String.format("%.2f",d1));
						}else {
							extobj3.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("货币资金合计");
						extobj4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj4.setAttr6(String.format("%.2f",d1));
						}else {
							extobj4.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应收在院病人医药费");
						extobj5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj5.setAttr6(String.format("%.2f",d1));
						}else {
							extobj5.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应收医疗款");
						extobj6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj6.setAttr6(String.format("%.2f",d1));
						}else {
							extobj6.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("减：坏账准备");
						extobj7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj7.setAttr6(String.format("%.2f",d1));
						}else {
							extobj7.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其他应收款");
						extobj8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj8.setAttr6(String.format("%.2f",d1));
						}else {
							extobj8.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("药品");
						extobj9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj9.setAttr6(String.format("%.2f",d1));
						}else {
							extobj9.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("减：药品进销差价");
						extobj10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj10.setAttr6(String.format("%.2f",d1));
						}else {
							extobj10.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("库存物资");
						extobj11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj11.setAttr6(String.format("%.2f",d1));
						}else {
							extobj11.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("在加工材料");
						extobj12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj12.setAttr6(String.format("%.2f",d1));
						}else {
							extobj12.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("待摊费用");
						extobj13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj13.setAttr6(String.format("%.2f",d1));
						}else {
							extobj13.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("待处理流动资产净损失");
						extobj14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj14.setAttr6(String.format("%.2f",d1));
						}else {
							extobj14.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("流动资产合计");
						extobj15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj15.setAttr6(String.format("%.2f",d1));
						}else {
							extobj15.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("对外投资");
						extobj16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj16.setAttr6(String.format("%.2f",d1));
						}else {
							extobj16.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("固定资产");
						extobj17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj17.setAttr6(String.format("%.2f",d1));
						}else {
							extobj17.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("在建工程");
						extobj18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj18.setAttr6(String.format("%.2f",d1));
						}else {
							extobj18.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("待处理固定资产净损失");
						extobj19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj19.setAttr6(String.format("%.2f",d1));
						}else {
							extobj19.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("固定资产合计");
						extobj20.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj20.setAttr6(String.format("%.2f",d1));
						}else {
							extobj20.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("无形资产");
						extobj21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj21.setAttr6(String.format("%.2f",d1));
						}else {
							extobj21.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("开办费");
						extobj22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj22.setAttr6(String.format("%.2f",d1));
						}else {
							extobj22.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("无形资产及开办费合计");
						extobj23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj23.setAttr6(String.format("%.2f",d1));
						}else {
							extobj23.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("资产合计");
						extobj24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj24.setAttr6(String.format("%.2f",d1));
						}else {
							extobj24.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("短期借款");
						extobj25.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj25.setAttr6(String.format("%.2f",d1));
						}else {
							extobj25.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应付账款");
						extobj26.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj26.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj26.setAttr6(String.format("%.2f",d1));
						}else {
							extobj26.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("预收医疗款");
						extobj27.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj27.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj27.setAttr6(String.format("%.2f",d1));
						}else {
							extobj27.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应付工资");
						extobj28.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj28.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj28.setAttr6(String.format("%.2f",d1));
						}else {
							extobj28.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应付社会保障费");
						extobj29.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj29.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj29.setAttr6(String.format("%.2f",d1));
						}else {
							extobj29.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其他应付款");
						extobj30.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj30.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj30.setAttr6(String.format("%.2f",d1));
						}else {
							extobj30.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("应缴超收款");
						extobj31.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj31.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj31.setAttr6(String.format("%.2f",d1));
						}else {
							extobj31.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("预提费用");
						extobj32.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj32.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj32.setAttr6(String.format("%.2f",d1));
						}else {
							extobj32.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("流动负债合计");
						extobj33.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj33.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj33.setAttr6(String.format("%.2f",d1));
						}else {
							extobj33.setAttr6("");
						}
						
						rs = (ReportSubject) reportMap1.get("长期借款");
						extobj34.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj34.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj34.setAttr6(String.format("%.2f",d1));
						}else {
							extobj34.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("长期应付款");
						extobj35.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj35.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj35.setAttr6(String.format("%.2f",d1));
						}else {
							extobj35.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("长期负债合计");
						extobj36.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj36.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj36.setAttr6(String.format("%.2f",d1));
						}else {
							extobj36.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("负债合计");
						extobj37.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj37.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj37.setAttr6(String.format("%.2f",d1));
						}else {
							extobj37.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("事业基金");
						extobj38.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj38.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj38.setAttr6(String.format("%.2f",d1));
						}else {
							extobj38.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其中：投资基金");
						extobj39.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj39.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj39.setAttr6(String.format("%.2f",d1));
						}else {
							extobj39.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其中：一般基金");
						extobj40.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj40.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj40.setAttr6(String.format("%.2f",d1));
						}else {
							extobj40.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("固定基金");
						extobj41.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj41.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj41.setAttr6(String.format("%.2f",d1));
						}else {
							extobj41.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("专用基金");
						extobj42.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj42.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj42.setAttr6(String.format("%.2f",d1));
						}else {
							extobj42.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("财政专项补助结余");
						extobj43.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj43.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj43.setAttr6(String.format("%.2f",d1));
						}else {
							extobj43.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("待分配结余");
						extobj44.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj44.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj44.setAttr6(String.format("%.2f",d1));
						}else {
							extobj44.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("其他净资产");
						extobj45.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj45.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj45.setAttr6(String.format("%.2f",d1));
						}else {
							extobj45.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("净资产合计");
						extobj46.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj46.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj46.setAttr6(String.format("%.2f",d1));
						}else {
							extobj46.setAttr6("");
						}
						rs = (ReportSubject) reportMap1.get("负债和净资产合计");
						extobj47.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj47.getAttr1()!=null){
							d1 = (Double.parseDouble(extobj47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobj47.setAttr6(String.format("%.2f",d1));
						}else {
							extobj47.setAttr6("");
						}
					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上年末
					if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
						Map reportMap2 = financedata.getAssetMap(cfs2);
						rs = (ReportSubject) reportMap2.get("现金");
						extobj1.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("银行存款");
						extobj2.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其他货币资金");
						extobj3.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("货币资金合计");
						extobj4.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应收在院病人医药费");
						extobj5.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应收医疗款");
						extobj6.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("减：坏账准备");
						extobj7.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其他应收款");
						extobj8.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("药品");
						extobj9.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("减：药品进销差价");
						extobj10.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("库存物资");
						extobj11.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("在加工材料");
						extobj12.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("待摊费用");
						extobj13.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("待处理流动资产净损失");
						extobj14.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("流动资产合计");
						extobj15.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("对外投资");
						extobj16.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("固定资产");
						extobj17.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("在建工程");
						extobj18.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("待处理固定资产净损失");
						extobj19.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("固定资产合计");
						extobj20.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("无形资产");
						extobj21.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("开办费");
						extobj22.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("无形资产及开办费合计");
						extobj23.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("资产合计");
						extobj24.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("短期借款");
						extobj25.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应付账款");
						extobj26.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("预收医疗款");
						extobj27.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应付工资");
						extobj28.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应付社会保障费");
						extobj29.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其他应付款");
						extobj30.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("应缴超收款");
						extobj31.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("预提费用");
						extobj32.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("流动负债合计");
						extobj33.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("长期借款");
						extobj34.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("长期应付款");
						extobj35.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("长期负债合计");
						extobj36.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("负债合计");
						extobj37.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("事业基金");
						extobj38.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其中：投资基金");
						extobj39.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其中：一般基金");
						extobj40.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("固定基金");
						extobj41.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("专用基金");
						extobj42.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("财政专项补助结余");
						extobj43.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("待分配结余");
						extobj44.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("其他净资产");
						extobj45.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("净资产合计");
						extobj46.setAttr3(rs.getCol2IntString());
						rs = (ReportSubject) reportMap2.get("负债和净资产合计");
						extobj47.setAttr3(rs.getCol2IntString());
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上两年末
					if(cfs3 != null&& cfs3.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
						Map reportMap3 = financedata.getAssetMap(cfs3);
						rs = (ReportSubject) reportMap3.get("现金");
						extobj1.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("银行存款");
						extobj2.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他货币资金");
						extobj3.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("货币资金合计");
						extobj4.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应收在院病人医药费");
						extobj5.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应收医疗款");
						extobj6.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("减：坏账准备");
						extobj7.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他应收款");
						extobj8.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("药品");
						extobj9.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("减：药品进销差价");
						extobj10.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("库存物资");
						extobj11.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("在加工材料");
						extobj12.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待摊费用");
						extobj13.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待处理流动资产净损失");
						extobj14.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("流动资产合计");
						extobj15.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("对外投资");
						extobj16.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定资产");
						extobj17.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("在建工程");
						extobj18.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待处理固定资产净损失");
						extobj19.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定资产合计");
						extobj20.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("无形资产");
						extobj21.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("开办费");
						extobj22.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("无形资产及开办费合计");
						extobj23.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("资产合计");
						extobj24.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("短期借款");
						extobj25.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付账款");
						extobj26.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("预收医疗款");
						extobj27.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付工资");
						extobj28.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付社会保障费");
						extobj29.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他应付款");
						extobj30.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应缴超收款");
						extobj31.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("预提费用");
						extobj32.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("流动负债合计");
						extobj33.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期借款");
						extobj34.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期应付款");
						extobj35.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期负债合计");
						extobj36.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("负债合计");
						extobj37.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("事业基金");
						extobj38.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其中：投资基金");
						extobj39.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其中：一般基金");
						extobj40.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定基金");
						extobj41.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("专用基金");
						extobj42.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("财政专项补助结余");
						extobj43.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待分配结余");
						extobj44.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他净资产");
						extobj45.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("净资产合计");
						extobj46.setAttr4(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("负债和净资产合计");
						extobj47.setAttr4(rs.getCol2IntString());
					}	
					
					CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//上三年末
					if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
						Map reportMap3 = financedata.getAssetMap(cfs4);
						rs = (ReportSubject) reportMap3.get("现金");
						extobj1.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("银行存款");
						extobj2.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他货币资金");
						extobj3.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("货币资金合计");
						extobj4.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应收在院病人医药费");
						extobj5.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应收医疗款");
						extobj6.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("减：坏账准备");
						extobj7.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他应收款");
						extobj8.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("药品");
						extobj9.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("减：药品进销差价");
						extobj10.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("库存物资");
						extobj11.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("在加工材料");
						extobj12.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待摊费用");
						extobj13.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待处理流动资产净损失");
						extobj14.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("流动资产合计");
						extobj15.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("对外投资");
						extobj16.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定资产");
						extobj17.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("在建工程");
						extobj18.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待处理固定资产净损失");
						extobj19.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定资产合计");
						extobj20.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("无形资产");
						extobj21.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("开办费");
						extobj22.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("无形资产及开办费合计");
						extobj23.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("资产合计");
						extobj24.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("短期借款");
						extobj25.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付账款");
						extobj26.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("预收医疗款");
						extobj27.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付工资");
						extobj28.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应付社会保障费");
						extobj29.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他应付款");
						extobj30.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("应缴超收款");
						extobj31.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("预提费用");
						extobj32.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("流动负债合计");
						extobj33.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期借款");
						extobj34.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期应付款");
						extobj35.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("长期负债合计");
						extobj36.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("负债合计");
						extobj37.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("事业基金");
						extobj38.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其中：投资基金");
						extobj39.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其中：一般基金");
						extobj40.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("固定基金");
						extobj41.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("专用基金");
						extobj42.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("财政专项补助结余");
						extobj43.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("待分配结余");
						extobj44.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("其他净资产");
						extobj45.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("净资产合计");
						extobj46.setAttr5(rs.getCol2IntString());
						rs = (ReportSubject) reportMap3.get("负债和净资产合计");
						extobj47.setAttr5(rs.getCol2IntString());
					}	
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		return true;
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

	public DocExtClass getExtobj26() {
		return extobj26;
	}

	public void setExtobj26(DocExtClass extobj26) {
		this.extobj26 = extobj26;
	}

	public DocExtClass getExtobj27() {
		return extobj27;
	}

	public void setExtobj27(DocExtClass extobj27) {
		this.extobj27 = extobj27;
	}

	public DocExtClass getExtobj28() {
		return extobj28;
	}

	public void setExtobj28(DocExtClass extobj28) {
		this.extobj28 = extobj28;
	}

	public DocExtClass getExtobj29() {
		return extobj29;
	}

	public void setExtobj29(DocExtClass extobj29) {
		this.extobj29 = extobj29;
	}

	public DocExtClass getExtobj30() {
		return extobj30;
	}

	public void setExtobj30(DocExtClass extobj30) {
		this.extobj30 = extobj30;
	}

	public DocExtClass getExtobj31() {
		return extobj31;
	}

	public void setExtobj31(DocExtClass extobj31) {
		this.extobj31 = extobj31;
	}

	public DocExtClass getExtobj32() {
		return extobj32;
	}

	public void setExtobj32(DocExtClass extobj32) {
		this.extobj32 = extobj32;
	}

	public DocExtClass getExtobj33() {
		return extobj33;
	}

	public void setExtobj33(DocExtClass extobj33) {
		this.extobj33 = extobj33;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj34() {
		return extobj34;
	}

	public void setExtobj34(DocExtClass extobj34) {
		this.extobj34 = extobj34;
	}

	public DocExtClass getExtobj35() {
		return extobj35;
	}

	public void setExtobj35(DocExtClass extobj35) {
		this.extobj35 = extobj35;
	}

	public DocExtClass getExtobj36() {
		return extobj36;
	}

	public void setExtobj36(DocExtClass extobj36) {
		this.extobj36 = extobj36;
	}

	public DocExtClass getExtobj37() {
		return extobj37;
	}

	public void setExtobj37(DocExtClass extobj37) {
		this.extobj37 = extobj37;
	}

	public DocExtClass getExtobj38() {
		return extobj38;
	}

	public void setExtobj38(DocExtClass extobj38) {
		this.extobj38 = extobj38;
	}

	public DocExtClass getExtobj39() {
		return extobj39;
	}

	public void setExtobj39(DocExtClass extobj39) {
		this.extobj39 = extobj39;
	}

	public DocExtClass getExtobj40() {
		return extobj40;
	}

	public void setExtobj40(DocExtClass extobj40) {
		this.extobj40 = extobj40;
	}

	public DocExtClass getExtobj41() {
		return extobj41;
	}

	public void setExtobj41(DocExtClass extobj41) {
		this.extobj41 = extobj41;
	}

	public DocExtClass getExtobj42() {
		return extobj42;
	}

	public void setExtobj42(DocExtClass extobj42) {
		this.extobj42 = extobj42;
	}

	public DocExtClass getExtobj43() {
		return extobj43;
	}

	public void setExtobj43(DocExtClass extobj43) {
		this.extobj43 = extobj43;
	}

	public DocExtClass getExtobj44() {
		return extobj44;
	}

	public void setExtobj44(DocExtClass extobj44) {
		this.extobj44 = extobj44;
	}

	public DocExtClass getExtobj45() {
		return extobj45;
	}

	public void setExtobj45(DocExtClass extobj45) {
		this.extobj45 = extobj45;
	}

	public DocExtClass getExtobj46() {
		return extobj46;
	}

	public void setExtobj46(DocExtClass extobj46) {
		this.extobj46 = extobj46;
	}

	public DocExtClass getExtobj47() {
		return extobj47;
	}

	public void setExtobj47(DocExtClass extobj47) {
		this.extobj47 = extobj47;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
	
}
