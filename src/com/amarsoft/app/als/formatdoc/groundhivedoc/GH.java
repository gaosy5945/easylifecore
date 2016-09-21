package com.amarsoft.app.als.formatdoc.groundhivedoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;

public class GH extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private String opinion1 = "";

	public GH() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("GH.initObject()");
		if("".equals(opinion1))opinion1="";
		
		String sObjectNo=this.getRecordObjectNo();
		String sObjectType=this.getRecordObjectType();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
	
		String customerID = "";
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				customerID = bo.getAttribute("CustomerID").getString();
			}
			extobj1 = new DocExtClass();
			extobj2 = new DocExtClass();
			if(customerID!=null&& !"".equals(customerID)){
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_INFO");
				q = m.createQuery("select * from O where O.projectType='03' and O.projectno in (select pr.projectNo from jbo.app.PROJECT_RELATIVE pr where pr.objectType='Customer' and pr.ObjectNo=:CustomerID) order by O.projectno desc").setParameter("CustomerID",customerID);
				bo = q.getSingleResult();
				if(bo != null){
					String projectType = bo.getAttribute("ProjectType").getString();
					extobj1.setAttr1(CodeManager.getItemName("ProjectStyle", projectType));
					extobj1.setAttr2(bo.getAttribute("HOLDAREA").getString());
					extobj1.setAttr3(bo.getAttribute("PROJECTADD").getString());
					String otherar = bo.getAttribute("OTHERAREAFLAG").getString();
					extobj1.setAttr4(CodeManager.getItemName("YesNo",otherar));
					extobj1.setAttr5(DataConvert.toMoney(bo.getAttribute("Sum1").getDouble()));
					extobj1.setAttr6(DataConvert.toMoney(bo.getAttribute("PROJECTCAPITAL").getDouble()));
					extobj1.setAttr7(DataConvert.toMoney(bo.getAttribute("Sum2").getDouble()));
					extobj1.setAttr8(bo.getAttribute("Sum8").getString());
					extobj1.setAttr9(bo.getAttribute("LICENCE1").getString());
					extobj1.setAttr0(bo.getAttribute("LICENCE4").getString());
					extobj2.setAttr1(bo.getAttribute("LICENCE2").getString());
					extobj2.setAttr2(bo.getAttribute("LICENCE5").getString());
					extobj2.setAttr3(bo.getAttribute("LICENCE3").getString());
					extobj2.setAttr4(bo.getAttribute("LICENCE6").getString());
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

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}
	
}
