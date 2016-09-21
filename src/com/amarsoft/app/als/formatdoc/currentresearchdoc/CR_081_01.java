package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_081_01 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	private DocExtClass extobj01;
	private DocExtClass extobj02;
	private DocExtClass[] extobjg1;
	private DocExtClass[] extobjg2;
//	private DocExtClass[] extobjg3;
	private DocExtClass[] extobjg4;
	
	/************/
	private DocExtClass[] extobj1;
    private DocExtClass extobj2;
    private DocExtClass[] extobj3;
    private DocExtClass[] extobj4;
    private String expTotal="";
    private String minTotal="";
    private String balanceTotal="";
    private String expTotal2="";
    private String minTotal2="";
    private String balanceTotal2="";
    private String outAll="";
    private String outBalance="";
	/************/
	
	private String opinion1 = "";
	private String opinion2 = "";
	private String opinion3 = "";
	private String opinion4 = "";
	private String opinion5 = "";
	private String opinion6 = "";
	private String opinion7 = "";

	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	public CR_081_01() {
	}

	public boolean initObjectForRead() {
//		extobj01 = new DocExtClass();
//		extobj02 = new DocExtClass();
//		String sObjectNo=this.getRecordObjectNo();
//		if(sObjectNo==null)sObjectNo="";
//		String guarantyNo = this.getGuarantyNo();	
//		if(guarantyNo==null)guarantyNo="";
//		try {
//			if(guarantyNo!=null&& !"".equals(guarantyNo)){
//				m = JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO");
//				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
//				bo = q.getSingleResult();
//				if(bo != null){
//					customerID = bo.getAttribute("COLASSETOWNER").getString();
//				}
//			}
//			if(!StringX.isSpace(customerID)){
//				extobj01.setAttr1(NameManager.getCustomerName(customerID));
//				m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
//				q = m.createQuery("CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID",customerID);
//				bo = q.getSingleResult();
//				if(bo != null){
//					extobj01.setAttr2(bo.getAttribute("SetupDate").getString());
////					extobj01.setAttr3(bo.getAttribute("FictitiousPerson").getString());
//					String sIndustry = bo.getAttribute("IndustryType").getString();
//					extobj01.setAttr4(CodeManager.getItemName("IndustryType", sIndustry));//行业归属
//					String sScope = bo.getAttribute("Scope").getString();
//					extobj01.setAttr5(CodeManager.getItemName("Scope", sScope));//企业规模
//					extobj01.setAttr7(bo.getAttribute("ListingCorpornot").getString());
//					String sRCCurrency = bo.getAttribute("RCCurrency").getString();
//					extobj01.setAttr8(CodeManager.getItemName("Currency", sRCCurrency));//注册币种
//					extobj01.setAttr9(DataConvert.toMoney(bo.getAttribute("RegisterCapital").getDouble()/10000));
//					String sPCCurrency = bo.getAttribute("PCCurrency").getString();
//					extobj01.setAttr0(CodeManager.getItemName("Currency", sPCCurrency));
//					extobj02.setAttr1(DataConvert.toMoney(bo.getAttribute("PaiclupCapital").getDouble()/10000));
//					
//					//注册地址
//					String countryCode = bo.getAttribute("OFFICECOUNTRYCODE").getString();
//					String country = CodeManager.getItemName("CountryCode", countryCode);
//					String regionCode = bo.getAttribute("OFFICEREGIONCODE").getString();
//					String region = CodeManager.getItemName("AreaCode", regionCode);
//					String registerAdd = bo.getAttribute("REGISTERADD").getString();
//					extobj02.setAttr2(country+region+registerAdd);
//					//办公地址
//					String officeCountryCode = bo.getAttribute("COUNTRYCODE").getString();
//					String officeCountry = CodeManager.getItemName("CountryCode", officeCountryCode);
//					String officeRegionCode  = bo.getAttribute("REGIONCODE").getString();
//					String officeRegion = CodeManager.getItemName("AreaCode", officeRegionCode);
//					String officeAdd = bo.getAttribute("OFFICEADD").getString();
//					extobj02.setAttr3(officeCountry+officeRegion+officeAdd);
//					
//					extobj02.setAttr4(bo.getAttribute("OfficeTel").getString());
//					extobj02.setAttr5(bo.getAttribute("FinancedeptTel").getString());
//					extobj02.setAttr6(bo.getAttribute("BasicBank").getString());
//					extobj02.setAttr7(bo.getAttribute("MainBank").getString());
//					}
//				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
//				q = m.createQuery("CUSTOMERID=:CUSTOMERID and RelationShip='0109'").setParameter("CUSTOMERID",customerID);
//				bo = q.getSingleResult();
//				String keyMan="",fictitiousPerson="";
//				if(bo != null){
//					keyMan = bo.getAttribute("CustomerName").getString();
//				}
//				q = m.createQuery("CUSTOMERID=:CUSTOMERID and RelationShip='0100'").setParameter("CUSTOMERID",customerID);
//				bo = q.getSingleResult();
//				if(bo != null){
//					fictitiousPerson = bo.getAttribute("CustomerName").getString();
//					extobj01.setAttr3(fictitiousPerson);
//				}
////				if(StringX.isSpace(keyMan)){//若实际控制人为空，则赋值法定代表人
////					keyMan = fictitiousPerson;
////				}
//				extobj01.setAttr6(keyMan);
//				//上市时间、上市地点、股票代码
//				m = JBOFactory.getFactory().getManager("jbo.app.ENT_IPO");
//				q = m.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID);
//				bo = q.getSingleResult();
//				if(bo != null){
//					extobj02.setAttr8(bo.getAttribute("IPODate").getString());
//					String bourseName =  bo.getAttribute("BourseName").getString();
//					extobj02.setAttr9(CodeManager.getItemName("IPOName",bourseName));
//					extobj02.setAttr0(bo.getAttribute("StockCode").getString());
//				}
//				//股权结构
//				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
//				q = m.createQuery("CustomerID=:CustomerID and RelationShip like '52%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
//				List<BizObject> relatives = q.getResultList();
//				extobjg1 = new DocExtClass[relatives.size()];
//				if(relatives.size()>0){
//					for(int i=0;i<relatives.size();i++){
//						BizObject relative = relatives.get(i);
//						extobjg1[i] = new DocExtClass();
//						extobjg1[i].setAttr1(relative.getAttribute("CustomerName").getString());
//						String sRelationShip = relative.getAttribute("RelationShip").getString();
//						extobjg1[i].setAttr2(CodeManager.getItemName("RelationShip",sRelationShip));
//						String sCurrency = relative.getAttribute("CurrencyType").getString();
//						extobjg1[i].setAttr3(CodeManager.getItemName("Currency", sCurrency));
//						extobjg1[i].setAttr4(DataConvert.toMoney(relative.getAttribute("OughtSum").getDouble()/10000));
//						extobjg1[i].setAttr5(DataConvert.toMoney(relative.getAttribute("InvestmentSum").getDouble()/10000));
//						extobjg1[i].setAttr6(relative.getAttribute("InvestmentProp").getString());
//						extobjg1[i].setAttr7(relative.getAttribute("investDate").getString());
//					}
//				}
//				//对外投资情况
//				q = m.createQuery("CustomerID =:CustomerID and RelationShip like '02%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
//				relatives = q.getResultList();
//				extobjg2 = new DocExtClass[relatives.size()];
//				if(relatives.size()>0){
//					for(int i=0;i<relatives.size();i++){
//						BizObject relative = relatives.get(i);
//						extobjg2[i] = new DocExtClass();
//						extobjg2[i].setAttr1(relative.getAttribute("CustomerName").getString());
//						extobjg2[i].setAttr2(DataConvert.toMoney(relative.getAttribute("INVESTMENTSUM").getDouble()/10000));
//						extobjg2[i].setAttr3(relative.getAttribute("INVESTMENTPROP").getString());
//						extobjg2[i].setAttr4(DataConvert.toMoney(relative.getAttribute("TOTALASSETS").getDouble()/10000));
//						extobjg2[i].setAttr5(DataConvert.toMoney(relative.getAttribute("NETASSETS").getDouble()/10000));
//						extobjg2[i].setAttr6(DataConvert.toMoney(relative.getAttribute("ANNUALINCOME").getDouble()/10000));
//						extobjg2[i].setAttr7(DataConvert.toMoney(relative.getAttribute("PUREINCOME").getDouble()/10000));
////						String sRelativeID = relative.getAttribute("RELATIVEID").getString();
////						m = JBOFactory.getFactory().getManager("jbo.finasys.CUSTOMER_FSRECORD");
////						q = m.createQuery("CustomerID=:CustomerID and reportScope='02' order by ReportDate desc").setParameter("CustomerID",sRelativeID);
////						bo = q.getSingleResult();
////						if(bo != null){
////							String sRecordNo = bo.getAttribute("RecordNo").getString();
////							m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
////							q = m.createQuery("FSRecordNo=:RecordNo and ModelNo='0020'").setParameter("RecordNo",sRecordNo);
////							BizObject bb = q.getSingleResult();
////							if(bb != null) {
////								String sReportNo = bb.getAttribute("ReportNo").getString();
////								m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_DATA");
////								q = m.createQuery("ReportNo=:ReportNo and RowNo='0010'").setParameter("ReportNo",sReportNo);//条件标记下
////								BizObject bl = q.getSingleResult();
////								if(bl != null){
////									extobjg2[i].setAttr6(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()/10000));
////								}
////								q = m.createQuery("ReportNo=:ReportNo and RowNo='0170'").setParameter("ReportNo",sReportNo);
////								bl = q.getSingleResult();
////								if(bl != null){
////									extobjg2[i].setAttr7(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()/10000));
////								}
////							}
////							m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
////							q = m.createQuery("FSRecordNo=:RecordNo and ModelNo='0010'").setParameter("RecordNo",sRecordNo);
////							bb = q.getSingleResult();
////							if(bb != null) {
////								String sReportNo = bb.getAttribute("ReportNo").getString();
////								m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_DATA");
////								q = m.createQuery("ReportNo=:ReportNo and RowNo='0370'").setParameter("ReportNo",sReportNo);//条件标记下
////								BizObject bl = q.getSingleResult();
////								if(bl != null){
////									extobjg2[i].setAttr4(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()/10000));
////								}
////								q = m.createQuery("ReportNo=:ReportNo and RowNo='0720'").setParameter("ReportNo",sReportNo);
////								bl = q.getSingleResult();
////								if(bl != null){
////									extobjg2[i].setAttr5(DataConvert.toMoney(bl.getAttribute("Col2Value").getDouble()/10000));
////								}
////							}
////						}
//					}
//				}
//				//企业管理水平
//				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
//				q = m.createQuery("CustomerID=:CustomerID and RelationShip like '01%' and length(RelationShip)>2").setParameter("CUSTOMERID",customerID);
//				relatives = q.getResultList();
//				extobjg4 = new DocExtClass[relatives.size()];
//				if(relatives.size()>0){
//					for(int i=0;i<relatives.size();i++){
//						BizObject relative = relatives.get(i);
//						extobjg4[i] = new DocExtClass();
//						String sRelationShip = relative.getAttribute("RelationShip").getString();
//						extobjg4[i].setAttr1(CodeManager.getItemName("RelationShip",sRelationShip));
//						extobjg4[i].setAttr2(relative.getAttribute("CustomerName").getString());
//						extobjg4[i].setAttr3(relative.getAttribute("BIRTHDAY").getString());
//						String eduExp = relative.getAttribute("EDUEXPERIENCE").getString();
//						extobjg4[i].setAttr4(CodeManager.getItemName("EducationExperience", eduExp));
//						extobjg4[i].setAttr5(relative.getAttribute("HOLDDATE").getString());
//						extobjg4[i].setAttr6(relative.getAttribute("ENGAGETERM").getString());
//						extobjg4[i].setAttr7(relative.getAttribute("HOLDSTOCK").getString());
//					}
//				}
//				
//				
//				/***********************授信情况*****************************/
//
//				double expt=0,mint=0,balt=0,expt1=0,balt1=0,expt2=0,mint2=0,balt2=0;
//		/*****************************************************************************/	
//				List<DocExtClass> list1 = new ArrayList<DocExtClass>();
//				String curDate = StringFunction.getToday();//当前日期
//				m = JBOFactory.getFactory().getManager("jbo.lmt.LMT_INFO");
//				q = m.createQuery("LMTCUSTOMERID =:CustomerID").setParameter("CustomerID",customerID);
//				List<BizObject> contracts1 = q.getResultList();
//				String isSignal = "";
//				if(contracts1.size()>0){
//					for(int i=0;i<contracts1.size();i++){
//						BizObject contract1 = contracts1.get(i);
//						String lmtID = contract1.getAttribute("LMTID").getString();
//						String lmtType = contract1.getAttribute("LMTType").getString();
//						if(LMTTMPConst.LMTTYPE_SINGLE.equals(lmtType)){
//							//单笔单批
//							isSignal = "signal";
//						}else{
//							//综合授信
//							isSignal = "collect";
//						}
//		/****************************************************************************/	
//						double balance = 0;
//						m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//						q = m.createQuery("select sum(balance) as V.balance from O where RELATIVELMTID=:RELATIVELMTID and tabletype='Contract'");
//						q.setParameter("RELATIVELMTID", lmtID);
//						bo = q.getSingleResult();
//						if(bo !=null){
//							balance = bo.getAttribute("balance").getDouble();
//						}
//						
//						m = JBOFactory.getFactory().getManager("jbo.lmt.LMT_TREE_NODE");
//						q = m.createQuery("SELECT * FROM O where O.EFFECTIVESTATUS='020' and O.LMTID=:lmtID1 and O.LMTTREELEVEL=0 and (O.lmtEndDate>:CurDate or :Balance>0)");
//						q.setParameter("lmtID1", lmtID);
//						q.setParameter("CurDate", curDate);
//						q.setParameter("Balance", balance);
//						BizObject ltNode = q.getSingleResult();
//						if(ltNode != null){
//							DocExtClass dc = new DocExtClass();
//							String productList = ltNode.getAttribute("PRODUCTLIST").getString();
//							dc.setAttr3(ltNode.getAttribute("LMTSTARTDATE").getString());
//							dc.setAttr4(ltNode.getAttribute("LMTENDDATE").getString());
//							double d1 = ltNode.getAttribute("CUREXPSUM").getDouble()/10000;
//							expt = expt+d1;
//							dc.setAttr7(DataConvert.toMoney(d1));
//							double d2 = ltNode.getAttribute("CURNOMSUM").getDouble()/10000;
//							mint = mint + d2;
//							dc.setAttr9(DataConvert.toMoney(d2));
//							//余额
//							String NodeID = ltNode.getAttribute("LMTTREENODEID").getString();
////							double dbal = ltNode.getAttribute("TOTALOCCEXPSUM").getDouble()/10000;
//							dc.setAttr8(DataConvert.toMoney(balance/10000));
//							balt = balt+balance/10000;
//							
//							String marginRatio = "";
//							String rateFloat = "";
//							if(isSignal.equals("signal")){
//								dc.setAttr1(LMTCheckInManager.getLabelListName("03",productList));
//								marginRatio = ltNode.getAttribute("MINMARGINRATIO").getString();
//								rateFloat = ltNode.getAttribute("RATEFLOAT").getString();
//								if(!StringX.isSpace(productList)){
//									m = JBOFactory.getFactory().getManager("jbo.app.PRD_CATALOG");
//									q = m.createQuery("PRODUCTID=:productID").setParameter("productID",productList);
//									BizObject bb1= q.getSingleResult();
//									if(bb1 != null){
//										String flag = bb1.getAttribute("OFFSHEETFLAG").getString();
//										if("1".equals(flag)){
//											dc.setAttr5(rateFloat);//表内业务取利率浮动幅度
//										}else if("2".equals(flag)){
//											dc.setAttr5(marginRatio);//表外业务取保证金比例
//										}
//									}
//								}
//								m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//								q = m.createQuery("RELATIVETREENODEID=:RELATIVETREENODEID").setParameter("RELATIVETREENODEID",NodeID);
//								BizObject bcon = q.getSingleResult();
//								if(bcon != null){
//									String vouchType = bcon.getAttribute("VOUCHTYPE").getString();
//									dc.setAttr6(CodeManager.getItemName("VouchType",vouchType));
//								}
//							}else{
//								dc.setAttr1("综合授信");
//								String bcSerialno = ltNode.getAttribute("REFLMTAGRID").getString();
//								m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//								q = m.createQuery("SERIALNO=:Serialno").setParameter("Serialno",bcSerialno);
//								BizObject con = q.getSingleResult();
//								if(con!=null){
//									String vouchType = con.getAttribute("VOUCHTYPE").getString();
//									dc.setAttr6(CodeManager.getItemName("VouchType",vouchType));
//								}
//							}
//							list1.add(dc);
//						}
//					}
//				}
//				expTotal = DataConvert.toMoney(expt);
//				minTotal = DataConvert.toMoney(mint);
//				balanceTotal = DataConvert.toMoney(balt);
//				extobj1 = new DocExtClass[list1.size()];
//				if(list1.size()>0){
//					for(int i=0;i<list1.size();i++){
//						extobj1[i] = list1.get(i);
//					}
//				}
//				
//				String groupID = "";
//				m = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
//				q = m.createQuery("CUSTOMERID=:custonerID").setParameter("custonerID", customerID);
//				bo = q.getSingleResult();
//				if(bo != null){
//					groupID = bo.getAttribute("BELONGGROUPNAME").getString();
//				}
//				if(!StringX.isSpace(groupID)){
//					m = JBOFactory.getFactory().getManager("jbo.lmt.LMT_INFO");
//					List<DocExtClass> list2 = new ArrayList<DocExtClass>();
//					q = m.createQuery("LMTCUSTOMERID<>:CustomerID and LMTCUSTOMERID in (select gmr.MEMBERCUSTOMERID from jbo.app.GROUP_MEMBER_RELATIVE gmr where gmr.GroupID=:groupID)");
//					q.setParameter("CustomerID",customerID);
////					q.setParameter("CurDate", curDate);
//					q.setParameter("groupID", groupID);
//					List<BizObject> trNodes = q.getResultList();
//					if(trNodes.size()>0){
//						for(int i=0;i<trNodes.size();i++){
//							BizObject trNode = trNodes.get(i);
//							String lmtID = trNode.getAttribute("LMTID").getString();
//							String lmtType = trNode.getAttribute("LMTType").getString();
//							String memberID = trNode.getAttribute("LMTCUSTOMERID").getString();//成员编号
//							if(LMTTMPConst.LMTTYPE_SINGLE.equals(lmtType)){
//								isSignal = "signal";//单笔单批
//							}else{
//								isSignal = "collect";//综合授信
//							}
//							
//							double balance = 0;
//							m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//							q = m.createQuery("select sum(balance) as V.balance from O where RELATIVELMTID=:RELATIVELMTID and tabletype='Contract'");
//							q.setParameter("RELATIVELMTID", lmtID);
//							bo = q.getSingleResult();
//							if(bo !=null){
//								balance = bo.getAttribute("balance").getDouble();
//							}
//							
//							m = JBOFactory.getFactory().getManager("jbo.lmt.LMT_TREE_NODE");
//							q = m.createQuery("SELECT * FROM O where O.EFFECTIVESTATUS='020' and O.LMTID=:lmtID1 and O.LMTTREELEVEL=0 and (O.lmtEndDate>:CurDate or :Balance>0) ");
//							q.setParameter("lmtID1", lmtID);
//							q.setParameter("CurDate", curDate);
//							q.setParameter("Balance", balance);
//							BizObject ltNode = q.getSingleResult();
//							if(ltNode != null){
//								DocExtClass dc = new DocExtClass();
//								dc.setAttr1(NameManager.getCustomerName(memberID));
//								String productList = ltNode.getAttribute("PRODUCTLIST").getString();
//								dc.setAttr4(ltNode.getAttribute("LMTSTARTDATE").getString());
//								dc.setAttr5(ltNode.getAttribute("LMTENDDATE").getString());
//								double d1 = ltNode.getAttribute("CUREXPSUM").getDouble()/10000;
//								expt2 = expt2+d1;
//								dc.setAttr8(DataConvert.toMoney(d1));
//								double d2 = ltNode.getAttribute("CURNOMSUM").getDouble()/10000;
//								mint2 = mint2 + d2;
//								dc.setAttr10(DataConvert.toMoney(d2));
//								//余额
//								String NodeID = ltNode.getAttribute("LMTTREENODEID").getString();
//								dc.setAttr9(DataConvert.toMoney(balance/10000));
//								balt2 = balt2+balance/10000;
//								
//								String marginRatio = "";
//								String rateFloat = "";
//								if(isSignal.equals("signal")){
//									dc.setAttr2(LMTCheckInManager.getLabelListName("03",productList));
//									marginRatio = ltNode.getAttribute("MINMARGINRATIO").getString();
//									rateFloat = ltNode.getAttribute("RATEFLOAT").getString();
//									if(!StringX.isSpace(productList)){
//										m = JBOFactory.getFactory().getManager("jbo.app.PRD_CATALOG");
//										q = m.createQuery("PRODUCTID=:productID").setParameter("productID",productList);
//										BizObject bb1= q.getSingleResult();
//										if(bb1 != null){
//											String flag = bb1.getAttribute("OFFSHEETFLAG").getString();
//											if("1".equals(flag)){
//												dc.setAttr6(rateFloat);//表内业务取利率浮动幅度
//											}else if("2".equals(flag)){
//												dc.setAttr6(marginRatio);//表外业务取保证金比例
//											}
//										}
//									}
//									m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//									q = m.createQuery("RELATIVETREENODEID=:RELATIVETREENODEID").setParameter("RELATIVETREENODEID",NodeID);
//									BizObject bcon = q.getSingleResult();
//									if(bcon != null){
//										String vouchType = bcon.getAttribute("VOUCHTYPE").getString();
//										dc.setAttr7(CodeManager.getItemName("VouchType",vouchType));
//									}
//								}else{
//									dc.setAttr2("综合授信");
//									String bcSerialno = ltNode.getAttribute("REFLMTAGRID").getString();
//									m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
//									q = m.createQuery("SERIALNO=:Serialno").setParameter("Serialno",bcSerialno);
//									BizObject con = q.getSingleResult();
//									if(con!=null){
//										String vouchType = con.getAttribute("VOUCHTYPE").getString();
//										dc.setAttr7(CodeManager.getItemName("VouchType",vouchType));
//									}
//								}
//								list2.add(dc);
//							}
//						}
//					}
//					expTotal2 = DataConvert.toMoney(expt2);
//					minTotal2 = DataConvert.toMoney(mint2);
//					balanceTotal2 = DataConvert.toMoney(balt2);
//					extobj3 = new DocExtClass[list2.size()];
//					if(list2.size()>0){
//						for(int i=0;i<list2.size();i++){
//							extobj3[i] = list2.get(i);
//						}
//					}
//				}
//				//在本行对外担保
//				m = JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
//				q = m.createQuery("select DISTINCT o.SerialNo AS v.SerialNo,o.CustomerID,o.BeginDate,o.EndDate,o.GuarantyValue from o,jbo.app.GUARANTY_INFO GI,jbo.app.GUARANTY_RELATIVE GR where GI.GUARANTYID=GR.GUARANTYID and GR.GCCONTRACTNO=SERIALNO and GR.RelationStatus = '010' and GI.COLASSETOWNER=:CustomerID and ContractStatus = '020' and ENDDATE>:curDate and GUARANTYTYPE not in('010040','070') and o.CUSTOMERID<>:CustomerID1 ");
//				q.setParameter("CustomerID",customerID);
//				q.setParameter("curDate", curDate);
//				q.setParameter("CustomerID1",customerID);
//				List<BizObject> contracts = q.getResultList();
//				extobj4 = new DocExtClass[contracts.size()];
//				if(contracts.size()>0){
//					double outAll1 = 0;
//					double outBalance1 = 0;
//					GuarantyContractModel gcModel=new GuarantyContractModel();
//					for(int i=0;i<contracts.size();i++){
//						BizObject contract = contracts.get(i);
//						String cusID = contract.getAttribute("CustomerID").getString();
//						String guarantyNo1=contract.getAttribute("SerialNo").getString();
//						extobj4[i] = new DocExtClass();
//						extobj4[i].setAttr1(NameManager.getCustomerName(cusID));
//						extobj4[i].setAttr3(contract.getAttribute("BeginDate").getString());
//						extobj4[i].setAttr4(contract.getAttribute("EndDate").getString());
//						double guarant = contract.getAttribute("GuarantyValue").getDouble()/10000;
//						extobj4[i].setAttr5(DataConvert.toMoney(guarant));
//						outAll1 = outAll1 + guarant;
//						double gvalue = gcModel.getGuarantyBalance(guarantyNo1)/10000;
//						extobj4[i].setAttr6(DataConvert.toMoney(gvalue));
//						outBalance1 = outBalance1 + gvalue;
//						m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
//						q = m.createQuery("select * from O where CUSTOMERID=:CustomerID and RELATIVEID=:RelativeID");
//						q.setParameter("CustomerID",customerID);
//						q.setParameter("RelativeID", cusID);
//						BizObject bb = q.getSingleResult();
//						if(bb != null) extobj4[i].setAttr2("是");//是否关联企业
//						else extobj4[i].setAttr2("否");//是否关联企业
//					}
//					outAll = DataConvert.toMoney(outAll1);
//					outBalance = DataConvert.toMoney(outBalance1);
//				}
//				/***********************************************************/
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			return false;
//		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		opinion5 = " ";
		opinion6 = " ";
		return true;
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

	public DocExtClass[] getExtobjg4() {
		return extobjg4;
	}

	public void setExtobjg4(DocExtClass[] extobjg4) {
		this.extobjg4 = extobjg4;
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

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
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

	public String getExpTotal() {
		return expTotal;
	}

	public void setExpTotal(String expTotal) {
		this.expTotal = expTotal;
	}

	public String getMinTotal() {
		return minTotal;
	}

	public void setMinTotal(String minTotal) {
		this.minTotal = minTotal;
	}

	public String getBalanceTotal() {
		return balanceTotal;
	}

	public void setBalanceTotal(String balanceTotal) {
		this.balanceTotal = balanceTotal;
	}

	public String getExpTotal2() {
		return expTotal2;
	}

	public void setExpTotal2(String expTotal2) {
		this.expTotal2 = expTotal2;
	}

	public String getMinTotal2() {
		return minTotal2;
	}

	public void setMinTotal2(String minTotal2) {
		this.minTotal2 = minTotal2;
	}

	public String getBalanceTotal2() {
		return balanceTotal2;
	}

	public void setBalanceTotal2(String balanceTotal2) {
		this.balanceTotal2 = balanceTotal2;
	}

	public String getOutAll() {
		return outAll;
	}

	public void setOutAll(String outAll) {
		this.outAll = outAll;
	}

	public String getOutBalance() {
		return outBalance;
	}

	public void setOutBalance(String outBalance) {
		this.outBalance = outBalance;
	}

	public String getOpinion7() {
		return opinion7;
	}

	public void setOpinion7(String opinion7) {
		this.opinion7 = opinion7;
	}
	
}

