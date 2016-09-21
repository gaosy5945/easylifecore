package com.amarsoft.app.als.formatdoc.manufacturerdoc;

import java.io.Serializable;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

public class MF extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private DocExtClass[] extobj2;
    private DocExtClass[] extobj3;
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";
    private String opinion4="";

	public MF() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("MF.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		if("".equals(opinion4))opinion4="";
		
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
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
				q = m.createQuery("ObjectNo=:CustomerID and ReportName='财务明细附表' order by ReportDate desc").setParameter("CustomerID",sCustomerID);
				bo = q.getSingleResult();
				if(bo != null){
					String sReportNo = bo.getAttribute("ReportNo").getString();
					m = JBOFactory.getFactory().getManager("jbo.finasys.PRIMARY_PRODUCTS");
					q = m.createQuery("ReportNo=:ReportNo").setParameter("ReportNo",sReportNo);
					List<BizObject> products = q.getResultList();
					if(products.size()>0){
						extobj1 = new DocExtClass[products.size()];
						for(int i=0;i<products.size();i++){
							BizObject product = products.get(i);
							extobj1[i] = new DocExtClass();
							extobj1[i].setAttr1(product.getAttribute("PRPRODUCTNAME").getString());
							extobj1[i].setAttr2(product.getAttribute("INCOMERATE").getString());
							extobj1[i].setAttr3(product.getAttribute("PROFITRATE").getString());
						}
					}
				}
				
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
				//取前五名的供应商
				q = m.createQuery("select * from o where  o.RelationShip like '9901' and o.CustomerID=:CustomerID order by InvestmentSum desc").setParameter("CUSTOMERID",sCustomerID);
				List<BizObject> providers = q.getResultList();
				extobj2 = new DocExtClass[providers.size()];
				if(providers.size()>0 && providers.size()<=5){
					for(int i=0;i<providers.size();i++){
						BizObject provider = providers.get(i);
						extobj2[i] = new DocExtClass();
						extobj2[i].setAttr1(provider.getAttribute("CustomerName").getString());
						extobj2[i].setAttr2(provider.getAttribute("InvestDate").getString());
						extobj2[i].setAttr3(provider.getAttribute("InvestmentProp").getString());
						extobj2[i].setAttr4(provider.getAttribute("Describe").getString());
						extobj2[i].setAttr5(DataConvert.toMoney(provider.getAttribute("InvestmentSum").getDouble()));
						//主要结算方式
					}
				}else if(providers.size()>5){
					for(int i=0;i<5;i++){
						BizObject provider = providers.get(i);
						extobj2[i] = new DocExtClass();
						extobj2[i].setAttr1(provider.getAttribute("CustomerName").getString());
						extobj2[i].setAttr2(provider.getAttribute("InvestDate").getString());
						extobj2[i].setAttr3(provider.getAttribute("InvestmentProp").getString());
						extobj2[i].setAttr4(provider.getAttribute("Describe").getString());
						extobj2[i].setAttr5(provider.getAttribute("InvestmentSum").getString());
						//主要结算方式
					}
				}
				//取前五名的销售商
				q = m.createQuery("select * from o where  o.RelationShip like '9951' and o.CustomerID=:CustomerID order by InvestmentSum desc").setParameter("CUSTOMERID",sCustomerID);
				List<BizObject> salers = q.getResultList();
				extobj3 = new DocExtClass[salers.size()];
				if(salers.size()>0){
					for(int i=0;i<salers.size();i++){
						BizObject saler = salers.get(i);
						extobj3[i] = new DocExtClass();
						extobj3[i].setAttr1(saler.getAttribute("CustomerName").getString());
						extobj3[i].setAttr2(saler.getAttribute("InvestDate").getString());
						extobj3[i].setAttr3(saler.getAttribute("InvestmentProp").getString());
						extobj3[i].setAttr4(saler.getAttribute("Describe").getString());
						extobj3[i].setAttr5(DataConvert.toMoney(saler.getAttribute("InvestmentSum").getDouble()));
						//主要结算方式
					}
				}else if(providers.size()>5){
					for(int i=0;i<5;i++){
						BizObject provider = providers.get(i);
						extobj2[i] = new DocExtClass();
						extobj2[i].setAttr1(provider.getAttribute("CustomerName").getString());
						extobj2[i].setAttr2(provider.getAttribute("InvestDate").getString());
						extobj2[i].setAttr3(provider.getAttribute("InvestmentProp").getString());
						extobj2[i].setAttr4(provider.getAttribute("Describe").getString());
						extobj2[i].setAttr5(provider.getAttribute("InvestmentSum").getString());
						//主要结算方式
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

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass[] getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass[] extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass[] getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass[] extobj3) {
		this.extobj3 = extobj3;
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
	
}
