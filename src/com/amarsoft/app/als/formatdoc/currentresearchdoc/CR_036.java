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
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_036 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private String opinion1="";

	public CR_036() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_036.initObject()");
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
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
				q = m.createQuery("CustomerID=:CustomerID and RelationShip like '01%' and length(RelationShip)>2").setParameter("CUSTOMERID",sCustomerID);
				List<BizObject> relatives = q.getResultList();
				extobj1 = new DocExtClass[relatives.size()];
				if(relatives.size()>0){
					for(int i=0;i<relatives.size();i++){
						BizObject relative = relatives.get(i);
						extobj1[i] = new DocExtClass();
						String sRelationShip = relative.getAttribute("RelationShip").getString();
						extobj1[i].setAttr1(CodeManager.getItemName("RelationShip",sRelationShip));
						extobj1[i].setAttr2(relative.getAttribute("CustomerName").getString());
						extobj1[i].setAttr3(relative.getAttribute("BIRTHDAY").getString());
						String eduExp = relative.getAttribute("DUTY").getString();
						extobj1[i].setAttr4(CodeManager.getItemName("EducationExperience", eduExp));
						extobj1[i].setAttr5(relative.getAttribute("HOLDDATE").getString());
						extobj1[i].setAttr6(relative.getAttribute("ENGAGETERM").getString());
						extobj1[i].setAttr7(relative.getAttribute("HOLDSTOCK").getString());
						extobj1[i].setAttr8(relative.getAttribute("DESCRIBE").getString());
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
