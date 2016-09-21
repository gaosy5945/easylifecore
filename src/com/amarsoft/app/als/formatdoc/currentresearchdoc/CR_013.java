package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.List;
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

public class CR_013 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private String opinion1 = "";

	public CR_013() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_013.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String contractNo = "";
	
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				contractNo=bo.getAttribute("RELATIVESERIALNO").getString();
				m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
				q = m.createQuery("SERIALNO = :serialNo").setParameter("serialNo", contractNo);
				List<BizObject> contracts = q.getResultList();
				if(contracts.size()>0) {
					extobj1 = new DocExtClass[contracts.size()];
					for(int i=0;i<contracts.size();i++){
						BizObject contract = contracts.get(i);
						extobj1[i] = new DocExtClass();
						extobj1[i].setAttr1(contract.getAttribute("SERIALNO").getString());
						String productID = contract.getAttribute("ProductID").getString();
						extobj1[i].setAttr2(NameManager.getBusinessName(productID));
						String sCurrency = contract.getAttribute("BUSINESSCURRENCY").getString();
						extobj1[i].setAttr3(CodeManager.getItemName("Currency", sCurrency));
						extobj1[i].setAttr4(DataConvert.toMoney(contract.getAttribute("BALANCE").getDouble()/10000));
						String vouchType = contract.getAttribute("VOUCHTYPE").getString();
						extobj1[i].setAttr5(CodeManager.getItemName("VouchType", vouchType));
						extobj1[i].setAttr6(contract.getAttribute("Putoutdate").getString());
						extobj1[i].setAttr7(contract.getAttribute("Maturity").getString());
						String classifyGrade = contract.getAttribute("CLASSIFYWORSTRES").getString();
						extobj1[i].setAttr8(CodeManager.getItemName("ClassifyGrade", classifyGrade));
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		return true;
	}

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}
	
}
