package com.amarsoft.app.als.formatdoc.financialreportdoc;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.FinanceDetailManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_0711 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
	private DocExtClass extobj1;
	private DocExtClass extobj2;
	private DocExtClass extobj3;
	private DocExtClass extobj4;
	private DocExtClass extobj5;
	private DocExtClass extobj6;
	private DocExtClass extobj7[];
	private DocExtClass extobj8;
	private DocExtClass extobj9;
	private DocExtClass extobj10;
	private DocExtClass extobj11;
	private DocExtClass extobj12;
	private DocExtClass extobj13[];
	
	private String opinion1="";
	private String opinion2="";
	private String opinion3="";
	private String opinion4="";
	private String opinion5="";

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_0711.initObject()");
		
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
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
				q = m.createQuery("CustomerID=:customerID").setParameter("customerID", sCustomerID);
				bo = q.getSingleResult();
				if(bo != null){
					String customerType = bo.getAttribute("CustomerType").getString();
					if("0210".equals(customerType)){
						m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
						q = m.createQuery("GroupID=:GroupID").setParameter("GroupID", sCustomerID);
						BizObject bb = q.getSingleResult();
						if(bb != null){
							sCustomerID = bb.getAttribute("FkeyMembercustomerID").getString();
						}
					}
				}
			}
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);
				CustomerFSRecord cfs1 = null;
				String reportNo = "";
				String laReportNo = "";
				Map reportMap = null;
				if(cfs != null){
					reportNo = financedata.getDetailNo(cfs);
					cfs1 = financedata.getRelativeYearReport(cfs,-1);
					reportMap = financedata.getAssetIDMap(cfs);
				}
				if(cfs1!=null){
					laReportNo = financedata.getDetailNo(cfs1);
				}
				FinanceDetailManager fdm = new FinanceDetailManager();
				//应付票据
				extobj1 = new DocExtClass();
				extobj2 = new DocExtClass();
				extobj3 = new DocExtClass();
				extobj4 = new DocExtClass();
				extobj5 = new DocExtClass();
				extobj6 = new DocExtClass();
				extobj8 = new DocExtClass();
				extobj9 = new DocExtClass();
				extobj10 = new DocExtClass();
				extobj11 = new DocExtClass();
				extobj12 = new DocExtClass();
				m = JBOFactory.getFactory().getManager("jbo.finasys.NOTES_PAYABLE");
				q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",reportNo);
				bo = q.getSingleResult();
				double ych = 0,laych=0,sch=0,lasch=0;
				if(bo != null){
					ych = bo.getAttribute("amount1").getDouble();
					extobj1.setAttr1(DataConvert.toMoney(ych));
				}
				q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",laReportNo);
				bo = q.getSingleResult();
				if(bo != null){
					laych = bo.getAttribute("amount1").getDouble();
					extobj1.setAttr2(DataConvert.toMoney(laych));
				}
				q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",reportNo);
				bo = q.getSingleResult();
				if(bo != null){
					sch = bo.getAttribute("amount1").getDouble();
					extobj1.setAttr4(DataConvert.toMoney(sch));
				}
				q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",laReportNo);
				bo = q.getSingleResult();
				if(bo != null){
					lasch = bo.getAttribute("amount1").getDouble();
					extobj1.setAttr5(DataConvert.toMoney(lasch));
				}
				extobj1.setAttr3(DataConvert.toMoney(ych-laych));
				extobj1.setAttr6(DataConvert.toMoney(sch-lasch));
				extobj1.setAttr7(DataConvert.toMoney(ych+sch));
				extobj1.setAttr8(DataConvert.toMoney(laych+lasch));
				extobj1.setAttr9(DataConvert.toMoney(ych-laych+sch-lasch));
				
				ReportSubject rs = null;
				double qtyfk = 0;
				double yfzk = 0;
				if(reportMap!=null&&reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("206");
					yfzk = rs.getCol2Value();
					rs = (ReportSubject) reportMap.get("218");
					qtyfk = rs.getCol2Value();
				}
				double jamount = Double.parseDouble(getTotalData(reportNo, "01"));
				double lajamount = Double.parseDouble(getTotalData(laReportNo, "01"));
				extobj6.setAttr1(DataConvert.toMoney(jamount));
				extobj6.setAttr2(DataConvert.toMoney(lajamount));
				extobj6.setAttr3(DataConvert.toMoney(jamount-lajamount));
				//三个月内
				double mijam = Double.parseDouble(getLastAccountAgeData(reportNo, "010", "01"));
				double lamijam = Double.parseDouble(getLastAccountAgeData(laReportNo, "010", "01"));
				extobj2.setAttr1(DataConvert.toMoney(mijam));
				extobj2.setAttr2(DataConvert.toMoney(lamijam));
				extobj2.setAttr3(DataConvert.toMoney(mijam-lamijam));
				if(mijam==0||yfzk==0) extobj2.setAttr4("0.00");
				else extobj2.setAttr4(String.format("%.0f",(mijam/yfzk)*100));
				//三个月到一年
				double oneyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "020", "01"));
				double laoyjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "020", "01"));
				extobj3.setAttr1(DataConvert.toMoney(oneyjam));
				extobj3.setAttr2(DataConvert.toMoney(laoyjam));
				extobj3.setAttr3(DataConvert.toMoney(oneyjam-laoyjam));
				if(oneyjam==0||yfzk==0) extobj3.setAttr4("0.00");
				else extobj3.setAttr4(String.format("%.0f",(oneyjam/yfzk)*100));
				//1~3年
				double onethyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "030", "01"));
				double laothyjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "030", "01"));
				extobj4.setAttr1(DataConvert.toMoney(onethyjam));
				extobj4.setAttr2(DataConvert.toMoney(laothyjam));
				extobj4.setAttr3(DataConvert.toMoney(onethyjam-laothyjam));
				if(onethyjam==0||yfzk==0) extobj4.setAttr4("0.00");
				else extobj4.setAttr4(String.format("%.0f",(onethyjam/yfzk)*100));
				//3年以上
				double thyoutjam = Double.parseDouble(getLastAccountAgeData(reportNo, "040", "01"));
				double lathyoutjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "040", "01"));
				extobj5.setAttr1(DataConvert.toMoney(thyoutjam));
				extobj5.setAttr2(DataConvert.toMoney(lathyoutjam));
				extobj5.setAttr3(DataConvert.toMoney(thyoutjam-lathyoutjam));
				if(thyoutjam==0||yfzk==0) extobj5.setAttr4("0.00");
				else extobj5.setAttr4(String.format("%.0f",(thyoutjam/yfzk)*100));
				m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
				q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='01' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
				List<BizObject> receives = q.getResultList();
				extobj7 = new DocExtClass[receives.size()];
				if(receives.size()>0&&receives.size()<=5){
					for(int i=0;i<receives.size();i++){
						BizObject receive = receives.get(i);
						extobj7[i] = new DocExtClass();
						extobj7[i].setAttr1(receive.getAttribute("CORPNAME").getString());
						double amount = receive.getAttribute("AMOUNT").getDouble();
						extobj7[i].setAttr2(DataConvert.toMoney(amount));
						String amountAge = receive.getAttribute("ACCOUNTAGE").getString();
						extobj7[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
						String lawSuit = receive.getAttribute("LAWSUIT").getString();
						extobj7[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
						String accountType = receive.getAttribute("ACCOUNTTYPE").getString();
						extobj7[i].setAttr5(CodeManager.getItemName("FootType",accountType));
						if(yfzk==0){
							extobj7[i].setAttr6("0");
						}else{
							extobj7[i].setAttr6(String.format("%.0f",(amount/yfzk)*100));
						}
						String isRelative = receive.getAttribute("ISRELATIVE").getString();
						extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}else if(receives.size()>5){
					extobj7 = new DocExtClass[5];
					for(int i=0;i<5;i++){
						BizObject receive = receives.get(i);
						extobj7[i] = new DocExtClass();
						extobj7[i].setAttr1(receive.getAttribute("CORPNAME").getString());
						double amount = receive.getAttribute("AMOUNT").getDouble();
						extobj7[i].setAttr2(DataConvert.toMoney(amount));
						String amountAge = receive.getAttribute("ACCOUNTAGE").getString();
						extobj7[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
						String lawSuit = receive.getAttribute("LAWSUIT").getString();
						extobj7[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
						String accountType = receive.getAttribute("ACCOUNTTYPE").getString();
						extobj7[i].setAttr5(CodeManager.getItemName("FootType",accountType));
						if(yfzk==0){
							extobj7[i].setAttr6("0");
						}else{
							extobj7[i].setAttr6(String.format("%.0f",(amount/yfzk)*100));
						}
						String isRelative = receive.getAttribute("ISRELATIVE").getString();
						extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}
				//其他应付账款
				double ojamount = Double.parseDouble(getTotalData(reportNo, "02"));
				double olajamount = Double.parseDouble(getTotalData(laReportNo, "02"));
				extobj12.setAttr1(DataConvert.toMoney(ojamount));
				extobj12.setAttr2(DataConvert.toMoney(olajamount));
				extobj12.setAttr3(DataConvert.toMoney(ojamount-olajamount));
				//三个月内
				double omijam = Double.parseDouble(getLastAccountAgeData(reportNo, "010", "02"));
				double olamijam = Double.parseDouble(getLastAccountAgeData(laReportNo, "010", "02"));
				extobj8.setAttr1(DataConvert.toMoney(omijam));
				extobj8.setAttr2(DataConvert.toMoney(olamijam));
				extobj8.setAttr3(DataConvert.toMoney(omijam-olamijam));
				if(omijam==0||qtyfk==0) extobj8.setAttr4("0.00");
				else extobj8.setAttr4(String.format("%.0f",(omijam/qtyfk)*100));
				//三个月到一年
				double ooneyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "020", "02"));
				double olaoyjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "020", "02"));
				extobj9.setAttr1(DataConvert.toMoney(ooneyjam));
				extobj9.setAttr2(DataConvert.toMoney(olaoyjam));
				extobj9.setAttr3(DataConvert.toMoney(ooneyjam-olaoyjam));
				if(ooneyjam==0||qtyfk==0) extobj9.setAttr4("0.00");
				else extobj9.setAttr4(String.format("%.0f",(ooneyjam/qtyfk)*100));
				//1~3年
				double oonethyjam = Double.parseDouble(getLastAccountAgeData(reportNo, "030", "02"));
				double olaothyjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "030", "02"));
				extobj10.setAttr1(DataConvert.toMoney(oonethyjam));
				extobj10.setAttr2(DataConvert.toMoney(olaothyjam));
				extobj10.setAttr3(DataConvert.toMoney(oonethyjam-olaothyjam));
				if(oonethyjam==0||qtyfk==0) extobj10.setAttr4("0.00");
				else extobj10.setAttr4(String.format("%.0f",(oonethyjam/qtyfk)*100));
				//3年以上
				double othyoutjam = Double.parseDouble(getLastAccountAgeData(reportNo, "040", "02"));
				double olathyoutjam = Double.parseDouble(getLastAccountAgeData(laReportNo, "040", "02"));
				extobj11.setAttr1(DataConvert.toMoney(othyoutjam));
				extobj11.setAttr2(DataConvert.toMoney(olathyoutjam));
				extobj11.setAttr3(DataConvert.toMoney(othyoutjam-olathyoutjam));
				if(othyoutjam==0||qtyfk==0) extobj11.setAttr4("0.00");
				else extobj11.setAttr4(String.format("%.0f",(othyoutjam/qtyfk)*100));
				m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
				q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='02' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
				List<BizObject> oreceives = q.getResultList();
				extobj13 = new DocExtClass[oreceives.size()];
				if(oreceives.size()>0&&oreceives.size()<=5){
					for(int i=0;i<oreceives.size();i++){
						BizObject oreceive = oreceives.get(i);
						extobj13[i] = new DocExtClass();
						extobj13[i].setAttr1(oreceive.getAttribute("CORPNAME").getString());
						double amount = oreceive.getAttribute("AMOUNT").getDouble();
						extobj13[i].setAttr2(DataConvert.toMoney(amount));
						String amountAge = oreceive.getAttribute("ACCOUNTAGE").getString();
						extobj13[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
						String lawSuit = oreceive.getAttribute("LAWSUIT").getString();
						extobj13[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
						String accountType = oreceive.getAttribute("ACCOUNTTYPE").getString();
						extobj13[i].setAttr5(CodeManager.getItemName("FootType",accountType));
						if(qtyfk==0){
							extobj13[i].setAttr6("0");
						}else{
							extobj13[i].setAttr6(String.format("%.0f",(amount/qtyfk)*100));
						}
						String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
						extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}else if(oreceives.size()>5){
					extobj13 = new DocExtClass[5];
					for(int i=0;i<5;i++){
						BizObject oreceive = oreceives.get(i);
						extobj13[i] = new DocExtClass();
						extobj13[i].setAttr1(oreceive.getAttribute("CORPNAME").getString());
						double amount = oreceive.getAttribute("AMOUNT").getDouble();
						extobj13[i].setAttr2(DataConvert.toMoney(amount));
						String amountAge = oreceive.getAttribute("ACCOUNTAGE").getString();
						extobj13[i].setAttr3(CodeManager.getItemName("AccountAge",amountAge));
						String lawSuit = oreceive.getAttribute("LAWSUIT").getString();
						extobj13[i].setAttr4(CodeManager.getItemName("YesNo",lawSuit));
						String accountType = oreceive.getAttribute("ACCOUNTTYPE").getString();
						extobj13[i].setAttr5(CodeManager.getItemName("FootType",accountType));
						if(qtyfk==0){
							extobj13[i].setAttr6("0");
						}else{
							extobj13[i].setAttr6(String.format("%.0f",(amount/qtyfk)*100));
						}
						String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
						extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}
				
				//应付账款
				m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
				q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='01'").setParameter("REPORTNO",reportNo);
				List<BizObject> payables = q.getResultList();
				extobj7 = new DocExtClass[payables.size()];
				if(payables.size()>5){
					extobj7 = new DocExtClass[5];
					for(int i=0;i<5;i++){
						BizObject payable = payables.get(i);
						extobj7[i] = new DocExtClass();
						extobj7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
						String currency = payable.getAttribute("CURRENCY").getString();
						extobj7[i].setAttr2(CodeManager.getItemName("Currency", currency));
						extobj7[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
						String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
						extobj7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
						String law = payable.getAttribute("LAWSUIT").getString();
						extobj7[i].setAttr5(CodeManager.getItemName("YesNo", law));
						String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
						extobj7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
						String isRelative = payable.getAttribute("ISRELATIVE").getString();
						extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}else if(payables.size()<=5){
//					extobj7 = new DocExtClass[payables.size()];
					for(int i=0;i<payables.size();i++){
						BizObject payable = payables.get(i);
						extobj7[i] = new DocExtClass();
						extobj7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
						String currency = payable.getAttribute("CURRENCY").getString();
						extobj7[i].setAttr2(CodeManager.getItemName("Currency", currency));
						extobj7[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
						String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
						extobj7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
						String law = payable.getAttribute("LAWSUIT").getString();
						extobj7[i].setAttr5(CodeManager.getItemName("YesNo", law));
						String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
						extobj7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
						String isRelative = payable.getAttribute("ISRELATIVE").getString();
						extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}
				//其他应付账款
				q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='02'").setParameter("REPORTNO",reportNo);
				payables = q.getResultList();
				extobj13 = new DocExtClass[payables.size()];
				if(payables.size()>5){
					extobj13 = new DocExtClass[5];
					for(int i=0;i<5;i++){
						BizObject payable = payables.get(i);
						extobj13[i] = new DocExtClass();
						extobj13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
						String currency = payable.getAttribute("CURRENCY").getString();
						extobj13[i].setAttr2(CodeManager.getItemName("Currency", currency));
						extobj13[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
						String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
						extobj13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
						String law = payable.getAttribute("LAWSUIT").getString();
						extobj13[i].setAttr5(CodeManager.getItemName("YesNo", law));
						String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
						extobj13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
						String isRelative = payable.getAttribute("ISRELATIVE").getString();
						extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
					}
				}else if(payables.size()<=5){
//					extobj13 = new DocExtClass[payables.size()];
					for(int i=0;i<payables.size();i++){
						BizObject payable = payables.get(i);
						extobj13[i] = new DocExtClass();
						extobj13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
						String currency = payable.getAttribute("CURRENCY").getString();
						extobj13[i].setAttr2(CodeManager.getItemName("Currency", currency));
						extobj13[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
						String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
						extobj13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
						String law = payable.getAttribute("LAWSUIT").getString();
						extobj13[i].setAttr5(CodeManager.getItemName("YesNo", law));
						String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
						extobj13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
						String isRelative = payable.getAttribute("ISRELATIVE").getString();
						extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
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
		return true;
	}
	//获得应付帐款分析（其他应收帐款分析）年初某个账龄的数据
    private String getLastAccountAgeData(String sReportNo,String sAccountAge,String sPayType){
		try{
			BizObjectManager m = null;
			BizObjectQuery q = null;
			BizObject bo = null;
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
			q = m.createQuery("select sum(AMOUNT) as V.jamount from O where reportNo=:reportNo and accountAge=:accountAge and PayType=:PayType");
		    q.setParameter("reportNo", sReportNo);
			q.setParameter("accountAge", sAccountAge);
			q.setParameter("PayType", sPayType);
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
    
  //获得应付帐款分析（其他应收帐款分析）合计的数据
    private String getTotalData(String sReportNo,String sReceiveType){
		try{
			BizObjectManager m = null;
			BizObjectQuery q = null;
			BizObject bo = null;
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
			q = m.createQuery("select sum(AMOUNT) as V.jamount from O where reportNo=:reportNo and PayType=:PayType");
		    q.setParameter("reportNo", sReportNo);
		    q.setParameter("PAYTYPE", sReceiveType);
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

	public DocExtClass[] getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass[] extobj7) {
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

	public DocExtClass[] getExtobj13() {
		return extobj13;
	}

	public void setExtobj13(DocExtClass[] extobj13) {
		this.extobj13 = extobj13;
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

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}
}
