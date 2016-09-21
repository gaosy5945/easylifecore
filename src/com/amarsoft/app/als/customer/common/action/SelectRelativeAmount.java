package com.amarsoft.app.als.customer.common.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class SelectRelativeAmount {
	public static String selectCRRelativeAmount(String SerialNo) throws Exception
	{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and RelativeType=:RelativeType")
				.setParameter("ObjectNo", SerialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("RelativeType", "05");
		List<BizObject> DataLast = q.getResultList(false);
		Double Amount = 0.00;
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			String ContractSerialNo = bo.getAttribute("ContractSerialNo").getString();
			
			BizObjectManager tableBC = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObjectQuery qBC = tableBC.createQuery("SerialNo=:Serialno").setParameter("SerialNo", ContractSerialNo);
			BizObject prBC = qBC.getSingleResult(false);
			if(prBC!=null)
				{
				Double RelativeAmount = bo.getAttribute("RelativeAmount").getDouble();
				Amount += RelativeAmount;
			}
			}
		}
		String result = String.valueOf(Amount);
		if("".equals(result)){
			result = "0";
		}
		return result;
	}
	public static String selectARRelativeAmount(String SerialNo) throws Exception
	{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and RelativeType=:RelativeType")
				.setParameter("ObjectNo", SerialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("RelativeType", "05");
		List<BizObject> DataLast = q.getResultList(false);
		Double Amount = 0.00;
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			String ApplySerialNo = bo.getAttribute("ApplySerialNo").getString();
			
			BizObjectManager tableBA = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
			BizObjectQuery qBA = tableBA.createQuery("SerialNo=:Serialno and ApproveStatus in ('01','02')").setParameter("SerialNo", ApplySerialNo);
			BizObject prBA = qBA.getSingleResult(false);
			if(prBA!=null)
				{
				Double RelativeAmount = bo.getAttribute("RelativeAmount").getDouble();
				Amount += RelativeAmount;
			}
			}
		}
		String result = String.valueOf(Amount);
		if("".equals(result)){
			result = "0";
		}
		return result;
	}
}
