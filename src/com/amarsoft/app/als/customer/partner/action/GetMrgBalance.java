package com.amarsoft.app.als.customer.partner.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class GetMrgBalance {
	public static String getMrgBalance(String customerID,String projectSerialNo) throws Exception{
		double sumTemp = 0.00;
		
		BizObjectManager tablePBI = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");

		BizObjectQuery PBI = tablePBI.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", projectSerialNo);
		BizObject prPBI = PBI.getSingleResult(false);
		if(prPBI != null){
			String projectType = prPBI.getAttribute("ProjectType").getString();
			String ObjectType = "";
			
			if("0107".equals(projectType)){
				ObjectType="jbo.customer.CUSTOMER_INFO";
			}else{
				ObjectType = "jbo.customer.CUSTOMER_LIST";
			}
			
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");

			BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'")
						.setParameter("ObjectNo", projectSerialNo);
			BizObject pr = q.getSingleResult(false);
			if(pr != null){
				String MarginSerialNo = pr.getAttribute("SerialNo").getString();
					
				BizObjectManager tableCMW = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_WASTEBOOK");
					
				BizObjectQuery CMW = tableCMW.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and MarginSerialNo=:MarginSerialNo and TransactionCode='0010'")
						.setParameter("ObjectNo", customerID).setParameter("ObjectType", ObjectType).setParameter("MarginSerialNo", MarginSerialNo);
				List<BizObject> DataLastCMW = CMW.getResultList(false);
				if(DataLastCMW!=null){
					for(BizObject bo:DataLastCMW){
						double amountTemp = bo.getAttribute("Amount").getDouble();
						sumTemp = sumTemp + amountTemp;
					}
				}
				
			}
		}
		String sum = String.valueOf(sumTemp);
		return sum;
	}
}
