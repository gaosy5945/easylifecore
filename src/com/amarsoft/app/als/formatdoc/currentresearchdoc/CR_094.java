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
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_094 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private String opinion1="";

	public CR_094() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_094.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		
		try {//ÆäËûµÖÑº
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
			q = m.createQuery("select * from o where o.GUARANTYTYPE like '0010%' and length(o.GUARANTYTYPE)>4 and o.GUARANTYTYPE not in ('001000100020','001000100010','001000200010','001000100030') and o.GUARANTYID in (select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in (select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) order by o.GUARANTYNAME").setParameter("SERIALNO",sObjectNo);
			List<BizObject> rooms = q.getResultList();
			extobj1 = new DocExtClass[rooms.size()];
			if(rooms.size() > 0) {
				for(int i=0;i<rooms.size();i++){
					BizObject room = rooms.get(i);
					extobj1[i] = new DocExtClass();
					extobj1[i].setAttr1(room.getAttribute("GUARANTYNAME").getString());
					String guarantyType = room.getAttribute("GUARANTYTYPE").getString();
					extobj1[i].setAttr2(NameManager.getGuarantyTypeName(guarantyType));
					extobj1[i].setAttr3(DataConvert.toMoney(room.getAttribute("CONFIRMVALUE").getDouble()/10000));
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
