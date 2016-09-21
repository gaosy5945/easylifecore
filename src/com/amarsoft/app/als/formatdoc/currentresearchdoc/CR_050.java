package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;

public class CR_050 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
    
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

	public CR_050(){
		
	}
	
	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_050.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m=null;
		BizObjectQuery q=null;
		BizObject bo=null;
		String customerID="";
		
//		try{
//			//通过JBO工厂获取对象管理器
//			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
//			//创建查询并设置参数
//			q = m.createQuery("serialNo=:serialNo").setParameter("serialNo",sObjectNo);
//			//获取对象
//			bo = q.getSingleResult();
//			if(bo!=null){
//	           customerID=bo.getAttribute("CustomerID").getString();   
//			}
//			if(customerID!=null&& !"".equals(customerID)){
//				double expt=0,mint=0,balt=0,expt1=0,balt1=0,expt2=0,mint2=0,balt2=0;
//		/*****************************************************************************/	
//				List<DocExtClass> list1 = new ArrayList<DocExtClass>();
//				String curDate = StringFunction.getToday();//当前日期
//				m = JBOFactory.getFactory().getManager("jbo.lmt.LMT_INFO");
//				q = m.createQuery("LMTCUSTOMERID =:CustomerID and LMTType not in ('2011091000000001','2011082000000001','2011091300000001','2011091300000003','2011102500000001','2011102600000001')").setParameter("CustomerID",customerID);
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
//						q = m.createQuery("select sum(balance) as V.balance from O where RELATIVELMTID=:RELATIVELMTID and tabletype='Contract' and (applyType<>'ParProApply' or applyType is null)");
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
//										//利率
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
//				
//				
//				m = JBOFactory.getFactory().getManager("jbo.app.GUARANTY_CONTRACT");
//				q = m.createQuery("select distinct o.SerialNo,o.CustomerID,o.BeginDate,o.EndDate,o.GuarantyValue from o,jbo.app.GUARANTY_INFO GI,jbo.app.GUARANTY_RELATIVE GR where GI.GUARANTYID=GR.GUARANTYID and GR.GCCONTRACTNO=SERIALNO and GR.RelationStatus = '010' and GI.COLASSETOWNER=:CustomerID and ContractStatus = '020' and ENDDATE>:curDate and GUARANTYTYPE not in('010040','070') and serialno in "
//					       +"(select a.gur_serialno "
//					         +" from jbo.app.AGR_CRE_SEC_RELA a "
//					         +"where a.creditobjtype in ('BusinessContract', 'BusinessDeal') "
//					          +" and a.serialno in "
//					              +" (select bc.serialno "
//					                +"  from jbo.app.BUSINESS_CONTRACT bc "
//					                 +"where bc.customerid <> :CustomerID)) ");
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
//						String guarantyNo=contract.getAttribute("SerialNo").getString();
//						extobj4[i] = new DocExtClass();
//						extobj4[i].setAttr1(NameManager.getCustomerName(cusID));
//						extobj4[i].setAttr3(contract.getAttribute("BeginDate").getString());
//						extobj4[i].setAttr4(contract.getAttribute("EndDate").getString());
//						double guarant = contract.getAttribute("GuarantyValue").getDouble()/10000;
//						extobj4[i].setAttr5(DataConvert.toMoney(guarant));
//						outAll1 = outAll1 + guarant;
//						double gvalue = gcModel.getGuarantyBalance(guarantyNo)/10000;
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
//			}
//		}catch(Exception e){
//			e.printStackTrace();
//		}
		return true;
	}
	
//	//获取授信品种
//	private String getBusType(String serialNo){
//		BizObjectManager m=null;
//		BizObjectQuery q=null;
//		BizObject bo=null;
//		String sreturn = "";
//		try {
//			if(serialNo != null && !"".equals(serialNo)){
//				m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
//				q = m.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo);
//				bo = q.getSingleResult();
//				if(bo != null){
//					String applyGroup = bo.getAttribute("APPLYGROUP").getString();
//					String product = bo.getAttribute("PRODUCTID").getString();
//					if(applyGroup.equals(CreditConst.APPLYTYPE_GROUP_SINGLE)){
//						sreturn = NameManager.getBusinessName(product);
//					}else{
//						sreturn  = "综合授信";
//					}
//				}
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return sreturn;
//	}

	public boolean initObjectForEdit() {
		extobj2 = new DocExtClass();
		return true;
	}

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public String getExpTotal() {
		return expTotal;
	}

	public void setExpTotal(String expTotal) {
		this.expTotal = expTotal;
	}

	public String getBalanceTotal() {
		return balanceTotal;
	}

	public void setBalanceTotal(String balanceTotal) {
		this.balanceTotal = balanceTotal;
	}

	public DocExtClass[] getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass[] extobj3) {
		this.extobj3 = extobj3;
	}

	public String getExpTotal2() {
		return expTotal2;
	}

	public void setExpTotal2(String expTotal2) {
		this.expTotal2 = expTotal2;
	}

	public String getBalanceTotal2() {
		return balanceTotal2;
	}

	public void setBalanceTotal2(String balanceTotal2) {
		this.balanceTotal2 = balanceTotal2;
	}

	public String getMinTotal() {
		return minTotal;
	}

	public void setMinTotal(String minTotal) {
		this.minTotal = minTotal;
	}

	public String getMinTotal2() {
		return minTotal2;
	}

	public void setMinTotal2(String minTotal2) {
		this.minTotal2 = minTotal2;
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

	public DocExtClass[] getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass[] extobj4) {
		this.extobj4 = extobj4;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}
	
}
