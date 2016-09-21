package com.amarsoft.app.als.formatdoc.educationdoc;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class ED_030 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	private String customerName="";
    private String setupDate="";
    private String fictitiousPerson="";
    private String industryType="";
    private String registerADD="";
    private String officeADD="";
    private String officeTel="";
    private String financedeptTel="";
    private String basicBank="";
    private String mainBank="";
    private String SuperCorpName="";
    private String loanCardNo="";//贷款卡号LOANCARDNO
    private String corpID="";//组织机构代码CORPID
    private String belongArea="";//所在国家地区
    
    private String opinion1="";
    

	public ED_030() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("ED_030.initObject()");
		if("".equals(opinion1))opinion1="";
		
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
					//fictitiousPerson = bo.getAttribute("FictitiousPerson").getString();
					String sIndustry = bo.getAttribute("IndustryType").getString();
					industryType = CodeManager.getItemName("IndustryType", sIndustry);
					loanCardNo = bo.getAttribute("loanCardNo").getString();
					corpID = bo.getAttribute("CORPID").getString();
					SuperCorpName=bo.getAttribute("SuperCorpName").getString();
					
					
					//注册地址
					String countryCode = bo.getAttribute("OFFICECOUNTRYCODE").getString();
					String country = CodeManager.getItemName("CountryCode", countryCode);
					if(country==null)country="";
					String regionCode = bo.getAttribute("OFFICEREGIONCODE").getString();
					String region = CodeManager.getItemName("AreaCode", regionCode);
					if(region==null)region="";
					String registerAdd = bo.getAttribute("REGISTERADD").getString();
					if(registerAdd==null)registerAdd="";
					registerADD = country+region+registerAdd;
					belongArea = country+region;
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
					mainBank = bo.getAttribute("MainBank").getString();
					//获取法人代表
					m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
					q = m.createQuery("CustomerID=:CustomerID and RelationShip='0100'").setParameter("CustomerID", sCustomerID);
					bo = q.getSingleResult();
					if(bo!=null){
						fictitiousPerson = bo.getAttribute("CustomerName").getString();
					}else{
						fictitiousPerson="";
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

	public String getLoanCardNo() {
		return loanCardNo;
	}

	public void setLoanCardNo(String loanCardNo) {
		this.loanCardNo = loanCardNo;
	}

	public String getCorpID() {
		return corpID;
	}

	public void setCorpID(String corpID) {
		this.corpID = corpID;
	}

	public String getBelongArea() {
		return belongArea;
	}

	public String getMainBank() {
		return mainBank;
	}

	public void setMainBank(String mainBank) {
		this.mainBank = mainBank;
	}

	public void setBelongArea(String belongArea) {
		this.belongArea = belongArea;
	}

	public String getSuperCorpName() {
		return SuperCorpName;
	}

	public void setSuperCorpName(String superCorpName) {
		SuperCorpName = superCorpName;
	}
	
}
