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
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_092 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;
    private String opinion1="";

	public CR_092() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_092.initObject()");
		if("".equals(opinion1))opinion1="";
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		
		try {//土地使用权抵押
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
			q = m.createQuery("select * from o where o.GUARANTYTYPE like '001000100010' and o.GUARANTYID in (select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in (select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) order by o.GUARANTYNAME").setParameter("SERIALNO",sObjectNo);
			List<BizObject> rooms = q.getResultList();
			extobj1 = new DocExtClass[rooms.size()];
			if(rooms.size() > 0) {
				for(int i=0;i<rooms.size();i++){
					BizObject room = rooms.get(i);
					extobj1[i] = new DocExtClass();
					String country = CodeManager.getItemName("CountryCode",room.getAttribute("COUNTRYCODE").getString());
					String province = CodeManager.getItemName("AreaCode",room.getAttribute("PROVINCE").getString());
					extobj1[i].setAttr1(country+province);
					extobj1[i].setAttr2(room.getAttribute("GROUNDLOCATION").getString());
					extobj1[i].setAttr3(room.getAttribute("GUARANTYNAME").getString());
					double bldgArea = room.getAttribute("COVEREDAREA").getDouble();
					extobj1[i].setAttr4(room.getAttribute("COVEREDAREA").getString());
					double conValue = room.getAttribute("CONFIRMVALUE").getDouble();
					extobj1[i].setAttr5(DataConvert.toMoney(conValue/bldgArea));
					String useType = room.getAttribute("GROUNDUSETYPE").getString();
					extobj1[i].setAttr6(CodeManager.getItemName("GuarantyGroundUse",useType));
					String accessType  = room.getAttribute("GROUNDACCESSTYPE").getString();
					extobj1[i].setAttr7(CodeManager.getItemName("GREarthType",accessType));
					String current = room.getAttribute("GROUNDCURRENT").getString();
					extobj1[i].setAttr8(CodeManager.getItemName("GroundStatus",current));
					extobj1[i].setAttr9(DataConvert.toMoney(room.getAttribute("TOTALPRICE").getDouble()/10000));
					extobj1[i].setAttr10(room.getAttribute("PURCHASEDATE").getString());
					String haveNot = room.getAttribute("ISACCRETE").getString();
					extobj1[i].setAttr11(CodeManager.getItemName("HaveNot", haveNot));
			
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
