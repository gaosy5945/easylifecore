package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class SelectGuarantySum {
	
	public static String selectPrjStatus(String GuarantySerialNo) throws Exception{
		
		BizObjectManager ARtable = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");

		BizObjectQuery q =ARtable.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and RelativeType=:RelativeType")
				.setParameter("ObjectNo", GuarantySerialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("RelativeType", "05");
		List<BizObject> DataLast = q.getResultList(false);
		String BASerialNo = "";
		Double BAAmount = 0.00;
		Double BCAmount = 0.00;
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				BASerialNo = bo.getAttribute("ApplySerialNo").getString();
				BizObjectManager BAtable = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
				
				BizObjectQuery qBA = BAtable.createQuery("SerialNo=:SerialNo and Status in ('01','02','03')").setParameter("SerialNo", BASerialNo);
				BizObject prBA = qBA.getSingleResult(false);
				if(prBA!=null){
					Double RelativeAmount = bo.getAttribute("RelativeAmount").getDouble();
					BAAmount += RelativeAmount;
				}
			}
		}
		
		BizObjectManager CRtable = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");

		BizObjectQuery qCR =CRtable.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and RelativeType=:RelativeType")
				.setParameter("ObjectNo", GuarantySerialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("RelativeType", "05");
		List<BizObject> DataLastCR = qCR.getResultList(false);
		String BCSerialNo = "";
		if(DataLastCR!=null){
			for(BizObject bo:DataLastCR){
				BCSerialNo = bo.getAttribute("ContractSerialNo").getString();
				BizObjectManager BCtable = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
				
				BizObjectQuery qBC = BCtable.createQuery("SerialNo=:SerialNo and Status in ('01','02','03')").setParameter("SerialNo", BCSerialNo);
				BizObject prBC = qBC.getSingleResult(false);
				if(prBC!=null){
					Double RelativeAmount = bo.getAttribute("RelativeAmount").getDouble();
					BCAmount += RelativeAmount;
				}
			}
		}
		
		String Amount = String.valueOf(BAAmount)+String.valueOf(BCAmount);
		return Amount;
	}
}
