package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_095 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private DocExtClass extobj2;
    private String opinion1="";

	public CR_095() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_095.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		extobj2 = new DocExtClass();
		try {//质押物
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
			//q = m.createQuery("select * from o,jbo.app.GUARANTY_RELATIVE rel where o.GUARANTYID=rel.GUARANTYID and o.GUARANTYTYPE like '0020%' and o.GUARANTYID in (select gr.GuarantyID from jbo.app.GUARANTY_RELATIVE gr where gr.GCContractNo in (select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo))").setParameter("SERIALNO",sObjectNo);
			q = m.createQuery("SELECT O.GUARANTYNAME,O.GUARANTYTYPE,O.OWNERNAME,O.CONFIRMVALUE,O.EVALNETVALUE," +
					"O.GUARANTYRATE ,o.OwnerTime FROM O,"+GuarantyConst.GUARANTY_CONTRACT+" gc,"+GuarantyConst.GUARANTY_RELATIVE+" gr  WHERE  gc.GuarantyType='060'  and gc.SerialNo=gr.contractno and gr.guarantyid=o.guarantyid " +
					" and gc.SerialNo in (select  AR.ObjectNo  from jbo.app.APPLY_RELATIVE AR where AR.SerialNo =:SerialNo)")
					.setParameter("SerialNo", sObjectNo);
			List<BizObject> impawns = q.getResultList();
			extobj1 = new DocExtClass[impawns.size()];
			double pgjz = 0,dyje = 0;
			if(impawns.size() >0){
				for(int i=0;i<impawns.size();i++){
					BizObject impawn = impawns.get(i);
					extobj1[i] = new DocExtClass();
					extobj1[i].setAttr1(impawn.getAttribute("GUARANTYNAME").getString());
					String guarantyType = impawn.getAttribute("GUARANTYTYPE").getString();
					extobj1[i].setAttr2(NameManager.getItemName("GuarantyType",guarantyType));
					String colaOwner = impawn.getAttribute("OWNERNAME").getString();
					extobj1[i].setAttr3(NameManager.getCustomerName(colaOwner));
					extobj1[i].setAttr4(impawn.getAttribute("OwnerTime").getString());//金融质押到期日
					double d1 = impawn.getAttribute("CONFIRMVALUE").getDouble()/10000;
					extobj1[i].setAttr5(DataConvert.toMoney(d1));
					pgjz += d1;
					double d2 = impawn.getAttribute("EVALNETVALUE").getDouble()/10000;
					extobj1[i].setAttr6(DataConvert.toMoney(d2));
					dyje += d2;
					extobj1[i].setAttr7(impawn.getAttribute("GUARANTYRATE").getString());
				}
			}
			extobj2.setAttr1(DataConvert.toMoney(pgjz));
			extobj2.setAttr2(DataConvert.toMoney(dyje));
			if(pgjz==0){
				extobj2.setAttr3("0.0");
			}else{
				extobj2.setAttr3(String.format("%.2f",dyje/pgjz*100));
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

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}
	
}
