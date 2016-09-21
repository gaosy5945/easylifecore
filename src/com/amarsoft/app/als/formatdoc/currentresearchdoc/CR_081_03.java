package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_081_03 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	private DocExtClass[] extobj1;
    private DocExtClass[] extobj2;
    private DocExtClass[] extobj3;
    private DocExtClass[] extobj4;
    private DocExtClass extobjy1;
    private DocExtClass extobjy2;
    private DocExtClass extobjy3;
    private DocExtClass extobjy4;
    private DocExtClass extobjy5;
    private DocExtClass[] extobjy6;
    private DocExtClass extobjq1;
    private DocExtClass extobjq2;
    private DocExtClass extobjq3;
    private DocExtClass extobjq4;
    private DocExtClass extobjq5;
    private DocExtClass[] extobjq6;
    
    private String totals = "";
    private String totals1 = "";
    private String totals2 = "";
    private String totals3 = "";
    
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";
    private String opinion4="";
    private String opinion5="";
    private String opinion6="";
    private String opinion7="";
    private String opinion8="";
    
    private DocExtClass extobj11;
    private DocExtClass extobj12;
    private DocExtClass extobj13;
    
    private String sFinancelType="";
	
	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	public CR_081_03() {
	}

	public boolean initObjectForRead() {
		extobjy1 = new DocExtClass();
		extobjy2 = new DocExtClass();
		extobjy3 = new DocExtClass();
		extobjy4 = new DocExtClass();
		extobjy5 = new DocExtClass();
		extobjq1 = new DocExtClass();
		extobjq2 = new DocExtClass();
		extobjq3 = new DocExtClass();
		extobjq4 = new DocExtClass();
		extobjq5 = new DocExtClass();
		
		extobj11 = new DocExtClass();
		extobj12 = new DocExtClass();
		extobj13 = new DocExtClass();
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String guarantyNo = this.getGuarantyNo();	
		if(guarantyNo==null)guarantyNo="";
		try {
			if(guarantyNo!=null&& !"".equals(guarantyNo)){
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
				bo = q.getSingleResult();
				if(bo != null){
					customerID = bo.getAttribute("COLASSETOWNER").getString();
				}
			}
			FinanceDataManager fdm=new FinanceDataManager();
			Map reportMap = null;
			if(!StringX.isSpace(customerID)){
				sFinancelType = getReportType(customerID);
				if(sFinancelType.equals("010")||sFinancelType.equals("020")){
					CustomerFSRecord cfsr=fdm.getNewestReport(customerID);//最新一期报表
					String reportNo = fdm.getDetailNo(cfsr);//本期报表编号
					CustomerFSRecord cfsr1 = fdm.getRelativeYearReport(cfsr, -1);
					String lastReportNo = fdm.getDetailNo(cfsr1);//上年年报编号
					if(cfsr != null){
						reportMap = fdm.getAssetIDMap(cfsr);
					}
					//货币资金分析
					double yamount = getMoney(reportNo, "010");
					double lsyamount = getMoney(lastReportNo, "010");
					extobj11.setAttr1(DataConvert.toMoney(yamount));
					extobj12.setAttr1(DataConvert.toMoney(lsyamount));
					extobj13.setAttr1(DataConvert.toMoney(yamount-lsyamount));
					double camount = getMoney(reportNo, "020");
					double lscamount = getMoney(lastReportNo, "020");
					extobj11.setAttr2(DataConvert.toMoney(camount));
					extobj12.setAttr2(DataConvert.toMoney(lscamount));
					extobj13.setAttr2(DataConvert.toMoney(camount-lscamount));
					double oamount = getMoney(reportNo, "030");
					double lsoamount = getMoney(lastReportNo, "030");
					extobj11.setAttr3(DataConvert.toMoney(oamount));
					extobj12.setAttr3(DataConvert.toMoney(lsoamount));
					extobj13.setAttr3(DataConvert.toMoney(oamount-lsoamount));
					extobj11.setAttr4(DataConvert.toMoney(yamount+camount+oamount));
					extobj12.setAttr4(DataConvert.toMoney(lsyamount+lscamount+lsoamount));
					extobj13.setAttr4(DataConvert.toMoney(yamount+camount+oamount-lsyamount-lscamount-lsoamount));
					// 应收帐款分析        总额
					ReportSubject rs = null;
					double yszk = 0;
					double qtyszk = 0;
					double yfzk = 0;
					double cunhuo = 0;
					double gdzc = 0;
					double wxzc = 0;
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("107");
						yszk = rs.getCol2Value();
						rs = (ReportSubject) reportMap.get("115");
						qtyszk = rs.getCol2Value();
						rs = (ReportSubject) reportMap.get("109");
						yfzk = rs.getCol2Value();
						rs = (ReportSubject) reportMap.get("117");
						cunhuo = rs.getCol2Value();
						rs = (ReportSubject) reportMap.get("137");
						if(rs!=null){
							gdzc = rs.getCol2Value();
						}else{
							rs = (ReportSubject) reportMap.get("154");
							gdzc = rs.getCol2Value();
						}
						rs = (ReportSubject) reportMap.get("149");
						wxzc = rs.getCol2Value();
					}
					double jamount = Double.parseDouble(getTotalData(reportNo, "01"));
					double lajamount = Double.parseDouble(getTotalData(lastReportNo, "01"));
					extobjy5.setAttr1(DataConvert.toMoney(jamount));
					extobjy5.setAttr2(DataConvert.toMoney(lajamount));
					extobjy5.setAttr3(DataConvert.toMoney(jamount-lajamount));
					//三个月内
					double mijam = Double.parseDouble(getLastAccountAgeData(reportNo, "010", "01"));
					double lamijam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "010", "01"));
					extobjy1.setAttr1(DataConvert.toMoney(mijam));
					extobjy1.setAttr2(DataConvert.toMoney(lamijam));
					extobjy1.setAttr3(DataConvert.toMoney(mijam-lamijam));
					if(mijam==0||yszk==0) extobjy1.setAttr7("0.00");
					else extobjy1.setAttr7(String.format("%.0f",(mijam/yszk)*100));
					//三个月到一年
					double oneyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "020", "01"));
					double laoyjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "020", "01"));
					extobjy2.setAttr1(DataConvert.toMoney(oneyjam));
					extobjy2.setAttr2(DataConvert.toMoney(laoyjam));
					extobjy2.setAttr3(DataConvert.toMoney(oneyjam-laoyjam));
					if(oneyjam==0||yszk==0) extobjy2.setAttr7("0.00");
					else extobjy2.setAttr7(String.format("%.0f",(oneyjam/yszk)*100));
					//1~3年
					double onethyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "030", "01"));
					double laothyjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "030", "01"));
					extobjy3.setAttr1(DataConvert.toMoney(onethyjam));
					extobjy3.setAttr2(DataConvert.toMoney(laothyjam));
					extobjy3.setAttr3(DataConvert.toMoney(onethyjam-laothyjam));
					if(onethyjam==0||yszk==0) extobjy3.setAttr7("0.00");
					else extobjy3.setAttr7(String.format("%.0f",(onethyjam/yszk)*100));
					//3年以上
					double thyoutjam = Double.parseDouble(getLastAccountAgeData(reportNo, "040", "01"));
					double lathyoutjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "040", "01"));
					extobjy4.setAttr1(DataConvert.toMoney(thyoutjam));
					extobjy4.setAttr2(DataConvert.toMoney(lathyoutjam));
					extobjy4.setAttr3(DataConvert.toMoney(thyoutjam-lathyoutjam));
					if(thyoutjam==0||yszk==0) extobjy4.setAttr7("0.00");
					else extobjy4.setAttr7(String.format("%.0f",(thyoutjam/yszk)*100));
					m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
					q = m.createQuery("REPORTNO=:REPORTNO AND RECEIVETYPE='01' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
					List<BizObject> receives = q.getResultList();
					extobjy6 = new DocExtClass[receives.size()];
					if(receives.size()>0&&receives.size()<=5){
						for(int i=0;i<receives.size();i++){
							BizObject receive = receives.get(i);
							extobjy6[i] = new DocExtClass();
							extobjy6[i].setAttr1(receive.getAttribute("CORPNAME").getString());
							double amount = receive.getAttribute("AMOUNT").getDouble();
							extobjy6[i].setAttr2(DataConvert.toMoney(amount));
							String amountAge = receive.getAttribute("ACCOUNTAGE").getString();
							extobjy6[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
							String lawSuit = receive.getAttribute("LAWSUIT").getString();
							extobjy6[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
							String accountType = receive.getAttribute("ACCOUNTTYPE").getString();
							extobjy6[i].setAttr5(CodeManager.getItemName("FootType",accountType));
							if(yszk==0){
								extobjy6[i].setAttr6("0");
							}else{
								extobjy6[i].setAttr6(String.format("%.0f",(amount/yszk)*100));
							}
							String isRelative = receive.getAttribute("ISRELATIVE").getString();
							extobjy6[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}else if(receives.size()>5){
						extobjy6 = new DocExtClass[5];
						for(int i=0;i<5;i++){
							BizObject receive = receives.get(i);
							extobjy6[i] = new DocExtClass();
							extobjy6[i].setAttr1(receive.getAttribute("CORPNAME").getString());
							double amount = receive.getAttribute("AMOUNT").getDouble();
							extobjy6[i].setAttr2(DataConvert.toMoney(amount));
							String amountAge = receive.getAttribute("ACCOUNTAGE").getString();
							extobjy6[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
							String lawSuit = receive.getAttribute("LAWSUIT").getString();
							extobjy6[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
							String accountType = receive.getAttribute("ACCOUNTTYPE").getString();
							extobjy6[i].setAttr5(CodeManager.getItemName("FootType",accountType));
							if(yszk==0){
								extobjy6[i].setAttr6("0");
							}else{
								extobjy6[i].setAttr6(String.format("%.0f",(amount/yszk)*100));
							}
							String isRelative = receive.getAttribute("ISRELATIVE").getString();
							extobjy6[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}
					//其他应收账款
					double ojamount = Double.parseDouble(getTotalData(reportNo, "02"));
					double olajamount = Double.parseDouble(getTotalData(lastReportNo, "01"));
					extobjq5.setAttr1(DataConvert.toMoney(ojamount));
					extobjq5.setAttr2(DataConvert.toMoney(olajamount));
					extobjq5.setAttr3(DataConvert.toMoney(ojamount-olajamount));
					//三个月内
					double omijam = Double.parseDouble(getLastAccountAgeData(reportNo, "010", "02"));
					double olamijam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "010", "02"));
					extobjq1.setAttr1(DataConvert.toMoney(omijam));
					extobjq1.setAttr2(DataConvert.toMoney(olamijam));
					extobjq1.setAttr3(DataConvert.toMoney(omijam-olamijam));
					if(omijam==0||qtyszk==0) extobjq1.setAttr7("0.00");
					else extobjq1.setAttr7(String.format("%.0f",(omijam/qtyszk)*100));
					//三个月到一年
					double ooneyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "020", "02"));
					double olaoyjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "020", "02"));
					extobjq2.setAttr1(DataConvert.toMoney(ooneyjam));
					extobjq2.setAttr2(DataConvert.toMoney(olaoyjam));
					extobjq2.setAttr3(DataConvert.toMoney(ooneyjam-olaoyjam));
					if(ooneyjam==0||qtyszk==0) extobjq2.setAttr7("0.00");
					else extobjq2.setAttr7(String.format("%.0f",(ooneyjam/qtyszk)*100));
					//1~3年
					double oonethyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "030", "02"));
					double olaothyjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "030", "02"));
					extobjq3.setAttr1(DataConvert.toMoney(oonethyjam));
					extobjq3.setAttr2(DataConvert.toMoney(olaothyjam));
					extobjq3.setAttr3(DataConvert.toMoney(oonethyjam-olaothyjam));
					if(oonethyjam==0||qtyszk==0) extobjq3.setAttr7("0.00");
					else extobjq3.setAttr7(String.format("%.0f",(oonethyjam/qtyszk)*100));
					//3年以上
					double othyoutjam = Double.parseDouble(getLastAccountAgeData(reportNo, "040", "02"));
					double olathyoutjam = Double.parseDouble(getLastAccountAgeData(lastReportNo, "040", "02"));
					extobjq4.setAttr1(DataConvert.toMoney(othyoutjam));
					extobjq4.setAttr2(DataConvert.toMoney(olathyoutjam));
					extobjq4.setAttr3(DataConvert.toMoney(othyoutjam-olathyoutjam));
					if(othyoutjam==0||qtyszk==0) extobjq4.setAttr7("0.00");
					else extobjq4.setAttr7(String.format("%.0f",(othyoutjam/qtyszk)*100));
					m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
					q = m.createQuery("REPORTNO=:REPORTNO AND RECEIVETYPE='02' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
					List<BizObject> oreceives = q.getResultList();
					extobjq6 = new DocExtClass[oreceives.size()];
					if(oreceives.size()>0&&oreceives.size()<=5){
						for(int i=0;i<oreceives.size();i++){
							BizObject oreceive = oreceives.get(i);
							extobjq6[i] = new DocExtClass();
							extobjq6[i].setAttr1(oreceive.getAttribute("CORPNAME").getString());
							double amount = oreceive.getAttribute("AMOUNT").getDouble();
							extobjq6[i].setAttr2(DataConvert.toMoney(amount));
							String amountAge = oreceive.getAttribute("ACCOUNTAGE").getString();
							extobjq6[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
							String lawSuit = oreceive.getAttribute("LAWSUIT").getString();
							extobjq6[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
							String accountType = oreceive.getAttribute("ACCOUNTTYPE").getString();
							extobjq6[i].setAttr5(CodeManager.getItemName("FootType",accountType));
							if(qtyszk==0){
								extobjq6[i].setAttr6("0");
							}else{
								extobjq6[i].setAttr6(String.format("%.0f",(amount/qtyszk)*100));
							}
							String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
							extobjq6[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}else if(oreceives.size()>5){
						extobjq6 = new DocExtClass[5];
						for(int i=0;i<5;i++){
							BizObject oreceive = oreceives.get(i);
							extobjq6[i] = new DocExtClass();
							extobjq6[i].setAttr1(oreceive.getAttribute("CORPNAME").getString());
							double amount = oreceive.getAttribute("AMOUNT").getDouble();
							extobjq6[i].setAttr2(DataConvert.toMoney(amount));
							String amountAge = oreceive.getAttribute("ACCOUNTAGE").getString();
							extobjq6[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
							String lawSuit = oreceive.getAttribute("LAWSUIT").getString();
							extobjq6[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
							String accountType = oreceive.getAttribute("ACCOUNTTYPE").getString();
							extobjq6[i].setAttr5(CodeManager.getItemName("FootType",accountType));
							if(qtyszk==0){
								extobjq6[i].setAttr6("0");
							}else{
								extobjq6[i].setAttr6(String.format("%.0f",(amount/qtyszk)*100));
							}
							String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
							extobjq6[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}
					
					//预付帐款分析
					m = JBOFactory.getFactory().getManager("jbo.finasys.ACCOUNT_PREPAID");
					q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
					List<BizObject> list = q.getResultList();
					extobj1 = new DocExtClass[list.size()];
					double tota=0;
					if(list.size()>0){
						for(int i=0;i<list.size();i++){
							BizObject fdr = list.get(i);
							extobj1[i]=new DocExtClass();
							extobj1[i].setAttr1(fdr.getAttribute("CORPNAME").getString());
							extobj1[i].setAttr2(fdr.getAttribute("AMOUNT").getString());
							tota+=fdr.getAttribute("AMOUNT").getDouble();
							if(yfzk==0){
							extobj1[i].setAttr3("0");
							}else{
							extobj1[i].setAttr3(String.format("%.0f",(fdr.getAttribute("AMOUNT").getDouble()/yfzk)*100));
							}
							String isRelative = fdr.getAttribute("ISRELATIVE").getString();
							extobj1[i].setAttr4(CodeManager.getItemName("YesNo", isRelative));
						}
					}
					totals = DataConvert.toMoney(tota);
					//存货分析
					m = JBOFactory.getFactory().getManager("jbo.finasys.INVENTORY_INFO");
					q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
					List<BizObject> rcvList = q.getResultList();
					extobj2 = new DocExtClass[rcvList.size()];
					double tota1 = 0;
					if(rcvList.size()>0){
						for(int i=0;i<rcvList.size();i++){
							BizObject rcvbo = rcvList.get(i);
							extobj2[i]=new DocExtClass();
							String invType = rcvbo.getAttribute("INVENTORYTYPE").getString();
							extobj2[i].setAttr0(CodeManager.getItemName("InventoryType",invType));
							extobj2[i].setAttr1(rcvbo.getAttribute("INVENTORYNAME").getString());
							double rcvAmount = rcvbo.getAttribute("AMOUNT").getDouble();
							extobj2[i].setAttr3(DataConvert.toMoney(rcvAmount));
							tota1 = rcvAmount + tota1;
							if(cunhuo==0){
								extobj2[i].setAttr2("0");
							}else{
								extobj2[i].setAttr2(String.format("%.0f",(rcvAmount/cunhuo)*100));
							}
							String isNormal = rcvbo.getAttribute("IsNormal").getString();
							extobj2[i].setAttr4(CodeManager.getItemName("YesNo", isNormal));
						}
					}
					totals1 = DataConvert.toMoney(tota1);
					//固定资产分析
					m = JBOFactory.getFactory().getManager("jbo.finasys.FIXED_ASSETS");
					q = m.createQuery("select sum(ACCOUNTVALUE) as v.total2 from o where ReportNo = :reportNo").setParameter("reportNo", reportNo);
					bo = q.getSingleResult();
					double total2 = bo.getAttribute("total2").getDouble();
					totals2 = DataConvert.toMoney(total2);
					q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
					List<BizObject> assets = q.getResultList();
					extobj3 = new DocExtClass[assets.size()];
					if(assets.size()>0){
						for(int i=0;i<assets.size();i++){
							extobj3[i] = new DocExtClass();
							BizObject asset = assets.get(i);
							extobj3[i].setAttr0(asset.getAttribute("ASSETNAME").getString());
							String assetType = asset.getAttribute("ASSETTYPE").getString();
							extobj3[i].setAttr1(CodeManager.getItemName("FixedAssetType", assetType));
							double cc=asset.getAttribute("ACCOUNTVALUE").getDouble();
							extobj3[i].setAttr2(DataConvert.toMoney(asset.getAttribute("ACCOUNTVALUE").getDouble()));
							double dd = asset.getAttribute("NETVALUE").getDouble();
							if(gdzc==0){
								extobj3[i].setAttr3("0");
							}else{
								extobj3[i].setAttr3(String.format("%.0f",(cc/gdzc)*100));
							}
							extobj3[i].setAttr4(DataConvert.toMoney(dd));
							String depMethod = asset.getAttribute("DEPREMETHOD").getString();
							extobj3[i].setAttr5(CodeManager.getItemName("Depre" +
									"Method", depMethod));
						}
					}
					
					//无形资产分析
					m = JBOFactory.getFactory().getManager("jbo.finasys.INTANGIBLE_ASSETS");
					q = m.createQuery("select sum(ACCOUNTVALUE) as v.total2 from o where ReportNo = :reportNo").setParameter("reportNo", reportNo);
					bo = q.getSingleResult();
					total2 = bo.getAttribute("total2").getDouble();
					totals3 = DataConvert.toMoney(total2);
					q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
					assets = q.getResultList();
					extobj4 = new DocExtClass[assets.size()];
					if(assets.size()>0){
						for(int i=0;i<assets.size();i++){
							extobj4[i] = new DocExtClass();
							BizObject asset = assets.get(i);
							extobj4[i].setAttr0(asset.getAttribute("ASSETNAME").getString());
							String assetType = asset.getAttribute("ASSETTYPE").getString();
							extobj4[i].setAttr1(CodeManager.getItemName("IntanAssetType", assetType));
							extobj4[i].setAttr2(DataConvert.toMoney(asset.getAttribute("ACCOUNTVALUE").getDouble()));
							double dd = asset.getAttribute("ACCOUNTVALUE").getDouble();
							if(wxzc==0){
								extobj4[i].setAttr3("0");
							}else{
								extobj4[i].setAttr3(String.format("%.0f",(dd/wxzc)*100));
							}
							extobj4[i].setAttr4(DataConvert.toMoney(asset.getAttribute("ACCEPTVALUE").getDouble()));
							extobj4[i].setAttr5(asset.getAttribute("REMARK").getString());
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	  public void setModelInputStream()throws Exception{
			try{
				if(sFinancelType.equals("010")){//新会计准则
					ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_03.html");
					this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_03.html");
				}else if(sFinancelType.equals("020")){//旧会计准则
					ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_03.html");
					this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_03.html");
				}else {//if(sFinancelType.equals("300")){//财务简表
					ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/Blank_000.html");
					this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/Blank_000.html");
				}
			}
			catch(Exception e){
				throw new Exception("没有找到模板文件：" + e.toString());
			}
		}
	
	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		opinion5 = " ";
		opinion6 = " ";
		opinion7 = " ";
		opinion8 = " ";
		return true;
	}
	
	//获取报表类型 
	public String getReportType(String CustomerID) throws JBOException{
		String sReturn = "";
		
		FinanceDataManager fdm = new FinanceDataManager();
		CustomerFSRecord cfs = fdm.getNewestReport(CustomerID);
		if(cfs != null){
			sReturn = cfs.getFinanceBelong();
		}else {
			sReturn = "";
		}
		return sReturn;
	}

	//获得应收帐款分析（其他应收帐款分析）年初某个账龄的数据
    private String getLastAccountAgeData(String sReportNo,String sAccountAge,String sReceiveType){
		try{
			BizObjectManager m = null;
			BizObjectQuery q = null;
			BizObject bo = null;
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
			q = m.createQuery("select sum(AMOUNT) as V.jamount from O where reportNo=:reportNo and accountAge=:accountAge and receiveType=:receiveType");
		    q.setParameter("reportNo", sReportNo);
			q.setParameter("accountAge", sAccountAge);
			q.setParameter("receiveType", sReceiveType);
			bo = q.getSingleResult();
			if(bo != null){
				String amount = bo.getAttribute("jamount").getString();
				if(amount==null)amount="0";
				return amount;
			}else{
				return "0";
			}
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
    
  //获得应收帐款分析（其他应收帐款分析）合计的数据
    private String getTotalData(String sReportNo,String sReceiveType){
		try{
			BizObjectManager m = null;
			BizObjectQuery q = null;
			BizObject bo = null;
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
			q = m.createQuery("select sum(AMOUNT) as V.jamount from O where reportNo=:reportNo and receiveType=:receiveType");
		    q.setParameter("reportNo", sReportNo);
		    q.setParameter("receiveType", sReceiveType);
			bo = q.getSingleResult();
			if(bo != null){
				String amount = bo.getAttribute("jamount").getString();
				if(amount==null)amount="0";
				return amount;
			}else{
				return "0";
			}
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
    
    //获取货币资金分析金额
    private double getMoney(String reportNo,String assetType){
    	BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		double amount=0;
		try {
			m = JBOFactory.getFactory().getManager("jbo.finasys.MONETARY_ASSETS");
			q = m.createQuery("select sum(AMOUNT) as V.amount from O where REPORTNO=:REPORTNO and ASSETTYPE=:assetType");
			q.setParameter("REPORTNO", reportNo);
			q.setParameter("assetType", assetType);
			bo = q.getSingleResult();
			amount = bo.getAttribute("amount").getDouble();
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return amount;
    }
    
	public DocExtClass[] getExtobj1() {
		return extobj1;
	}


	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}


	public String getTotals() {
		return totals;
	}


	public void setTotals(String totals) {
		this.totals = totals;
	}


	public DocExtClass[] getExtobj2() {
		return extobj2;
	}


	public void setExtobj2(DocExtClass[] extobj2) {
		this.extobj2 = extobj2;
	}


	public String getTotals1() {
		return totals1;
	}


	public void setTotals1(String totals1) {
		this.totals1 = totals1;
	}


	public DocExtClass[] getExtobj3() {
		return extobj3;
	}


	public void setExtobj3(DocExtClass[] extobj3) {
		this.extobj3 = extobj3;
	}


	public String getTotals2() {
		return totals2;
	}


	public void setTotals2(String totals2) {
		this.totals2 = totals2;
	}


	public DocExtClass[] getExtobj4() {
		return extobj4;
	}


	public void setExtobj4(DocExtClass[] extobj4) {
		this.extobj4 = extobj4;
	}


	public String getTotals3() {
		return totals3;
	}


	public void setTotals3(String totals3) {
		this.totals3 = totals3;
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


	public String getOpinion7() {
		return opinion7;
	}


	public void setOpinion7(String opinion7) {
		this.opinion7 = opinion7;
	}


	public String getOpinion8() {
		return opinion8;
	}


	public void setOpinion8(String opinion8) {
		this.opinion8 = opinion8;
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

	public DocExtClass getExtobjy1() {
		return extobjy1;
	}

	public void setExtobjy1(DocExtClass extobjy1) {
		this.extobjy1 = extobjy1;
	}

	public DocExtClass getExtobjy2() {
		return extobjy2;
	}

	public void setExtobjy2(DocExtClass extobjy2) {
		this.extobjy2 = extobjy2;
	}

	public DocExtClass getExtobjy3() {
		return extobjy3;
	}

	public void setExtobjy3(DocExtClass extobjy3) {
		this.extobjy3 = extobjy3;
	}

	public DocExtClass getExtobjy4() {
		return extobjy4;
	}

	public void setExtobjy4(DocExtClass extobjy4) {
		this.extobjy4 = extobjy4;
	}

	public DocExtClass getExtobjy5() {
		return extobjy5;
	}

	public void setExtobjy5(DocExtClass extobjy5) {
		this.extobjy5 = extobjy5;
	}

	public DocExtClass[] getExtobjy6() {
		return extobjy6;
	}

	public void setExtobjy6(DocExtClass[] extobjy6) {
		this.extobjy6 = extobjy6;
	}

	public DocExtClass getExtobjq1() {
		return extobjq1;
	}

	public void setExtobjq1(DocExtClass extobjq1) {
		this.extobjq1 = extobjq1;
	}

	public DocExtClass getExtobjq2() {
		return extobjq2;
	}

	public void setExtobjq2(DocExtClass extobjq2) {
		this.extobjq2 = extobjq2;
	}

	public DocExtClass getExtobjq3() {
		return extobjq3;
	}

	public void setExtobjq3(DocExtClass extobjq3) {
		this.extobjq3 = extobjq3;
	}

	public DocExtClass getExtobjq4() {
		return extobjq4;
	}

	public void setExtobjq4(DocExtClass extobjq4) {
		this.extobjq4 = extobjq4;
	}

	public DocExtClass getExtobjq5() {
		return extobjq5;
	}

	public void setExtobjq5(DocExtClass extobjq5) {
		this.extobjq5 = extobjq5;
	}

	public DocExtClass[] getExtobjq6() {
		return extobjq6;
	}

	public void setExtobjq6(DocExtClass[] extobjq6) {
		this.extobjq6 = extobjq6;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	} 
}

