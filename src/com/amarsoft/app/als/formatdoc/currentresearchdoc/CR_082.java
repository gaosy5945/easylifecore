package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.List;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_082 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass extobj1;
    private DocExtClass[] extobj2;
    
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";
    private String opinion4="";
    private DocExtClass extobj3;

	public CR_082() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_082.initObject()");
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		if("".equals(opinion4))opinion4="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String guarantyNo = this.getGuarantyNo();
		if(guarantyNo==null)guarantyNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String customerID = "";
		
		try {
			if(guarantyNo!=null&& !"".equals(guarantyNo)){
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
				bo = q.getSingleResult();
				if(bo != null){
					customerID = bo.getAttribute("COLASSETOWNER").getString();
				}
				if(customerID!=null&& !"".equals(customerID)){
					extobj1 = new DocExtClass();
					m = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
					q = m.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",customerID);
					bo = q.getSingleResult();
					if(bo != null){
						extobj1.setAttr0(bo.getAttribute("FULLNAME").getString());
						String sex = bo.getAttribute("Sex").getString();
						extobj1.setAttr1(CodeManager.getItemName("Sex", sex));
						String certType = bo.getAttribute("CERTTYPE").getString();//证件类型
						extobj1.setAttr2(CodeManager.getItemName("CertType", certType));
						extobj1.setAttr3(bo.getAttribute("CERTID").getString());
						extobj1.setAttr4(bo.getAttribute("BIRTHDAY").getString());
						String eduExp = bo.getAttribute("EDUEXPERIENCE").getString();//最高学历
						extobj1.setAttr5(CodeManager.getItemName("EducationExperience", eduExp));
						extobj1.setAttr6(bo.getAttribute("FAMILYTEL").getString());//联系电话 
						extobj1.setAttr7(bo.getAttribute("MOBILETELEPHONE").getString());//手机号码
						
						String nativeAdd = bo.getAttribute("NATIVEADD").getString();//户籍地址
						extobj1.setAttr8(CodeManager.getItemName("AreaCode", nativeAdd));
						String commAdd = bo.getAttribute("COMMADD").getString();//通讯地址
						extobj1.setAttr9(CodeManager.getItemName("AreaCode", commAdd));
						
					}
					m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
					q = m.createQuery("CustomerID=:CustomerID and RelationShip like '03%' and length(RelationShip)>2 and RelationShip in ('0301','0302','0303')").setParameter("CustomerID", customerID);
					List<BizObject> relatives = q.getResultList();
					if(relatives.size()>0){
						extobj2 = new DocExtClass[relatives.size()];
						for(int i=0;i<relatives.size();i++){
							BizObject relative = relatives.get(i);
							extobj2[i] = new DocExtClass();
							extobj2[i].setAttr1(relative.getAttribute("CUSTOMERNAME").getString());
							String certType = bo.getAttribute("CERTTYPE").getString();
							extobj2[i].setAttr2(CodeManager.getItemName("CertType", certType));
							extobj2[i].setAttr3(relative.getAttribute("CERTID").getString());
							String relationShip = relative.getAttribute("RELATIONSHIP").getString();
							extobj2[i].setAttr4(CodeManager.getItemName("RelationShip",relationShip));
						}
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
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		extobj3 = new DocExtClass();
		return true;
	}

	public DocExtClass[] getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass[] extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
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

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}
	
}

