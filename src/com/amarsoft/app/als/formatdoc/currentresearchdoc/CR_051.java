package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;

public class CR_051 extends FormatDocData implements Serializable{
     
	private static final long serialVersionUID = 1L;
	
	private DocExtClass[] extobj1;
	private DocExtClass[] extobj2;
	private String balanceAll="";
	private String balanceAll1="";

	private String opinion1="";
	private String opinion2="";
	private String opinion3="";
	private String opinion4="";

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_051.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		if("".equals(opinion4))opinion4="";

		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
//		BizObjectManager m=null;
//		BizObjectQuery q=null;
//		BizObject o=null;
//		
//		String sCustomerID="";
				
//		try{
//			m=JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
//			q=m.createQuery("serialNo=:serialNo").setParameter("serialNo",sObjectNo);
//			o=q.getSingleResult();
//			if(o!=null){
//		           sCustomerID=o.getAttribute("customerID").getString();   
//			}
//			
//			FinanceDataManager fdm=new FinanceDataManager();
//			CustomerFSRecord cfsr=fdm.getNewestReport(sCustomerID);
//			CustomerFSRecord cfs1 = fdm.getRelativeYearReport(cfsr, -1);
//			String reportNo=fdm.getDetailNo(cfsr);
//			String lsReportNo = fdm.getDetailNo(cfs1);
//			//他行授信情况分析
//			m=JBOFactory.getFactory().getManager("jbo.finasys.OTHERBANK_LOANS");
//			q=m.createQuery("REPORTNO=:reportNo").setParameter("reportNo",reportNo);
//			List<BizObject> loans = q.getResultList();
//			extobj1 = new DocExtClass[loans.size()];
//			double dbal = 0;
//			if(loans.size()>0){
//				for(int i=0;i<loans.size();i++){
//					BizObject loan = loans.get(i);
//					extobj1[i] = new DocExtClass();
//					extobj1[i].setAttr1(loan.getAttribute("BANKNAME").getString());
//					String buType = loan.getAttribute("BUSINESSTYPE").getString();
//					extobj1[i].setAttr2(CodeManager.getItemName("OtherBusinessType",buType));//融资种类
//					double d1 = loan.getAttribute("BALANCE").getDouble();
//					dbal = dbal + d1;
//					extobj1[i].setAttr3(DataConvert.toMoney(d1));
//					extobj1[i].setAttr4(loan.getAttribute("BAILRATE").getString());
//					String guarantyType = loan.getAttribute("GUARANTYTYPE").getString();
//					extobj1[i].setAttr5(CodeManager.getItemName("GuarantyType",guarantyType));
//					extobj1[i].setAttr6(loan.getAttribute("BEGINDATE").getString());
//					extobj1[i].setAttr7(loan.getAttribute("MATURITY").getString());
//					String cfresult = loan.getAttribute("CLASSIFYRESULT").getString();
//					extobj1[i].setAttr8(CodeManager.getItemName("ClassifyResult",cfresult));
//				}
//			}
//			balanceAll = DataConvert.toMoney(dbal);
//			//或有负债分析
//			m=JBOFactory.getFactory().getManager("jbo.finasys.CONTINGENT_LIABILITY");
//			q=m.createQuery("REPORTNO=:reportNo").setParameter("reportNo",reportNo);
//			List<BizObject> liabilitys = q.getResultList();
//			extobj2 = new DocExtClass[liabilitys.size()];
//			double bal = 0;
//			if(liabilitys.size()>0){
//				for(int i=0;i<liabilitys.size();i++){
//					extobj2[i] = new DocExtClass();
//					BizObject liability = liabilitys.get(i);
//					String liab = liability.getAttribute("LIABILITYTYPE").getString();
//					extobj2[i].setAttr0(CodeManager.getItemName("LiabilitType",liab));
//					double d1 = liability.getAttribute("AMOUNT").getDouble();
//					extobj2[i].setAttr1(DataConvert.toMoney(d1));
//					bal = bal + d1;
//					extobj2[i].setAttr2(liability.getAttribute("BEGINDATE").getString());
//					extobj2[i].setAttr3(liability.getAttribute("MATURITY").getString());
//					String claresult = liability.getAttribute("CLASSIFYRESULT").getString();
//					extobj2[i].setAttr4(CodeManager.getItemName("ClassifyResult",claresult));
//				}
//			}
//			balanceAll1 = DataConvert.toMoney(bal);
////			String s = getContingentData(reportNo,"010");
////			double sAmount1=Double.parseDouble(getContingentData(reportNo,"010"));
////            double sAmount2=Double.parseDouble(getContingentData(reportNo,"020"));
////            double sAmount3=Double.parseDouble(getContingentData(reportNo,"030"));
////            double sToAmount=sAmount1+sAmount2+sAmount3;
////            extobj2.setAttr1(DataConvert.toMoney(sAmount1/10000));
////            extobj2.setAttr2(DataConvert.toMoney(sAmount2/10000));
////            extobj2.setAttr3(DataConvert.toMoney(sAmount3/10000));
////            extobj2.setAttr4(DataConvert.toMoney(sToAmount/10000));
////            
////            double lAmount1=Double.parseDouble(getContingentData(lsReportNo,"010"));
////            double lAmount2=Double.parseDouble(getContingentData(lsReportNo,"020"));
////            double lAmount3=Double.parseDouble(getContingentData(lsReportNo,"030"));
////            double lToAmount=lAmount1+lAmount2+lAmount3;
////            extobj3.setAttr1(DataConvert.toMoney(sAmount1-lAmount1));
////            extobj3.setAttr2(DataConvert.toMoney(sAmount2-lAmount2));
////            extobj3.setAttr3(DataConvert.toMoney(sAmount3-lAmount3));
////            extobj3.setAttr4(DataConvert.toMoney(sToAmount-lToAmount));
//				
//		}catch(Exception e){
//			e.printStackTrace();
//		}
		return true;
	}
    
//	//获取或有负债各指标名称的总金额
//	private String getContingentData(String sReportNo,String sLiabilityType){
//		String amount = "";
//		try{
//			BizObjectManager m=null;
//			BizObjectQuery q=null;
//			BizObject bo = null;
//		    m=JBOFactory.getFactory().getManager("jbo.finasys.CONTINGENT_LIABILITY");
//			q=m.createQuery("select sum(AMOUNT) as V.famount from O where reportNo=:reportNo and liabilityType=:liabilityType");
//			q.setParameter("reportNo", sReportNo);
//			q.setParameter("liabilityType", sLiabilityType);
//			bo = q.getSingleResult();
//			amount = bo.getAttribute("famount").getString();
//			if(amount==null)amount="0";
//			
//		}catch(Exception e){
//			e.printStackTrace();
//		}
//		return amount;
//	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		return true;
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

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public String getBalanceAll() {
		return balanceAll;
	}

	public void setBalanceAll(String balanceAll) {
		this.balanceAll = balanceAll;
	}

	public DocExtClass[] getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass[] extobj2) {
		this.extobj2 = extobj2;
	}

	public String getBalanceAll1() {
		return balanceAll1;
	}

	public void setBalanceAll1(String balanceAll1) {
		this.balanceAll1 = balanceAll1;
	}
	
}
