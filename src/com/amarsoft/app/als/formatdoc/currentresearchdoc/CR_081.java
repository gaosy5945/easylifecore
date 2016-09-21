package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.FinanceDetailManager;
import com.amarsoft.app.als.finance.analyse.model.FinanceDetailRcv;
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
import com.amarsoft.dict.als.manage.NameManager;

public class CR_081 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	private String auditOpinion="";
	private DocExtClass extobj01;
	private DocExtClass extobj02;
	private DocExtClass extobj03;
	private DocExtClass[] extobjg1;
	private DocExtClass[] extobjg2;
//	private DocExtClass[] extobjg3;
	private DocExtClass[] extobjg4;
	private DocExtClass extobjc0;
	private DocExtClass extobjc1;
	private DocExtClass extobjc2;
//	private DocExtClass extobjc3;
	private DocExtClass extobjc4;
//	private DocExtClass extobjc5;
	private DocExtClass extobjc6;
	private DocExtClass extobjc7;
	private DocExtClass extobjc8;
	private DocExtClass extobjc9;
	private DocExtClass extobjc10;
	private DocExtClass extobjc11;
	private DocExtClass extobjc12;
	private DocExtClass extobjc13;
	private DocExtClass extobjc14;
	private DocExtClass extobjc15;
	private DocExtClass extobjc16;
	private DocExtClass extobjc17;
	private DocExtClass extobjc18;
	private DocExtClass extobjc19;
	private DocExtClass extobjc20;
	private DocExtClass extobjc21;
	private DocExtClass extobjc22;
	private DocExtClass extobjc23;
	private DocExtClass extobjc24;
	private DocExtClass extobjc25;
	private DocExtClass[] extobjc26;
	private String ctotals="";
	private DocExtClass[] extobjp;
	
	//资产负债表
	private DocExtClass extobjz0;
    private DocExtClass extobjz1;
    private DocExtClass extobjz2;
    private DocExtClass extobjz3;
    private DocExtClass extobjz4;
    private DocExtClass extobjz5;
    private DocExtClass extobjz6;
    private DocExtClass extobjz7;
    private DocExtClass extobjz8;
    private DocExtClass extobjz9;
    private DocExtClass extobjz10;
    private DocExtClass extobjz11;
    private DocExtClass extobjz12;
    private DocExtClass extobjz13;
    private DocExtClass extobjz14;
    private DocExtClass extobjz15;
    private DocExtClass extobjz16;
    private DocExtClass extobjz17;
    private DocExtClass extobjz18;
    private DocExtClass extobjz19;
    private DocExtClass extobjz20;
    private DocExtClass extobjz21;
    private DocExtClass extobjz22;
    private DocExtClass extobjz23;
    private DocExtClass extobjz24;
    private DocExtClass extobjz25;
    private DocExtClass extobjz26;
    private DocExtClass extobjz27;
    private DocExtClass extobjz28;
    private DocExtClass extobjz29;
    private DocExtClass extobjz30;
    private DocExtClass extobjz31;
    private DocExtClass extobjz32;
    private DocExtClass extobjz33;
    private DocExtClass extobjz34;
    private DocExtClass extobjz35;
    private DocExtClass extobjz36;
    private DocExtClass extobjz37;
    private DocExtClass extobjz38;
    private DocExtClass extobjz39;
    private DocExtClass extobjz40;
    private DocExtClass extobjz41;
    private DocExtClass extobjz42;
    private DocExtClass extobjz43;
    private DocExtClass extobjz44;
    private DocExtClass extobjz45;
    private DocExtClass extobjz46;
    private DocExtClass extobjz47;
    private DocExtClass extobjz48;
    private DocExtClass extobjz49;
    private DocExtClass extobjz50;
    private DocExtClass extobjz51;
    private DocExtClass extobjz52;
    private DocExtClass extobjz53;
    private DocExtClass extobjz54;
    private DocExtClass extobjz55;
    private DocExtClass extobjz56;
    private DocExtClass extobjz57;
    private DocExtClass extobjz58;
    private DocExtClass extobjz59;
    private DocExtClass extobjz60;
    private DocExtClass extobjz61;
    private DocExtClass extobjz62;
    private DocExtClass extobjz63;
    private DocExtClass extobjz64;
    private DocExtClass extobjz65;
    private DocExtClass extobjz66;
    private DocExtClass extobjz67;
    private DocExtClass extobjz68;
    private DocExtClass extobjz69;
    private DocExtClass extobjz70;
    private DocExtClass extobjz71;
    private DocExtClass extobjz72;
    private DocExtClass extobjz73;
    private DocExtClass extobjz74;
    private DocExtClass extobjz75;
    private DocExtClass extobjz76;
	//利润表
    private DocExtClass extobjl0;
    private DocExtClass extobjl1;
    private DocExtClass extobjl2;
    private DocExtClass extobjl3;
    private DocExtClass extobjl4;
    private DocExtClass extobjl5;
    private DocExtClass extobjl6;
    private DocExtClass extobjl7;
    private DocExtClass extobjl8;
    private DocExtClass extobjl9;
    private DocExtClass extobjl10;
    private DocExtClass extobjl11;
    private DocExtClass extobjl12;
    private DocExtClass extobjl13;
    private DocExtClass extobjl14;
    private DocExtClass extobjl15;
    private DocExtClass extobjl16;
    private DocExtClass extobjl17;
    private DocExtClass extobjl18;
    private DocExtClass extobjl19;
    private DocExtClass extobjl20;
    private DocExtClass extobjl21;
    private DocExtClass extobjl22;
    private DocExtClass extobjl23;
    private DocExtClass extobjl24;
    private DocExtClass extobjl25;
    private DocExtClass extobjl26;
    //现金流量表
    private DocExtClass extobjx0;
    private DocExtClass extobjx1;
    private DocExtClass extobjx2;
    private DocExtClass extobjx3;
    private DocExtClass extobjx4;
    private DocExtClass extobjx5;
    private DocExtClass extobjx6;
    private DocExtClass extobjx7;
    private DocExtClass extobjx8;
    private DocExtClass extobjx9;
    private DocExtClass extobjx10;
    private DocExtClass extobjx11;
    private DocExtClass extobjx12;
    private DocExtClass extobjx13;
    private DocExtClass extobjx14;
    private DocExtClass extobjx15;
    private DocExtClass extobjx16;
    private DocExtClass extobjx17;
    private DocExtClass extobjx18;
    private DocExtClass extobjx19;
    private DocExtClass extobjx20;
    private DocExtClass extobjx21;
    private DocExtClass extobjx22;
    private DocExtClass extobjx23;
    private DocExtClass extobjx24;
    private DocExtClass extobjx25;
    private DocExtClass extobjx26;
    private DocExtClass extobjx27;
    private DocExtClass extobjx28;
    private DocExtClass extobjx29;
    private DocExtClass extobjx30;
    private DocExtClass extobjx31;
    private DocExtClass extobjx32;
    private DocExtClass extobjx33;
    private DocExtClass extobjx34;
    private DocExtClass extobjx35;
    //重要负债科目分析
	private DocExtClass extobjf1;
	private DocExtClass extobjf2;
	private DocExtClass extobjf3;
	private DocExtClass extobjf4;
	private DocExtClass extobjf5;
	private DocExtClass extobjf6;
	private DocExtClass extobjf7[];
	private DocExtClass extobjf8;
	private DocExtClass extobjf9;
	private DocExtClass extobjf10;
	private DocExtClass extobjf11;
	private DocExtClass extobjf12;
	private DocExtClass extobjf13[];
	//重要资产科目分析
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
	private String opinion9="";
	private String opinion10="";
	private String opinion11="";
	private String opinion12="";
	private String opinion13="";
	private String opinion14="";
	private String opinion15="";
	private String opinion16="";
	private String opinion17="";
	private String opinion18="";
	private String opinion19="";
	private String opinion20="";
	private String opinion21="";
	private String opinion22="";
	private String opinion23="";
	private String opinion24="";
	private String opinion25="";
	private String opinion26="";
