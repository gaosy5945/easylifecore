package com.amarsoft.app.als.customer.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class SelectContractSerialNo {
	public static String selectBCContractNo(String ContractSerialNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
		BizObjectQuery boq = bm.createQuery("ContractSerialNo=:ContractSerialNo"); 
		boq.setParameter("ContractSerialNo", ContractSerialNo);
		BizObject bo = boq.getSingleResult(false);
		String ObjectNo="";
		String ContractArtificialSerialNo="";
		if(bo!=null)
		{
			ObjectNo = bo.getAttribute("OBJECTNO").getString();
			
			BizObjectManager bmBC=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObjectQuery boqBC = bmBC.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ObjectNo);
			BizObject boBC = boqBC.getSingleResult(false);
			if(boBC!=null){
				ContractArtificialSerialNo = boBC.getAttribute("CONTRACTARTIFICIALNO").getString();
			}
		}
		return ContractArtificialSerialNo;
	}
	
	public static String selectBAContractNo(String ApplySerialNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		BizObjectQuery boq = bm.createQuery("ApplySerialNo=:ApplySerialNo"); 
		boq.setParameter("ApplySerialNo", ApplySerialNo);
		BizObject bo = boq.getSingleResult(false);
		String ObjectNo="";
		String ContractArtificialSerialNo="";
		if(bo!=null)
		{
			ObjectNo = bo.getAttribute("OBJECTNO").getString();
			
			BizObjectManager bmBC=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObjectQuery boqBC = bmBC.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ObjectNo);
			BizObject boBC = boqBC.getSingleResult(false);
			if(boBC!=null){
				ContractArtificialSerialNo = boBC.getAttribute("CONTRACTARTIFICIALNO").getString();
			}
		}
		return ContractArtificialSerialNo;
	}
}
