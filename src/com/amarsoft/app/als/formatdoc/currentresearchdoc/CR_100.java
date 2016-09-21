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
import com.amarsoft.are.lang.StringX;

public class CR_100 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private String opinion1="";

	public CR_100() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_100.initObject()");
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
			
//			m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
//			q = m.createQuery("select * from O where CustomerNo=:CustomerID and (ratingperion>='2011/12' or (ratingperion<'2011/12' and EffState='1' and FinishDate is null)) order by ratingperion asc")
//				 .setParameter("CustomerID",sCustomerID);
//			List<BizObject> guarantys = q.getResultList();
//			extobj1 = new DocExtClass[guarantys.size()];
//			if(guarantys.size() >0){
//				for(int i=0;i<guarantys.size();i++){
//					BizObject guaranty = guarantys.get(i);
//					extobj1[i] = new DocExtClass();
//					extobj1[i].setAttr1(guaranty.getAttribute("RatingPerion").getString());
//					extobj1[i].setAttr2(guaranty.getAttribute("ModeGrade01").getString());
//					extobj1[i].setAttr3(guaranty.getAttribute("RatingGrade99").getString());
//					String effState = guaranty.getAttribute("EffState").getString();
//					String finishDate = guaranty.getAttribute("FinishDate").getString();
//					if(effState.equals("1")&& StringX.isSpace(finishDate)){
//						extobj1[i].setAttr4("ÊÇ");
//					}else{
//						extobj1[i].setAttr4("·ñ");
//					}
//				}
//			}
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
