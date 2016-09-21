package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_010 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	private String customerName="";
    private String orgName="";
    private String autoRemark="";
    private String finalRemark="";
    
    private DocExtClass docCover1;
    
    private DocExtClass extobj0;
    private DocExtClass extobj1[];
    private DocExtClass extobj2[];
	private DocExtClass extobj3[];
	private DocExtClass extobj4[];
	private DocExtClass extobj5[];
	private DocExtClass extobj6[];
	private DocExtClass ext01;
	private DocExtClass ext02;
	private DocExtClass ext03;
	private DocExtClass ext05;
	private DocExtClass ext06;
	private DocExtClass ext07;
	private DocExtClass ext08;
	private DocExtClass ext09;
	private String flag1 = "none";
	private String flag2 = "none";
	private String flag3 = "none";
	private String flag4 = "none";
	private String flag5 = "none";
	private String flag6 = "none";
	private String flag7 = "none";
	private String flag8 = "none";
	private String flag9 = "none";
	private String flag10 = "none";
	
	private DocExtClass write;
	public CR_010() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_010.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String sObjectType=this.getRecordObjectType();
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
		String sOrgID = "";
	
		try {
		    docCover1 = new DocExtClass();
		    /*m = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RELA");
			q = m.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and fromPage='ResearchDoc'");
			q.setParameter("ObjectNo", sObjectNo);
			q.setParameter("ObjectType", sObjectType);
			bo = q.getSingleResult();
			if(bo != null){
				String docType = bo.getAttribute("docType").getString();
				m = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
				q = m.createQuery("DocType=:DocType and isinuse='1'").setParameter("DocType", docType);
				BizObject bb = q.getSingleResult();
				if(bb != null){
					docCover1.setAttr1(bb.getAttribute("DocName").getString());
				}
			}*/
			
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			extobj0 = new DocExtClass();
			if(bo != null){
				sCustomerID=bo.getAttribute("CustomerID").getString();
				//sOrgID = bo.getAttribute("OPERATEORGID").getString();
				String currency = bo.getAttribute("BUSINESSCURRENCY").getString();
				extobj0.setAttr0(CodeManager.getItemName("Currency", currency));
				//extobj0.setAttr1(bo.getAttribute("CUSTOMERRELATION").getString());
				extobj0.setAttr2(bo.getAttribute("OCCURTYPE").getString());
				String calculate = bo.getAttribute("CalculateMode").getString();
				//extobj0.setAttr3(CodeManager.getItemName("MEAType", calculate));
				extobj0.setAttr4(DataConvert.toMoney(bo.getAttribute("EXPOSURESUM").getDouble()/10000));//转化成金额形式
				extobj0.setAttr5(DataConvert.toMoney(bo.getAttribute("BusinessSum").getDouble()/10000));
				//extobj0.setAttr6(bo.getAttribute("YMDNumber").getString());
				//String mdCode = bo.getAttribute("MDCode").getString();
				//if(!StringX.isSpace(mdCode))extobj0.setAttr10("("+CodeManager.getItemName("MDCode", mdCode)+")");
				String sVouchType = bo.getAttribute("VouchType").getString();
				extobj0.setAttr7(CodeManager.getItemName("VouchType", sVouchType));
				String sVouchFlag = bo.getAttribute("VouchFlag").getString();
				extobj0.setAttr8(CodeManager.getItemName("VouchType", sVouchFlag));
//				String mainOperator = bo.getAttribute("MainOperator").getString();
//				extobj0.setAttr11(NameManager.getUserName(mainOperator));
				String sUserID = bo.getAttribute("InputUserID").getString();
				extobj0.setAttr12(NameManager.getUserName(sUserID));
				
				//获取机构号
				BizObjectManager mm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
				BizObjectQuery qq = mm.createQuery("USERID=:USERID").setParameter("USERID",sUserID);
				BizObject boo = qq.getSingleResult();
				if(boo!=null){
					sOrgID=boo.getAttribute("BelongOrg").getString();
				}
				//合作方客户名称取值
			/*	String applygroup=bo.getAttribute("ApplyGroup").getString();
				if(applygroup.equals("PartnerProject")){
					BizObjectManager m1= JBOFactory.getFactory().getManager("jbo.app.PARTNER_PROJECT_RELATIVE");
					BizObjectQuery q1 = m1.createQuery("ProjectNO=:productID").setParameter("productID",sCustomerID);
					BizObject boq = q1.getSingleResult();
					String CustomerID = boq.getAttribute("CustomerID").getString();
					docCover1.setAttr2(NameManager.getCustomerName(CustomerID));
				}else{
				docCover1.setAttr2(NameManager.getCustomerName(sCustomerID));
				}*/
				docCover1.setAttr3(NameManager.getOrgName(sOrgID));
				docCover1.setAttr4(NameManager.getUserName(sUserID));
				docCover1.setAttr5(StringFunction.getToday());
			}
			//主要负责人
			BizObjectManager bmCP = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_PRINCIPAL");
			BizObjectQuery bqCP = bmCP.createQuery("CustomerID=:CustomerID and PrincipalOrgID =:PrincipalOrgID and Status =:Status")
			.setParameter("CustomerID",sCustomerID).setParameter("PrincipalOrgID",sOrgID).setParameter("Status","1");
			if(bqCP.getTotalCount() == 1){
				BizObject boCP = bqCP.getSingleResult();
				String PrincipalUserID=boCP.getAttribute("PrincipalUserID").getString();
				if(!StringX.isEmpty(PrincipalUserID)){
					extobj0.setAttr11(NameManager.getUserName(PrincipalUserID));
				}
			}
			customerName=NameManager.getCustomerName(sCustomerID);
			orgName=NameManager.getOrgName(sOrgID);
			
			List<DocExtClass> lmtInfos6=getGuaranty(sObjectNo);//担保人信息
			extobj1 = new DocExtClass[lmtInfos6.size()];
			if(lmtInfos6.size()>0){
				for(int i=0;i<lmtInfos6.size();i++){
					extobj1[i]=lmtInfos6.get(i);
				}
			}
			
			m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
			q = m.createQuery("CustomerNo=:CustomerNo and EffState = '1' and (FinishDate is null or FinishDate = ' ')").setParameter("CustomerNo",sCustomerID);
			bo = q.getSingleResult();
			if(bo != null){
				autoRemark = bo.getAttribute("ModeGrade01").getString();
				finalRemark = bo.getAttribute("RatingGrade99").getString();
			}
			
			ext05=getDocExtClass(sObjectNo,"010");
			if(ext05.getAttr0()!=null||ext05.getAttr1()!=null||ext05.getAttr2()!=null){
				flag1 = "block";
			}else{
				flag1 = "none";
			}
			ext06=getDocExtClass(sObjectNo,"020");
			if(ext06.getAttr0()!=null||ext06.getAttr1()!=null||ext06.getAttr2()!=null){
				flag2 = "block";
			}else{
				flag2 = "none";
			}
			ext07=getDocExtClass(sObjectNo,"030");
			if(ext07.getAttr0()!=null||ext07.getAttr1()!=null||ext07.getAttr2()!=null){
				flag3 = "block";
			}else{
				flag3 = "none";
			}
			ext08=getDocExtClass(sObjectNo,"040");
			if(ext08.getAttr0()!=null||ext08.getAttr1()!=null||ext08.getAttr2()!=null){
				flag4 = "block";
			}else{
				flag4 = "none";
			}
			ext09=getDocExtClass(sObjectNo,"050");
			if(ext09.getAttr0()!=null||ext09.getAttr1()!=null||ext09.getAttr2()!=null){
				flag5 = "block";
			}else{
				flag5 = "none";
			}
			List<DocExtClass> lmtInfos1=getDocExtClassList(sObjectNo,"010");//一般
			if(lmtInfos1.size()>0){
				flag6 = "block";
			}else{
				flag6 = "none";
			}
			extobj2 = new DocExtClass[lmtInfos1.size()];
			for(int i=0;i<lmtInfos1.size();i++){
				extobj2[i] = lmtInfos1.get(i);
				
			}
			
			List<DocExtClass> lmtInfos2=getDocExtClassList(sObjectNo,"020");//货押
			if(lmtInfos2.size()>0){
				flag7 = "block";
			}else{
				flag7 = "none";
			}
			extobj3 = new DocExtClass[lmtInfos2.size()];
			for(int i=0;i<lmtInfos2.size();i++){
				extobj3[i] = lmtInfos2.get(i);
				
			}
			List<DocExtClass> lmtInfos3=getDocExtClassList(sObjectNo,"030");//保理
			if(lmtInfos3.size()>0){
				flag8 = "block";
			}else{
				flag8 = "none";
			}
			extobj4 = new DocExtClass[lmtInfos3.size()];
			for(int i=0;i<lmtInfos3.size();i++){
				extobj4[i] = lmtInfos3.get(i);
				
			}
			List<DocExtClass> lmtInfos4=getDocExtClassList(sObjectNo,"040");//厂商银
			if(lmtInfos4.size()>0){
				flag9 = "block";
			}else{
				flag9 = "none";
			}
			extobj5 = new DocExtClass[lmtInfos4.size()];
			for(int i=0;i<lmtInfos4.size();i++){
				extobj5[i] = lmtInfos4.get(i);
				
			}
			List<DocExtClass> lmtInfos5=getDocExtClassList(sObjectNo,"050");//结构性订单融资
			if(lmtInfos5.size()>0){
				flag10 = "block";
			}else{
				flag10 = "none";
			}
			extobj6 = new DocExtClass[lmtInfos5.size()];
			for(int i=0;i<lmtInfos5.size();i++){
				extobj6[i] = lmtInfos5.get(i);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		write = new DocExtClass();
		return true;
	}
	
	public List<DocExtClass>  getDocExtClassList(String objectNo,String CurNodeDim) {
		List<DocExtClass> lmtInfos1= new ArrayList<DocExtClass>();
		try{
			BizObjectManager bm=JBOFactory.getFactory().getManager("jbo.lmt.LMT_TREE_NODE");
			String jql = "REFBIZAPPLID =:ObjectNo and CurNodeDim=:CurNodeDim and LmtTreeLevel=1 and (copystatus<>'D' or copystatus is null)";
			BizObjectQuery bq=bm.createQuery(jql).setParameter("ObjectNo", objectNo).setParameter("CurNodeDim", CurNodeDim);
			BizObject bo=bq.getSingleResult();
			String lmtTreeNodID ="";
			if(bo!=null) lmtTreeNodID=bo.getAttribute("LMTTREENODEID").toString();
			BizObjectQuery bq1=bm.createQuery("PARENTNODEID =:PARENTNODEID and (copystatus<>'D' or copystatus is null)").setParameter("PARENTNODEID", lmtTreeNodID);
			List<BizObject> lmtInfos=bq1.getResultList();
			BizObjectManager bmprd = JBOFactory.getFactory().getManager("jbo.app.PRD_CATALOG");
			BizObjectQuery bqprd = null;
			for(int i=0;i<lmtInfos.size();i++){
				ext01=new DocExtClass();
				BizObject bo1=lmtInfos.get(i);
				ext01.setAttr9(bo1.getAttribute("REQMARGINRATIO").toString());
				String lmtTreeNodID1=bo1.getAttribute("LMTTREENODEID").toString();
				ext01.setAttr2(DataConvert.toMoney(bo1.getAttribute("CURNOMSUM").getDouble()/10000));
				ext01.setAttr3(DataConvert.toMoney(bo1.getAttribute("CUREXPSUM").getDouble()/10000));
				ext01.setAttr4(bo1.getAttribute("YMDNumber").toString());
//				ext01.setAttr5(bo1.getAttribute("MINMARGINRATIO").toString());
//				ext01.setAttr6(bo1.getAttribute("RATEFLOAT").toString());
				String marginRatio = bo1.getAttribute("MINMARGINRATIO").toString();//保证金比例
				String rateFloat = bo1.getAttribute("RATEFLOAT").toString();//利率浮动幅度
				ext01.setAttr1(i+1+"、"+bo1.getAttribute("CurNodeLabel").getString());
//				String payMethod = bo1.getAttribute("PAYCYC").getString();
				ext01.setAttr7(CodeManager.getItemName("CorpusPayMethod", bo1.getAttribute("PAYCYC").getString()));
//				String adjust = bo1.getAttribute("ADJUSTRATETYPE").getString();
				ext01.setAttr8(CodeManager.getItemName("AdjustRateType", bo1.getAttribute("ADJUSTRATETYPE").getString()));
				String prdId = bo1.getAttribute("CURNODEDIM").getString();
				if(!StringX.isSpace(prdId)&&prdId.indexOf(",")<0){
					bqprd = bmprd.createQuery("ProductId=:productID and offSheetFlag='2' and sortno not like '001000700010%' and sortno not like '001000600050%'")
								 .setParameter("productID", prdId);
					List<BizObject> listPrd = bqprd.getResultList();
					if(listPrd.size()>0){
						ext01.setAttr5(marginRatio);
					}else{
						ext01.setAttr6(rateFloat);
					}
				}
				lmtInfos1.add(ext01);
				BizObjectQuery bq2=bm.createQuery("PARENTNODEID =:PARENTNODEID").setParameter("PARENTNODEID", lmtTreeNodID1);
				List<BizObject> lmtInfos2=bq2.getResultList();
				for(int j=0;j<lmtInfos2.size();j++){
					ext02=new DocExtClass();
					BizObject bo2=lmtInfos2.get(j);
					ext02.setAttr9(bo2.getAttribute("REQMARGINRATIO").toString());
					ext02.setAttr2(DataConvert.toMoney(bo2.getAttribute("CURNOMSUM").getDouble()/10000));
					ext02.setAttr3(DataConvert.toMoney(bo2.getAttribute("CUREXPSUM").getDouble()/10000));
					ext02.setAttr4(bo2.getAttribute("YMDNumber").getString());
//					ext02.setAttr5(bo2.getAttribute("MINMARGINRATIO").getString());
//					ext02.setAttr6(bo2.getAttribute("RATEFLOAT").getString());
					marginRatio = bo2.getAttribute("MINMARGINRATIO").toString();//保证金比例
					rateFloat = bo2.getAttribute("RATEFLOAT").toString();//利率浮动幅度
					ext02.setAttr1("("+(j+1)+")"+bo2.getAttribute("CurNodeLabel").getString());
					String payMethod = bo2.getAttribute("PAYCYC").getString();
					ext02.setAttr7(CodeManager.getItemName("CorpusPayMethod", payMethod));
					String adjust = bo2.getAttribute("ADJUSTRATETYPE").getString();
					ext02.setAttr8(CodeManager.getItemName("AdjustRateType", adjust));
					
					String prdId1 = bo2.getAttribute("CURNODEDIM").getString();
					if(!StringX.isSpace(prdId1)&&prdId1.indexOf(",")<0){
						bqprd = bmprd.createQuery("ProductId=:productID and offSheetFlag='2' and sortno not like '001000700010%' and sortno not like '001000600050%'")
									 .setParameter("productID", prdId1);
						List<BizObject> listPrd = bqprd.getResultList();
						if(listPrd.size()>0){
							ext02.setAttr5(marginRatio);
						}else{
							ext02.setAttr6(rateFloat);
						}
					}
					lmtInfos1.add(ext02);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return lmtInfos1;
	}
	
	public DocExtClass getDocExtClass(String objectNo,String CurNodeDim) {
		DocExtClass ext04=new DocExtClass();
		try {
			BizObjectManager  bm = JBOFactory.getFactory().getManager("jbo.lmt.LMT_TREE_NODE");
			String jql = "REFBIZAPPLID =:ObjectNo and CurNodeDim=:CurNodeDim and LmtTreeLevel=1 and (copystatus<>'D' or copystatus is null)";
			BizObjectQuery bq=bm.createQuery(jql).setParameter("ObjectNo", objectNo).setParameter("CurNodeDim", CurNodeDim);
			BizObject bo=bq.getSingleResult();
		    if(bo!=null){
				ext04.setAttr0(DataConvert.toMoney(bo.getAttribute("CURNOMSUM").getDouble()/10000));
				ext04.setAttr1(DataConvert.toMoney(bo.getAttribute("CUREXPSUM").getDouble()/10000));
				ext04.setAttr2(bo.getAttribute("YMDNumber").toString());
				String mdCode = bo.getAttribute("MDCode").getString();
				if(!StringX.isSpace(mdCode))ext04.setAttr3("("+CodeManager.getItemName("MDCode",mdCode)+")");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ext04;
	}

	public List<DocExtClass> getGuaranty(String objectNo){
		List<DocExtClass> gmsg = new ArrayList<DocExtClass>();
	try {
		BizObjectManager m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_CONTRACT);
		BizObjectQuery q = m.createQuery("select o.SerialNo,o.guarantytype,o.GuarantyValue from o where o.SerialNo in (select acs.GUR_SERIALNO from jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:serialNo and acs.CREDITOBJTYPE='CreditApply')").setParameter("serialNo",objectNo);
		List<BizObject> guarantys = q.getResultList();
		if(guarantys.size()>0){
			for(int i=0;i<guarantys.size();i++){
				BizObject graranty = guarantys.get(i);
				String guaType = graranty.getAttribute("GuarantyType").getString();
				String sGuarantyType = CodeManager.getItemName("GuarantyType",guaType);
				String countractNo = graranty.getAttribute("SerialNo").getString();
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("select distinct o.CURRENCY,o.BailSum,o.CRMVALUE01,o.guarantyID,o.BAILOWNER,o.COLASSETOWNER,gr.CognizanceValue from o,"+GuarantyConst.GUARANTY_RELATIVE+" gr where o.GuarantyID=gr.GuarantyID and gr.GCContractNo = :ContractNo and gr.RelationStatus = '010' ").setParameter("ContractNo", countractNo);
				List<BizObject> names = q.getResultList();
				if(names.size()>0){
					for(int j=0;j<names.size();j++){
						BizObject namea= names.get(j);
						DocExtClass dec = new DocExtClass();
						if(guaType.equals("010040")){
							dec.setAttr1(NameManager.getCustomerName(namea.getAttribute("BAILOWNER").getString()));
							dec.setAttr3(DataConvert.toMoney(namea.getAttribute("BailSum").getDouble()/10000));
						}else if(guaType.equals("010010")){
							dec.setAttr1(NameManager.getCustomerName(namea.getAttribute("COLASSETOWNER").getString()));
							dec.setAttr3(DataConvert.toMoney(namea.getAttribute("CRMVALUE01").getDouble()/10000));
						}else{
//							dec.setAttr1(NameManager.getCustomerName(namea.getAttribute("COLASSETOWNER").getString()));
//						    dec.setAttr3(DataConvert.toMoney(namea.getAttribute("CognizanceValue").getDouble()/10000));
						    String currency=namea.getAttribute("CURRENCY").getString();
							String CognizanceValue=namea.getAttribute("CognizanceValue").getString();
							double value=Double.parseDouble(getCognizanceValue(currency,CognizanceValue));
							dec.setAttr1(NameManager.getCustomerName(namea.getAttribute("COLASSETOWNER").getString()));
						    dec.setAttr3(DataConvert.toMoney(value/10000));
						}
						dec.setAttr2(sGuarantyType);
						gmsg.add(dec);
					}
				}
			}
		}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return gmsg; 
	}
	
	/**
	 * 获取币种对应的认定价值
	 */
	public static String getCognizanceValue(String currency,String cognizanceValue) throws Exception{
		double exchangeValue = 0.0;
		double dCognizanceValue = 0.0;
		if(!StringX.isSpace(cognizanceValue) && !"null".equals(cognizanceValue)){
			dCognizanceValue = Double.parseDouble(cognizanceValue);
		}
		BizObjectManager bmEI = JBOFactory.getFactory().getManager("jbo.sys.ERATE_INFO");
		BizObject boForEI = bmEI.createQuery("Currency=:Currency").setParameter("Currency",currency).getSingleResult();
		if(boForEI != null){
			exchangeValue = boForEI.getAttribute("ExchangeValue").getDouble();
		}
		if(exchangeValue != 0){
			dCognizanceValue = dCognizanceValue/exchangeValue;
		}
		return String.valueOf(dCognizanceValue);
	}
	
	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getAutoRemark() {
		return autoRemark;
	}

	public void setAutoRemark(String autoRemark) {
		this.autoRemark = autoRemark;
	}

	public String getFinalRemark() {
		return finalRemark;
	}

	public void setFinalRemark(String finalRemark) {
		this.finalRemark = finalRemark;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
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

	public DocExtClass[] getExtobj5() {
		return extobj5;
	}

	public void setExtobj5(DocExtClass[] extobj5) {
		this.extobj5 = extobj5;
	}

	public DocExtClass[] getExtobj6() {
		return extobj6;
	}

	public void setExtobj6(DocExtClass[] extobj6) {
		this.extobj6 = extobj6;
	}

	public DocExtClass getExt01() {
		return ext01;
	}

	public void setExt01(DocExtClass ext01) {
		this.ext01 = ext01;
	}

	public DocExtClass getExt02() {
		return ext02;
	}

	public void setExt02(DocExtClass ext02) {
		this.ext02 = ext02;
	}

	public DocExtClass getExt03() {
		return ext03;
	}

	public void setExt03(DocExtClass ext03) {
		this.ext03 = ext03;
	}

	public DocExtClass getExt05() {
		return ext05;
	}

	public void setExt05(DocExtClass ext05) {
		this.ext05 = ext05;
	}

	public DocExtClass getExt06() {
		return ext06;
	}

	public void setExt06(DocExtClass ext06) {
		this.ext06 = ext06;
	}

	public DocExtClass getExt07() {
		return ext07;
	}

	public void setExt07(DocExtClass ext07) {
		this.ext07 = ext07;
	}

	public DocExtClass getExt08() {
		return ext08;
	}

	public void setExt08(DocExtClass ext08) {
		this.ext08 = ext08;
	}

	public DocExtClass getExt09() {
		return ext09;
	}

	public void setExt09(DocExtClass ext09) {
		this.ext09 = ext09;
	}

	public String getFlag1() {
		return flag1;
	}

	public void setFlag1(String flag1) {
		this.flag1 = flag1;
	}

	public String getFlag2() {
		return flag2;
	}

	public void setFlag2(String flag2) {
		this.flag2 = flag2;
	}

	public String getFlag3() {
		return flag3;
	}

	public void setFlag3(String flag3) {
		this.flag3 = flag3;
	}

	public String getFlag4() {
		return flag4;
	}

	public void setFlag4(String flag4) {
		this.flag4 = flag4;
	}

	public String getFlag5() {
		return flag5;
	}

	public void setFlag5(String flag5) {
		this.flag5 = flag5;
	}

	public String getFlag6() {
		return flag6;
	}

	public void setFlag6(String flag6) {
		this.flag6 = flag6;
	}

	public String getFlag7() {
		return flag7;
	}

	public void setFlag7(String flag7) {
		this.flag7 = flag7;
	}

	public String getFlag8() {
		return flag8;
	}

	public void setFlag8(String flag8) {
		this.flag8 = flag8;
	}

	public String getFlag9() {
		return flag9;
	}

	public void setFlag9(String flag9) {
		this.flag9 = flag9;
	}

	public String getFlag10() {
		return flag10;
	}

	public void setFlag10(String flag10) {
		this.flag10 = flag10;
	}

	public DocExtClass getWrite() {
		return write;
	}

	public void setWrite(DocExtClass write) {
		this.write = write;
	}

	public DocExtClass getDocCover1() {
		return docCover1;
	}

	public void setDocCover1(DocExtClass docCover1) {
		this.docCover1 = docCover1;
	}
	
}
