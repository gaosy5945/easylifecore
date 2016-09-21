package com.amarsoft.app.als.formatdoc.financialreportdoc;

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
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 资产负债表（旧会计准则）
 * @author Administrator
 *
 */
public class CR_0701 extends FormatDocData implements Serializable {
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
    private DocExtClass extobj48;
    private DocExtClass extobj49;
    private DocExtClass extobj50;
    private DocExtClass extobj51;
    private DocExtClass extobj52;
    private DocExtClass extobj53;
    private DocExtClass extobj54;
    private DocExtClass extobj55;
    private DocExtClass extobj56;
    private DocExtClass extobj57;
    private DocExtClass extobj58;
    private DocExtClass extobj59;
    private DocExtClass extobj60;
    private DocExtClass extobj61;
    private DocExtClass extobj62;
    private DocExtClass extobj63;
    private DocExtClass extobj64;
    private DocExtClass extobj65;
    private DocExtClass extobj66;
    private DocExtClass extobj67;
    private DocExtClass extobj68;
    private DocExtClass extobj69;
    private DocExtClass extobj70;
    private DocExtClass extobj71;
    private DocExtClass extobj72;
    private DocExtClass extobj73;
    private DocExtClass extobj74;
    private DocExtClass extobj75;
    private DocExtClass extobj76;

    private String opinion1="";

