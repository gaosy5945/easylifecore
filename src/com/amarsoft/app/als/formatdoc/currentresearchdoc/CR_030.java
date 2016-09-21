package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_030 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	private String customerName="";
    private String setupDate="";
    private String fictitiousPerson="";
    private String industryType="";
    private String scope="";
    private String listingCorpornot="";
    private String rcCurrency="";
    private String registerCapital="";
    private String pcCurrency="";
    private String paiclupCapital="";
    private String registerADD="";
    private String officeADD="";
    private String officeTel="";
    private String financedeptTel="";
    private String basicBank="";
    private String mainBank="";
    private String opinion1="";
   
    private DocExtClass extobj1;
    
    private String keymanName="";

	public CR_030() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_030.initObject()");
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
			customerName=NameManager.getCustomerName(sCustomerID);
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
				q = m.createQuery("CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID",sCustomerID);
				bo = q.getSingleResult();
				if(bo != null){
					setupDate = bo.getAttribute("SetupDate").getString();
					String sIndustry = bo.getAttribute("IndustryType").getString();
					industryType = CodeManager.getItemName("IndustryType", sIndustry);
					String sScope = bo.getAttribute("Scope").getString();
					scope = CodeManager.getItemName("Scope", sScope);
					listingCorpornot = bo.getAttribute("ListingCorpornot").getString();
					String sRCCurrency = bo.getAttribute("RCCurrency").getString();
					rcCurrency = CodeManager.getItemName("Currency", sRCCurrency);
					registerCapital = DataConvert.toMoney(bo.getAttribute("RegisterCapital").getDouble()/10000);
					String sPCCurrency = bo.getAttribute("PCCurrency").getString();
					pcCurrency = CodeManager.getItemName("Currency", sPCCurrency);
					paiclupCapital = DataConvert.toMoney(bo.getAttribute("PaiclupCapital").getDouble()/10000);
					
					//注册地址
					String countryCode = bo.getAttribute("OFFICECOUNTRYCODE").getString();
					String country = CodeManager.getItemName("CountryCode", countryCode);
					String regionCode = bo.getAttribute("OFFICEREGIONCODE").getString();
					String region = CodeManager.getItemName("AreaCode", regionCode);
					String registerAdd = bo.getAttribute("REGISTERADD").getString();
					registerADD = country+region+registerAdd;
					//办公地址
					String officeCountryCode = bo.getAttribute("COUNTRYCODE").getString();
					String officeCountry = CodeManager.getItemName("CountryCode", officeCountryCode);
					if(officeCountry==null)officeCountry="";
					String officeRegionCode  = bo.getAttribute("REGIONCODE").getString();
					String officeRegion = CodeManager.getItemName("AreaCode", officeRegionCode);
					if(officeRegion==null)officeRegion="";
					String officeAdd = bo.getAttribute("OFFICEADD").getString();
					if(officeAdd==null)officeAdd="";
					officeADD = officeCountry+officeRegion+officeAdd;
					
					officeTel = bo.getAttribute("OfficeTel").getString();
					financedeptTel = bo.getAttribute("FinancedeptTel").getString();
					basicBank = bo.getAttribute("BasicBank").getString();
					//mainBank = bo.getAttribute("MainBank").getString();
 				}
				//实际控制人
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
				q = m.createQuery("CUSTOMERID=:CUSTOMERID and RelationShip='0109'").setParameter("CUSTOMERID",sCustomerID);
				bo = q.getSingleResult();
				if(bo != null){
					keymanName = bo.getAttribute("CustomerName").getString();
				}else{
					keymanName="";
				}
				//获取法人代表
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
				q = m.createQuery("CustomerID=:CustomerID and RelationShip='0100'").setParameter("CustomerID", sCustomerID);
				bo = q.getSingleResult();
				if(bo!=null){
					fictitiousPerson = bo.getAttribute("CustomerName").getString();
				}else{
					fictitiousPerson="";
				}
//				if(StringX.isSpace(keymanName)){//若实际控制人为空，则赋值法定代表人
//					keymanName = fictitiousPerson;
//				}
				
				m = JBOFactory.getFactory().getManager("jbo.app.ENT_IPO");
				q = m.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID);
				bo = q.getSingleResult();
				extobj1 = new DocExtClass();
				if(bo != null){
					extobj1.setAttr1(bo.getAttribute("IPODate").getString());
					/*String bourseName =  bo.getAttribute("BourseName").getString();
					extobj1.setAttr2(CodeManager.getItemName("IPOName",bourseName));*/
					extobj1.setAttr2(bo.getAttribute("BourseName").getString());
					extobj1.setAttr3(bo.getAttribute("StockCode").getString());
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

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getSetupDate() {
		return setupDate;
	}

	public void setSetupDate(String setupDate) {
		this.setupDate = setupDate;
	}

	public String getFictitiousPerson() {
		return fictitiousPerson;
	}

	public void setFictitiousPerson(String fictitiousPerson) {
		this.fictitiousPerson = fictitiousPerson;
	}

	public String getIndustryType() {
		return industryType;
	}

	public void setIndustryType(String industryType) {
		this.industryType = industryType;
	}

	public String getScope() {
		return scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public String getListingCorpornot() {
		return listingCorpornot;
	}

	public void setListingCorpornot(String listingCorpornot) {
		this.listingCorpornot = listingCorpornot;
	}

	public String getRcCurrency() {
		return rcCurrency;
	}

	public void setRcCurrency(String rcCurrency) {
		this.rcCurrency = rcCurrency;
	}

	public String getRegisterCapital() {
		return registerCapital;
	}

	public void setRegisterCapital(String registerCapital) {
		this.registerCapital = registerCapital;
	}

	public String getPcCurrency() {
		return pcCurrency;
	}

	public void setPcCurrency(String pcCurrency) {
		this.pcCurrency = pcCurrency;
	}

	public String getPaiclupCapital() {
		return paiclupCapital;
	}

	public void setPaiclupCapital(String paiclupCapital) {
		this.paiclupCapital = paiclupCapital;
	}

	public String getRegisterADD() {
		return registerADD;
	}

	public void setRegisterADD(String registerADD) {
		this.registerADD = registerADD;
	}

	public String getOfficeADD() {
		return officeADD;
	}

	public void setOfficeADD(String officeADD) {
		this.officeADD = officeADD;
	}

	public String getKeymanName() {
		return keymanName;
	}

	public void setKeymanName(String keymanName) {
		this.keymanName = keymanName;
	}

	public String getOfficeTel() {
		return officeTel;
	}

	public void setOfficeTel(String officeTel) {
		this.officeTel = officeTel;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getFinancedeptTel() {
		return financedeptTel;
	}

	public void setFinancedeptTel(String financedeptTel) {
		this.financedeptTel = financedeptTel;
	}

	public String getBasicBank() {
		return basicBank;
	}

	public void setBasicBank(String basicBank) {
		this.basicBank = basicBank;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public String getMainBank() {
		return mainBank;
	}

	public void setMainBank(String mainBank) {
		this.mainBank = mainBank;
	}
	
}
