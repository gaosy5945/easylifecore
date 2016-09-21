package com.amarsoft.app.als.formatdoc.simpleeventdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.NameManager;

public class SE extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private DocExtClass docCover1;
    
	private String opinion1="";
    
	public SE() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("SE.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo=" ";
		String sObjectType=this.getRecordObjectType();
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String sCustomerID = "";
		String sOrgID = "";
		
		try {
			docCover1 = new DocExtClass();
			m = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RELA");
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
				m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
				bo = q.getSingleResult();
				
				if(bo != null){
					sCustomerID=bo.getAttribute("CustomerID").getString();
					//sOrgID = bo.getAttribute("OPERATEORGID").getString();
					String sUserID = bo.getAttribute("InputUserID").getString();
					//获取机构号
					BizObjectManager mm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
					BizObjectQuery qq = mm.createQuery("USERID=:USERID").setParameter("USERID",sUserID);
					BizObject boo = qq.getSingleResult();
					if(boo!=null){
						sOrgID=boo.getAttribute("BelongOrg").getString();
					}
					//合作方客户名称取值
					String applygroup=bo.getAttribute("ApplyGroup").getString();
					if(applygroup.equals("PartnerProject")){
						BizObjectManager m1= JBOFactory.getFactory().getManager("jbo.app.PARTNER_PROJECT_RELATIVE");
						BizObjectQuery q1 = m1.createQuery("ProjectNO=:productID").setParameter("productID",sCustomerID);
						BizObject boq = q1.getSingleResult();
						String CustomerID = boq.getAttribute("CustomerID").getString();
						docCover1.setAttr2(NameManager.getCustomerName(CustomerID));
					}else{
					docCover1.setAttr2(NameManager.getCustomerName(sCustomerID));
					}
					docCover1.setAttr3(NameManager.getOrgName(sOrgID));
					docCover1.setAttr4(NameManager.getUserName(sUserID));
					docCover1.setAttr5(StringFunction.getToday());
				}
			}
			}catch (Exception e) {
				e.printStackTrace();
				return false;
			}
			return true;
		}
		

	public boolean initObjectForEdit() {
//		ARE.getLog().trace(this.getClass().getName()+".initObjectForEdit()");
//		NumberFormat nf = NumberFormat.getInstance();
//        nf.setMinimumFractionDigits(0);
//        nf.setMaximumFractionDigits(6);
		opinion1 = " ";
		return true;
	}
	
	public DocExtClass getDocCover1() {
		return docCover1;
	}

	public void setDocCover1(DocExtClass docCover1) {
		this.docCover1 = docCover1;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}
}