	public CR_0701() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_0701.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
		String reprotType = "";
	
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
			extobj48 = new DocExtClass();
			extobj49 = new DocExtClass();
			extobj50 = new DocExtClass();
			extobj51 = new DocExtClass();
			extobj52 = new DocExtClass();
			extobj53 = new DocExtClass();
			extobj54 = new DocExtClass();
			extobj55 = new DocExtClass();
			extobj56 = new DocExtClass();
			extobj57 = new DocExtClass();
			extobj58 = new DocExtClass();
			extobj59 = new DocExtClass();
			extobj60 = new DocExtClass();
			extobj61 = new DocExtClass();
			extobj62 = new DocExtClass();
			extobj63 = new DocExtClass();
			extobj64 = new DocExtClass();
			extobj65 = new DocExtClass();
			extobj66 = new DocExtClass();
			extobj67 = new DocExtClass();
			extobj68 = new DocExtClass();
			extobj69 = new DocExtClass();
			extobj70 = new DocExtClass();
			extobj71 = new DocExtClass();
			extobj72 = new DocExtClass();
			extobj73 = new DocExtClass();
			extobj74 = new DocExtClass();
			extobj75 = new DocExtClass();
			extobj76 = new DocExtClass();
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				ReportSubject rs = null;
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);//本期
				if(cfs != null ){
					reprotType = cfs.getFinanceBelong();
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = null;
					//financedata.getAssetMap(cfs);
					reportMap=financedata.getAllSubject(cfs);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("101");//货币资金
						if(rs!=null){
							extobj1.setAttr1(rs.getCol2IntString());
						}
//						extobj1.setAttr1(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("102");//短期投资
						if(rs!=null){
							extobj2.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("104");//减：短期投资跌价准备
						if(rs!=null){
							extobj3.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("106");//短期投资净额
						if(rs!=null){
							extobj4.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("105");//应收票据
						if(rs!=null){
							extobj5.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("113");//应收股利
						if(rs!=null){
							extobj6.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("111");//应收利息
						if(rs!=null){
							extobj7.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("107");//应收账款
						if(rs!=null){
							extobj8.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("108");//减：坏账准备
						if(rs!=null){
							extobj9.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("112");//应收账款净额
						if(rs!=null){
							extobj10.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("115");//其他应收款
						if(rs!=null){
							extobj11.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("109");//预付账款
						if(rs!=null){
							extobj12.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("110");//应收补贴款
						if(rs!=null){
							extobj13.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("117");//存货
						if(rs!=null){
							extobj14.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("118");//减：存货跌价准备
						if(rs!=null){
							extobj15.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("116");//存货净额
						if(rs!=null){
							extobj16.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("120");//待摊费用
						if(rs!=null){
							extobj17.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("122");//待处理流动资产净损失
						if(rs!=null){
							extobj18.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("114");//一年内到期的长期流动资产净损失
						if(rs!=null){
							extobj19.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("121");//其他流动资产
						if(rs!=null){
							extobj20.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("123");//流动资产合计
						if(rs!=null){
							extobj21.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("133");//长期股权投资
						if(rs!=null){
							extobj22.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("134");//长期债权投资
						if(rs!=null){
							extobj23.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("136");//减：长期投资减值准备(包括股权、债权、减值准备)
						if(rs!=null){
							extobj24.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("138");//长期投资净额
						if(rs!=null){
							extobj25.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("140");//其中：合并价差
						if(rs!=null){
							extobj26.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("142");//固定资产原价
						if(rs!=null){
							extobj27.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("144");//减：累计折旧
						if(rs!=null){
							extobj28.setAttr1(rs.getCol2IntString());
						}
						if(cfs.getFinanceBelong().equals(reprotType)){
						rs = (ReportSubject) reportMap.get("146");//固定资产净值
						if(rs!=null){
							extobj29.setAttr1(rs.getCol2IntString());
						}
						}else{
							rs = (ReportSubject) reportMap.get("143");//固定资产净值
							if(rs!=null){
								extobj29.setAttr1(rs.getCol2IntString());
							}
						}
						rs = (ReportSubject) reportMap.get("148");//减：固定资产减值准备
						if(rs!=null){
							extobj30.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("150");//固定资产净额
						if(rs!=null){
							extobj31.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("141");//工程物资
						if(rs!=null){
							extobj32.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("139");//在建工程
						if(rs!=null){
							extobj33.setAttr1(rs.getCol2IntString());
						}
						if(cfs.getFinanceBelong().equals(reprotType)){
						rs = (ReportSubject) reportMap.get("143");//固定资产清理
						if(rs!=null){
							extobj34.setAttr1(rs.getCol2IntString());
						}
						}
						rs = (ReportSubject) reportMap.get("189");//待处理固定资产净损失
						if(rs!=null){
							extobj35.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("154");//固定资产合计
						if(rs!=null){
							extobj36.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("149");//无形资产
						if(rs!=null){
							extobj37.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("190");//开办费
						if(rs!=null){
							extobj38.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("155");//长期待摊费用
						if(rs!=null){
							extobj39.setAttr1(rs.getCol2IntString());
						}
						if(cfs.getFinanceBelong().equals(reprotType)){
						rs = (ReportSubject) reportMap.get("158");//其他长期资产
						if(rs!=null){
							extobj40.setAttr1(rs.getCol2IntString());
						}
						}else{
							rs = (ReportSubject) reportMap.get("159");//其他长期资产
							if(rs!=null){
								extobj40.setAttr1(rs.getCol2IntString());
							}
						}
						if(cfs.getFinanceBelong().equals(reprotType)){
						rs = (ReportSubject) reportMap.get("160");//无形及其他资产合计
						if(rs!=null){
							extobj41.setAttr1(rs.getCol2IntString());
						}
						}else{
							rs = (ReportSubject) reportMap.get("153");//无形及其他资产合计
							if(rs!=null){
								extobj41.setAttr1(rs.getCol2IntString());
							}
						}
						rs = (ReportSubject) reportMap.get("157");//递延税款借项
						if(rs!=null){
							extobj42.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("165");//资产合计
						if(rs!=null){
							extobj43.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("200");//短期借款
						if(rs!=null){
							extobj44.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("204");//应付票据
						if(rs!=null){
							extobj45.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("206");//应付账款
						if(rs!=null){
							extobj46.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("208");//预收账款
						if(rs!=null){
							extobj47.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("209");//代销商品款
						if(rs!=null){
							extobj48.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("210");//应付工资
						if(rs!=null){
							extobj49.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("211");//应付福利费
						if(rs!=null){
							extobj50.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("216");//应付股利
						if(rs!=null){
							extobj51.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("212");//应交税金
						if(rs!=null){
							extobj52.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("223");//其他应交款
						if(rs!=null){
							extobj53.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("218");//其他应付款
						if(rs!=null){
							extobj54.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("219");//预提费用
						if(rs!=null){
							extobj55.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("236");//预计负债
						if(rs!=null){
							extobj56.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("220");//一年内到期的长期负债
						if(rs!=null){
							extobj57.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("222");//其他流动负债
						if(rs!=null){
							extobj58.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("224");//流动负债合计
						if(rs!=null){
							extobj59.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("228");//长期借款
						if(rs!=null){
							extobj60.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("230");//应付债券
						if(rs!=null){
							extobj61.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("232");//长期应付款
						if(rs!=null){
							extobj62.setAttr1(rs.getCol2IntString());
						};
						rs = (ReportSubject) reportMap.get("234");//专项应付款
						if(rs!=null){
							extobj63.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("235");//其他长期负债
						if(rs!=null){
							extobj64.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("237");//长期负债合计
						if(rs!=null){
							extobj65.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("238");//递延税款贷项
						if(rs!=null){
							extobj66.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("246");//负债合计
						if(rs!=null){
							extobj67.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("264");//少数股东权益
						if(rs!=null){
							extobj68.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("250");//实收资本(或股本)净额
						if(rs!=null){
							extobj69.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("252");//资本公积
						if(rs!=null){
							extobj70.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("256");//盈余公积
						if(rs!=null){
							extobj71.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("257");//其中：法定公益金
						if(rs!=null){
							extobj72.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("258");//未分配利润
						if(rs!=null){
							extobj73.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("260");//外币报表折算差额
						if(rs!=null){
							extobj74.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("266");//所有者权益合计
						if(rs!=null){
							extobj75.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("270");//负债和所有者权益合计
						if(rs!=null){
							extobj76.setAttr1(rs.getCol2IntString());
						}
					}
					CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
					if(cfs1 != null) {
						if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
//					extobj0.setAttr2(cfs1.getReportDate());
						double d1;
						Map reportMap1 = null;
						//financedata.getAssetMap(cfs1);
						reportMap1=financedata.getAllSubject(cfs1);
						if(reportMap1.size()>0){
							rs = (ReportSubject) reportMap1.get("101");//货币资金
							if(rs!=null){
								extobj1.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj1.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj1.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("102");//短期投资
							if(rs!=null){
								extobj2.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj2.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj2.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("104");//减：短期投资跌价准备
							if(rs!=null){
								extobj3.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj3.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj3.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("106");//短期投资净额
							if(rs!=null){
								extobj4.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj4.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj4.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("105");//应收票据
							if(rs!=null){
								extobj5.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj5.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj5.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("113");//应收股利
							if(rs!=null){
								extobj6.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj6.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj6.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("111");//应收利息
							if(rs!=null){
								extobj7.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj7.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj7.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("107");//应收账款
							if(rs!=null){
								extobj8.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj8.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj8.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("108");//减：坏账准备
							if(rs!=null){
								extobj9.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj9.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj9.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("112");//应收账款净额
							if(rs!=null){
								extobj10.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj10.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj10.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("115");//其他应收款
							if(rs!=null){
								extobj11.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj11.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj11.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("109");//预付账款
							if(rs!=null){
								extobj12.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj12.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj12.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("110");//应收补贴款
							if(rs!=null){
								extobj13.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj13.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj13.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("117");//存货
							if(rs!=null){
								extobj14.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj14.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj14.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("118");//减：存货跌价准备
							if(rs!=null){
								extobj15.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj15.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj15.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("116");//存货净额
							if(rs!=null){
								extobj16.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj16.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj16.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("120");//待摊费用
							if(rs!=null){
								extobj17.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj17.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj17.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("122");//待处理流动资产净损失
							if(rs!=null){
								extobj18.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj18.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj18.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("114");//一年内到期的长期流动资产净损失
							if(rs!=null){
								extobj19.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj19.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj19.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("121");//其他流动资产
							if(rs!=null){
								extobj20.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj20.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj20.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("123");//流动资产合计
							if(rs!=null){
								extobj21.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj21.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj21.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("133");//长期股权投资
							if(rs!=null){
								extobj22.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj22.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj22.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("134");//长期债权投资
							if(rs!=null){
								extobj23.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj23.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj23.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("136");//减：长期投资减值准备(包括股权、债权、减值准备)
							if(rs!=null){
								extobj24.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj24.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj24.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("138");//长期投资净额
							if(rs!=null){
								extobj25.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj25.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj25.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("140");//其中：合并价差
							if(rs!=null){
								extobj26.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj26.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj26.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj26.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("142");//固定资产原价
							if(rs!=null){
								extobj27.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj27.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj27.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj27.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("144");//减：累计折旧
							if(rs!=null){
								extobj28.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj28.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj28.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj28.setAttr6("");
								}
							}
							if(cfs1.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap1.get("146");//固定资产净值
							if(rs!=null){
								extobj29.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj29.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj29.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj29.setAttr6("");
								}
							}
							}else{
								rs = (ReportSubject) reportMap1.get("143");//固定资产净值
								if(rs!=null){
									extobj29.setAttr2(rs.getCol2IntString());
									if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj29.getAttr1()!=null){
										d1 = (Double.parseDouble(extobj29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
										extobj29.setAttr6(String.format("%.0f",d1*100));
									}else {
										extobj29.setAttr6("");
									}
								}
							}
							rs = (ReportSubject) reportMap1.get("148");//减：固定资产减值准备
							if(rs!=null){
								extobj30.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj30.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj30.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj30.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("150");//固定资产净额
							if(rs!=null){
								extobj31.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj31.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj31.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj31.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("141");//工程物资
							if(rs!=null){
								extobj32.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj32.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj32.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj32.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("139");//在建工程
							if(rs!=null){
								extobj33.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj33.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj33.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj33.setAttr6("");
								}
							}
							if(cfs1.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap1.get("143");//固定资产清理
							if(rs!=null){
								extobj34.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj34.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj34.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj34.setAttr6("");
								}
							}
							}
							rs = (ReportSubject) reportMap1.get("189");//待处理固定资产净损失
							if(rs!=null){
								extobj35.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj35.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj35.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj35.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("154");//固定资产合计
							if(rs!=null){
								extobj36.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj36.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj36.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj36.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("149");//无形资产
							if(rs!=null){
								extobj37.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj37.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj37.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj37.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("190");//开办费
							if(rs!=null){
								extobj38.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj38.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj38.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj38.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("155");//长期待摊费用
							if(rs!=null){
								extobj39.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj39.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj39.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj39.setAttr6("");
								}
							}
							if(cfs1.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap1.get("158");//其他长期资产
							if(rs!=null){
								extobj40.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj40.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj40.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj40.setAttr6("");
								}
							}
							}else{
								rs = (ReportSubject) reportMap1.get("159");//其他长期资产
								if(rs!=null){
									extobj40.setAttr2(rs.getCol2IntString());
									if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj40.getAttr1()!=null){
										d1 = (Double.parseDouble(extobj40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
										extobj40.setAttr6(String.format("%.0f",d1*100));
									}else {
										extobj40.setAttr6("");
									}
								}
							}
							if(cfs1.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap1.get("160");//无形及其他资产合计
							if(rs!=null){
								extobj41.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj41.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj41.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj41.setAttr6("");
								}
							}
							}else{
								rs = (ReportSubject) reportMap1.get("153");//无形及其他资产合计
								if(rs!=null){
									extobj41.setAttr2(rs.getCol2IntString());
									if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj41.getAttr1()!=null){
										d1 = (Double.parseDouble(extobj41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
										extobj41.setAttr6(String.format("%.0f",d1*100));
									}else {
										extobj41.setAttr6("");
									}
								}
							}
							rs = (ReportSubject) reportMap1.get("157");//递延税款借项
							if(rs!=null){
								extobj42.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj42.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj42.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj42.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("165");//资产合计
							if(rs!=null){
								extobj43.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj43.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj43.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj43.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("200");//短期借款
							if(rs!=null){
								extobj44.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj44.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj44.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj44.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("204");//应付票据
							if(rs!=null){
								extobj45.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj45.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj45.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj45.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("206");//应付账款
							if(rs!=null){
								extobj46.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj46.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj46.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj46.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("208");//预收账款
							if(rs!=null){
								extobj47.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj47.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj47.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj47.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("209");//代销商品款
							if(rs!=null){
								extobj48.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj48.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj48.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj48.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj48.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("210");//应付工资
							if(rs!=null){
								extobj49.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj49.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj49.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj49.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj49.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("211");//应付福利费
							if(rs!=null){
								extobj50.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj50.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj50.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj50.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj50.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("216");//应付股利
							if(rs!=null){
								extobj51.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj51.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj51.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj51.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj51.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("212");//应交税金
							if(rs!=null){
								extobj52.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj52.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj52.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj52.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj52.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("223");//其他应交款
							if(rs!=null){
								extobj53.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj53.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj53.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj53.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj53.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("218");
							if(rs!=null){
								extobj54.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj54.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj54.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj54.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj54.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("219");
							if(rs!=null){
								extobj55.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj55.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj55.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj55.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj55.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("236");
							if(rs!=null){
								extobj56.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj56.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj56.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj56.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj56.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("220");
							if(rs!=null){
								extobj57.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj57.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj57.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj57.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj57.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("222");
							if(rs!=null){
								extobj58.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj58.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj58.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj58.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj58.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("224");
							if(rs!=null){
								extobj59.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj59.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj59.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj59.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj59.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("228");
							if(rs!=null){
								extobj60.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj60.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj60.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj60.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj60.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("230");
							if(rs!=null){
								extobj61.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj61.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj61.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj61.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj61.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("232");
							if(rs!=null){
								extobj62.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj62.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj62.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj62.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj62.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("234");
							if(rs!=null){
								extobj63.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj63.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj63.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj63.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj63.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("235");
							if(rs!=null){
								extobj64.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj64.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj64.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj64.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj64.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("237");
							if(rs!=null){
								extobj65.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj65.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj65.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj65.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj65.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("238");
							if(rs!=null){
								extobj66.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj66.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj66.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj66.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj66.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("246");
							if(rs!=null){
								extobj67.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj67.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj67.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj67.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj67.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("264");
							if(rs!=null){
								extobj68.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj68.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj68.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj68.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj68.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("250");
							if(rs!=null){
								extobj69.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj69.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj69.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj69.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj69.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("252");
							if(rs!=null){
								extobj70.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj70.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj70.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj70.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj70.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("256");
							if(rs!=null){
								extobj71.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj71.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj71.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj71.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj71.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("257");
							if(rs!=null){
								extobj72.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj72.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj72.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj72.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj72.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("258");
							if(rs!=null){
								extobj73.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj73.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj73.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj73.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj73.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("260");
							if(rs!=null){
								extobj74.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj74.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj74.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj74.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj74.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("266");
							if(rs!=null){
								extobj75.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj75.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj75.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj75.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj75.setAttr6("");
								}
							}
							rs = (ReportSubject) reportMap1.get("270");
							if(rs!=null){
								extobj76.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj76.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj76.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj76.setAttr6(String.format("%.0f",d1*100));
								}else {
									extobj76.setAttr6("");
								}
							}
						}
					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上年末
					if(cfs2 != null){
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
//					extobj0.setAttr3(cfs2.getReportDate());
						Map reportMap2 =null;
						//financedata.getAssetMap(cfs2);
						reportMap2=financedata.getAllSubject(cfs2);
						if(reportMap2.size()>0){
							rs = (ReportSubject) reportMap2.get("101");
							if(rs!=null){
								extobj1.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("102");
							if(rs!=null){
								extobj2.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("104");//减：短期投资跌价准备
							if(rs!=null){
								extobj3.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("106");//短期投资净额
							if(rs!=null){
								extobj4.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("105");//应收票据
							if(rs!=null){
								extobj5.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("113");//应收股利
							if(rs!=null){
								extobj6.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("111");//应收利息
							if(rs!=null){
								extobj7.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("107");//应收账款
							if(rs!=null){
								extobj8.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("108");//减：坏账准备
							if(rs!=null){
								extobj9.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("112");//应收账款净额
							if(rs!=null){
								extobj10.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("115");//其他应收款
							if(rs!=null){
								extobj11.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("109");//预付账款
							if(rs!=null){
								extobj12.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("110");//应收补贴款
							if(rs!=null){
								extobj13.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("117");//存货
							if(rs!=null){
								extobj14.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("118");//减：存货跌价准备
							if(rs!=null){
								extobj15.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("116");//存货净额
							if(rs!=null){
								extobj16.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("120");//待摊费用
							if(rs!=null){
								extobj17.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("122");//待处理流动资产净损失
							if(rs!=null){
								extobj18.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("114");//一年内到期的长期流动资产净损失
							if(rs!=null){
								extobj19.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("121");//其他流动资产
							if(rs!=null){
								extobj20.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("123");//流动资产合计
							if(rs!=null){
								extobj21.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("133");//长期股权投资
							if(rs!=null){
								extobj22.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("134");//长期债权投资
							if(rs!=null){
								extobj23.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("136");//减：长期投资减值准备(包括股权、债权、减值准备)
							if(rs!=null){
								extobj24.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("138");//长期投资净额
							if(rs!=null){
								extobj25.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("140");//其中：合并价差
							if(rs!=null){
								extobj26.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("142");//固定资产原价
							if(rs!=null){
								extobj27.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("144");//减：累计折旧
							if(rs!=null){
								extobj28.setAttr3(rs.getCol2IntString());
							}
							if(cfs2.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap2.get("146");//固定资产净值
							if(rs!=null){
								extobj29.setAttr3(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap2.get("143");//固定资产净值
								if(rs!=null){
									extobj29.setAttr3(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap2.get("148");//减：固定资产减值准备
							if(rs!=null){
								extobj30.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("150");//固定资产净额
							if(rs!=null){
								extobj31.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("141");//工程物资
							if(rs!=null){
								extobj32.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("139");//在建工程
							if(rs!=null){
								extobj33.setAttr3(rs.getCol2IntString());
							}
							if(cfs2.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap2.get("143");//固定资产清理
							if(rs!=null){
								extobj34.setAttr3(rs.getCol2IntString());
							}
							}
							rs = (ReportSubject) reportMap2.get("189");//待处理固定资产净损失
							if(rs!=null){
								extobj35.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("154");//固定资产合计
							if(rs!=null){
								extobj36.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("149");//无形资产
							if(rs!=null){
								extobj37.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("190");//开办费
							if(rs!=null){
								extobj38.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("155");//长期待摊费用
							if(rs!=null){
								extobj39.setAttr3(rs.getCol2IntString());
							}
							if(cfs2.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap2.get("158");//其他长期资产
							if(rs!=null){
								extobj40.setAttr3(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap2.get("159");//其他长期资产
								if(rs!=null){
									extobj40.setAttr3(rs.getCol2IntString());
								}
							}
							if(cfs2.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap2.get("160");//无形及其他资产合计
							if(rs!=null){
								extobj41.setAttr3(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap2.get("153");//无形及其他资产合计
								if(rs!=null){
									extobj41.setAttr3(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap2.get("157");//递延税款借项
							if(rs!=null){
								extobj42.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("165");//资产合计
							if(rs!=null){
								extobj43.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("200");//短期借款
							if(rs!=null){
								extobj44.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("204");//应付票据
							if(rs!=null){
								extobj45.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("206");//应付账款
							if(rs!=null){
								extobj46.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("208");//预收账款
							if(rs!=null){
								extobj47.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("209");//代销商品款
							if(rs!=null){
								extobj48.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("210");//应付工资
							if(rs!=null){
								extobj49.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("211");//应付福利费
							if(rs!=null){
								extobj50.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("216");//应付股利
							if(rs!=null){
								extobj51.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("212");//应交税金
							if(rs!=null){
								extobj52.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("223");//其他应交款
							if(rs!=null){
								extobj53.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("218");
							if(rs!=null){
								extobj54.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("219");
							if(rs!=null){
								extobj55.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("236");
							if(rs!=null){
								extobj56.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("220");
							if(rs!=null){
								extobj57.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("222");
							if(rs!=null){
								extobj58.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("224");
							if(rs!=null){
								extobj59.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("228");
							if(rs!=null){
								extobj60.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("230");
							if(rs!=null){
								extobj61.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("232");
							if(rs!=null){
								extobj62.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("234");
							if(rs!=null){
								extobj63.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("235");
							if(rs!=null){
								extobj64.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("237");
							if(rs!=null){
								extobj65.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("238");
							if(rs!=null){
								extobj66.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("246");
							if(rs!=null){
								extobj67.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("264");
							if(rs!=null){
								extobj68.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("250");
							if(rs!=null){
								extobj69.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("252");
							if(rs!=null){
								extobj70.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("256");
							if(rs!=null){
								extobj71.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("257");
							if(rs!=null){
								extobj72.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("258");
							if(rs!=null){
								extobj73.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("260");
							if(rs!=null){
								extobj74.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("266");
							if(rs!=null){
								extobj75.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap2.get("270");
							if(rs!=null){
								extobj76.setAttr3(rs.getCol2IntString());
							}
						}
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上两年末
					if(cfs3 != null ){
//					extobj0.setAttr4(cfs3.getReportDate());
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
						Map reportMap3 = null;
						//financedata.getAssetMap(cfs3);
						reportMap3=financedata.getAllSubject(cfs3);
						if(reportMap3.size()>0){
							rs = (ReportSubject) reportMap3.get("101");//货币资金
							if(rs!=null){
								extobj1.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("102");//短期投资
							if(rs!=null){
								extobj2.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("104");//减：短期投资跌价准备
							if(rs!=null){
								extobj3.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("106");//短期投资净额
							if(rs!=null){
								extobj4.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("105");//应收票据
							if(rs!=null){
								extobj5.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("113");//应收股利
							if(rs!=null){
								extobj6.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("111");//应收利息
							if(rs!=null){
								extobj7.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("107");//应收账款
							if(rs!=null){
								extobj8.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("108");//减：坏账准备
							if(rs!=null){
								extobj9.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("112");//应收账款净额
							if(rs!=null){
								extobj10.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("115");//其他应收款
							if(rs!=null){
								extobj11.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("109");//预付账款
							if(rs!=null){
								extobj12.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("110");//应收补贴款
							if(rs!=null){
								extobj13.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("117");//存货
							if(rs!=null){
								extobj14.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("118");//减：存货跌价准备
							if(rs!=null){
								extobj15.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("116");//存货净额
							if(rs!=null){
								extobj16.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("120");//待摊费用
							if(rs!=null){
								extobj17.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("122");//待处理流动资产净损失
							if(rs!=null){
								extobj18.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("114");//一年内到期的长期流动资产净损失
							if(rs!=null){
								extobj19.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("121");//其他流动资产
							if(rs!=null){
								extobj20.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("123");//流动资产合计
							if(rs!=null){
								extobj21.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("133");//长期股权投资
							if(rs!=null){
								extobj22.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("134");//长期债权投资
							if(rs!=null){
								extobj23.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("136");//减：长期投资减值准备(包括股权、债权、减值准备)
							if(rs!=null){
								extobj24.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("138");//长期投资净额
							if(rs!=null){
								extobj25.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("140");//其中：合并价差
							if(rs!=null){
								extobj26.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("142");//固定资产原价
							if(rs!=null){
								extobj27.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("144");//减：累计折旧
							if(rs!=null){
								extobj28.setAttr4(rs.getCol2IntString());
							}
							if(cfs3.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("146");//固定资产净值
							if(rs!=null){
								extobj29.setAttr4(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("143");//固定资产净值
								if(rs!=null){
									extobj29.setAttr4(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap3.get("148");//减：固定资产减值准备
							if(rs!=null){
								extobj30.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("150");//固定资产净额
							if(rs!=null){
								extobj31.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("141");//工程物资
							if(rs!=null){
								extobj32.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("139");//在建工程
							if(rs!=null){
								extobj33.setAttr4(rs.getCol2IntString());
							}
							if(cfs3.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("143");//固定资产清理
							if(rs!=null){
								extobj34.setAttr4(rs.getCol2IntString());
							}
							}
							rs = (ReportSubject) reportMap3.get("189");//待处理固定资产净损失
							if(rs!=null){
								extobj35.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("154");//固定资产合计
							if(rs!=null){
								extobj36.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("149");//无形资产
							if(rs!=null){
								extobj37.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("190");//开办费
							if(rs!=null){
								extobj38.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("155");//长期待摊费用
							if(rs!=null){
								extobj39.setAttr4(rs.getCol2IntString());
							}
							if(cfs3.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("158");//其他长期资产
							if(rs!=null){
								extobj40.setAttr4(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("159");//其他长期资产
								if(rs!=null){
									extobj40.setAttr4(rs.getCol2IntString());
								}
							}
							if(cfs3.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("160");//无形及其他资产合计
							if(rs!=null){
								extobj41.setAttr4(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("153");//无形及其他资产合计
								if(rs!=null){
									extobj41.setAttr4(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap3.get("157");//递延税款借项
							if(rs!=null){
								extobj42.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("165");//资产合计
							if(rs!=null){
								extobj43.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("200");//短期借款
							if(rs!=null){
								extobj44.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("204");//应付票据
							if(rs!=null){
								extobj45.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("206");//应付账款
							if(rs!=null){
								extobj46.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("208");//预收账款
							if(rs!=null){
								extobj47.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("209");//代销商品款
							if(rs!=null){
								extobj48.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("210");//应付工资
							if(rs!=null){
								extobj49.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("211");//应付福利费
							if(rs!=null){
								extobj50.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("216");//应付股利
							if(rs!=null){
								extobj51.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("212");//应交税金
							if(rs!=null){
								extobj52.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("223");//其他应交款
							if(rs!=null){
								extobj53.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("218");
							if(rs!=null){
								extobj54.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("219");
							if(rs!=null){
								extobj55.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("236");
							if(rs!=null){
								extobj56.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("220");
							if(rs!=null){
								extobj57.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("222");
							if(rs!=null){
								extobj58.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("224");
							if(rs!=null){
								extobj59.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("228");
							if(rs!=null){
								extobj60.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("230");
							if(rs!=null){
								extobj61.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("232");
							if(rs!=null){
								extobj62.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("234");
							if(rs!=null){
								extobj63.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("235");
							if(rs!=null){
								extobj64.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("237");
							if(rs!=null){
								extobj65.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("238");
							if(rs!=null){
								extobj66.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("246");
							if(rs!=null){
								extobj67.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("264");
							if(rs!=null){
								extobj68.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("250");
							if(rs!=null){
								extobj69.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("252");
							if(rs!=null){
								extobj70.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("256");
							if(rs!=null){
								extobj71.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("257");
							if(rs!=null){
								extobj72.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("258");
							if(rs!=null){
								extobj73.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("260");
							if(rs!=null){
								extobj74.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("266");
							if(rs!=null){
								extobj75.setAttr4(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("270");
							if(rs!=null){
								extobj76.setAttr4(rs.getCol2IntString());
							}
						}
					}	
					
					CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//上三年末
					if(cfs4 != null ){
//					extobj0.setAttr5(cfs4.getReportDate());
						if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
						Map reportMap3 =null;
						//financedata.getAssetMap(cfs4)
						reportMap3=financedata.getAllSubject(cfs4);
						if(reportMap3.size()>0){
							rs = (ReportSubject) reportMap3.get("101");//货币资金
							if(rs!=null){
								extobj1.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("102");
							if(rs!=null){
								extobj2.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("104");//减：短期投资跌价准备
							if(rs!=null){
								extobj3.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("106");//短期投资净额
							if(rs!=null){
								extobj4.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("105");//应收票据
							if(rs!=null){
								extobj5.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("113");//应收股利
							if(rs!=null){
								extobj6.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("111");//应收利息
							if(rs!=null){
								extobj7.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("107");//应收账款
							if(rs!=null){
								extobj8.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("108");//减：坏账准备
							if(rs!=null){
								extobj9.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("112");//应收账款净额
							if(rs!=null){
								extobj10.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("115");//其他应收款
							if(rs!=null){
								extobj11.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("109");//预付账款
							if(rs!=null){
								extobj12.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("110");//应收补贴款
							if(rs!=null){
								extobj13.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("117");//存货
							if(rs!=null){
								extobj14.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("118");//减：存货跌价准备
							if(rs!=null){
								extobj15.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("116");//存货净额
							if(rs!=null){
								extobj16.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("120");//待摊费用
							if(rs!=null){
								extobj17.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("122");//待处理流动资产净损失
							if(rs!=null){
								extobj18.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("114");//一年内到期的长期流动资产净损失
							if(rs!=null){
								extobj19.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("121");//其他流动资产
							if(rs!=null){
								extobj20.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("123");//流动资产合计
							if(rs!=null){
								extobj21.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("133");//长期股权投资
							if(rs!=null){
								extobj22.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("134");//长期债权投资
							if(rs!=null){
								extobj23.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("136");//减：长期投资减值准备(包括股权、债权、减值准备)
							if(rs!=null){
								extobj24.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("138");//长期投资净额
							if(rs!=null){
								extobj25.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("140");//其中：合并价差
							if(rs!=null){
								extobj26.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("142");//固定资产原价
							if(rs!=null){
								extobj27.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("144");//减：累计折旧
							if(rs!=null){
								extobj28.setAttr5(rs.getCol2IntString());
							}
							if(cfs4.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("146");//固定资产净值
							if(rs!=null){
								extobj29.setAttr5(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("143");//固定资产净值
								if(rs!=null){
									extobj29.setAttr5(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap3.get("148");//减：固定资产减值准备
							if(rs!=null){
								extobj30.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("150");//固定资产净额
							if(rs!=null){
								extobj31.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("141");//工程物资
							if(rs!=null){
								extobj32.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("139");//在建工程
							if(rs!=null){
								extobj33.setAttr5(rs.getCol2IntString());
							}
							if(cfs4.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("143");//固定资产清理
							if(rs!=null){
								extobj34.setAttr5(rs.getCol2IntString());
							}
							}
							rs = (ReportSubject) reportMap3.get("189");//待处理固定资产净损失
							if(rs!=null){
								extobj35.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("154");//固定资产合计
							if(rs!=null){
								extobj36.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("149");//无形资产
							if(rs!=null){
								extobj37.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("190");//开办费
							if(rs!=null){
								extobj38.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("155");//长期待摊费用
							if(rs!=null){
								extobj39.setAttr5(rs.getCol2IntString());
							}
							if(cfs4.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("158");//其他长期资产
							if(rs!=null){
								extobj40.setAttr5(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("159");//其他长期资产
								if(rs!=null){
									extobj40.setAttr5(rs.getCol2IntString());
								}
							}
							if(cfs4.getFinanceBelong().equals(reprotType)){
							rs = (ReportSubject) reportMap3.get("160");//无形及其他资产合计
							if(rs!=null){
								extobj41.setAttr5(rs.getCol2IntString());
							}
							}else{
								rs = (ReportSubject) reportMap3.get("153");//无形及其他资产合计
								if(rs!=null){
									extobj41.setAttr5(rs.getCol2IntString());
								}
							}
							rs = (ReportSubject) reportMap3.get("157");//递延税款借项
							if(rs!=null){
								extobj42.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("165");//资产合计
							if(rs!=null){
								extobj43.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("200");//短期借款
							if(rs!=null){
								extobj44.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("204");//应付票据
							if(rs!=null){
								extobj45.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("206");//应付账款
							if(rs!=null){
								extobj46.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("208");//预收账款
							if(rs!=null){
								extobj47.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("209");//代销商品款
							if(rs!=null){
								extobj48.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("210");//应付工资
							if(rs!=null){
								extobj49.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("211");//应付福利费
							if(rs!=null){
								extobj50.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("216");//应付股利
							if(rs!=null){
								extobj51.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("212");//应交税金
							if(rs!=null){
								extobj52.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("223");//其他应交款
							if(rs!=null){
								extobj53.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("218");
							if(rs!=null){
								extobj54.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("219");
							if(rs!=null){
								extobj55.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("236");
							if(rs!=null){
								extobj56.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("220");
							if(rs!=null){
								extobj57.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("222");
							if(rs!=null){
								extobj58.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("224");
							if(rs!=null){
								extobj59.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("228");
							if(rs!=null){
								extobj60.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("230");
							if(rs!=null){
								extobj61.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("232");
							if(rs!=null){
								extobj62.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("234");
							if(rs!=null){
								extobj63.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("235");
							if(rs!=null){
								extobj64.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("237");
							if(rs!=null){
								extobj65.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("238");
							if(rs!=null){
								extobj66.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("246");
							if(rs!=null){
								extobj67.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("264");
							if(rs!=null){
								extobj68.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("250");
							if(rs!=null){
								extobj69.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("252");
							if(rs!=null){
								extobj70.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("256");
							if(rs!=null){
								extobj71.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("257");
							if(rs!=null){
								extobj72.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("258");
							if(rs!=null){
								extobj73.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("260");
							if(rs!=null){
								extobj74.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("266");
							if(rs!=null){
								extobj75.setAttr5(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap3.get("270");
							if(rs!=null){
								extobj76.setAttr5(rs.getCol2IntString());
							}
						}	
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		// do nothing
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

	public DocExtClass getExtobj48() {
		return extobj48;
	}

	public void setExtobj48(DocExtClass extobj48) {
		this.extobj48 = extobj48;
	}

	public DocExtClass getExtobj49() {
		return extobj49;
	}

	public void setExtobj49(DocExtClass extobj49) {
		this.extobj49 = extobj49;
	}

	public DocExtClass getExtobj50() {
		return extobj50;
	}

	public void setExtobj50(DocExtClass extobj50) {
		this.extobj50 = extobj50;
	}

	public DocExtClass getExtobj51() {
		return extobj51;
	}

	public void setExtobj51(DocExtClass extobj51) {
		this.extobj51 = extobj51;
	}

	public DocExtClass getExtobj52() {
		return extobj52;
	}

	public void setExtobj52(DocExtClass extobj52) {
		this.extobj52 = extobj52;
	}

	public DocExtClass getExtobj53() {
		return extobj53;
	}

	public void setExtobj53(DocExtClass extobj53) {
		this.extobj53 = extobj53;
	}

	public DocExtClass getExtobj54() {
		return extobj54;
	}

	public void setExtobj54(DocExtClass extobj54) {
		this.extobj54 = extobj54;
	}

	public DocExtClass getExtobj55() {
		return extobj55;
	}

	public void setExtobj55(DocExtClass extobj55) {
		this.extobj55 = extobj55;
	}

	public DocExtClass getExtobj56() {
		return extobj56;
	}

	public void setExtobj56(DocExtClass extobj56) {
		this.extobj56 = extobj56;
	}

	public DocExtClass getExtobj57() {
		return extobj57;
	}

	public void setExtobj57(DocExtClass extobj57) {
		this.extobj57 = extobj57;
	}

	public DocExtClass getExtobj58() {
		return extobj58;
	}

	public void setExtobj58(DocExtClass extobj58) {
		this.extobj58 = extobj58;
	}

	public DocExtClass getExtobj59() {
		return extobj59;
	}

	public void setExtobj59(DocExtClass extobj59) {
		this.extobj59 = extobj59;
	}

	public DocExtClass getExtobj60() {
		return extobj60;
	}

	public void setExtobj60(DocExtClass extobj60) {
		this.extobj60 = extobj60;
	}

	public DocExtClass getExtobj61() {
		return extobj61;
	}

	public void setExtobj61(DocExtClass extobj61) {
		this.extobj61 = extobj61;
	}

	public DocExtClass getExtobj62() {
		return extobj62;
	}

	public void setExtobj62(DocExtClass extobj62) {
		this.extobj62 = extobj62;
	}

	public DocExtClass getExtobj63() {
		return extobj63;
	}

	public void setExtobj63(DocExtClass extobj63) {
		this.extobj63 = extobj63;
	}

	public DocExtClass getExtobj64() {
		return extobj64;
	}

	public void setExtobj64(DocExtClass extobj64) {
		this.extobj64 = extobj64;
	}

	public DocExtClass getExtobj65() {
		return extobj65;
	}

	public void setExtobj65(DocExtClass extobj65) {
		this.extobj65 = extobj65;
	}

	public DocExtClass getExtobj66() {
		return extobj66;
	}

	public void setExtobj66(DocExtClass extobj66) {
		this.extobj66 = extobj66;
	}

	public DocExtClass getExtobj67() {
		return extobj67;
	}

	public void setExtobj67(DocExtClass extobj67) {
		this.extobj67 = extobj67;
	}

	public DocExtClass getExtobj68() {
		return extobj68;
	}

	public void setExtobj68(DocExtClass extobj68) {
		this.extobj68 = extobj68;
	}

	public DocExtClass getExtobj69() {
		return extobj69;
	}

	public void setExtobj69(DocExtClass extobj69) {
		this.extobj69 = extobj69;
	}

	public DocExtClass getExtobj70() {
		return extobj70;
	}

	public void setExtobj70(DocExtClass extobj70) {
		this.extobj70 = extobj70;
	}

	public DocExtClass getExtobj71() {
		return extobj71;
	}

	public void setExtobj71(DocExtClass extobj71) {
		this.extobj71 = extobj71;
	}

	public DocExtClass getExtobj72() {
		return extobj72;
	}

	public void setExtobj72(DocExtClass extobj72) {
		this.extobj72 = extobj72;
	}

	public DocExtClass getExtobj73() {
		return extobj73;
	}

	public void setExtobj73(DocExtClass extobj73) {
		this.extobj73 = extobj73;
	}

	public DocExtClass getExtobj74() {
		return extobj74;
	}

	public void setExtobj74(DocExtClass extobj74) {
		this.extobj74 = extobj74;
	}

	public DocExtClass getExtobj75() {
		return extobj75;
	}

	public void setExtobj75(DocExtClass extobj75) {
		this.extobj75 = extobj75;
	}

	public DocExtClass getExtobj76() {
		return extobj76;
	}

	public void setExtobj76(DocExtClass extobj76) {
		this.extobj76 = extobj76;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
	
}
