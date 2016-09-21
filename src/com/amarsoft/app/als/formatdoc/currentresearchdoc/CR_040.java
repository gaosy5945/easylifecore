package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_040 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass extobj0;
    private String payType="";
    private String opinion0="";
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";

	public CR_040() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_040.initObject()");
		if("".equals(opinion0))opinion0="";
		if("".equals(opinion1))opinion1="";
		if("".equals(opinion2))opinion2="";
		if("".equals(opinion3))opinion3="";
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String sObjectType=this.getRecordObjectType();
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		extobj0 = new DocExtClass();
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				String payMethod = bo.getAttribute("CorpusPayMethod").getString();
				payType = CodeManager.getItemName("CorpusPayMethod", payMethod);
			}
			
			m = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_RECORD");
			q = m.createQuery("select * from o where o.ApplyNo=:ApplyNo and o.ApplyType=:ApplyType and RefModelID='WCLN001' and o.ratingScore01 is not null order by o.serialno desc");
			q.setParameter("ApplyNo",sObjectNo);
			q.setParameter("ApplyType", sObjectType);
			bo = q.getSingleResult();
			if(bo != null){
				String sSerialNo = bo.getAttribute("SerialNo").getString();
				m = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='3.05'").setParameter("SerialNo",sSerialNo);
				BizObject bb = q.getSingleResult();
				if(bb != null){
					extobj0.setAttr1(bb.getAttribute("Value1").getString());
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='2.12'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					extobj0.setAttr2(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='2.11'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					extobj0.setAttr3(bb.getAttribute("Value1").getString());
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='1.01'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					String value2 = bb.getAttribute("Value2").getString();
					if(!StringX.isSpace(value2)){
						extobj0.setAttr4(value2);
					}else{
						extobj0.setAttr4(bb.getAttribute("Value1").getString());
					}
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='3.04'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					extobj0.setAttr5(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='1.02'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					String value2 = bb.getAttribute("Value2").getString();
					if(!StringX.isSpace(value2)){
						extobj0.setAttr6(DataConvert.toMoney(bb.getAttribute("Value2").getDouble()/10000));
					}else{
						extobj0.setAttr6(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
					}
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='1.04'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					String value2 = bb.getAttribute("Value2").getString();
					if(!StringX.isSpace(value2)){
						extobj0.setAttr7(DataConvert.toMoney(bb.getAttribute("Value2").getDouble()/10000));
					}else{
						extobj0.setAttr7(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
					}
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='1.03'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					String value2 = bb.getAttribute("Value2").getString();
					if(!StringX.isSpace(value2)){
						extobj0.setAttr8(DataConvert.toMoney(bb.getAttribute("Value2").getDouble()/10000));
					}else{
						extobj0.setAttr8(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
					}
				}
				q = m.createQuery("SerialNo=:SerialNo and SubjectNo='3.08'").setParameter("SerialNo",sSerialNo);
				bb = q.getSingleResult();
				if(bb != null){
					extobj0.setAttr9(DataConvert.toMoney(bb.getAttribute("Value1").getDouble()/10000));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion0 = " ";
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion0() {
		return opinion0;
	}

	public void setOpinion0(String opinion0) {
		this.opinion0 = opinion0;
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

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}
	
}
