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

public class CR_011 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    private DocExtClass[] extobj1;
    private String opinion1 = "";

	public CR_011() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_011.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		String sObjectType=this.getRecordObjectType();
		if(sObjectNo==null)sObjectNo="";
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
	
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PROVIDER");
			q = m.createQuery("ObjectNo=:ObjectNo").setParameter("ObjectNo",sObjectNo);
			List<BizObject> providers = q.getResultList();
			extobj1 = new DocExtClass[providers.size()];
			if(providers.size()>0){
				for(int i=0;i<providers.size();i++){
					BizObject provider = providers.get(i);
					extobj1[i] = new DocExtClass();
					extobj1[i].setAttr1(provider.getAttribute("PROVIDERNAME").getString());
					String sRole = provider.getAttribute("PROVIDERROLE").getString();
					String sRoleName = CodeManager.getItemName("BankRole", sRole);
					extobj1[i].setAttr2(sRoleName);
					String sCurrency = provider.getAttribute("BUSINESSCURRENCY").getString();
					String sCurrencyName = CodeManager.getItemName("Currency", sCurrency);
					extobj1[i].setAttr3(sCurrencyName);
					extobj1[i].setAttr4(DataConvert.toMoney(provider.getAttribute("BUSINESSSUM").getDouble()/10000));
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
