package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import  com.amarsoft.biz.formatdoc.model.FormatDocData;
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

public class CR_012 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	private String customerName="";
    private String orgName="";
    private String autoRemark="";
    private String finalRemark="";
    
    private DocExtClass docCover1;
    
    private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass[] extobj2;
//    private DocExtClass[] extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;

	public CR_012() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_012.initObject()");
		
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
			extobj1 = new DocExtClass();
			extobj4 = new DocExtClass();
			extobj5 = new DocExtClass();
			if(bo != null){
				sCustomerID=bo.getAttribute("CustomerID").getString();
				sOrgID = bo.getAttribute("OPERATEORGID").getString();
				//extobj0.setAttr1(bo.getAttribute("CUSTOMERRELATION").getString());
				extobj0.setAttr2(bo.getAttribute("OCCURTYPE").getString());
			//	String productID = bo.getAttribute("ProductID").getString();
				//extobj1.setAttr1(NameManager.getBusinessName(productID));
				extobj1.setAttr2(bo.getAttribute("BUSINESSSUBTYPE").getString());
				String sCurrency = bo.getAttribute("BUSINESSCURRENCY").getString();
				extobj1.setAttr3(CodeManager.getItemName("Currency", sCurrency));
				//extobj1.setAttr4(bo.getAttribute("YMDNumber").getString());
				//extobj1.setAttr20(bo.getAttribute("CashGuaSum").getString());
				//String mdCode = bo.getAttribute("MDCode").getString();
				//if(!StringX.isSpace(mdCode))extobj1.setAttr10("("+CodeManager.getItemName("MDCode", mdCode)+")");
				extobj1.setAttr5(DataConvert.toMoney(bo.getAttribute("EXPOSURESUM").getDouble()/10000));
				extobj1.setAttr6(DataConvert.toMoney(bo.getAttribute("BusinessSum").getDouble()/10000));
//				extobj1.setAttr7(bo.getAttribute("BAILRATIO").getString());
				String sVouchType = bo.getAttribute("VouchType").getString();
				extobj1.setAttr8(CodeManager.getItemName("VouchType", sVouchType));
				String sVouchFlag = bo.getAttribute("VouchFlag").getString();
				extobj1.setAttr9(CodeManager.getItemName("VouchType", sVouchFlag));
				String adjust = bo.getAttribute("ADJUSTRATETYPE").getString();
				extobj1.setAttr11(CodeManager.getItemName("AdjustRateType", adjust));
				String payMethod = bo.getAttribute("CorpusPayMethod").getString();
				extobj1.setAttr12(CodeManager.getItemName("CorpusPayMethod", payMethod));
				
//				String operator = bo.getAttribute("MainOperator").getString();
//				extobj4.setAttr1(NameManager.getUserName(operator));
				String sUserID = bo.getAttribute("InputUserID").getString();
				extobj4.setAttr3(NameManager.getUserName(sUserID));
				
				extobj0.setAttr3(bo.getAttribute("OperateType").getString());
				
				docCover1.setAttr2(NameManager.getCustomerName(sCustomerID));
				docCover1.setAttr3(NameManager.getOrgName(sOrgID));
				docCover1.setAttr4(NameManager.getUserName(sUserID));
				docCover1.setAttr5(StringFunction.getToday());
				
				//主要负责人
	/*			BizObjectManager bmCP = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_PRINCIPAL");
				BizObjectQuery bqCP = bmCP.createQuery("CustomerID=:CustomerID and PrincipalOrgID =:PrincipalOrgID and Status =:Status")
				.setParameter("CustomerID",sCustomerID).setParameter("PrincipalOrgID",sOrgID).setParameter("Status","1");
				if(bqCP.getTotalCount() == 1){
					BizObject boCP = bqCP.getSingleResult();
					String PrincipalUserID=boCP.getAttribute("PrincipalUserID").getString();
					if(!StringX.isEmpty(PrincipalUserID)){
						extobj4.setAttr1(NameManager.getUserName(PrincipalUserID));
					}
				}	*/
				//if(!StringX.isSpace(productID)){
					//m = JBOFactory.getFactory().getManager("jbo.app.PRD_CATALOG");
					//q = m.createQuery("PRODUCTID=:productID").setParameter("productID",productID);
					//BizObject bb = q.getSingleResult();
					//String flag = bb.getAttribute("OFFSHEETFLAG").getString();
					//if("1".equals(flag)){
						extobj1.setAttr7(bo.getAttribute("RateFloat").getString());//表内业务这个字段取利率浮动幅度
					//}else if("2".equals(flag)){
						extobj1.setAttr34(bo.getAttribute("ExeYearRate").getString());
						extobj1.setAttr35(bo.getAttribute("BAILRATIO").getDouble()+"");//表外业务取保证金比例
					//}
				//}
			}
			customerName=NameManager.getCustomerName(sCustomerID);
			orgName=NameManager.getOrgName(sOrgID);
			
			List<DocExtClass> lmtInfos6=getGuaranty(sObjectNo);//担保人信息
			extobj2 = new DocExtClass[lmtInfos6.size()];
			if(lmtInfos6.size()>0){
				for(int i=0;i<lmtInfos6.size();i++){
					extobj2[i]=lmtInfos6.get(i);
				}
			}
			
			m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
			q = m.createQuery("CustomerNo=:CustomerNo and EffState = '1' and (FinishDate is null or FinishDate = ' ')").setParameter("CustomerNo",sCustomerID);
			bo = q.getSingleResult();
			if(bo != null){
				autoRemark = bo.getAttribute("ModeGrade01").getString();
				finalRemark = bo.getAttribute("RatingGrade99").getString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		extobj5 = new DocExtClass();
		return true;
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
//				q = m.createQuery("select distinct o.BailSum,o.CRMVALUE01,o.guarantyID,o.BAILOWNER,o.COLASSETOWNER,gr.CognizanceValue from o,jbo.app.GUARANTY_RELATIVE gr where o.GuarantyID=gr.GuarantyID AND o.GuarantyID in (select GR.GuarantyID from jbo.app.GUARANTY_RELATIVE GR where GR.GCContractNo = :ContractNo and GR.RelationStatus = '010' )").setParameter("ContractNo", countractNo);
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

	public DocExtClass[] getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass[] extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj5() {
		return extobj5;
	}

	public void setExtobj5(DocExtClass extobj5) {
		this.extobj5 = extobj5;
	}

	public DocExtClass getDocCover1() {
		return docCover1;
	}

	public void setDocCover1(DocExtClass docCover1) {
		this.docCover1 = docCover1;
	}
	
}