//	private String opinion27="";
	private String opinion28="";
	private String opinion29="";
	private String opinion30="";
	private String opinion31="";
	
	private DocExtClass write1;
	private DocExtClass write2;//货币资金分析
	private DocExtClass write3;
	private DocExtClass write4;
	String sFinancelType = "";
	String customerID = "";

	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	public CR_081() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_081.initObject()");
		extobjz0 = new DocExtClass();
		extobjz1 = new DocExtClass();
		extobjz2 = new DocExtClass();
		extobjz3 = new DocExtClass();
		extobjz4 = new DocExtClass();
		extobjz5 = new DocExtClass();
		extobjz6 = new DocExtClass();
		extobjz7 = new DocExtClass();
		extobjz8 = new DocExtClass();
		extobjz9 = new DocExtClass();
		extobjz10 = new DocExtClass();
		extobjz11 = new DocExtClass();
		extobjz12 = new DocExtClass();
		extobjz13 = new DocExtClass();
		extobjz14 = new DocExtClass();
		extobjz15 = new DocExtClass();
		extobjz16 = new DocExtClass();
		extobjz17 = new DocExtClass();
		extobjz18 = new DocExtClass();
		extobjz19 = new DocExtClass();
		extobjz20 = new DocExtClass();
		extobjz21 = new DocExtClass();
		extobjz22 = new DocExtClass();
		extobjz23 = new DocExtClass();
		extobjz24 = new DocExtClass();
		extobjz25 = new DocExtClass();
		extobjz26 = new DocExtClass();
		extobjz27 = new DocExtClass();
		extobjz28 = new DocExtClass();
		extobjz29 = new DocExtClass();
		extobjz30 = new DocExtClass();
		extobjz31 = new DocExtClass();
		extobjz32 = new DocExtClass();
		extobjz33 = new DocExtClass();
		extobjz34 = new DocExtClass();
		extobjz35 = new DocExtClass();
		extobjz36 = new DocExtClass();
		extobjz37 = new DocExtClass();
		extobjz38 = new DocExtClass();
		extobjz39 = new DocExtClass();
		extobjz40 = new DocExtClass();
		extobjz41 = new DocExtClass();
		extobjz42 = new DocExtClass();
		extobjz43 = new DocExtClass();
		extobjz44 = new DocExtClass();
		extobjz45 = new DocExtClass();
		extobjz46 = new DocExtClass();
		extobjz47 = new DocExtClass();
		extobjz48 = new DocExtClass();
		extobjz49 = new DocExtClass();
		extobjz50 = new DocExtClass();
		extobjz51 = new DocExtClass();
		extobjz52 = new DocExtClass();
		extobjz53 = new DocExtClass();
		extobjz54 = new DocExtClass();
		extobjz55 = new DocExtClass();
		extobjz56 = new DocExtClass();
		extobjz57 = new DocExtClass();
		extobjz58 = new DocExtClass();
		extobjz59 = new DocExtClass();
		extobjz60 = new DocExtClass();
		extobjz61 = new DocExtClass();
		extobjz62 = new DocExtClass();
		extobjz63 = new DocExtClass();
		extobjz64 = new DocExtClass();
		extobjz65 = new DocExtClass();
		extobjz66 = new DocExtClass();
		extobjz67 = new DocExtClass();
		extobjz68 = new DocExtClass();
		extobjz69 = new DocExtClass();
		extobjz70 = new DocExtClass();
		extobjz71 = new DocExtClass();
		extobjz72 = new DocExtClass();
		extobjz73 = new DocExtClass();
		extobjz74 = new DocExtClass();
		extobjz75 = new DocExtClass();
		extobjz76 = new DocExtClass();
		
		extobjl0 = new DocExtClass();
		extobjl1 = new DocExtClass();
		extobjl2 = new DocExtClass();
		extobjl3 = new DocExtClass();
		extobjl4 = new DocExtClass();
		extobjl5 = new DocExtClass();
		extobjl6 = new DocExtClass();
		extobjl7 = new DocExtClass();
		extobjl8 = new DocExtClass();
		extobjl9 = new DocExtClass();
		extobjl10 = new DocExtClass();
		extobjl11 = new DocExtClass();
		extobjl12 = new DocExtClass();
		extobjl13 = new DocExtClass();
		extobjl14 = new DocExtClass();
		extobjl15 = new DocExtClass();
		extobjl16 = new DocExtClass();
		extobjl17 = new DocExtClass();
		extobjl18 = new DocExtClass();
		extobjl19 = new DocExtClass();
		extobjl20 = new DocExtClass();
		extobjl21 = new DocExtClass();
		extobjl22 = new DocExtClass();
		extobjl23 = new DocExtClass();
		extobjl24 = new DocExtClass();
		extobjl25 = new DocExtClass();
		extobjl26 = new DocExtClass();
		
		extobjx0 = new DocExtClass();
		extobjx1 = new DocExtClass();
		extobjx2 = new DocExtClass();
		extobjx3 = new DocExtClass();
		extobjx4 = new DocExtClass();
		extobjx5 = new DocExtClass();
		extobjx6 = new DocExtClass();
		extobjx7 = new DocExtClass();
		extobjx8 = new DocExtClass();
		extobjx9 = new DocExtClass();
		extobjx10 = new DocExtClass();
		extobjx11 = new DocExtClass();
		extobjx12 = new DocExtClass();
		extobjx13 = new DocExtClass();
		extobjx14 = new DocExtClass();
		extobjx15 = new DocExtClass();
		extobjx16 = new DocExtClass();
		extobjx17 = new DocExtClass();
		extobjx18 = new DocExtClass();
		extobjx19 = new DocExtClass();
		extobjx20 = new DocExtClass();
		extobjx21 = new DocExtClass();
		extobjx22 = new DocExtClass();
		extobjx23 = new DocExtClass();
		extobjx24 = new DocExtClass();
		extobjx25 = new DocExtClass();
		extobjx26 = new DocExtClass();
		extobjx27 = new DocExtClass();
		extobjx28 = new DocExtClass();
		extobjx29 = new DocExtClass();
		extobjx30 = new DocExtClass();
		extobjx31 = new DocExtClass();
		extobjx32 = new DocExtClass();
		extobjx33 = new DocExtClass();
		extobjx34 = new DocExtClass();
		extobjx35 = new DocExtClass();
	
		write2 = new DocExtClass();
		write3 = new DocExtClass();
		write4 = new DocExtClass();
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
				sFinancelType = getReportType(customerID);
				getSame();
				if("010".equals(sFinancelType)){
					getNew();
				}else if("020".equals(sFinancelType)){
					getOld();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		write1 = new DocExtClass();
		return true;
	}
	
	public void setModelInputStream()throws Exception{
		//String sFinancelType = "010";//以新会计准则为例
		try{
			if(sFinancelType.equals("010"))
			{
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new.html");//templateFileName+"_new.html"文件要存在
			}
			else
			{
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081.html");//templateFileName+"_old.html"文件要存在
			}
		}
		catch(Exception e){
			throw new Exception("没有找到模板文件：" + e.toString());
		}
	}
	
	public void getSame(){//获取相同的信息
		extobj01 = new DocExtClass();
		extobj02 = new DocExtClass();
		extobj03 = new DocExtClass();
		extobjc0 = new DocExtClass();
		extobjc1 = new DocExtClass();
		extobjc2 = new DocExtClass();
//		extobjc3 = new DocExtClass();
		extobjc4 = new DocExtClass();
//		extobjc5 = new DocExtClass();
		extobjc6 = new DocExtClass();
		extobjc7 = new DocExtClass();
		extobjc8 = new DocExtClass();
		extobjc9 = new DocExtClass();
		extobjc10 = new DocExtClass();
		extobjc11 = new DocExtClass();
		extobjc12 = new DocExtClass();
		extobjc13 = new DocExtClass();
		extobjc14 = new DocExtClass();
		extobjc15 = new DocExtClass();
		extobjc16 = new DocExtClass();
		extobjc17 = new DocExtClass();
		extobjc18 = new DocExtClass();
		extobjc19 = new DocExtClass();
		extobjc20 = new DocExtClass();
		extobjc21 = new DocExtClass();
		extobjc22 = new DocExtClass();
		extobjc23 = new DocExtClass();
		extobjc24 = new DocExtClass();
		extobjc25 = new DocExtClass();
		
		extobjf2 = new DocExtClass();
		extobjf3 = new DocExtClass();
		extobjf4 = new DocExtClass();
		extobjf5 = new DocExtClass();
		extobjf6 = new DocExtClass();
		extobjf8 = new DocExtClass();
		extobjf9 = new DocExtClass();
		extobjf10 = new DocExtClass();
		extobjf11 = new DocExtClass();
		extobjf12 = new DocExtClass();
		
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
		try {//申请人基本信息
			extobj01.setAttr1(NameManager.getCustomerName(customerID));
			m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
			q = m.createQuery("CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID",customerID);
			bo = q.getSingleResult();
			if(bo != null){
				extobj01.setAttr2(bo.getAttribute("SetupDate").getString());
//				extobj01.setAttr3(bo.getAttribute("FictitiousPerson").getString());
				String sIndustry = bo.getAttribute("IndustryType").getString();
				extobj01.setAttr4(CodeManager.getItemName("IndustryType", sIndustry));//行业归属
				String sScope = bo.getAttribute("Scope").getString();
				extobj01.setAttr5(CodeManager.getItemName("Scope", sScope));//企业规模
				extobj01.setAttr7(bo.getAttribute("ListingCorpornot").getString());
				String sRCCurrency = bo.getAttribute("RCCurrency").getString();
				extobj01.setAttr8(CodeManager.getItemName("Currency", sRCCurrency));//注册币种
				extobj01.setAttr9(DataConvert.toMoney(bo.getAttribute("RegisterCapital").getDouble()/10000));
				String sPCCurrency = bo.getAttribute("PCCurrency").getString();
				extobj01.setAttr0(CodeManager.getItemName("Currency", sPCCurrency));
				extobj02.setAttr1(DataConvert.toMoney(bo.getAttribute("PaiclupCapital").getDouble()/10000));
				
				//注册地址
				String countryCode = bo.getAttribute("OFFICECOUNTRYCODE").getString();
				String country = CodeManager.getItemName("CountryCode", countryCode);
				String regionCode = bo.getAttribute("OFFICEREGIONCODE").getString();
				String region = CodeManager.getItemName("AreaCode", regionCode);
				String registerAdd = bo.getAttribute("REGISTERADD").getString();
				extobj02.setAttr2(country+region+registerAdd);
				//办公地址
				String officeCountryCode = bo.getAttribute("COUNTRYCODE").getString();
				String officeCountry = CodeManager.getItemName("CountryCode", officeCountryCode);
				String officeRegionCode  = bo.getAttribute("REGIONCODE").getString();
				String officeRegion = CodeManager.getItemName("AreaCode", officeRegionCode);
				String officeAdd = bo.getAttribute("OFFICEADD").getString();
				extobj02.setAttr3(officeCountry+officeRegion+officeAdd);
				
				extobj02.setAttr4(bo.getAttribute("OfficeTel").getString());
				extobj02.setAttr5(bo.getAttribute("FinancedeptTel").getString());
				extobj02.setAttr7(bo.getAttribute("BasicBank").getString());
				extobj02.setAttr6(bo.getAttribute("BasicAccount").getString());
				}
			m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
			q = m.createQuery("CUSTOMERID=:CUSTOMERID and RelationShip='0109'").setParameter("CUSTOMERID",customerID);
			bo = q.getSingleResult();
			if(bo != null){
				extobj01.setAttr6(bo.getAttribute("CustomerName").getString());
			}
			q = m.createQuery("CUSTOMERID=:CUSTOMERID and RelationShip='0100'").setParameter("CUSTOMERID",customerID);
			bo = q.getSingleResult();
			if(bo != null){
				extobj01.setAttr3(bo.getAttribute("CustomerName").getString());
			}
			//上市时间、上市地点、股票代码
			m = JBOFactory.getFactory().getManager("jbo.app.ENT_IPO");
			q = m.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID);
			bo = q.getSingleResult();
			if(bo != null){
				extobj02.setAttr8(bo.getAttribute("IPODate").getString());
				String bourseName =  bo.getAttribute("BourseName").getString();
				extobj02.setAttr9(CodeManager.getItemName("IPOName",bourseName));
				extobj02.setAttr0(bo.getAttribute("StockCode").getString());
			}
			//股权结构
			m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
			q = m.createQuery("CustomerID=:CustomerID and RelationShip like '52%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
			List<BizObject> relatives = q.getResultList();
			extobjg1 = new DocExtClass[relatives.size()];
			if(relatives.size()>0){
				for(int i=0;i<relatives.size();i++){
					BizObject relative = relatives.get(i);
					extobjg1[i] = new DocExtClass();
					extobjg1[i].setAttr1(relative.getAttribute("CustomerName").getString());
					String sRelationShip = relative.getAttribute("RelationShip").getString();
					extobjg1[i].setAttr2(CodeManager.getItemName("RelationShip",sRelationShip));
					String sCurrency = relative.getAttribute("CurrencyType").getString();
					extobjg1[i].setAttr3(CodeManager.getItemName("Currency", sCurrency));
					extobjg1[i].setAttr4(DataConvert.toMoney(relative.getAttribute("OughtSum").getDouble()));
					extobjg1[i].setAttr5(DataConvert.toMoney(relative.getAttribute("InvestmentSum").getDouble()));
					extobjg1[i].setAttr6(relative.getAttribute("InvestmentProp").getString());
					extobjg1[i].setAttr7(relative.getAttribute("investDate").getString());
				}
			}
			//对外投资情况
			q = m.createQuery("CustomerID =:CustomerID and RelationShip like '02%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
			relatives = q.getResultList();
			extobjg2 = new DocExtClass[relatives.size()];
			if(relatives.size()>0){
				for(int i=0;i<relatives.size();i++){
					BizObject relative = relatives.get(i);
					extobjg2[i] = new DocExtClass();
					extobjg2[i].setAttr1(relative.getAttribute("CustomerName").getString());
					extobjg2[i].setAttr2(DataConvert.toMoney(relative.getAttribute("INVESTMENTSUM").getDouble()));
					extobjg2[i].setAttr3(relative.getAttribute("INVESTMENTPROP").getString());

					String sRelativeID = relative.getAttribute("RELATIVEID").getString();
					m = JBOFactory.getFactory().getManager("jbo.finasys.CUSTOMER_FSRECORD");
					q = m.createQuery("CustomerID=:CustomerID and reportScope='02' order by ReportDate desc").setParameter("CustomerID",sRelativeID);
					bo = q.getSingleResult();
					if(bo != null){
						String sRecordNo = bo.getAttribute("RecordNo").getString();
						m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
						q = m.createQuery("FSRecordNo=:RecordNo and ModelNo='0020'").setParameter("RecordNo",sRecordNo);
						BizObject bb = q.getSingleResult();
						if(bb != null) {
							String sReportNo = bb.getAttribute("ReportNo").getString();
							m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_DATA");
							q = m.createQuery("ReportNo=:ReportNo and RowNo='0010'").setParameter("ReportNo",sReportNo);//条件标记下
							BizObject bl = q.getSingleResult();
							if(bl != null){
								extobjg2[i].setAttr6(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()));
							}
							q = m.createQuery("ReportNo=:ReportNo and RowNo='0170'").setParameter("ReportNo",sReportNo);
							bl = q.getSingleResult();
							if(bl != null){
								extobjg2[i].setAttr7(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()));
							}
						}
						m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
						q = m.createQuery("FSRecordNo=:RecordNo and ModelNo='0010'").setParameter("RecordNo",sRecordNo);
						bb = q.getSingleResult();
						if(bb != null) {
							String sReportNo = bb.getAttribute("ReportNo").getString();
							m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_DATA");
							q = m.createQuery("ReportNo=:ReportNo and RowNo='0370'").setParameter("ReportNo",sReportNo);//条件标记下
							BizObject bl = q.getSingleResult();
							if(bl != null){
								extobjg2[i].setAttr4(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()));
							}
							q = m.createQuery("ReportNo=:ReportNo and RowNo='0720'").setParameter("ReportNo",sReportNo);
							bl = q.getSingleResult();
							if(bl != null){
								extobjg2[i].setAttr5(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()));
							}
						}
					}
				}
			}
			//企业管理水平
			m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
			q = m.createQuery("CustomerID=:CustomerID and RelationShip like '01%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
			relatives = q.getResultList();
			extobjg4 = new DocExtClass[relatives.size()];
			if(relatives.size()>0){
				for(int i=0;i<relatives.size();i++){
					BizObject relative = relatives.get(i);
					extobjg4[i] = new DocExtClass();
					String sRelationShip = relative.getAttribute("RelationShip").getString();
					extobjg4[i].setAttr1(CodeManager.getItemName("RelationShip",sRelationShip));
					extobjg4[i].setAttr2(relative.getAttribute("CustomerName").getString());
					extobjg4[i].setAttr3(relative.getAttribute("BIRTHDAY").getString());
					extobjg4[i].setAttr4(relative.getAttribute("EDUEXPERIENCE").getString());
					extobjg4[i].setAttr5(relative.getAttribute("HOLDDATE").getString());
					extobjg4[i].setAttr6(relative.getAttribute("ENGAGETERM").getString());
					extobjg4[i].setAttr7(relative.getAttribute("HOLDSTOCK").getString());
				}
			}
			//财务报表说明
			FinanceDataManager fdm=new FinanceDataManager();
			CustomerFSRecord cfs=fdm.getNewestReport(customerID);
			CustomerFSRecord yearReport = fdm.getNewYearReport(customerID);
			if(cfs != null){
				extobj03.setAttr1(cfs.getReportDate());
				extobj03.setAttr2(cfs.getReportScope());
				extobj03.setAttr3(CodeManager.getItemName("FinanceBelong",cfs.getFinanceBelong()));
				String sCurrency=cfs.getReportCurrency();
				extobj03.setAttr4(CodeManager.getItemName("Currency", sCurrency));
				extobj03.setAttr9(fdm.isLianXu(customerID));
			}
			if(yearReport!=null){
				extobj03.setAttr5(yearReport.getReportDate());
				extobj03.setAttr6(yearReport.getAuditFlag());
				extobj03.setAttr7(yearReport.getAuditOffice());
				extobj03.setAttr8(yearReport.getAuditOpchoose());
				auditOpinion = yearReport.getAuditOpinion();
				extobj03.setAttr0(yearReport.getReportOpinion());
			}
			//取财务指标表数据
			ReportSubject rs = null;
			if(cfs != null){
				if(!StringX.isSpace(cfs.getReportDate()))extobjc0.setAttr1("("+cfs.getReportDate()+")");
				Map reportMap = fdm.getGuideMap(cfs);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("流动比率(倍)");
					extobjc1.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("速动比率(倍)");
					extobjc2.setAttr1(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//				extobjc3.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("现金比率(倍)");
					extobjc4.setAttr1(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("营运资本");
//				extobjc5.setAgetCol2IntString()String());
					rs = (ReportSubject) reportMap.get("资产负债率(%)");
					extobjc6.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
					extobjc7.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
					extobjc8.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("产权比率(%)");
					extobjc9.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
					extobjc10.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
					extobjc11.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("销售毛利率(%)");
					extobjc12.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("营业利润率(%)");
					extobjc13.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("税前利润率(%)");
					extobjc14.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("销售净利率(%)");
					extobjc15.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
					extobjc16.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("总资产收益率(%)");
					extobjc17.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("净资产收益率(%)");
					extobjc18.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
					extobjc19.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("存货周转率(次)");
					extobjc20.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
					extobjc21.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("净营业周期(天)");
					extobjc22.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
					extobjc23.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
					extobjc24.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("总资产周转率(次)");
					extobjc25.setAttr1(rs.getCol2ValueString());
				}
				
				CustomerFSRecord cfs1 = fdm.getLastSerNReport(cfs, -1);//获得去年同期
				if(cfs1 != null){
					if(!StringX.isSpace(cfs1.getReportDate()))extobjc0.setAttr2("("+cfs1.getReportDate()+")");
					reportMap = fdm.getGuideMap(cfs1);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("流动比率(倍)");
						extobjc1.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("速动比率(倍)");
						extobjc2.setAttr2(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//					extobjc3.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("现金比率(倍)");
						extobjc4.setAttr2(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("营运资本");
//					extobjc5.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("资产负债率(%)");
						extobjc6.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
						extobjc7.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
						extobjc8.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("产权比率(%)");
						extobjc9.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
						extobjc10.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
						extobjc11.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售毛利率(%)");
						extobjc12.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("营业利润率(%)");
						extobjc13.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("税前利润率(%)");
						extobjc14.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售净利率(%)");
						extobjc15.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
						extobjc16.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产收益率(%)");
						extobjc17.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净资产收益率(%)");
						extobjc18.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
						extobjc19.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("存货周转率(次)");
						extobjc20.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
						extobjc21.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净营业周期(天)");
						extobjc22.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
						extobjc23.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
						extobjc24.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产周转率(次)");
						extobjc25.setAttr2(rs.getCol2ValueString());
					}
				}
				
				CustomerFSRecord cfs2 = fdm.getRelativeYearReport(cfs, -1);//获得去年年末
				if(cfs2 != null){
					if(!StringX.isSpace(cfs2.getReportDate()))extobjc0.setAttr3("("+cfs2.getReportDate()+")");
					reportMap = fdm.getGuideMap(cfs2);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("流动比率(倍)");
						extobjc1.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("速动比率(倍)");
						extobjc2.setAttr3(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//					extobjc3.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("现金比率(倍)");
						extobjc4.setAttr3(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("营运资本");
//					extobjc5.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("资产负债率(%)");
						extobjc6.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
						extobjc7.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
						extobjc8.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("产权比率(%)");
						extobjc9.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
						extobjc10.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
						extobjc11.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售毛利率(%)");
						extobjc12.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("营业利润率(%)");
						extobjc13.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("税前利润率(%)");
						extobjc14.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售净利率(%)");
						extobjc15.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
						extobjc16.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产收益率(%)");
						extobjc17.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净资产收益率(%)");
						extobjc18.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
						extobjc19.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("存货周转率(次)");
						extobjc20.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
						extobjc21.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净营业周期(天)");
						extobjc22.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
						extobjc23.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
						extobjc24.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产周转率(次)");
						extobjc25.setAttr3(rs.getCol2ValueString());
					}
				}
				
				CustomerFSRecord cfs3 = fdm.getRelativeYearReport(cfs, -2);//获得上两年末
				if(cfs3 != null){
					if(!StringX.isSpace(cfs3.getReportDate()))extobjc0.setAttr4("("+cfs3.getReportDate()+")");
					reportMap = fdm.getGuideMap(cfs3);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("流动比率(倍)");
						extobjc1.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("速动比率(倍)");
						extobjc2.setAttr4(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//					extobjc3.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("现金比率(倍)");
						extobjc4.setAttr4(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("营运资本");
//					extobjc5.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("资产负债率(%)");
						extobjc6.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
						extobjc7.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
						extobjc8.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("产权比率(%)");
						extobjc9.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
						extobjc10.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
						extobjc11.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售毛利率(%)");
						extobjc12.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("营业利润率(%)");
						extobjc13.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("税前利润率(%)");
						extobjc14.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售净利率(%)");
						extobjc15.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
						extobjc16.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产收益率(%)");
						extobjc17.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净资产收益率(%)");
						extobjc18.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
						extobjc19.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("存货周转率(次)");
						extobjc20.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
						extobjc21.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净营业周期(天)");
						extobjc22.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
						extobjc23.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
						extobjc24.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产周转率(次)");
						extobjc25.setAttr4(rs.getCol2ValueString());
					}
				}
				
				CustomerFSRecord cfs4 = fdm.getRelativeYearReport(cfs, -3);//获得上三年末
				if(cfs4 != null){
					if(!StringX.isSpace(cfs4.getReportDate()))extobjc0.setAttr5("("+cfs4.getReportDate()+")");
					reportMap = fdm.getGuideMap(cfs4);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("流动比率(倍)");
						extobjc1.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("速动比率(倍)");
						extobjc2.setAttr5(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("保守速动比率(倍)");
//					extobjc3.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("现金比率(倍)");
						extobjc4.setAttr5(rs.getCol2ValueString());
//					rs = (ReportSubject) reportMap.get("营运资本");
//					extobjc5.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("资产负债率(%)");
						extobjc6.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("调整后的资产负债率(%)");
						extobjc7.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("齿轮比率(刚性负债比率)(%)");
						extobjc8.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("产权比率(%)");
						extobjc9.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有形净值债务率(%)");
						extobjc10.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("利息保障倍数(倍)");
						extobjc11.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售毛利率(%)");
						extobjc12.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("营业利润率(%)");
						extobjc13.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("税前利润率(%)");
						extobjc14.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("销售净利率(%)");
						extobjc15.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("成本费用利润率(%)");
						extobjc16.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产收益率(%)");
						extobjc17.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净资产收益率(%)");
						extobjc18.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应收账款周转率(次)");
						extobjc19.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("存货周转率(次)");
						extobjc20.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("应付账款周转率(次)");
						extobjc21.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("净营业周期(天)");
						extobjc22.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("流动资产周转率(次)");
						extobjc23.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("固定资产周转率(次)");
						extobjc24.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("总资产周转率(次)");
						extobjc25.setAttr5(rs.getCol2ValueString());
					}
				}
			}
			m = JBOFactory.getFactory().getManager("jbo.finasys.TAX_PAY");
			String reportNo = fdm.getDetailNo(cfs);//当期报表编号
			q = m.createQuery("ReportNo = :reportNo and TaxType in ('01','02','04','99')").setParameter("reportNo", reportNo);
			List<BizObject> taxPays = q.getResultList();
			if(taxPays.size()>0){
				extobjc26 = new DocExtClass[taxPays.size()];
				for(int i=0;i<taxPays.size();i++){
					BizObject taxPay = taxPays.get(i);
					extobjc26[i] = new DocExtClass();
					String taxType = taxPay.getAttribute("TAXTYPE").getString();
					extobjc26[i].setAttr0(CodeManager.getItemName("TaxType", taxType));
					String taxBased = taxPay.getAttribute("TAXBASED").getString();
					extobjc26[i].setAttr1(CodeManager.getItemName("RateElements", taxBased));
					extobjc26[i].setAttr2(taxPay.getAttribute("TAXPAYDATE").getString());
					extobjc26[i].setAttr3(taxPay.getAttribute("BAILRATE").getString());
					extobjc26[i].setAttr4(DataConvert.toMoney(taxPay.getAttribute("BALANCE").getDouble()));
				}
			}
			//查询合计结果
			q = m.createQuery("select sum(BALANCE) as v.sumBal from o where ReportNo = :reportNo and TaxType in ('01','02','04','99')").setParameter("reportNo", reportNo);
			bo = q.getSingleResult();
			if(bo != null){
				ctotals = DataConvert.toMoney(bo.getAttribute("sumBal").getDouble());
			}
			//评级信息
			m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
			q = m.createQuery("customerno = :CustomerID").setParameter("CustomerID",customerID);
			List<BizObject> guarantys = q.getResultList();
			if(guarantys.size() >0){
				BizObjectQuery q1 = m.createQuery("select * from o where o.customerno = :CustomerID order by o.confirmdate desc").setParameter("CustomerID",customerID);
				bo = q1.getSingleResult();
				String sdate = bo.getAttribute("ConfirmDate").getString();
				extobjp = new DocExtClass[guarantys.size()];
				for(int i=0;i<guarantys.size();i++){
					BizObject guaranty = guarantys.get(i);
					extobjp[i] = new DocExtClass();
					extobjp[i].setAttr1(guaranty.getAttribute("RatingPerion").getString());
					extobjp[i].setAttr2(guaranty.getAttribute("ModeGrade01").getString());
					extobjp[i].setAttr3(guaranty.getAttribute("RatingGrade99").getString());
					if(sdate.equals(guaranty.getAttribute("ConfirmDate").getString())){
						extobjp[i].setAttr4("是");
					}else{
						extobjp[i].setAttr4("否");
					}
				}
			}
			CustomerFSRecord cfs1 = fdm.getRelativeYearReport(cfs,-1);
			String laReportNo = fdm.getDetailNo(cfs1);
			FinanceDetailManager fdem = new FinanceDetailManager();
			extobjf1 = new DocExtClass();
			m = JBOFactory.getFactory().getManager("jbo.finasys.NOTES_PAYABLE");
			q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",reportNo);
			bo = q.getSingleResult();
			double ych = 0,laych=0,sch=0,lasch=0;
			if(bo != null){
				ych = bo.getAttribute("amount1").getDouble();
				extobjf1.setAttr1(DataConvert.toMoney(ych));
			}
			q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",laReportNo);
			bo = q.getSingleResult();
			if(bo != null){
				laych = bo.getAttribute("amount1").getDouble();
				extobjf1.setAttr2(DataConvert.toMoney(laych));
			}
			q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",reportNo);
			bo = q.getSingleResult();
			if(bo != null){
				sch = bo.getAttribute("amount1").getDouble();
				extobjf1.setAttr4(DataConvert.toMoney(sch));
			}
			q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",laReportNo);
			bo = q.getSingleResult();
			if(bo != null){
				lasch = bo.getAttribute("amount1").getDouble();
				extobjf1.setAttr5(DataConvert.toMoney(lasch));
			}
			extobjf1.setAttr3(DataConvert.toMoney(ych-laych));
			extobjf1.setAttr6(DataConvert.toMoney(sch-lasch));
			extobjf1.setAttr7(DataConvert.toMoney(ych+sch));
			extobjf1.setAttr8(DataConvert.toMoney(laych+lasch));
			extobjf1.setAttr9(DataConvert.toMoney(ych-laych+sch-lasch));
			List<FinanceDetailRcv> rcvList1 = fdem.getDetailData(cfs, "应付帐款");
			double tmin = 0;
			double tmout = 0;
			double tyin = 0;
			double tyout = 0;
			double alls =0;
			
			if(rcvList1.size()>0){
				for(int i=0;i<rcvList1.size();i++){
					FinanceDetailRcv rece = rcvList1.get(i);
					if("3个月以内（含）".equals(rece.getDataType())){
						tmin = tmin + rece.getAmount();
					}else if("3个月~1年（含）".equals(rece.getDataType())){
						tmout = tmout + rece.getAmount();
					}else if("1~3年（含）".equals(rece.getDataType())){
						tyin = tyin + rece.getAmount();
					}else if("3年以上".equals(rece.getDataType())){
						tyout = tyout + rece.getAmount();
					}
				}
				alls = tmin + tmout + tyout + tyin;
				extobjf2.setAttr1(DataConvert.toMoney(tmin));
				extobjf2.setAttr4(String.format("%.0f",(tmin/alls)*100));
				extobjf3.setAttr1(DataConvert.toMoney(tmout));
				extobjf3.setAttr4(String.format("%.0f",(tmout/alls)*100));
				extobjf4.setAttr1(DataConvert.toMoney(tyin));
				extobjf4.setAttr4(String.format("%.0f",(tyin/alls)*100));
				extobjf5.setAttr1(DataConvert.toMoney(tyout));
				extobjf5.setAttr4(String.format("%.0f",(tyout/alls)*100));
				extobjf6.setAttr1(DataConvert.toMoney(alls));
			}
			
			List<FinanceDetailRcv> rcvList2 = fdem.getDetailData(cfs1, "应付帐款");
			double latmin = 0;
			double latmout = 0;
			double latyin = 0;
			double latyout = 0;
			double laalls =0;
			if(rcvList2.size()>0){
				for(int i=0;i<rcvList2.size();i++){
					FinanceDetailRcv rece = rcvList2.get(i);
					if("3个月以内（含）".equals(rece.getDataType())){
						latmin = latmin + rece.getAmount();
					}else if("3个月~1年（含）".equals(rece.getDataType())){
						latmout = latmout + rece.getAmount();
					}else if("1~3年（含）".equals(rece.getDataType())){
						latyin = latyin + rece.getAmount();
					}else if("3年以上".equals(rece.getDataType())){
						latyout = latyout + rece.getAmount();
					}
				}
				laalls = latmin + latmout + latyout + latyin;
				extobjf2.setAttr2(DataConvert.toMoney(latmin));
				extobjf2.setAttr3(DataConvert.toMoney(tmin-latmin));
				extobjf3.setAttr2(DataConvert.toMoney(latmout));
				extobjf3.setAttr3(DataConvert.toMoney(tmout-latmout));
				extobjf4.setAttr2(DataConvert.toMoney(latyin));
				extobjf4.setAttr3(DataConvert.toMoney(tyin-latyin));
				extobjf5.setAttr2(DataConvert.toMoney(latyout));
				extobjf5.setAttr3(DataConvert.toMoney(tyout-latyout));
				extobjf6.setAttr2(DataConvert.toMoney(laalls));
				extobjf6.setAttr3(DataConvert.toMoney(alls-laalls));
			}
			
			
			List<FinanceDetailRcv> rcvList3 = fdem.getDetailData(cfs, "其他应付帐款");
			double tmin1 = 0;
			double tmout1 = 0;
			double tyin1 = 0;
			double tyout1 = 0;
			double alls1 =0;
			if(rcvList3.size()>0){
				for(int i=0;i<rcvList3.size();i++){
					FinanceDetailRcv rece = rcvList3.get(i);
					if("3个月以内（含）".equals(rece.getDataType())){
						tmin1 = tmin1 + rece.getAmount();
					}else if("3个月~1年（含）".equals(rece.getDataType())){
						tmout1 = tmout1 + rece.getAmount();
					}else if("1~3年（含）".equals(rece.getDataType())){
						tyin1 = tyin1 + rece.getAmount();
					}else if("3年以上".equals(rece.getDataType())){
						tyout1 = tyout1 + rece.getAmount();
					}
				}
				alls1 = tmin1 + tmout1 + tyout1 + tyin1;
				extobjf8.setAttr1(DataConvert.toMoney(tmin1));
				extobjf8.setAttr4(String.format("%.0f",(tmin1/alls1)*100));
				extobjf9.setAttr1(DataConvert.toMoney(tmout1));
				extobjf9.setAttr4(String.format("%.0f",(tmout1/alls1)*100));
				extobjf10.setAttr1(DataConvert.toMoney(tyin1));
				extobjf10.setAttr4(String.format("%.0f",(tyin1/alls1)*100));
				extobjf11.setAttr1(DataConvert.toMoney(tyout1));
				extobjf11.setAttr4(String.format("%.0f",(tyout1/alls1)*100));
				extobjf12.setAttr1(DataConvert.toMoney(alls1));
			}
			
			List<FinanceDetailRcv> rcvList4 = fdem.getDetailData(cfs1, "其他应付帐款");
			double latmin1 = 0;
			double latmout1 = 0;
			double latyin1 = 0;
			double latyout1 = 0;
			double laalls1 =0;
			if(rcvList4.size()>0){
				for(int i=0;i<rcvList4.size();i++){
					FinanceDetailRcv rece = rcvList4.get(i);
					if("3个月以内（含）".equals(rece.getDataType())){
						latmin1 = latmin1 + rece.getAmount();
					}else if("3个月~1年（含）".equals(rece.getDataType())){
						latmout1 = latmout1 + rece.getAmount();
					}else if("1~3年（含）".equals(rece.getDataType())){
						latyin1 = latyin1 + rece.getAmount();
					}else if("3年以上".equals(rece.getDataType())){
						latyout1 = latyout1 + rece.getAmount();
					}
				}
				laalls1 = latmin1 + latmout1 + latyout1 + latyin1;
				extobjf8.setAttr2(DataConvert.toMoney(latmin1));
				extobjf8.setAttr3(DataConvert.toMoney(tmin1-latmin1));
				extobjf9.setAttr2(DataConvert.toMoney(latmout1));
				extobjf9.setAttr3(DataConvert.toMoney(tmout1-latmout1));
				extobjf10.setAttr2(DataConvert.toMoney(latyin1));
				extobjf10.setAttr3(DataConvert.toMoney(tyin1-latyin1));
				extobjf11.setAttr2(DataConvert.toMoney(latyout1));
				extobjf11.setAttr3(DataConvert.toMoney(tyout1-latyout1));
				extobjf12.setAttr2(DataConvert.toMoney(laalls1));
				extobjf12.setAttr3(DataConvert.toMoney(alls1-laalls1));
			}
			
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
			q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='01'").setParameter("REPORTNO",reportNo);
			List<BizObject> payables = q.getResultList();
			if(payables.size()>5){
				extobjf7 = new DocExtClass[5];
				for(int i=0;i<5;i++){
					BizObject payable = payables.get(i);
					extobjf7[i] = new DocExtClass();
					extobjf7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
					String currency = payable.getAttribute("CURRENCY").getString();
					extobjf7[i].setAttr2(CodeManager.getItemName("Currency", currency));
					extobjf7[i].setAttr3(payable.getAttribute("AMOUNT").getString());
					String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
					extobjf7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
					String law = payable.getAttribute("LAWSUIT").getString();
					extobjf7[i].setAttr5(CodeManager.getItemName("YesNo", law));
					String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
					extobjf7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
					String isRelative = payable.getAttribute("ISRELATIVE").getString();
					extobjf7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
				}
			}else if(payables.size()<=5){
				extobjf7 = new DocExtClass[payables.size()];
				for(int i=0;i<payables.size();i++){
					BizObject payable = payables.get(i);
					extobjf7[i] = new DocExtClass();
					extobjf7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
					String currency = payable.getAttribute("CURRENCY").getString();
					extobjf7[i].setAttr2(CodeManager.getItemName("Currency", currency));
					extobjf7[i].setAttr3(payable.getAttribute("AMOUNT").getString());
					String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
					extobjf7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
					String law = payable.getAttribute("LAWSUIT").getString();
					extobjf7[i].setAttr5(CodeManager.getItemName("YesNo", law));
					String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
					extobjf7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
					String isRelative = payable.getAttribute("ISRELATIVE").getString();
					extobjf7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
				}
			}
			q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='02'").setParameter("REPORTNO",reportNo);
			payables = q.getResultList();
			if(payables.size()>5){
				extobjf13 = new DocExtClass[5];
				for(int i=0;i<5;i++){
					BizObject payable = payables.get(i);
					extobjf13[i] = new DocExtClass();
					extobjf13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
					String currency = payable.getAttribute("CURRENCY").getString();
					extobjf13[i].setAttr2(CodeManager.getItemName("Currency", currency));
					extobjf13[i].setAttr3(payable.getAttribute("AMOUNT").getString());
					String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
					extobjf13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
					String law = payable.getAttribute("LAWSUIT").getString();
					extobjf13[i].setAttr5(CodeManager.getItemName("YesNo", law));
					String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
					extobjf13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
					String isRelative = payable.getAttribute("ISRELATIVE").getString();
					extobjf13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
				}
			}else if(payables.size()<=5){
				extobjf13 = new DocExtClass[payables.size()];
				for(int i=0;i<payables.size();i++){
					BizObject payable = payables.get(i);
					extobjf13[i] = new DocExtClass();
					extobjf13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
					String currency = payable.getAttribute("CURRENCY").getString();
					extobjf13[i].setAttr2(CodeManager.getItemName("Currency", currency));
					extobjf13[i].setAttr3(payable.getAttribute("AMOUNT").getString());
					String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
					extobjf13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
					String law = payable.getAttribute("LAWSUIT").getString();
					extobjf13[i].setAttr5(CodeManager.getItemName("YesNo", law));
					String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
					extobjf13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
					String isRelative = payable.getAttribute("ISRELATIVE").getString();
					extobjf13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
				}
			}
			
			CustomerFSRecord cfsr=fdm.getNewestReport(customerID);
			reportNo = fdm.getDetailNo(cfsr);//本期报表编号
			CustomerFSRecord cfsr1 = fdm.getRelativeYearReport(cfsr, -1);
			String lastReportNo = fdm.getDetailNo(cfsr1);//上年年报编号
			//货币资金分析
			double yamount = getMoney(reportNo, "010");
			double lsyamount = getMoney(lastReportNo, "010");
			write2.setAttr1(DataConvert.toMoney(yamount));
			write3.setAttr1(DataConvert.toMoney(lsyamount));
			write4.setAttr1(DataConvert.toMoney(yamount-lsyamount));
			double camount = getMoney(reportNo, "020");
			double lscamount = getMoney(lastReportNo, "020");
			write2.setAttr2(DataConvert.toMoney(camount));
			write3.setAttr2(DataConvert.toMoney(lscamount));
			write4.setAttr2(DataConvert.toMoney(camount-lscamount));
			double oamount = getMoney(reportNo, "030");
			double lsoamount = getMoney(lastReportNo, "030");
			write2.setAttr3(DataConvert.toMoney(oamount));
			write3.setAttr3(DataConvert.toMoney(lsoamount));
			write4.setAttr3(DataConvert.toMoney(oamount-lsoamount));
			write2.setAttr4(DataConvert.toMoney(yamount+camount+oamount));
			write3.setAttr4(DataConvert.toMoney(lsyamount+lscamount+lsoamount));
			write4.setAttr4(DataConvert.toMoney(yamount+camount+oamount-lsyamount-lscamount-lsoamount));
			// 应收帐款分析        总额
			String[] heji = getTotalData(reportNo, "01").split("/");
			double jamount = Double.parseDouble(heji[0]);
			double hamount = Double.parseDouble(heji[1]);
			String[] laheji = getTotalData(lastReportNo, "01").split("/");
			double lajamount = Double.parseDouble(laheji[0]);
			double lahamount = Double.parseDouble(laheji[1]);
			extobjy5.setAttr1(DataConvert.toMoney(jamount));
			extobjy5.setAttr2(DataConvert.toMoney(lajamount));
			extobjy5.setAttr3(DataConvert.toMoney(jamount-lajamount));
//			extobjy5.setAttr4(DataConvert.toMoney(hamount));
//			extobjy5.setAttr5(DataConvert.toMoney(lahamount));
//			extobjy5.setAttr6(DataConvert.toMoney(hamount-lahamount));
			//三个月内
			String[] thmin = getLastAccountAgeData(reportNo, "010", "01").split("/");
			double mijam = Double.parseDouble(thmin[0]);
			double miham = Double.parseDouble(thmin[1]);
			String[] lathmin = getLastAccountAgeData(lastReportNo, "010", "01").split("/");
			double lamijam = Double.parseDouble(lathmin[0]);
			double lamiham = Double.parseDouble(lathmin[1]);
			extobjy1.setAttr1(DataConvert.toMoney(mijam));
			extobjy1.setAttr2(DataConvert.toMoney(lamijam));
			extobjy1.setAttr3(DataConvert.toMoney(mijam-lamijam));
//			extobjy1.setAttr4(DataConvert.toMoney(miham));
//			extobjy1.setAttr5(DataConvert.toMoney(lamiham));
//			extobjy1.setAttr6(DataConvert.toMoney(miham-lamiham));
			if(mijam==0) extobjy1.setAttr7("0.00");
			else extobjy1.setAttr7(String.format("%.0f",(mijam/jamount)*100));
			//三个月到一年
			String[] oney = getLastAccountAgeData(reportNo, "020", "01").split("/");
			double oneyjam = Double.parseDouble(oney[0]);
			double oneyham = Double.parseDouble(oney[1]);
			String[] laoney = getLastAccountAgeData(lastReportNo, "020", "01").split("/");
			double laoyjam = Double.parseDouble(laoney[0]);
			double laoyham = Double.parseDouble(laoney[1]);
			extobjy2.setAttr1(DataConvert.toMoney(oneyjam));
			extobjy2.setAttr2(DataConvert.toMoney(laoyjam));
			extobjy2.setAttr3(DataConvert.toMoney(oneyjam-laoyjam));
//			extobjy2.setAttr4(DataConvert.toMoney(oneyham));
//			extobjy2.setAttr5(DataConvert.toMoney(laoyham));
//			extobjy2.setAttr6(DataConvert.toMoney(oneyham-laoyham));
			if(oneyjam==0){
				extobjy2.setAttr7("0.00");
			}else{
				extobjy2.setAttr7(String.format("%.0f",(oneyjam/jamount)*100));
			}
			//1~3年
			String[] onethy = getLastAccountAgeData(reportNo, "030", "01").split("/");
			double onethyjam = Double.parseDouble(onethy[0]);
			double onethyham = Double.parseDouble(onethy[1]);
			String[] laonethy = getLastAccountAgeData(lastReportNo, "030", "01").split("/");
			double laothyjam = Double.parseDouble(laonethy[0]);
			double laothyham = Double.parseDouble(laonethy[1]);
			extobjy3.setAttr1(DataConvert.toMoney(onethyjam));
			extobjy3.setAttr2(DataConvert.toMoney(onethyham));
			extobjy3.setAttr3(DataConvert.toMoney(onethyjam-onethyham));
//			extobjy3.setAttr4(DataConvert.toMoney(laothyjam));
//			extobjy3.setAttr5(DataConvert.toMoney(laothyham));
//			extobjy3.setAttr6(DataConvert.toMoney(laothyjam-laothyham));
			if(onethyjam==0){
				extobjy3.setAttr7("0.00");
			}else{
				extobjy3.setAttr7(String.format("%.0f",(onethyjam/jamount)*100));
			}
			//3年以上
			String[] thyout = getLastAccountAgeData(reportNo, "030", "01").split("/");
			double thyoutjam = Double.parseDouble(thyout[0]);
			double thyoutham = Double.parseDouble(thyout[1]);
			String[] lathyout = getLastAccountAgeData(lastReportNo, "030", "01").split("/");
			double lathyoutjam = Double.parseDouble(lathyout[0]);
			double lathyoutham = Double.parseDouble(lathyout[1]);
			extobjy4.setAttr1(DataConvert.toMoney(thyoutjam));
			extobjy4.setAttr2(DataConvert.toMoney(thyoutham));
			extobjy4.setAttr3(DataConvert.toMoney(thyoutjam-thyoutham));
//			extobjy4.setAttr4(DataConvert.toMoney(lathyoutjam));
//			extobjy4.setAttr5(DataConvert.toMoney(lathyoutham));
//			extobjy4.setAttr6(DataConvert.toMoney(lathyoutjam-lathyoutham));
			if(thyoutjam==0){
				extobjy4.setAttr7("0.00");
			}else{
				extobjy4.setAttr7(String.format("%.0f",(thyoutjam/jamount)*100));
			}
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
		    q = m.createQuery("REPORTNO=:REPORTNO AND RECEIVETYPE='01' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
		    List<BizObject> receives = q.getResultList();
		    if(receives.size()>0&&receives.size()<=5){
		    	extobjy6 = new DocExtClass[receives.size()];
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
		    		extobjy6[i].setAttr6(String.format("%.0f",(amount/jamount)*100));
		    		String isRelative = receive.getAttribute("ISRELATIVE").getString();
		    		extobjy6[i].setAttr7(CodeManager.getItemName("YesNo",isRelative));
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
		    		extobjy6[i].setAttr6(String.format("%.0f",(amount/jamount)*100));
		    		String isRelative = receive.getAttribute("ISRELATIVE").getString();
		    		extobjy6[i].setAttr7(CodeManager.getItemName("YesNo",isRelative));
		    	}
		    }
		    //其他应收账款
		    String[] oheji = getTotalData(reportNo, "02").split("/");
			double ojamount = Double.parseDouble(oheji[0]);
			double ohamount = Double.parseDouble(oheji[1]);
			String[] olaheji = getTotalData(lastReportNo, "01").split("/");
			double olajamount = Double.parseDouble(olaheji[0]);
			double olahamount = Double.parseDouble(olaheji[1]);
			extobjq5.setAttr1(DataConvert.toMoney(ojamount));
			extobjq5.setAttr2(DataConvert.toMoney(olajamount));
			extobjq5.setAttr3(DataConvert.toMoney(ojamount-olajamount));
			//三个月内
			String[] othmin = getLastAccountAgeData(reportNo, "010", "02").split("/");
			double omijam = Double.parseDouble(othmin[0]);
			double omiham = Double.parseDouble(othmin[1]);
			String[] olathmin = getLastAccountAgeData(lastReportNo, "010", "02").split("/");
			double olamijam = Double.parseDouble(olathmin[0]);
			double olamiham = Double.parseDouble(olathmin[1]);
			extobjq1.setAttr1(DataConvert.toMoney(omijam));
			extobjq1.setAttr2(DataConvert.toMoney(olamijam));
			extobjq1.setAttr3(DataConvert.toMoney(omijam-olamijam));
//			extobjq1.setAttr4(DataConvert.toMoney(omiham));
//			extobjq1.setAttr5(DataConvert.toMoney(olamiham));
//			extobjq1.setAttr6(DataConvert.toMoney(omiham-olamiham));
			if(omijam==0){
				extobjq1.setAttr7("0.00");
			}else{
				extobjq1.setAttr7(String.format("%.0f",(omijam/ojamount)*100));
			}
			//三个月到一年
			String[] ooney = getLastAccountAgeData(reportNo, "020", "02").split("/");
			double ooneyjam = Double.parseDouble(ooney[0]);
			double ooneyham = Double.parseDouble(ooney[1]);
			String[] olaoney = getLastAccountAgeData(lastReportNo, "020", "02").split("/");
			double olaoyjam = Double.parseDouble(olaoney[0]);
			double olaoyham = Double.parseDouble(olaoney[1]);
			extobjq2.setAttr1(DataConvert.toMoney(ooneyjam));
			extobjq2.setAttr2(DataConvert.toMoney(olaoyjam));
			extobjq2.setAttr3(DataConvert.toMoney(ooneyjam-olaoyjam));
//			extobjq2.setAttr4(DataConvert.toMoney(ooneyham));
//			extobjq2.setAttr5(DataConvert.toMoney(olaoyham));
//			extobjq2.setAttr6(DataConvert.toMoney(ooneyham-olaoyham));
			if(ooneyjam==0){
				extobjq2.setAttr7("0.00");
			}else{
				extobjq2.setAttr7(String.format("%.0f",(ooneyjam/ojamount)*100));
			}
			//1~3年
			String[] oonethy = getLastAccountAgeData(reportNo, "030", "02").split("/");
			double oonethyjam = Double.parseDouble(oonethy[0]);
			double oonethyham = Double.parseDouble(oonethy[1]);
			String[] olaonethy = getLastAccountAgeData(lastReportNo, "030", "02").split("/");
			double olaothyjam = Double.parseDouble(olaonethy[0]);
			double olaothyham = Double.parseDouble(olaonethy[1]);
			extobjq3.setAttr1(DataConvert.toMoney(oonethyjam));
			extobjq3.setAttr2(DataConvert.toMoney(oonethyham));
			extobjq3.setAttr3(DataConvert.toMoney(oonethyjam-oonethyham));
//			extobjq3.setAttr4(DataConvert.toMoney(olaothyjam));
//			extobjq3.setAttr5(DataConvert.toMoney(olaothyham));
//			extobjq3.setAttr6(DataConvert.toMoney(olaothyjam-olaothyham));
			if(oonethyjam==0){
				extobjq3.setAttr7("0.00");
			}else{
				extobjq3.setAttr7(String.format("%.0f",(oonethyjam/ojamount)*100));
			}
			//3年以上
			String[] othyout = getLastAccountAgeData(reportNo, "030", "02").split("/");
			double othyoutjam = Double.parseDouble(othyout[0]);
			double othyoutham = Double.parseDouble(othyout[1]);
			String[] olathyout = getLastAccountAgeData(lastReportNo, "030", "02").split("/");
			double olathyoutjam = Double.parseDouble(olathyout[0]);
			double olathyoutham = Double.parseDouble(olathyout[1]);
			extobjq4.setAttr1(DataConvert.toMoney(othyoutjam));
			extobjq4.setAttr2(DataConvert.toMoney(othyoutham));
			extobjq4.setAttr3(DataConvert.toMoney(othyoutjam-othyoutham));
//			extobjq4.setAttr4(DataConvert.toMoney(olathyoutjam));
//			extobjq4.setAttr5(DataConvert.toMoney(olathyoutham));
//			extobjq4.setAttr6(DataConvert.toMoney(olathyoutjam-olathyoutham));
			extobjq4.setAttr7(String.format("%.0f",(othyoutjam/ojamount)*100));
			m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_RECEIVABLE");
		    q = m.createQuery("REPORTNO=:REPORTNO AND RECEIVETYPE='02' order by AMOUNT desc").setParameter("REPORTNO", reportNo);
		    List<BizObject> oreceives = q.getResultList();
		    if(oreceives.size()>0&&oreceives.size()<=5){
		    	extobjq6 = new DocExtClass[oreceives.size()];
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
		    		extobjq6[i].setAttr6(String.format("%.0f",(amount/ojamount)*100));
		    		String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
		    		extobjq6[i].setAttr7(CodeManager.getItemName("YesNo",isRelative));
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
		    		extobjq6[i].setAttr6(String.format("%.0f",(amount/ojamount)*100));
		    		String isRelative = oreceive.getAttribute("ISRELATIVE").getString();
		    		extobjq6[i].setAttr7(CodeManager.getItemName("YesNo",isRelative));
		    	}
		    }
		    
			//预付帐款分析
			FinanceDetailManager detmgn = new FinanceDetailManager();
			List<FinanceDetailRcv> rcvList = detmgn.getDetailData(cfsr, "预付帐款");
			if(rcvList.size()>0){
				extobj1 = new DocExtClass[rcvList.size()];
				double tota = 0;
				for(int i=0;i<rcvList.size();i++){
					FinanceDetailRcv fdr = rcvList.get(i);
					tota = fdr.getAmount() + tota;
				}
				for(int i=0;i<rcvList.size();i++){
					extobj1[i] = new DocExtClass();
					FinanceDetailRcv fdr = rcvList.get(i);
					extobj1[i].setAttr1(fdr.getDataName());
					extobj1[i].setAttr2(DataConvert.toMoney(fdr.getAmount()));
					extobj1[i].setAttr3(String.format("%.0f",(fdr.getAmount()/tota)*100));//与本企业关系暂时没有获得
				}
				totals = DataConvert.toMoney(tota);
			}
			//存货分析
			rcvList = detmgn.getDetailData(cfsr, "存货信息");
			if(rcvList.size()>0){
				extobj2 = new DocExtClass[rcvList.size()];
				double tota = 0;
				for(int i=0;i<rcvList.size();i++){
					FinanceDetailRcv fdr = rcvList.get(i);
					tota = fdr.getAmount() + tota;
				}
				for(int i=0;i<rcvList.size();i++){
					extobj2[i] = new DocExtClass();
					FinanceDetailRcv fdr = rcvList.get(i);
					extobj2[i].setAttr0(fdr.getDataType());
					extobj2[i].setAttr1(fdr.getDataName());
					extobj2[i].setAttr2(String.format("%.0f",(fdr.getAmount()/tota)*100));
					extobj2[i].setAttr3(DataConvert.toMoney(fdr.getAmount()));
				}
				totals1 = DataConvert.toMoney(tota);
			}
			//固定资产分析
		    m = JBOFactory.getFactory().getManager("jbo.finasys.FIXED_ASSETS");
		    q = m.createQuery("select sum(ACCOUNTVALUE) as v.total2 from o where ReportNo = :reportNo").setParameter("reportNo", reportNo);
		    bo = q.getSingleResult();
		    double total2 = bo.getAttribute("total2").getDouble();
		    totals2 = total2 + "";
		    q = m.createQuery("ReportNo = :reportNo").setParameter("reportNo", reportNo);
			List<BizObject> assets = q.getResultList();
			if(assets.size()>0){
				extobj3 = new DocExtClass[assets.size()];
				for(int i=0;i<assets.size();i++){
					extobj3[i] = new DocExtClass();
					BizObject asset = assets.get(i);
					extobj3[i].setAttr0(asset.getAttribute("ASSETNAME").getString());
					String assetType = asset.getAttribute("ASSETTYPE").getString();
					extobj3[i].setAttr1(CodeManager.getItemName("FixedAssetType", assetType));
					extobj3[i].setAttr2(DataConvert.toMoney(asset.getAttribute("ACCOUNTVALUE").getDouble()));
					double dd = asset.getAttribute("ACCOUNTVALUE").getDouble();
					extobj3[i].setAttr3(String.format("%.0f",(dd/total2)*100));
					extobj3[i].setAttr4(DataConvert.toMoney(asset.getAttribute("NETVALUE").getDouble()));
					String depMethod = asset.getAttribute("DEPREMETHOD").getString();
					extobj3[i].setAttr5(CodeManager.getItemName("DepreMethod", depMethod));
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
			if(assets.size()>0){
				extobj4 = new DocExtClass[assets.size()];
				for(int i=0;i<assets.size();i++){
					extobj4[i] = new DocExtClass();
					BizObject asset = assets.get(i);
					extobj4[i].setAttr0(asset.getAttribute("ASSETNAME").getString());
					String assetType = asset.getAttribute("ASSETTYPE").getString();
					extobj4[i].setAttr1(CodeManager.getItemName("IntanAssetType", assetType));
					extobj4[i].setAttr2(DataConvert.toMoney(asset.getAttribute("ACCOUNTVALUE").getDouble()));
					double dd = asset.getAttribute("ACCOUNTVALUE").getDouble();
					extobj4[i].setAttr3(String.format("%.0f",(dd/total2)*100));
					extobj4[i].setAttr4(DataConvert.toMoney(asset.getAttribute("ACCEPTVALUE").getDouble()));
					//没有评估方法字段
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void getOld(){//旧会计准则报表
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("货币资金");
				extobjz1.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("短期投资");
				extobjz2.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：短期投资跌价准备");
				extobjz3.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("短期投资净额");
				extobjz4.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收票据");
				extobjz5.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收股利");
				extobjz6.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收利息");
				extobjz7.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收账款");
				extobjz8.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：坏账准备");
				extobjz9.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收账款净额");
				extobjz10.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他应收款");
				extobjz11.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预付账款");
				extobjz12.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收补贴款");
				extobjz13.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("存货");
				extobjz14.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：存货跌价准备");
				extobjz15.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("存货净额");
				extobjz16.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("待摊费用");
				extobjz17.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("待处理流动资产净损失");
				extobjz18.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("一年内到期的长期流动资产净损失");
				extobjz19.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他流动资产");
				extobjz20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("流动资产合计");
				extobjz21.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期股权投资");
				extobjz22.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期债权投资");
				extobjz23.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：长期投资减值准备(包括股权、债权、减值准备)");
				extobjz24.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期投资净额");
				extobjz25.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：合并价差");
				extobjz26.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产原价");
				extobjz27.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：累计折旧");
				extobjz28.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产净值");
				extobjz29.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：固定资产减值准备");
				extobjz30.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产净额");
				extobjz31.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("工程物资");
				extobjz32.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("在建工程");
				extobjz33.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产清理");
				extobjz34.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("待处理固定资产净损失");
				extobjz35.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产合计");
				extobjz36.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("无形资产");
				extobjz37.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("开办费");
				extobjz38.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期待摊费用");
				extobjz39.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他长期资产");
				extobjz40.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("无形及其他资产合计");
				extobjz41.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("递延税款借项");
				extobjz42.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产合计");
				extobjz43.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("短期借款");
				extobjz44.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付票据");
				extobjz45.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付账款");
				extobjz46.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预收账款");
				extobjz47.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("代销商品款");
				extobjz48.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付工资");
				extobjz49.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付福利费");
				extobjz50.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付股利");
				extobjz51.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应交税金");
				extobjz52.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他应交款");
				extobjz53.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他应付款");
				extobjz54.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预提费用");
				extobjz55.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预计负债");
				extobjz56.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("一年内到期的长期负债");
				extobjz57.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他流动负债");
				extobjz58.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("流动负债合计");
				extobjz59.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期借款");
				extobjz60.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付债券");
				extobjz61.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期应付款");
				extobjz62.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("专项应付款");
				extobjz63.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他长期负债");
				extobjz64.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期负债合计");
				extobjz65.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("递延税款贷项");
				extobjz66.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("负债合计");
				extobjz67.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东权益");
				extobjz68.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("实收资本(或股本)净额");
				extobjz69.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资本公积");
				extobjz70.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("盈余公积");
				extobjz71.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：法定公益金");
				extobjz72.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("未分配利润");
				extobjz73.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("外币报表折算差额");
				extobjz74.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("所有者权益合计");
				extobjz75.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("负债和所有者权益合计");
				extobjz76.setAttr1(rs.getCol2IntString());
			}
		}
		
		CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
		if(cfs1 != null) {
			if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
			double d1;
			Map reportMap1 = financedata.getAssetMap(cfs1);
			if(reportMap1.size()>0){
				rs = (ReportSubject) reportMap1.get("货币资金");
				extobjz1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz1.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz1.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("短期投资");
				extobjz2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz2.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz2.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：短期投资跌价准备");
				extobjz3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz3.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz3.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("短期投资净额");
				extobjz4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz4.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz4.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收票据");
				extobjz5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz5.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz5.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收股利");
				extobjz6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz6.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz6.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收利息");
				extobjz7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz7.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz7.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收账款");
				extobjz8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz8.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz8.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：坏账准备");
				extobjz9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz9.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz9.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收账款净额");
				extobjz10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz10.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz10.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他应收款");
				extobjz11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz11.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz11.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预付账款");
				extobjz12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz12.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz12.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收补贴款");
				extobjz13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz13.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz13.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("存货");
				extobjz14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz14.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz14.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：存货跌价准备");
				extobjz15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz15.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz15.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("存货净额");
				extobjz16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz16.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz16.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("待摊费用");
				extobjz17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz17.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz17.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("待处理流动资产净损失");
				extobjz18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz18.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz18.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("一年内到期的长期流动资产净损失");
				extobjz19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz19.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz19.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他流动资产");
				extobjz20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz20.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz20.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("流动资产合计");
				extobjz21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz21.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz21.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期股权投资");
				extobjz22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz22.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz22.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期债权投资");
				extobjz23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz23.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz23.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：长期投资减值准备(包括股权、债权、减值准备)");
				extobjz24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz24.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz24.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期投资净额");
				extobjz25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz25.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz25.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其中：合并价差");
				extobjz26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz26.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz26.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产原价");
				extobjz27.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz27.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz27.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：累计折旧");
				extobjz28.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz28.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz28.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产净值");
				extobjz29.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz29.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz29.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：固定资产减值准备");
				extobjz30.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz30.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz30.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产净额");
				extobjz31.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz31.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz31.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("工程物资");
				extobjz32.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz32.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz32.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("在建工程");
				extobjz33.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz33.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz33.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产清理");
				extobjz34.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz34.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz34.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("待处理固定资产净损失");
				extobjz35.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz35.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz35.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产合计");
				extobjz36.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz36.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz36.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("无形资产");
				extobjz37.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz37.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz37.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("开办费");
				extobjz38.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz38.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz38.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期待摊费用");
				extobjz39.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz39.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz39.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他长期资产");
				extobjz40.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz40.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz40.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("无形及其他资产合计");
				extobjz41.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz41.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz41.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("递延税款借项");
				extobjz42.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz42.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz42.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("资产合计");
				extobjz43.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz43.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz43.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("短期借款");
				extobjz44.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz44.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz44.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付票据");
				extobjz45.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz45.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz45.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付账款");
				extobjz46.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz46.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz46.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预收账款");
				extobjz47.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz47.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz47.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("代销商品款");
				extobjz48.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz48.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz48.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz48.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz48.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付工资");
				extobjz49.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz49.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz49.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz49.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz49.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付福利费");
				extobjz50.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz50.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz50.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz50.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz50.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付股利");
				extobjz51.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz51.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz51.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz51.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz51.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应交税金");
				extobjz52.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz52.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz52.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz52.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz52.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他应交款");
				extobjz53.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz53.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz53.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz53.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz53.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他应付款");
				extobjz54.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz54.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz54.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz54.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz54.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预提费用");
				extobjz55.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz55.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz55.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz55.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz55.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预计负债");
				extobjz56.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz56.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz56.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz56.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz56.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("一年内到期的长期负债");
				extobjz57.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz57.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz57.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz57.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz57.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他流动负债");
				extobjz58.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz58.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz58.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz58.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz58.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("流动负债合计");
				extobjz59.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz59.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz59.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz59.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz59.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期借款");
				extobjz60.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz60.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz60.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz60.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz60.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付债券");
				extobjz61.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz61.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz61.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz61.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz61.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期应付款");
				extobjz62.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz62.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz62.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz62.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz62.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("专项应付款");
				extobjz63.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz63.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz63.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz63.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz63.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他长期负债");
				extobjz64.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz64.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz64.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz64.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz64.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期负债合计");
				extobjz65.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz65.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz65.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz65.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz65.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("递延税款贷项");
				extobjz66.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz66.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz66.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz66.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz66.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("负债合计");
				extobjz67.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz67.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz67.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz67.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz67.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("少数股东权益");
				extobjz68.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz68.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz68.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz68.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz68.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("实收资本(或股本)净额");
				extobjz69.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz69.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz69.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz69.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz69.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("资本公积");
				extobjz70.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz70.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz70.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz70.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz70.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("盈余公积");
				extobjz71.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz71.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz71.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz71.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz71.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其中：法定公益金");
				extobjz72.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz72.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz72.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz72.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz72.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("未分配利润");
				extobjz73.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz73.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz73.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz73.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz73.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("外币报表折算差额");
				extobjz74.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz74.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz74.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz74.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz74.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("所有者权益合计");
				extobjz75.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz75.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz75.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz75.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz75.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("负债和所有者权益合计");
				extobjz76.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz76.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz76.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz76.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz76.setAttr6("");
				}
			}
		}
		
		CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上年末
		if(cfs2 != null){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
			Map reportMap2 = financedata.getAssetMap(cfs2);
			if(reportMap2.size()>0){
				rs = (ReportSubject) reportMap2.get("货币资金");
				extobjz1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("短期投资");
				extobjz2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：短期投资跌价准备");
				extobjz3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("短期投资净额");
				extobjz4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收票据");
				extobjz5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收股利");
				extobjz6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收利息");
				extobjz7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收账款");
				extobjz8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：坏账准备");
				extobjz9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收账款净额");
				extobjz10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他应收款");
				extobjz11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预付账款");
				extobjz12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收补贴款");
				extobjz13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("存货");
				extobjz14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：存货跌价准备");
				extobjz15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("存货净额");
				extobjz16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("待摊费用");
				extobjz17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("待处理流动资产净损失");
				extobjz18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("一年内到期的长期流动资产净损失");
				extobjz19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他流动资产");
				extobjz20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("流动资产合计");
				extobjz21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期股权投资");
				extobjz22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期债权投资");
				extobjz23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：长期投资减值准备(包括股权、债权、减值准备)");
				extobjz24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期投资净额");
				extobjz25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其中：合并价差");
				extobjz26.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产原价");
				extobjz27.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：累计折旧");
				extobjz28.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产净值");
				extobjz29.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：固定资产减值准备");
				extobjz30.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产净额");
				extobjz31.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("工程物资");
				extobjz32.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("在建工程");
				extobjz33.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产清理");
				extobjz34.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("待处理固定资产净损失");
				extobjz35.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产合计");
				extobjz36.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("无形资产");
				extobjz37.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("开办费");
				extobjz38.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期待摊费用");
				extobjz39.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他长期资产");
				extobjz40.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("无形及其他资产合计");
				extobjz41.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("递延税款借项");
				extobjz42.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("资产合计");
				extobjz43.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("短期借款");
				extobjz44.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付票据");
				extobjz45.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付账款");
				extobjz46.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预收账款");
				extobjz47.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("代销商品款");
				extobjz48.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付工资");
				extobjz49.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付福利费");
				extobjz50.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付股利");
				extobjz51.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应交税金");
				extobjz52.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他应交款");
				extobjz53.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他应付款");
				extobjz54.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预提费用");
				extobjz55.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预计负债");
				extobjz56.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("一年内到期的长期负债");
				extobjz57.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他流动负债");
				extobjz58.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("流动负债合计");
				extobjz59.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期借款");
				extobjz60.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付债券");
				extobjz61.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期应付款");
				extobjz62.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("专项应付款");
				extobjz63.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他长期负债");
				extobjz64.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期负债合计");
				extobjz65.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("递延税款贷项");
				extobjz66.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("负债合计");
				extobjz67.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("少数股东权益");
				extobjz68.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("实收资本(或股本)净额");
				extobjz69.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("资本公积");
				extobjz70.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("盈余公积");
				extobjz71.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其中：法定公益金");
				extobjz72.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("未分配利润");
				extobjz73.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("外币报表折算差额");
				extobjz74.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("所有者权益合计");
				extobjz75.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("负债和所有者权益合计");
				extobjz76.setAttr3(rs.getCol2IntString());
			}
		}
		
		CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上两年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs3);
			if(reportMap3.size()>0){
				rs = (ReportSubject) reportMap3.get("货币资金");
				extobjz1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期投资");
				extobjz2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：短期投资跌价准备");
				extobjz3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期投资净额");
				extobjz4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收票据");
				extobjz5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收股利");
				extobjz6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收利息");
				extobjz7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款");
				extobjz8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：坏账准备");
				extobjz9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款净额");
				extobjz10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应收款");
				extobjz11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预付账款");
				extobjz12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收补贴款");
				extobjz13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货");
				extobjz14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：存货跌价准备");
				extobjz15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货净额");
				extobjz16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待摊费用");
				extobjz17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待处理流动资产净损失");
				extobjz18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的长期流动资产净损失");
				extobjz19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动资产");
				extobjz20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动资产合计");
				extobjz21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期股权投资");
				extobjz22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期债权投资");
				extobjz23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：长期投资减值准备(包括股权、债权、减值准备)");
				extobjz24.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期投资净额");
				extobjz25.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其中：合并价差");
				extobjz26.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产原价");
				extobjz27.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：累计折旧");
				extobjz28.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产净值");
				extobjz29.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：固定资产减值准备");
				extobjz30.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产净额");
				extobjz31.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("工程物资");
				extobjz32.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("在建工程");
				extobjz33.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产清理");
				extobjz34.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待处理固定资产净损失");
				extobjz35.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产合计");
				extobjz36.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形资产");
				extobjz37.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("开办费");
				extobjz38.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期待摊费用");
				extobjz39.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他长期资产");
				extobjz40.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形及其他资产合计");
				extobjz41.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延税款借项");
				extobjz42.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资产合计");
				extobjz43.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期借款");
				extobjz44.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付票据");
				extobjz45.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付账款");
				extobjz46.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预收账款");
				extobjz47.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("代销商品款");
				extobjz48.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付工资");
				extobjz49.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付福利费");
				extobjz50.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付股利");
				extobjz51.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应交税金");
				extobjz52.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应交款");
				extobjz53.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应付款");
				extobjz54.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预提费用");
				extobjz55.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预计负债");
				extobjz56.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的长期负债");
				extobjz57.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动负债");
				extobjz58.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动负债合计");
				extobjz59.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期借款");
				extobjz60.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付债券");
				extobjz61.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应付款");
				extobjz62.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("专项应付款");
				extobjz63.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他长期负债");
				extobjz64.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期负债合计");
				extobjz65.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延税款贷项");
				extobjz66.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债合计");
				extobjz67.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("少数股东权益");
				extobjz68.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("实收资本(或股本)净额");
				extobjz69.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资本公积");
				extobjz70.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("盈余公积");
				extobjz71.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其中：法定公益金");
				extobjz72.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("未分配利润");
				extobjz73.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("外币报表折算差额");
				extobjz74.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("所有者权益合计");
				extobjz75.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债和所有者权益合计");
				extobjz76.setAttr4(rs.getCol2IntString());
			}
		}	
		
		CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//上三年末
		if(cfs4 != null){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs4);
			if(reportMap3.size()>0){
				rs = (ReportSubject) reportMap3.get("货币资金");
				extobjz1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期投资");
				extobjz2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：短期投资跌价准备");
				extobjz3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期投资净额");
				extobjz4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收票据");
				extobjz5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收股利");
				extobjz6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收利息");
				extobjz7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款");
				extobjz8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：坏账准备");
				extobjz9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款净额");
				extobjz10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应收款");
				extobjz11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预付账款");
				extobjz12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收补贴款");
				extobjz13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货");
				extobjz14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：存货跌价准备");
				extobjz15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货净额");
				extobjz16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待摊费用");
				extobjz17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待处理流动资产净损失");
				extobjz18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的长期流动资产净损失");
				extobjz19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动资产");
				extobjz20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动资产合计");
				extobjz21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期股权投资");
				extobjz22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期债权投资");
				extobjz23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：长期投资减值准备(包括股权、债权、减值准备)");
				extobjz24.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期投资净额");
				extobjz25.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其中：合并价差");
				extobjz26.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产原价");
				extobjz27.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：累计折旧");
				extobjz28.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产净值");
				extobjz29.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：固定资产减值准备");
				extobjz30.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产净额");
				extobjz31.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("工程物资");
				extobjz32.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("在建工程");
				extobjz33.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产清理");
				extobjz34.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("待处理固定资产净损失");
				extobjz35.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产合计");
				extobjz36.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形资产");
				extobjz37.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("开办费");
				extobjz38.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期待摊费用");
				extobjz39.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他长期资产");
				extobjz40.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形及其他资产合计");
				extobjz41.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延税款借项");
				extobjz42.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资产合计");
				extobjz43.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期借款");
				extobjz44.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付票据");
				extobjz45.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付账款");
				extobjz46.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预收账款");
				extobjz47.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("代销商品款");
				extobjz48.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付工资");
				extobjz49.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付福利费");
				extobjz50.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付股利");
				extobjz51.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应交税金");
				extobjz52.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应交款");
				extobjz53.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应付款");
				extobjz54.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预提费用");
				extobjz55.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预计负债");
				extobjz56.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的长期负债");
				extobjz57.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动负债");
				extobjz58.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动负债合计");
				extobjz59.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期借款");
				extobjz60.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付债券");
				extobjz61.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应付款");
				extobjz62.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("专项应付款");
				extobjz63.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他长期负债");
				extobjz64.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期负债合计");
				extobjz65.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延税款贷项");
				extobjz66.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债合计");
				extobjz67.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("少数股东权益");
				extobjz68.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("实收资本(或股本)净额");
				extobjz69.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资本公积");
				extobjz70.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("盈余公积");
				extobjz71.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其中：法定公益金");
				extobjz72.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("未分配利润");
				extobjz73.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("外币报表折算差额");
				extobjz74.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("所有者权益合计");
				extobjz75.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债和所有者权益合计");
				extobjz76.setAttr5(rs.getCol2IntString());
			}
		}
		//损益表
		if(!StringX.isSpace(cfs.getReportDate()))extobjl0.setAttr1("("+cfs.getReportDate()+")");
		Map reportMap = financedata.getLossMap(cfs);
		if(reportMap.size()>0){
			rs = (ReportSubject) reportMap.get("一、主营业务收入");
			extobjl1.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：折扣与折让");
			extobjl2.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("二、主营业务收入净额");
			extobjl3.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("主营业务成本");
			extobjl4.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：主营业务税金及附加");
			extobjl5.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("三、主营业务利润");
			extobjl6.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：其他业务利润");
			extobjl7.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：存货跌价损失");
			extobjl8.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("营业费用");
			extobjl9.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("管理费用");
			extobjl10.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("财务费用(含汇兑损益)");
			extobjl11.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("销售费用");
			extobjl12.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("四、营业利润");
			extobjl13.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：投资收益");
			extobjl14.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("补贴收入");
			extobjl15.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("营业外收入");
			extobjl16.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：营业外支出");
			extobjl17.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：以前年度损益调整");
			extobjl18.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("五、利润总额");
			extobjl19.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：所得税");
			extobjl20.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("少数股东损益");
			extobjl21.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：未确认的投资损失");
			extobjl22.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：财政返还(含所得税返还)");
			extobjl23.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("六、净利润");
			extobjl24.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("应付优先股股利");
			extobjl25.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("应付普通股股利");
			extobjl26.setAttr1(rs.getCol2IntString());
		}
		
		cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
		if(cfs1 != null){
			if(!StringX.isSpace(cfs1.getReportDate()))extobjl0.setAttr2("("+cfs1.getReportDate()+")");
			double d1;
			reportMap = financedata.getLossMap(cfs1);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、主营业务收入");
				extobjl1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl1.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：折扣与折让");
				extobjl2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl2.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("二、主营业务收入净额");
				extobjl3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl3.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("主营业务成本");
				extobjl4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl4.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：主营业务税金及附加");
				extobjl5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl5.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("三、主营业务利润");
				extobjl6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl6.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl7.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：存货跌价损失");
				extobjl8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl8.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("营业费用");
				extobjl9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl9.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl10.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("财务费用(含汇兑损益)");
				extobjl11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl11.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl12.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl13.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：投资收益");
				extobjl14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl14.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("补贴收入");
				extobjl15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl15.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("营业外收入");
				extobjl16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl16.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl17.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：以前年度损益调整");
				extobjl18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl18.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("五、利润总额");
				extobjl19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl19.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl19.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl20.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl20.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl21.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：未确认的投资损失");
				extobjl22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl22.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl22.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：财政返还(含所得税返还)");
				extobjl23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl23.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl23.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("六、净利润");
				extobjl24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl24.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl24.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl25.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl25.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl26.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl26.setAttr6("");
				}
			}
		}
		
		cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
		if(cfs2 != null){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjl0.setAttr3("("+cfs2.getReportDate()+")");
			reportMap = financedata.getLossMap(cfs2);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、主营业务收入");
				extobjl1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：折扣与折让");
				extobjl2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、主营业务收入净额");
				extobjl3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("主营业务成本");
				extobjl4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：主营业务税金及附加");
				extobjl5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、主营业务利润");
				extobjl6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：存货跌价损失");
				extobjl8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业费用");
				extobjl9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用(含汇兑损益)");
				extobjl11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：投资收益");
				extobjl14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("补贴收入");
				extobjl15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业外收入");
				extobjl16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：以前年度损益调整");
				extobjl18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("五、利润总额");
				extobjl19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：未确认的投资损失");
				extobjl22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：财政返还(含所得税返还)");
				extobjl23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("六、净利润");
				extobjl24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl26.setAttr3(rs.getCol2IntString());
			}
		}
		
		cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjl0.setAttr4("("+cfs3.getReportDate()+")");
			reportMap = financedata.getLossMap(cfs3);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、主营业务收入");
				extobjl1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：折扣与折让");
				extobjl2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、主营业务收入净额");
				extobjl3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("主营业务成本");
				extobjl4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：主营业务税金及附加");
				extobjl5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、主营业务利润");
				extobjl6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：存货跌价损失");
				extobjl8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业费用");
				extobjl9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用(含汇兑损益)");
				extobjl11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：投资收益");
				extobjl14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("补贴收入");
				extobjl15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业外收入");
				extobjl16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：以前年度损益调整");
				extobjl18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("五、利润总额");
				extobjl19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：未确认的投资损失");
				extobjl22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：财政返还(含所得税返还)");
				extobjl23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("六、净利润");
				extobjl24.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl25.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl26.setAttr4(rs.getCol2IntString());
			}
		}
		
		cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
		if(cfs4 != null){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjl0.setAttr5("("+cfs4.getReportDate()+")");
			reportMap = financedata.getLossMap(cfs4);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、主营业务收入");
				extobjl1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：折扣与折让");
				extobjl2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、主营业务收入净额");
				extobjl3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("主营业务成本");
				extobjl4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：主营业务税金及附加");
				extobjl5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、主营业务利润");
				extobjl6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：存货跌价损失");
				extobjl8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业费用");
				extobjl9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用(含汇兑损益)");
				extobjl11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：投资收益");
				extobjl14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("补贴收入");
				extobjl15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业外收入");
				extobjl16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：以前年度损益调整");
				extobjl18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("五、利润总额");
				extobjl19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：未确认的投资损失");
				extobjl22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：财政返还(含所得税返还)");
				extobjl23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("六、净利润");
				extobjl24.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl25.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl26.setAttr5(rs.getCol2IntString());
			}
		}
		//现金流量表
		cfs1 = financedata.getRelativeYearReport(cfs, -1);//获得去年年报
		if(cfs1 != null){
			if(!StringX.isSpace(cfs1.getReportDate()))extobjx0.setAttr1("("+cfs1.getReportDate()+")");
			reportMap = financedata.getCashMap(cfs1);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx14.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx15.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx16.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资所支付的现金");
				extobjx17.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx18.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx19.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
				extobjx21.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx22.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx23.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx24.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx25.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
				extobjx26.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx27.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx28.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx29.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响");
				extobjx30.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx31.setAttr1(rs.getCol2IntString());
			}
		}
		
		cfs2 = financedata.getRelativeYearReport(cfs, -2);//上两年末
		if(cfs2 != null){
			extobjx0.setAttr2(cfs2.getReportDate());
			if(!StringX.isSpace(cfs2.getReportDate()))extobjx0.setAttr2("("+cfs2.getReportDate()+")");
			double d1;
			reportMap = financedata.getCashMap(cfs2);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx1.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx1.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx2.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx2.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx3.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx3.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx4.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx4.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx5.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx5.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx6.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx6.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx7.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx7.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx8.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx8.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx9.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx9.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx10.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx10.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx11.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx11.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx12.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx12.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx13.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx13.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx14.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx14.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx15.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx15.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx15.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx16.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx16.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资所支付的现金");
				extobjx17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx17.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx17.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx18.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx18.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx19.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx19.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx20.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx20.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
				extobjx21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx21.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx21.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx22.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx22.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx23.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx23.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx24.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx24.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx25.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx25.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
				extobjx26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx26.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx26.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx27.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx27.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx27.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx28.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx28.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx28.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx29.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx29.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx29.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响");
				extobjx30.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx30.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx30.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx31.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx31.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx31.setAttr4("");
				}
			}
		}
		
		cfs3 = financedata.getRelativeYearReport(cfs, -3);//上三年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjx0.setAttr3("("+cfs3.getReportDate()+")");
			reportMap = financedata.getCashMap(cfs3);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资所支付的现金");
				extobjx17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
				extobjx21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
				extobjx26.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx27.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx28.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx29.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响");
				extobjx30.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx31.setAttr3(rs.getCol2IntString());
			}
		}
	}
	
	public void getNew(){//新会计准则报表
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("货币资金");
				extobjz1.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("交易性金融资产");
				extobjz2.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收票据");
				extobjz3.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收账款");
				extobjz4.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预付款项");
				extobjz5.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收利息");
				extobjz6.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应收股利");
				extobjz7.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他应收款");
				extobjz8.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("存货");
				extobjz9.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("一年内到期的非流动资产");
				extobjz10.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他流动资产");
				extobjz11.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("流动资产合计");
				extobjz12.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("可供出售金融资产");
				extobjz13.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("持有至到期投资");
				extobjz14.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期应收款");
				extobjz15.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期股权投资");
				extobjz16.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资性房地产");
				extobjz17.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产");
				extobjz18.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("在建工程");
				extobjz19.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("工程物资");
				extobjz20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("固定资产清理");
				extobjz21.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("生产性生物资产");
				extobjz22.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("油气资产");
				extobjz23.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("无形资产");
				extobjz24.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("开发支出");
				extobjz25.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("商誉");
				extobjz26.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期待摊费用");
				extobjz27.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("递延所得税资产");
				extobjz28.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他非流动资产");
				extobjz29.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("非流动资产合计");
				extobjz30.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产合计");
				extobjz31.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("短期借款");
				extobjz32.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("交易性金融负债");
				extobjz33.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付票据");
				extobjz34.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付账款");
				extobjz35.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预收款项");
				extobjz36.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付职工薪酬");
				extobjz37.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应交税费");
				extobjz38.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付利息");
				extobjz39.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付股利");
				extobjz40.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他应付款");
				extobjz41.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("一年内到期的非流动负债");
				extobjz42.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他流动负债");
				extobjz43.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("流动负债合计");
				extobjz44.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期借款");
				extobjz45.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付债券");
				extobjz46.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("长期应付款");
				extobjz47.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("专项应付款");
				extobjz48.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("预计负债");
				extobjz49.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("递延所得税负债");
				extobjz50.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他非流动负债");
				extobjz51.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("非流动负债合计");
				extobjz52.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("负债合计");
				extobjz53.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("实收资本(或股本)");
				extobjz54.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资本公积");
				extobjz55.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：库存股");
				extobjz56.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("盈余公积");
				extobjz57.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("未分配利润");
				extobjz58.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("外币报表折算差额");
				extobjz59.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("归属于母公司所有者权益合计");
				extobjz60.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东权益");
				extobjz61.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("所有者权益合计");
				extobjz62.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("负债和所有者权益(或股东权益)合计");
				extobjz63.setAttr1(rs.getCol2IntString());
			}
		}
		
		CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
		if(cfs1 != null) {
			if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
			double d1;
			Map reportMap1 = financedata.getAssetMap(cfs1);
			if(reportMap1.size()>0){
				rs = (ReportSubject) reportMap1.get("货币资金");
				extobjz1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz1.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz1.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("交易性金融资产");
				extobjz2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz2.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz2.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收票据");
				extobjz3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz3.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz3.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收账款");
				extobjz4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz4.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz4.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预付款项");
				extobjz5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz5.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz5.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收利息");
				extobjz6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz6.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz6.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应收股利");
				extobjz7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz7.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz7.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他应收款");
				extobjz8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz8.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz8.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("存货");
				extobjz9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz9.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz9.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("一年内到期的非流动资产");
				extobjz10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz10.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz10.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他流动资产");
				extobjz11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz11.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz11.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("流动资产合计");
				extobjz12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz12.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz12.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("可供出售金融资产");
				extobjz13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz13.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz13.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("持有至到期投资");
				extobjz14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz14.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz14.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期应收款");
				extobjz15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz15.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz15.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期股权投资");
				extobjz16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz16.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz16.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("投资性房地产");
				extobjz17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz17.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz17.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产");
				extobjz18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz18.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz18.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("在建工程");
				extobjz19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz19.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz19.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("工程物资");
				extobjz20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz20.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz20.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("固定资产清理");
				extobjz21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz21.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz21.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("生产性生物资产");
				extobjz22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz22.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz22.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("油气资产");
				extobjz23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz23.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz23.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("无形资产");
				extobjz24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz24.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz24.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("开发支出");
				extobjz25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz25.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz25.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("商誉");
				extobjz26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz26.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz26.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期待摊费用");
				extobjz27.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz27.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz27.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("递延所得税资产");
				extobjz28.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz28.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz28.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他非流动资产");
				extobjz29.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz29.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz29.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("非流动资产合计");
				extobjz30.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz30.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz30.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("资产合计");
				extobjz31.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz31.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz31.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("短期借款");
				extobjz32.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz32.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz32.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("交易性金融负债");
				extobjz33.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz33.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz33.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付票据");
				extobjz34.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz34.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz34.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付账款");
				extobjz35.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz35.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz35.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预收款项");
				extobjz36.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz36.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz36.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付职工薪酬");
				extobjz37.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz37.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz37.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应交税费");
				extobjz38.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz38.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz38.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付利息");
				extobjz39.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz39.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz39.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付股利");
				extobjz40.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz40.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz40.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他应付款");
				extobjz41.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz41.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz41.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("一年内到期的非流动负债");
				extobjz42.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz42.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz42.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他流动负债");
				extobjz43.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz43.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz43.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("流动负债合计");
				extobjz44.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz44.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz44.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期借款");
				extobjz45.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz45.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz45.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("应付债券");
				extobjz46.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz46.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz46.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("长期应付款");
				extobjz47.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz47.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz47.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("专项应付款");
				extobjz48.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz48.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz48.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz48.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz48.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("预计负债");
				extobjz49.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz49.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz49.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz49.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz49.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("递延所得税负债");
				extobjz50.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz50.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz50.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz50.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz50.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("其他非流动负债");
				extobjz51.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz51.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz51.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz51.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz51.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("非流动负债合计");
				extobjz52.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz52.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz52.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz52.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz52.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("负债合计");
				extobjz53.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz53.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz53.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz53.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz53.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("实收资本(或股本)");
				extobjz54.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz54.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz54.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz54.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz54.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("资本公积");
				extobjz55.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz55.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz55.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz55.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz55.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("减：库存股");
				extobjz56.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz56.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz56.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz56.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz56.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("盈余公积");
				extobjz57.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz57.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz57.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz57.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz57.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("未分配利润");
				extobjz58.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz58.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz58.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz58.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz58.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("外币报表折算差额");
				extobjz59.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz59.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz59.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz59.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz59.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("归属于母公司所有者权益合计");
				extobjz60.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz60.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz60.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz60.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz60.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("少数股东权益");
				extobjz61.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz61.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz61.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz61.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz61.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("所有者权益合计");
				extobjz62.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz62.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz62.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz62.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz62.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("负债和所有者权益(或股东权益)合计");
				extobjz63.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz63.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz63.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz63.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjz63.setAttr6("");
				}
			}
		}
		
		CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上年末
		if(cfs2 != null){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
			Map reportMap2 = financedata.getAssetMap(cfs2);
			if(reportMap2.size()>0){
				rs = (ReportSubject) reportMap2.get("货币资金");
				extobjz1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("交易性金融资产");
				extobjz2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收票据");
				extobjz3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收账款");
				extobjz4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预付款项");
				extobjz5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收利息");
				extobjz6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应收股利");
				extobjz7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他应收款");
				extobjz8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("存货");
				extobjz9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("一年内到期的非流动资产");
				extobjz10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他流动资产");
				extobjz11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("流动资产合计");
				extobjz12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("可供出售金融资产");
				extobjz13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("持有至到期投资");
				extobjz14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期应收款");
				extobjz15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期股权投资");
				extobjz16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("投资性房地产");
				extobjz17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产");
				extobjz18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("在建工程");
				extobjz19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("工程物资");
				extobjz20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("固定资产清理");
				extobjz21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("生产性生物资产");
				extobjz22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("油气资产");
				extobjz23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("无形资产");
				extobjz24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("开发支出");
				extobjz25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("商誉");
				extobjz26.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期待摊费用");
				extobjz27.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("递延所得税资产");
				extobjz28.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他非流动资产");
				extobjz29.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("非流动资产合计");
				extobjz30.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("资产合计");
				extobjz31.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("短期借款");
				extobjz32.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("交易性金融负债");
				extobjz33.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付票据");
				extobjz34.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付账款");
				extobjz35.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预收款项");
				extobjz36.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付职工薪酬");
				extobjz37.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应交税费");
				extobjz38.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付利息");
				extobjz39.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付股利");
				extobjz40.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他应付款");
				extobjz41.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("一年内到期的非流动负债");
				extobjz42.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他流动负债");
				extobjz43.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("流动负债合计");
				extobjz44.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期借款");
				extobjz45.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("应付债券");
				extobjz46.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("长期应付款");
				extobjz47.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("专项应付款");
				extobjz48.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("预计负债");
				extobjz49.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("递延所得税负债");
				extobjz50.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("其他非流动负债");
				extobjz51.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("非流动负债合计");
				extobjz52.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("负债合计");
				extobjz53.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("实收资本(或股本)");
				extobjz54.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("资本公积");
				extobjz55.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("减：库存股");
				extobjz56.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("盈余公积");
				extobjz57.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("未分配利润");
				extobjz58.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("外币报表折算差额");
				extobjz59.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("归属于母公司所有者权益合计");
				extobjz60.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("少数股东权益");
				extobjz61.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("所有者权益合计");
				extobjz62.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("负债和所有者权益(或股东权益)合计");
				extobjz63.setAttr3(rs.getCol2IntString());
			}
		}
		
		CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上两年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs3);
			if(reportMap3.size()>0){
				rs = (ReportSubject) reportMap3.get("货币资金");
				extobjz1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("交易性金融资产");
				extobjz2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收票据");
				extobjz3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款");
				extobjz4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预付款项");
				extobjz5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收利息");
				extobjz6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收股利");
				extobjz7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应收款");
				extobjz8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货");
				extobjz9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的非流动资产");
				extobjz10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动资产");
				extobjz11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动资产合计");
				extobjz12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("可供出售金融资产");
				extobjz13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("持有至到期投资");
				extobjz14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应收款");
				extobjz15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期股权投资");
				extobjz16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("投资性房地产");
				extobjz17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产");
				extobjz18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("在建工程");
				extobjz19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("工程物资");
				extobjz20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产清理");
				extobjz21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("生产性生物资产");
				extobjz22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("油气资产");
				extobjz23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形资产");
				extobjz24.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("开发支出");
				extobjz25.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("商誉");
				extobjz26.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期待摊费用");
				extobjz27.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延所得税资产");
				extobjz28.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他非流动资产");
				extobjz29.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("非流动资产合计");
				extobjz30.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资产合计");
				extobjz31.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期借款");
				extobjz32.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("交易性金融负债");
				extobjz33.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付票据");
				extobjz34.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付账款");
				extobjz35.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预收款项");
				extobjz36.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付职工薪酬");
				extobjz37.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应交税费");
				extobjz38.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付利息");
				extobjz39.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付股利");
				extobjz40.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应付款");
				extobjz41.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的非流动负债");
				extobjz42.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动负债");
				extobjz43.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动负债合计");
				extobjz44.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期借款");
				extobjz45.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付债券");
				extobjz46.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应付款");
				extobjz47.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("专项应付款");
				extobjz48.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预计负债");
				extobjz49.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延所得税负债");
				extobjz50.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他非流动负债");
				extobjz51.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("非流动负债合计");
				extobjz52.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债合计");
				extobjz53.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("实收资本(或股本)");
				extobjz54.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资本公积");
				extobjz55.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：库存股");
				extobjz56.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("盈余公积");
				extobjz57.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("未分配利润");
				extobjz58.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("外币报表折算差额");
				extobjz59.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("归属于母公司所有者权益合计");
				extobjz60.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("少数股东权益");
				extobjz61.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("所有者权益合计");
				extobjz62.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债和所有者权益(或股东权益)合计");
				extobjz63.setAttr4(rs.getCol2IntString());
			}
		}	
		
		CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//上三年末
		if(cfs4 != null){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs4);
			if(reportMap3.size()>0){
				rs = (ReportSubject) reportMap3.get("货币资金");
				extobjz1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("交易性金融资产");
				extobjz2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收票据");
				extobjz3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收账款");
				extobjz4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预付款项");
				extobjz5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收利息");
				extobjz6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应收股利");
				extobjz7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应收款");
				extobjz8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("存货");
				extobjz9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的非流动资产");
				extobjz10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动资产");
				extobjz11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动资产合计");
				extobjz12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("可供出售金融资产");
				extobjz13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("持有至到期投资");
				extobjz14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应收款");
				extobjz15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期股权投资");
				extobjz16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("投资性房地产");
				extobjz17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产");
				extobjz18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("在建工程");
				extobjz19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("工程物资");
				extobjz20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("固定资产清理");
				extobjz21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("生产性生物资产");
				extobjz22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("油气资产");
				extobjz23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("无形资产");
				extobjz24.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("开发支出");
				extobjz25.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("商誉");
				extobjz26.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期待摊费用");
				extobjz27.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延所得税资产");
				extobjz28.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他非流动资产");
				extobjz29.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("非流动资产合计");
				extobjz30.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资产合计");
				extobjz31.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("短期借款");
				extobjz32.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("交易性金融负债");
				extobjz33.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付票据");
				extobjz34.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付账款");
				extobjz35.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预收款项");
				extobjz36.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付职工薪酬");
				extobjz37.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应交税费");
				extobjz38.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付利息");
				extobjz39.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付股利");
				extobjz40.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他应付款");
				extobjz41.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("一年内到期的非流动负债");
				extobjz42.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他流动负债");
				extobjz43.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("流动负债合计");
				extobjz44.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期借款");
				extobjz45.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("应付债券");
				extobjz46.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("长期应付款");
				extobjz47.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("专项应付款");
				extobjz48.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("预计负债");
				extobjz49.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("递延所得税负债");
				extobjz50.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("其他非流动负债");
				extobjz51.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("非流动负债合计");
				extobjz52.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债合计");
				extobjz53.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("实收资本(或股本)");
				extobjz54.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("资本公积");
				extobjz55.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("减：库存股");
				extobjz56.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("盈余公积");
				extobjz57.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("未分配利润");
				extobjz58.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("外币报表折算差额");
				extobjz59.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("归属于母公司所有者权益合计");
				extobjz60.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("少数股东权益");
				extobjz61.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("所有者权益合计");
				extobjz62.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("负债和所有者权益(或股东权益)合计");
				extobjz63.setAttr5(rs.getCol2IntString());
			}
		}
		//现金流量表
		cfs1 = financedata.getRelativeYearReport(cfs, -1);//获得去年年报
		if(cfs1 != null){
			if(!StringX.isSpace(cfs1.getReportDate()))extobjx0.setAttr1("("+cfs1.getReportDate()+")");
			Map reportMap = financedata.getCashMap(cfs1);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置子公司及其他营业单位收到的现金净额");
				extobjx14.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx15.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx16.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx17.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资支付的现金");
				extobjx18.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得子公司及其他营业单位支付的现金净额");
				extobjx19.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx21.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx22.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("吸收投资收到的现金");
				extobjx23.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx24.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx25.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx26.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx27.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息支付的现金");
				extobjx28.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx29.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx30.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx31.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
				extobjx32.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx33.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：期初现金及现金等价物余额");
				extobjx34.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("期末现金及现金等价物余额");
				extobjx35.setAttr1(rs.getCol2IntString());
			}
		}
		
		cfs2 = financedata.getRelativeYearReport(cfs, -2);//上两年末
		if(cfs2 != null){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr2("("+cfs2.getReportDate()+")");
			double d1;
			Map reportMap = financedata.getCashMap(cfs2);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx1.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx1.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx2.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx2.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx3.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx3.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx4.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx4.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx5.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx5.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx6.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx6.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx7.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx7.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx8.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx8.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx9.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx9.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx10.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx10.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx11.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx11.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx12.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx12.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx13.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx13.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("处置子公司及其他营业单位收到的现金净额");
				extobjx14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx14.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx14.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx15.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx15.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx16.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx16.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx17.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx17.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资支付的现金");
				extobjx18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx18.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx18.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("取得子公司及其他营业单位支付的现金净额");
				extobjx19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx19.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx19.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx20.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx20.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx21.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx21.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx22.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx22.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("吸收投资收到的现金");
				extobjx23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx23.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx23.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx24.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx24.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx25.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx25.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx26.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx26.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx27.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx27.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx27.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息支付的现金");
				extobjx28.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx28.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx28.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx29.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx29.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx29.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx30.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx30.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx30.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx31.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx31.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx31.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
				extobjx32.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx32.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx32.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx33.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx33.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx33.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("加：期初现金及现金等价物余额");
				extobjx34.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx34.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx34.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("期末现金及现金等价物余额");
				extobjx35.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjx35.setAttr4(String.format("%.0f",d1*100));
				}else {
					extobjx35.setAttr4("");
				}
			}
		}
		
		cfs3 = financedata.getRelativeYearReport(cfs, -3);//上三年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjx0.setAttr3("("+cfs3.getReportDate()+")");
			Map reportMap = financedata.getCashMap(cfs3);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("销售商品、提供劳务收到的现金");
				extobjx1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购买商品、接受劳务支付的现金");
				extobjx5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("处置子公司及其他营业单位收到的现金净额");
				extobjx14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资支付的现金");
				extobjx18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("取得子公司及其他营业单位支付的现金净额");
				extobjx19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("吸收投资收到的现金");
				extobjx23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx26.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx27.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息支付的现金");
				extobjx28.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx29.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx30.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx31.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
				extobjx32.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx33.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：期初现金及现金等价物余额");
				extobjx34.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("期末现金及现金等价物余额");
				extobjx35.setAttr3(rs.getCol2IntString());
			}
		}
		
		//损益表
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjl0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、营业收入");
				extobjl1.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业成本");
				extobjl2.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业税金及附加");
				extobjl3.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl4.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl5.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用");
				extobjl6.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产减值损失");
				extobjl7.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：公允价值变动净收益");
				extobjl8.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资收益");
				extobjl9.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：对联营企业和合营企业的投资收益");
				extobjl10.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、营业利润");
				extobjl11.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：营业外收入");
				extobjl12.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl13.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：非流动资产处置净损失");
				extobjl14.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、利润总额");
				extobjl15.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税费用");
				extobjl16.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、净利润");
				extobjl17.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("归属于母公司所有者的净利润");
				extobjl18.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl19.setAttr1(rs.getCol2IntString());
