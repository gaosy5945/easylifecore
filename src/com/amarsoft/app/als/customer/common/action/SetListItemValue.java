package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

//计算共赢联盟成员保证金余额
public class SetListItemValue {

	
	public static String setItemValue(String CustomerID,String ProejctSerialNo) throws JBOException{
		
		double amount = 0.00;
		
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'")
					.setParameter("ObjectNo", ProejctSerialNo);
		BizObject pr = q.getSingleResult(false);
		if(pr != null){
			String MarginSerialNo = pr.getAttribute("SerialNo").getString();
			
			BizObjectManager bmCMW = JBOFactory.getFactory().getManager("jbo.guaranty.CLR_MARGIN_WASTEBOOK");
			String Sql01 = "select sum(amount) as V.Amount from O where MarginSerialno=:MarginSerialno and ObjectType=:ObjectType and ObjectNo=:ObjectNo and TransactionCode='0010'";
			String Sql02 = "select sum(amount) as V.Amount from O where MarginSerialno=:MarginSerialno and ObjectType=:ObjectType and ObjectNo=:ObjectNo and TransactionCode='0030'";
			
			//客户已缴纳保证金
			BizObject boCMW01 =bmCMW.createQuery(Sql01).setParameter("MarginSerialno", MarginSerialNo).setParameter("ObjectType", "jbo.customer.CUSTOMER_INFO").setParameter("ObjectNo", CustomerID).getSingleResult(false);
			
			//客户已代偿保证金
			BizObject boCMW02 =bmCMW.createQuery(Sql02).setParameter("MarginSerialno", MarginSerialNo).setParameter("ObjectType", "jbo.customer.CUSTOMER_INFO").setParameter("ObjectNo", CustomerID).getSingleResult(false);
			
			if(boCMW01 != null && boCMW02 != null){
				amount = boCMW01.getAttribute("Amount").getDouble() - boCMW02.getAttribute("Amount").getDouble();
			}
			
		}
		
		
		String sAmount = String.valueOf(amount);
		return sAmount;
	}
}
