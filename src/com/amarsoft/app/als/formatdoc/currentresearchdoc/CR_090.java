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

public class CR_090 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private DocExtClass extobj2;
    private String opinion1="";

	public CR_090() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_090.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		extobj2 = new DocExtClass();
		try {
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
			q = m.createQuery("SELECT O.GUARANTYNAME,O.GUARANTYTYPE,O.OWNERNAME,O.CONFIRMVALUE,O.EVALNETVALUE," +
					"O.GUARANTYRATE FROM O,"+GuarantyConst.GUARANTY_CONTRACT+" gc,"+GuarantyConst.GUARANTY_RELATIVE+" gr  WHERE  gc.GuarantyType='060'  and gc.SerialNo=gr.contractno and gr.guarantyid=o.guarantyid " +
					" and gc.SerialNo in (select  AR.ObjectNo  from jbo.app.APPLY_RELATIVE AR where AR.SerialNo =:SerialNo)")
					.setParameter("SerialNo", sObjectNo);
			List<BizObject> guarantys = q.getResultList();
			double pgjz = 0,dyje = 0;
			if(guarantys.size() >0){
				extobj1 = new DocExtClass[guarantys.size()];
				for(int i=0;i<guarantys.size();i++){
					BizObject guaranty = guarantys.get(i);
					extobj1[i] = new DocExtClass();
					extobj1[i].setAttr1(guaranty.getAttribute("GUARANTYNAME").getString());
					String guarantyType = guaranty.getAttribute("GUARANTYTYPE").getString();
					extobj1[i].setAttr2(NameManager.getItemName("GuarantyType",guarantyType));
					String colaOwner = guaranty.getAttribute("OWNERNAME").getString();
					extobj1[i].setAttr3(NameManager.getCustomerName(colaOwner));
//					extobj1[i].setAttr4(guaranty.getAttribute("COLASSETCERTID").getString());
					double d1 = guaranty.getAttribute("CONFIRMVALUE").getDouble()/10000;
					extobj1[i].setAttr5(DataConvert.toMoney(d1));
					pgjz += d1;
					double d2 = guaranty.getAttribute("EVALNETVALUE").getDouble()/10000;
					extobj1[i].setAttr6(DataConvert.toMoney(d2));
					dyje += d2;
					extobj1[i].setAttr7( DataConvert.toMoney(guaranty.getAttribute("GUARANTYRATE").getString()));
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