//		rs = (ReportSubject) reportMap.get("五、每股收益");
//		extobj20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(一)基本每股收益");
				extobjl21.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(二)稀释每股收益");
				extobjl22.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl23.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl24.setAttr1(rs.getCol2IntString());
			}
		}
		
		cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
		if(cfs1 != null){
			double d1;
			if(!StringX.isSpace(cfs1.getReportDate()))extobjl0.setAttr2("("+cfs1.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs1);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、营业收入");
				extobjl1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl1.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：营业成本");
				extobjl2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl2.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("营业税金及附加");
				extobjl3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl3.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl4.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl5.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("财务费用");
				extobjl6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl6.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("资产减值损失");
				extobjl7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl7.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：公允价值变动净收益");
				extobjl8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl8.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("投资收益");
				extobjl9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl9.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：对联营企业和合营企业的投资收益");
				extobjl10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl10.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("二、营业利润");
				extobjl11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl11.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：营业外收入");
				extobjl12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl12.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl13.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：非流动资产处置净损失");
				extobjl14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl14.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("三、利润总额");
				extobjl15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl15.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：所得税费用");
				extobjl16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl16.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("四、净利润");
				extobjl17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl17.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("归属于母公司所有者的净利润");
				extobjl18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl18.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl19.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl19.setAttr6("");
				}
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr2(rs.getCol2IntString());
//				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
//					d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
//					extobj20.setAttr6(String.format("%.0f",d1*100));
//				}else {
//					extobj20.setAttr6("");
//				}
				rs = (ReportSubject) reportMap.get("(一)基本每股收益");
				extobjl21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl21.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("(二)稀释每股收益");
				extobjl22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl22.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl22.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl23.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl23.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjl24.setAttr6(String.format("%.0f",d1*100));
				}else {
					extobjl24.setAttr6("");
				}
			}
		}
		
		cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
		if(cfs2 != null){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjl0.setAttr3("("+cfs2.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs2);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、营业收入");
				extobjl1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业成本");
				extobjl2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业税金及附加");
				extobjl3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用");
				extobjl6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产减值损失");
				extobjl7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：公允价值变动净收益");
				extobjl8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资收益");
				extobjl9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：对联营企业和合营企业的投资收益");
				extobjl10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、营业利润");
				extobjl11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：营业外收入");
				extobjl12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：非流动资产处置净损失");
				extobjl14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、利润总额");
				extobjl15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税费用");
				extobjl16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、净利润");
				extobjl17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("归属于母公司所有者的净利润");
				extobjl18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl19.setAttr3(rs.getCol2IntString());
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(一)基本每股收益");
				extobjl21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(二)稀释每股收益");
				extobjl22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl24.setAttr3(rs.getCol2IntString());
			}
		}
		
		cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
		if(cfs3 != null){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjl0.setAttr4("("+cfs3.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs3);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、营业收入");
				extobjl1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业成本");
				extobjl2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业税金及附加");
				extobjl3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用");
				extobjl6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产减值损失");
				extobjl7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：公允价值变动净收益");
				extobjl8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资收益");
				extobjl9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：对联营企业和合营企业的投资收益");
				extobjl10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、营业利润");
				extobjl11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：营业外收入");
				extobjl12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：非流动资产处置净损失");
				extobjl14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、利润总额");
				extobjl15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税费用");
				extobjl16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、净利润");
				extobjl17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("归属于母公司所有者的净利润");
				extobjl18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl19.setAttr4(rs.getCol2IntString());
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(一)基本每股收益");
				extobjl21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(二)稀释每股收益");
				extobjl22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl24.setAttr4(rs.getCol2IntString());
			}
		}
		
		cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
		if(cfs4 != null){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjl0.setAttr5("("+cfs4.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs4);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("一、营业收入");
				extobjl1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业成本");
				extobjl2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("营业税金及附加");
				extobjl3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("销售费用");
				extobjl4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("管理费用");
				extobjl5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财务费用");
				extobjl6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("资产减值损失");
				extobjl7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：公允价值变动净收益");
				extobjl8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("投资收益");
				extobjl9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：对联营企业和合营企业的投资收益");
				extobjl10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("二、营业利润");
				extobjl11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：营业外收入");
				extobjl12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：营业外支出");
				extobjl13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：非流动资产处置净损失");
				extobjl14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("三、利润总额");
				extobjl15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：所得税费用");
				extobjl16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("四、净利润");
				extobjl17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("归属于母公司所有者的净利润");
				extobjl18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("少数股东损益");
				extobjl19.setAttr5(rs.getCol2IntString());
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(一)基本每股收益");
				extobjl21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("(二)稀释每股收益");
				extobjl22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付优先股股利");
				extobjl23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl24.setAttr5(rs.getCol2IntString());
			}
		}
	}
	
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
			q = m.createQuery("select sum(AMOUNT) as V.jamount,sum(BADACCOUNT) as V.hamount from O where reportNo=:reportNo and accountAge=:accountAge and receiveType=:receiveType");
		    q.setParameter("reportNo", sReportNo);
			q.setParameter("accountAge", sAccountAge);
			q.setParameter("receiveType", sReceiveType);
			bo = q.getSingleResult();
			if(bo != null){
				String amount = bo.getAttribute("jamount").getString();
				String badacCount = bo.getAttribute("hamount").getString();
				if(amount==null)amount="0";
				if(badacCount==null)badacCount="0";
				return amount+"/"+badacCount;
			}else{
				return "0/0";
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
			q = m.createQuery("select sum(AMOUNT) as V.jamount,sum(BADACCOUNT) as V.hamount from O where reportNo=:reportNo and receiveType=:receiveType");
		    q.setParameter("reportNo", sReportNo);
		    q.setParameter("receiveType", sReceiveType);
			bo = q.getSingleResult();
			if(bo != null){
				String amount = bo.getAttribute("jamount").getString();
				String badacCount = bo.getAttribute("hamount").getString();
				if(amount==null)amount="0";
				if(badacCount==null)badacCount="0";
				return amount+"/"+badacCount;
			}else{
				return "0/0";
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

	public String getOpinion9() {
		return opinion9;
	}

	public void setOpinion9(String opinion9) {
		this.opinion9 = opinion9;
	}

	public String getOpinion10() {
		return opinion10;
	}

	public void setOpinion10(String opinion10) {
		this.opinion10 = opinion10;
	}

	public String getOpinion11() {
		return opinion11;
	}

	public void setOpinion11(String opinion11) {
		this.opinion11 = opinion11;
	}

	public String getOpinion12() {
		return opinion12;
	}

	public void setOpinion12(String opinion12) {
		this.opinion12 = opinion12;
	}

	public String getOpinion13() {
		return opinion13;
	}

	public void setOpinion13(String opinion13) {
		this.opinion13 = opinion13;
	}

	public String getOpinion14() {
		return opinion14;
	}

	public void setOpinion14(String opinion14) {
		this.opinion14 = opinion14;
	}

	public String getOpinion15() {
		return opinion15;
	}

	public void setOpinion15(String opinion15) {
		this.opinion15 = opinion15;
	}

	public String getOpinion16() {
		return opinion16;
	}

	public void setOpinion16(String opinion16) {
		this.opinion16 = opinion16;
	}

	public String getOpinion17() {
		return opinion17;
	}

	public void setOpinion17(String opinion17) {
		this.opinion17 = opinion17;
	}

	public String getOpinion18() {
		return opinion18;
	}

	public void setOpinion18(String opinion18) {
		this.opinion18 = opinion18;
	}

	public String getOpinion19() {
		return opinion19;
	}

	public void setOpinion19(String opinion19) {
		this.opinion19 = opinion19;
	}

	public String getOpinion20() {
		return opinion20;
	}

	public void setOpinion20(String opinion20) {
		this.opinion20 = opinion20;
	}

	public String getOpinion21() {
		return opinion21;
	}

	public void setOpinion21(String opinion21) {
		this.opinion21 = opinion21;
	}

	public String getOpinion22() {
		return opinion22;
	}

	public void setOpinion22(String opinion22) {
		this.opinion22 = opinion22;
	}

	public String getOpinion23() {
		return opinion23;
	}

	public void setOpinion23(String opinion23) {
		this.opinion23 = opinion23;
	}

	public String getOpinion24() {
		return opinion24;
	}

	public void setOpinion24(String opinion24) {
		this.opinion24 = opinion24;
	}

	public DocExtClass getExtobj01() {
		return extobj01;
	}

	public void setExtobj01(DocExtClass extobj01) {
		this.extobj01 = extobj01;
	}

	public DocExtClass getExtobj02() {
		return extobj02;
	}

	public void setExtobj02(DocExtClass extobj02) {
		this.extobj02 = extobj02;
	}

	public DocExtClass getExtobj03() {
		return extobj03;
	}

	public void setExtobj03(DocExtClass extobj03) {
		this.extobj03 = extobj03;
	}

	public DocExtClass getExtobjc1() {
		return extobjc1;
	}

	public void setExtobjc1(DocExtClass extobjc1) {
		this.extobjc1 = extobjc1;
	}

	public DocExtClass getExtobjc2() {
		return extobjc2;
	}

	public void setExtobjc2(DocExtClass extobjc2) {
		this.extobjc2 = extobjc2;
	}

//	public DocExtClass getExtobjc3() {
//		return extobjc3;
//	}
//
//	public void setExtobjc3(DocExtClass extobjc3) {
//		this.extobjc3 = extobjc3;
//	}

	public DocExtClass getExtobjc4() {
		return extobjc4;
	}

	public void setExtobjc4(DocExtClass extobjc4) {
		this.extobjc4 = extobjc4;
	}

//	public DocExtClass getExtobjc5() {
//		return extobjc5;
//	}
//
//	public void setExtobjc5(DocExtClass extobjc5) {
//		this.extobjc5 = extobjc5;
//	}

	public DocExtClass getExtobjc6() {
		return extobjc6;
	}

	public void setExtobjc6(DocExtClass extobjc6) {
		this.extobjc6 = extobjc6;
	}

	public DocExtClass getExtobjc7() {
		return extobjc7;
	}

	public void setExtobjc7(DocExtClass extobjc7) {
		this.extobjc7 = extobjc7;
	}

	public DocExtClass getExtobjc8() {
		return extobjc8;
	}

	public void setExtobjc8(DocExtClass extobjc8) {
		this.extobjc8 = extobjc8;
	}

	public DocExtClass getExtobjc9() {
		return extobjc9;
	}

	public void setExtobjc9(DocExtClass extobjc9) {
		this.extobjc9 = extobjc9;
	}

	public DocExtClass getExtobjc10() {
		return extobjc10;
	}

	public void setExtobjc10(DocExtClass extobjc10) {
		this.extobjc10 = extobjc10;
	}

	public DocExtClass getExtobjc11() {
		return extobjc11;
	}

	public void setExtobjc11(DocExtClass extobjc11) {
		this.extobjc11 = extobjc11;
	}

	public DocExtClass getExtobjc12() {
		return extobjc12;
	}

	public void setExtobjc12(DocExtClass extobjc12) {
		this.extobjc12 = extobjc12;
	}

	public DocExtClass getExtobjc13() {
		return extobjc13;
	}

	public void setExtobjc13(DocExtClass extobjc13) {
		this.extobjc13 = extobjc13;
	}

	public DocExtClass getExtobjc14() {
		return extobjc14;
	}

	public void setExtobjc14(DocExtClass extobjc14) {
		this.extobjc14 = extobjc14;
	}

	public DocExtClass getExtobjc15() {
		return extobjc15;
	}

	public void setExtobjc15(DocExtClass extobjc15) {
		this.extobjc15 = extobjc15;
	}

	public DocExtClass getExtobjc16() {
		return extobjc16;
	}

	public void setExtobjc16(DocExtClass extobjc16) {
		this.extobjc16 = extobjc16;
	}

	public DocExtClass getExtobjc17() {
		return extobjc17;
	}

	public void setExtobjc17(DocExtClass extobjc17) {
		this.extobjc17 = extobjc17;
	}

	public DocExtClass getExtobjc18() {
		return extobjc18;
	}

	public void setExtobjc18(DocExtClass extobjc18) {
		this.extobjc18 = extobjc18;
	}

	public DocExtClass getExtobjc19() {
		return extobjc19;
	}

	public void setExtobjc19(DocExtClass extobjc19) {
		this.extobjc19 = extobjc19;
	}

	public DocExtClass getExtobjc20() {
		return extobjc20;
	}

	public void setExtobjc20(DocExtClass extobjc20) {
		this.extobjc20 = extobjc20;
	}

	public DocExtClass getExtobjc21() {
		return extobjc21;
	}

	public void setExtobjc21(DocExtClass extobjc21) {
		this.extobjc21 = extobjc21;
	}

	public DocExtClass getExtobjc22() {
		return extobjc22;
	}

	public void setExtobjc22(DocExtClass extobjc22) {
		this.extobjc22 = extobjc22;
	}

	public DocExtClass getExtobjc23() {
		return extobjc23;
	}

	public void setExtobjc23(DocExtClass extobjc23) {
		this.extobjc23 = extobjc23;
	}

	public DocExtClass getExtobjc24() {
		return extobjc24;
	}

	public void setExtobjc24(DocExtClass extobjc24) {
		this.extobjc24 = extobjc24;
	}

	public DocExtClass getExtobjc25() {
		return extobjc25;
	}

	public void setExtobjc25(DocExtClass extobjc25) {
		this.extobjc25 = extobjc25;
	}

	public DocExtClass[] getExtobjc26() {
		return extobjc26;
	}

	public void setExtobjc26(DocExtClass[] extobjc26) {
		this.extobjc26 = extobjc26;
	}

	public String getCtotals() {
		return ctotals;
	}

	public void setCtotals(String ctotals) {
		this.ctotals = ctotals;
	}

	public DocExtClass[] getExtobjp() {
		return extobjp;
	}

	public void setExtobjp(DocExtClass[] extobjp) {
		this.extobjp = extobjp;
	}

	public DocExtClass getExtobjz1() {
		return extobjz1;
	}

	public void setExtobjz1(DocExtClass extobjz1) {
		this.extobjz1 = extobjz1;
	}

	public DocExtClass getExtobjz2() {
		return extobjz2;
	}

	public void setExtobjz2(DocExtClass extobjz2) {
		this.extobjz2 = extobjz2;
	}

	public DocExtClass getExtobjz3() {
		return extobjz3;
	}

	public void setExtobjz3(DocExtClass extobjz3) {
		this.extobjz3 = extobjz3;
	}

	public DocExtClass getExtobjz4() {
		return extobjz4;
	}

	public void setExtobjz4(DocExtClass extobjz4) {
		this.extobjz4 = extobjz4;
	}

	public DocExtClass getExtobjz5() {
		return extobjz5;
	}

	public void setExtobjz5(DocExtClass extobjz5) {
		this.extobjz5 = extobjz5;
	}

	public DocExtClass getExtobjz6() {
		return extobjz6;
	}

	public void setExtobjz6(DocExtClass extobjz6) {
		this.extobjz6 = extobjz6;
	}

	public DocExtClass getExtobjz7() {
		return extobjz7;
	}

	public void setExtobjz7(DocExtClass extobjz7) {
		this.extobjz7 = extobjz7;
	}

	public DocExtClass getExtobjz8() {
		return extobjz8;
	}

	public void setExtobjz8(DocExtClass extobjz8) {
		this.extobjz8 = extobjz8;
	}

	public DocExtClass getExtobjz9() {
		return extobjz9;
	}

	public void setExtobjz9(DocExtClass extobjz9) {
		this.extobjz9 = extobjz9;
	}

	public DocExtClass getExtobjz10() {
		return extobjz10;
	}

	public void setExtobjz10(DocExtClass extobjz10) {
		this.extobjz10 = extobjz10;
	}

	public DocExtClass getExtobjz11() {
		return extobjz11;
	}

	public void setExtobjz11(DocExtClass extobjz11) {
		this.extobjz11 = extobjz11;
	}

	public DocExtClass getExtobjz12() {
		return extobjz12;
	}

	public void setExtobjz12(DocExtClass extobjz12) {
		this.extobjz12 = extobjz12;
	}

	public DocExtClass getExtobjz13() {
		return extobjz13;
	}

	public void setExtobjz13(DocExtClass extobjz13) {
		this.extobjz13 = extobjz13;
	}

	public DocExtClass getExtobjz14() {
		return extobjz14;
	}

	public void setExtobjz14(DocExtClass extobjz14) {
		this.extobjz14 = extobjz14;
	}

	public DocExtClass getExtobjz15() {
		return extobjz15;
	}

	public void setExtobjz15(DocExtClass extobjz15) {
		this.extobjz15 = extobjz15;
	}

	public DocExtClass getExtobjz16() {
		return extobjz16;
	}

	public void setExtobjz16(DocExtClass extobjz16) {
		this.extobjz16 = extobjz16;
	}

	public DocExtClass getExtobjz17() {
		return extobjz17;
	}

	public void setExtobjz17(DocExtClass extobjz17) {
		this.extobjz17 = extobjz17;
	}

	public DocExtClass getExtobjz18() {
		return extobjz18;
	}

	public void setExtobjz18(DocExtClass extobjz18) {
		this.extobjz18 = extobjz18;
	}

	public DocExtClass getExtobjz19() {
		return extobjz19;
	}

	public void setExtobjz19(DocExtClass extobjz19) {
		this.extobjz19 = extobjz19;
	}

	public DocExtClass getExtobjz20() {
		return extobjz20;
	}

	public void setExtobjz20(DocExtClass extobjz20) {
		this.extobjz20 = extobjz20;
	}

	public DocExtClass getExtobjz21() {
		return extobjz21;
	}

	public void setExtobjz21(DocExtClass extobjz21) {
		this.extobjz21 = extobjz21;
	}

	public DocExtClass getExtobjz22() {
		return extobjz22;
	}

	public void setExtobjz22(DocExtClass extobjz22) {
		this.extobjz22 = extobjz22;
	}

	public DocExtClass getExtobjz23() {
		return extobjz23;
	}

	public void setExtobjz23(DocExtClass extobjz23) {
		this.extobjz23 = extobjz23;
	}

	public DocExtClass getExtobjz24() {
		return extobjz24;
	}

	public void setExtobjz24(DocExtClass extobjz24) {
		this.extobjz24 = extobjz24;
	}

	public DocExtClass getExtobjz25() {
		return extobjz25;
	}

	public void setExtobjz25(DocExtClass extobjz25) {
		this.extobjz25 = extobjz25;
	}

	public DocExtClass getExtobjz26() {
		return extobjz26;
	}

	public void setExtobjz26(DocExtClass extobjz26) {
		this.extobjz26 = extobjz26;
	}

	public DocExtClass getExtobjz27() {
		return extobjz27;
	}

	public void setExtobjz27(DocExtClass extobjz27) {
		this.extobjz27 = extobjz27;
	}

	public DocExtClass getExtobjz28() {
		return extobjz28;
	}

	public void setExtobjz28(DocExtClass extobjz28) {
		this.extobjz28 = extobjz28;
	}

	public DocExtClass getExtobjz29() {
		return extobjz29;
	}

	public void setExtobjz29(DocExtClass extobjz29) {
		this.extobjz29 = extobjz29;
	}

	public DocExtClass getExtobjz30() {
		return extobjz30;
	}

	public void setExtobjz30(DocExtClass extobjz30) {
		this.extobjz30 = extobjz30;
	}

	public DocExtClass getExtobjz31() {
		return extobjz31;
	}

	public void setExtobjz31(DocExtClass extobjz31) {
		this.extobjz31 = extobjz31;
	}

	public DocExtClass getExtobjz32() {
		return extobjz32;
	}

	public void setExtobjz32(DocExtClass extobjz32) {
		this.extobjz32 = extobjz32;
	}

	public DocExtClass getExtobjz33() {
		return extobjz33;
	}

	public void setExtobjz33(DocExtClass extobjz33) {
		this.extobjz33 = extobjz33;
	}

	public DocExtClass getExtobjz34() {
		return extobjz34;
	}

	public void setExtobjz34(DocExtClass extobjz34) {
		this.extobjz34 = extobjz34;
	}

	public DocExtClass getExtobjz35() {
		return extobjz35;
	}

	public void setExtobjz35(DocExtClass extobjz35) {
		this.extobjz35 = extobjz35;
	}

	public DocExtClass getExtobjz36() {
		return extobjz36;
	}

	public void setExtobjz36(DocExtClass extobjz36) {
		this.extobjz36 = extobjz36;
	}

	public DocExtClass getExtobjz37() {
		return extobjz37;
	}

	public void setExtobjz37(DocExtClass extobjz37) {
		this.extobjz37 = extobjz37;
	}

	public DocExtClass getExtobjz38() {
		return extobjz38;
	}

	public void setExtobjz38(DocExtClass extobjz38) {
		this.extobjz38 = extobjz38;
	}

	public DocExtClass getExtobjz39() {
		return extobjz39;
	}

	public void setExtobjz39(DocExtClass extobjz39) {
		this.extobjz39 = extobjz39;
	}

	public DocExtClass getExtobjz40() {
		return extobjz40;
	}

	public void setExtobjz40(DocExtClass extobjz40) {
		this.extobjz40 = extobjz40;
	}

	public DocExtClass getExtobjz41() {
		return extobjz41;
	}

	public void setExtobjz41(DocExtClass extobjz41) {
		this.extobjz41 = extobjz41;
	}

	public DocExtClass getExtobjz42() {
		return extobjz42;
	}

	public void setExtobjz42(DocExtClass extobjz42) {
		this.extobjz42 = extobjz42;
	}

	public DocExtClass getExtobjz43() {
		return extobjz43;
	}

	public void setExtobjz43(DocExtClass extobjz43) {
		this.extobjz43 = extobjz43;
	}

	public DocExtClass getExtobjz44() {
		return extobjz44;
	}

	public void setExtobjz44(DocExtClass extobjz44) {
		this.extobjz44 = extobjz44;
	}

	public DocExtClass getExtobjz45() {
		return extobjz45;
	}

	public void setExtobjz45(DocExtClass extobjz45) {
		this.extobjz45 = extobjz45;
	}

	public DocExtClass getExtobjz46() {
		return extobjz46;
	}

	public void setExtobjz46(DocExtClass extobjz46) {
		this.extobjz46 = extobjz46;
	}

	public DocExtClass getExtobjz47() {
		return extobjz47;
	}

	public void setExtobjz47(DocExtClass extobjz47) {
		this.extobjz47 = extobjz47;
	}

	public DocExtClass getExtobjz48() {
		return extobjz48;
	}

	public void setExtobjz48(DocExtClass extobjz48) {
		this.extobjz48 = extobjz48;
	}

	public DocExtClass getExtobjz49() {
		return extobjz49;
	}

	public void setExtobjz49(DocExtClass extobjz49) {
		this.extobjz49 = extobjz49;
	}

	public DocExtClass getExtobjz50() {
		return extobjz50;
	}

	public void setExtobjz50(DocExtClass extobjz50) {
		this.extobjz50 = extobjz50;
	}

	public DocExtClass getExtobjz51() {
		return extobjz51;
	}

	public void setExtobjz51(DocExtClass extobjz51) {
		this.extobjz51 = extobjz51;
	}

	public DocExtClass getExtobjz52() {
		return extobjz52;
	}

	public void setExtobjz52(DocExtClass extobjz52) {
		this.extobjz52 = extobjz52;
	}

	public DocExtClass getExtobjz53() {
		return extobjz53;
	}

	public void setExtobjz53(DocExtClass extobjz53) {
		this.extobjz53 = extobjz53;
	}

	public DocExtClass getExtobjz54() {
		return extobjz54;
	}

	public void setExtobjz54(DocExtClass extobjz54) {
		this.extobjz54 = extobjz54;
	}

	public DocExtClass getExtobjz55() {
		return extobjz55;
	}

	public void setExtobjz55(DocExtClass extobjz55) {
		this.extobjz55 = extobjz55;
	}

	public DocExtClass getExtobjz56() {
		return extobjz56;
	}

	public void setExtobjz56(DocExtClass extobjz56) {
		this.extobjz56 = extobjz56;
	}

	public DocExtClass getExtobjz57() {
		return extobjz57;
	}

	public void setExtobjz57(DocExtClass extobjz57) {
		this.extobjz57 = extobjz57;
	}

	public DocExtClass getExtobjz58() {
		return extobjz58;
	}

	public void setExtobjz58(DocExtClass extobjz58) {
		this.extobjz58 = extobjz58;
	}

	public DocExtClass getExtobjz59() {
		return extobjz59;
	}

	public void setExtobjz59(DocExtClass extobjz59) {
		this.extobjz59 = extobjz59;
	}

	public DocExtClass getExtobjz60() {
		return extobjz60;
	}

	public void setExtobjz60(DocExtClass extobjz60) {
		this.extobjz60 = extobjz60;
	}

	public DocExtClass getExtobjz61() {
		return extobjz61;
	}

	public void setExtobjz61(DocExtClass extobjz61) {
		this.extobjz61 = extobjz61;
	}

	public DocExtClass getExtobjz62() {
		return extobjz62;
	}

	public void setExtobjz62(DocExtClass extobjz62) {
		this.extobjz62 = extobjz62;
	}

	public DocExtClass getExtobjz63() {
		return extobjz63;
	}

	public void setExtobjz63(DocExtClass extobjz63) {
		this.extobjz63 = extobjz63;
	}

	public DocExtClass getExtobjz64() {
		return extobjz64;
	}

	public void setExtobjz64(DocExtClass extobjz64) {
		this.extobjz64 = extobjz64;
	}

	public DocExtClass getExtobjz65() {
		return extobjz65;
	}

	public void setExtobjz65(DocExtClass extobjz65) {
		this.extobjz65 = extobjz65;
	}

	public DocExtClass getExtobjz66() {
		return extobjz66;
	}

	public void setExtobjz66(DocExtClass extobjz66) {
		this.extobjz66 = extobjz66;
	}

	public DocExtClass getExtobjz67() {
		return extobjz67;
	}

	public void setExtobjz67(DocExtClass extobjz67) {
		this.extobjz67 = extobjz67;
	}

	public DocExtClass getExtobjz68() {
		return extobjz68;
	}

	public void setExtobjz68(DocExtClass extobjz68) {
		this.extobjz68 = extobjz68;
	}

	public DocExtClass getExtobjz69() {
		return extobjz69;
	}

	public void setExtobjz69(DocExtClass extobjz69) {
		this.extobjz69 = extobjz69;
	}

	public DocExtClass getExtobjz70() {
		return extobjz70;
	}

	public void setExtobjz70(DocExtClass extobjz70) {
		this.extobjz70 = extobjz70;
	}

	public DocExtClass getExtobjz71() {
		return extobjz71;
	}

	public void setExtobjz71(DocExtClass extobjz71) {
		this.extobjz71 = extobjz71;
	}

	public DocExtClass getExtobjz72() {
		return extobjz72;
	}

	public void setExtobjz72(DocExtClass extobjz72) {
		this.extobjz72 = extobjz72;
	}

	public DocExtClass getExtobjz73() {
		return extobjz73;
	}

	public void setExtobjz73(DocExtClass extobjz73) {
		this.extobjz73 = extobjz73;
	}

	public DocExtClass getExtobjz74() {
		return extobjz74;
	}

	public void setExtobjz74(DocExtClass extobjz74) {
		this.extobjz74 = extobjz74;
	}

	public DocExtClass getExtobjz75() {
		return extobjz75;
	}

	public void setExtobjz75(DocExtClass extobjz75) {
		this.extobjz75 = extobjz75;
	}

	public DocExtClass getExtobjz76() {
		return extobjz76;
	}

	public void setExtobjz76(DocExtClass extobjz76) {
		this.extobjz76 = extobjz76;
	}

	public DocExtClass getExtobjl1() {
		return extobjl1;
	}

	public void setExtobjl1(DocExtClass extobjl1) {
		this.extobjl1 = extobjl1;
	}

	public DocExtClass getExtobjl2() {
		return extobjl2;
	}

	public void setExtobjl2(DocExtClass extobjl2) {
		this.extobjl2 = extobjl2;
	}

	public DocExtClass getExtobjl3() {
		return extobjl3;
	}

	public void setExtobjl3(DocExtClass extobjl3) {
		this.extobjl3 = extobjl3;
	}

	public DocExtClass getExtobjl4() {
		return extobjl4;
	}

	public void setExtobjl4(DocExtClass extobjl4) {
		this.extobjl4 = extobjl4;
	}

	public DocExtClass getExtobjl5() {
		return extobjl5;
	}

	public void setExtobjl5(DocExtClass extobjl5) {
		this.extobjl5 = extobjl5;
	}

	public DocExtClass getExtobjl6() {
		return extobjl6;
	}

	public void setExtobjl6(DocExtClass extobjl6) {
		this.extobjl6 = extobjl6;
	}

	public DocExtClass getExtobjl7() {
		return extobjl7;
	}

	public void setExtobjl7(DocExtClass extobjl7) {
		this.extobjl7 = extobjl7;
	}

	public DocExtClass getExtobjl8() {
		return extobjl8;
	}

	public void setExtobjl8(DocExtClass extobjl8) {
		this.extobjl8 = extobjl8;
	}

	public DocExtClass getExtobjl9() {
		return extobjl9;
	}

	public void setExtobjl9(DocExtClass extobjl9) {
		this.extobjl9 = extobjl9;
	}

	public DocExtClass getExtobjl10() {
		return extobjl10;
	}

	public void setExtobjl10(DocExtClass extobjl10) {
		this.extobjl10 = extobjl10;
	}

	public DocExtClass getExtobjl11() {
		return extobjl11;
	}

	public void setExtobjl11(DocExtClass extobjl11) {
		this.extobjl11 = extobjl11;
	}

	public DocExtClass getExtobjl12() {
		return extobjl12;
	}

	public void setExtobjl12(DocExtClass extobjl12) {
		this.extobjl12 = extobjl12;
	}

	public DocExtClass getExtobjl13() {
		return extobjl13;
	}

	public void setExtobjl13(DocExtClass extobjl13) {
		this.extobjl13 = extobjl13;
	}

	public DocExtClass getExtobjl14() {
		return extobjl14;
	}

	public void setExtobjl14(DocExtClass extobjl14) {
		this.extobjl14 = extobjl14;
	}

	public DocExtClass getExtobjl15() {
		return extobjl15;
	}

	public void setExtobjl15(DocExtClass extobjl15) {
		this.extobjl15 = extobjl15;
	}

	public DocExtClass getExtobjl16() {
		return extobjl16;
	}

	public void setExtobjl16(DocExtClass extobjl16) {
		this.extobjl16 = extobjl16;
	}

	public DocExtClass getExtobjl17() {
		return extobjl17;
	}

	public void setExtobjl17(DocExtClass extobjl17) {
		this.extobjl17 = extobjl17;
	}

	public DocExtClass getExtobjl18() {
		return extobjl18;
	}

	public void setExtobjl18(DocExtClass extobjl18) {
		this.extobjl18 = extobjl18;
	}

	public DocExtClass getExtobjl19() {
		return extobjl19;
	}

	public void setExtobjl19(DocExtClass extobjl19) {
		this.extobjl19 = extobjl19;
	}

	public DocExtClass getExtobjl20() {
		return extobjl20;
	}

	public void setExtobjl20(DocExtClass extobjl20) {
		this.extobjl20 = extobjl20;
	}

	public DocExtClass getExtobjl21() {
		return extobjl21;
	}

	public void setExtobjl21(DocExtClass extobjl21) {
		this.extobjl21 = extobjl21;
	}

	public DocExtClass getExtobjl22() {
		return extobjl22;
	}

	public void setExtobjl22(DocExtClass extobjl22) {
		this.extobjl22 = extobjl22;
	}

	public DocExtClass getExtobjl23() {
		return extobjl23;
	}

	public void setExtobjl23(DocExtClass extobjl23) {
		this.extobjl23 = extobjl23;
	}

	public DocExtClass getExtobjl24() {
		return extobjl24;
	}

	public void setExtobjl24(DocExtClass extobjl24) {
		this.extobjl24 = extobjl24;
	}

	public DocExtClass getExtobjl25() {
		return extobjl25;
	}

	public void setExtobjl25(DocExtClass extobjl25) {
		this.extobjl25 = extobjl25;
	}

	public DocExtClass getExtobjl26() {
		return extobjl26;
	}

	public void setExtobjl26(DocExtClass extobjl26) {
		this.extobjl26 = extobjl26;
	}

	public DocExtClass getExtobjx1() {
		return extobjx1;
	}

	public void setExtobjx1(DocExtClass extobjx1) {
		this.extobjx1 = extobjx1;
	}

	public DocExtClass getExtobjx2() {
		return extobjx2;
	}

	public void setExtobjx2(DocExtClass extobjx2) {
		this.extobjx2 = extobjx2;
	}

	public DocExtClass getExtobjx3() {
		return extobjx3;
	}

	public void setExtobjx3(DocExtClass extobjx3) {
		this.extobjx3 = extobjx3;
	}

	public DocExtClass getExtobjx4() {
		return extobjx4;
	}

	public void setExtobjx4(DocExtClass extobjx4) {
		this.extobjx4 = extobjx4;
	}

	public DocExtClass getExtobjx5() {
		return extobjx5;
	}

	public void setExtobjx5(DocExtClass extobjx5) {
		this.extobjx5 = extobjx5;
	}

	public DocExtClass getExtobjx6() {
		return extobjx6;
	}

	public void setExtobjx6(DocExtClass extobjx6) {
		this.extobjx6 = extobjx6;
	}

	public DocExtClass getExtobjx7() {
		return extobjx7;
	}

	public void setExtobjx7(DocExtClass extobjx7) {
		this.extobjx7 = extobjx7;
	}

	public DocExtClass getExtobjx8() {
		return extobjx8;
	}

	public void setExtobjx8(DocExtClass extobjx8) {
		this.extobjx8 = extobjx8;
	}

	public DocExtClass getExtobjx9() {
		return extobjx9;
	}

	public void setExtobjx9(DocExtClass extobjx9) {
		this.extobjx9 = extobjx9;
	}

	public DocExtClass getExtobjx10() {
		return extobjx10;
	}

	public void setExtobjx10(DocExtClass extobjx10) {
		this.extobjx10 = extobjx10;
	}

	public DocExtClass getExtobjx11() {
		return extobjx11;
	}

	public void setExtobjx11(DocExtClass extobjx11) {
		this.extobjx11 = extobjx11;
	}

	public DocExtClass getExtobjx12() {
		return extobjx12;
	}

	public void setExtobjx12(DocExtClass extobjx12) {
		this.extobjx12 = extobjx12;
	}

	public DocExtClass getExtobjx13() {
		return extobjx13;
	}

	public void setExtobjx13(DocExtClass extobjx13) {
		this.extobjx13 = extobjx13;
	}

	public DocExtClass getExtobjx14() {
		return extobjx14;
	}

	public void setExtobjx14(DocExtClass extobjx14) {
		this.extobjx14 = extobjx14;
	}

	public DocExtClass getExtobjx15() {
		return extobjx15;
	}

	public void setExtobjx15(DocExtClass extobjx15) {
		this.extobjx15 = extobjx15;
	}

	public DocExtClass getExtobjx16() {
		return extobjx16;
	}

	public void setExtobjx16(DocExtClass extobjx16) {
		this.extobjx16 = extobjx16;
	}

	public DocExtClass getExtobjx17() {
		return extobjx17;
	}

	public void setExtobjx17(DocExtClass extobjx17) {
		this.extobjx17 = extobjx17;
	}

	public DocExtClass getExtobjx18() {
		return extobjx18;
	}

	public void setExtobjx18(DocExtClass extobjx18) {
		this.extobjx18 = extobjx18;
	}

	public DocExtClass getExtobjx19() {
		return extobjx19;
	}

	public void setExtobjx19(DocExtClass extobjx19) {
		this.extobjx19 = extobjx19;
	}

	public DocExtClass getExtobjx20() {
		return extobjx20;
	}

	public void setExtobjx20(DocExtClass extobjx20) {
		this.extobjx20 = extobjx20;
	}

	public DocExtClass getExtobjx21() {
		return extobjx21;
	}

	public void setExtobjx21(DocExtClass extobjx21) {
		this.extobjx21 = extobjx21;
	}

	public DocExtClass getExtobjx22() {
		return extobjx22;
	}

	public void setExtobjx22(DocExtClass extobjx22) {
		this.extobjx22 = extobjx22;
	}

	public DocExtClass getExtobjx23() {
		return extobjx23;
	}

	public void setExtobjx23(DocExtClass extobjx23) {
		this.extobjx23 = extobjx23;
	}

	public DocExtClass getExtobjx24() {
		return extobjx24;
	}

	public void setExtobjx24(DocExtClass extobjx24) {
		this.extobjx24 = extobjx24;
	}

	public DocExtClass getExtobjx25() {
		return extobjx25;
	}

	public void setExtobjx25(DocExtClass extobjx25) {
		this.extobjx25 = extobjx25;
	}

	public DocExtClass getExtobjx26() {
		return extobjx26;
	}

	public void setExtobjx26(DocExtClass extobjx26) {
		this.extobjx26 = extobjx26;
	}

	public DocExtClass getExtobjx27() {
		return extobjx27;
	}

	public void setExtobjx27(DocExtClass extobjx27) {
		this.extobjx27 = extobjx27;
	}

	public DocExtClass getExtobjx28() {
		return extobjx28;
	}

	public void setExtobjx28(DocExtClass extobjx28) {
		this.extobjx28 = extobjx28;
	}

	public DocExtClass getExtobjx29() {
		return extobjx29;
	}

	public void setExtobjx29(DocExtClass extobjx29) {
		this.extobjx29 = extobjx29;
	}

	public DocExtClass getExtobjx30() {
		return extobjx30;
	}

	public void setExtobjx30(DocExtClass extobjx30) {
		this.extobjx30 = extobjx30;
	}

	public DocExtClass getExtobjx31() {
		return extobjx31;
	}

	public void setExtobjx31(DocExtClass extobjx31) {
		this.extobjx31 = extobjx31;
	}

	public DocExtClass getExtobjx32() {
		return extobjx32;
	}

	public void setExtobjx32(DocExtClass extobjx32) {
		this.extobjx32 = extobjx32;
	}

	public DocExtClass getExtobjx33() {
		return extobjx33;
	}

	public void setExtobjx33(DocExtClass extobjx33) {
		this.extobjx33 = extobjx33;
	}

	public DocExtClass getExtobjx34() {
		return extobjx34;
	}

	public void setExtobjx34(DocExtClass extobjx34) {
		this.extobjx34 = extobjx34;
	}

	public DocExtClass getExtobjx35() {
		return extobjx35;
	}

	public void setExtobjx35(DocExtClass extobjx35) {
		this.extobjx35 = extobjx35;
	}

	public DocExtClass getExtobjf2() {
		return extobjf2;
	}

	public void setExtobjf2(DocExtClass extobjf2) {
		this.extobjf2 = extobjf2;
	}

	public DocExtClass getExtobjf3() {
		return extobjf3;
	}

	public void setExtobjf3(DocExtClass extobjf3) {
		this.extobjf3 = extobjf3;
	}

	public DocExtClass getExtobjf4() {
		return extobjf4;
	}

	public void setExtobjf4(DocExtClass extobjf4) {
		this.extobjf4 = extobjf4;
	}

	public DocExtClass getExtobjf5() {
		return extobjf5;
	}

	public void setExtobjf5(DocExtClass extobjf5) {
		this.extobjf5 = extobjf5;
	}

	public DocExtClass getExtobjf6() {
		return extobjf6;
	}

	public void setExtobjf6(DocExtClass extobjf6) {
		this.extobjf6 = extobjf6;
	}

	public DocExtClass[] getExtobjf7() {
		return extobjf7;
	}

	public void setExtobjf7(DocExtClass[] extobjf7) {
		this.extobjf7 = extobjf7;
	}

	public DocExtClass getExtobjf8() {
		return extobjf8;
	}

	public void setExtobjf8(DocExtClass extobjf8) {
		this.extobjf8 = extobjf8;
	}

	public DocExtClass getExtobjf9() {
		return extobjf9;
	}

	public void setExtobjf9(DocExtClass extobjf9) {
		this.extobjf9 = extobjf9;
	}

	public DocExtClass getExtobjf10() {
		return extobjf10;
	}

	public void setExtobjf10(DocExtClass extobjf10) {
		this.extobjf10 = extobjf10;
	}

	public DocExtClass getExtobjf11() {
		return extobjf11;
	}

	public void setExtobjf11(DocExtClass extobjf11) {
		this.extobjf11 = extobjf11;
	}

	public DocExtClass getExtobjf12() {
		return extobjf12;
	}

	public void setExtobjf12(DocExtClass extobjf12) {
		this.extobjf12 = extobjf12;
	}

	public DocExtClass[] getExtobjf13() {
		return extobjf13;
	}

	public void setExtobjf13(DocExtClass[] extobjf13) {
		this.extobjf13 = extobjf13;
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

	public DocExtClass[] getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass[] extobj4) {
		this.extobj4 = extobj4;
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

	public String getTotals() {
		return totals;
	}

	public void setTotals(String totals) {
		this.totals = totals;
	}

	public String getTotals1() {
		return totals1;
	}

	public void setTotals1(String totals1) {
		this.totals1 = totals1;
	}

	public String getTotals2() {
		return totals2;
	}

	public void setTotals2(String totals2) {
		this.totals2 = totals2;
	}

	public String getTotals3() {
		return totals3;
	}

	public void setTotals3(String totals3) {
		this.totals3 = totals3;
	}

	public DocExtClass getWrite1() {
		return write1;
	}

	public void setWrite1(DocExtClass write1) {
		this.write1 = write1;
	}

	public DocExtClass getWrite2() {
		return write2;
	}

	public void setWrite2(DocExtClass write2) {
		this.write2 = write2;
	}

	public DocExtClass getWrite3() {
		return write3;
	}

	public void setWrite3(DocExtClass write3) {
		this.write3 = write3;
	}

	public DocExtClass getWrite4() {
		return write4;
	}

	public void setWrite4(DocExtClass write4) {
		this.write4 = write4;
	}

	public DocExtClass[] getExtobjg1() {
		return extobjg1;
	}

	public void setExtobjg1(DocExtClass[] extobjg1) {
		this.extobjg1 = extobjg1;
	}

	public DocExtClass[] getExtobjg2() {
		return extobjg2;
	}

	public void setExtobjg2(DocExtClass[] extobjg2) {
		this.extobjg2 = extobjg2;
	}
//
//	public DocExtClass[] getExtobjg3() {
//		return extobjg3;
//	}
//
//	public void setExtobjg3(DocExtClass[] extobjg3) {
//		this.extobjg3 = extobjg3;
//	}

	public DocExtClass[] getExtobjg4() {
		return extobjg4;
	}

	public void setExtobjg4(DocExtClass[] extobjg4) {
		this.extobjg4 = extobjg4;
	}

	public String getOpinion25() {
		return opinion25;
	}

	public void setOpinion25(String opinion25) {
		this.opinion25 = opinion25;
	}

	public String getOpinion26() {
		return opinion26;
	}

	public void setOpinion26(String opinion26) {
		this.opinion26 = opinion26;
	}

	public String getOpinion28() {
		return opinion28;
	}

	public void setOpinion28(String opinion28) {
		this.opinion28 = opinion28;
	}

	public String getOpinion29() {
		return opinion29;
	}

	public void setOpinion29(String opinion29) {
		this.opinion29 = opinion29;
	}

	public String getOpinion30() {
		return opinion30;
	}

	public void setOpinion30(String opinion30) {
		this.opinion30 = opinion30;
	}

	public String getAuditOpinion() {
		return auditOpinion;
	}

	public void setAuditOpinion(String auditOpinion) {
		this.auditOpinion = auditOpinion;
	}

	public DocExtClass getExtobjz0() {
		return extobjz0;
	}

	public void setExtobjz0(DocExtClass extobjz0) {
		this.extobjz0 = extobjz0;
	}

	public DocExtClass getExtobjc0() {
		return extobjc0;
	}

	public void setExtobjc0(DocExtClass extobjc0) {
		this.extobjc0 = extobjc0;
	}

	public DocExtClass getExtobjl0() {
		return extobjl0;
	}

	public void setExtobjl0(DocExtClass extobjl0) {
		this.extobjl0 = extobjl0;
	}

	public DocExtClass getExtobjx0() {
		return extobjx0;
	}

	public void setExtobjx0(DocExtClass extobjx0) {
		this.extobjx0 = extobjx0;
	}

	public DocExtClass getExtobjf1() {
		return extobjf1;
	}

	public void setExtobjf1(DocExtClass extobjf1) {
		this.extobjf1 = extobjf1;
	}

	public String getOpinion31() {
		return opinion31;
	}

	public void setOpinion31(String opinion31) {
		this.opinion31 = opinion31;
	}
	
}
