package com.amarsoft.app.als.credit.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class QueryUseCredit {
	//查询批准额度
	public static String getAppAmt(String SerialNo) throws Exception
	{
		String appAmt = "";
		BizObjectManager cim = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery ciq = cim.createQuery("ObjectType='jbo.app.BUSINESS_CONTRACT' and ObjectNo=:ObjectNo and "
				+ "CLType in ('0101','0102','0103','0104','0107','0108')").setParameter("ObjectNo", SerialNo);
		BizObject cibo = ciq.getSingleResult(false);
		
		if(cibo != null){
			double appAmtTemp =  cibo.getAttribute("BusinessAppAmt").getDouble();
			appAmt = String.valueOf(appAmtTemp);
			return appAmt;
		}
		return appAmt;
	}
	
	//查询可用额度
	public static String getUsingCredit(String SerialNo) throws Exception
	{
		String avaBalance = "";
		BizObjectManager cim = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery ciq = cim.createQuery("ObjectType='jbo.app.BUSINESS_CONTRACT' and ObjectNo=:ObjectNo and "
				+ "CLType in ('0101','0102','0103','0104','0107','0108')").setParameter("ObjectNo", SerialNo);
		BizObject cibo = ciq.getSingleResult(false);
		
		if(cibo != null){
			double avaBalanceTemp = cibo.getAttribute("BusinessAvaBalance").getDouble();
			avaBalance = String.valueOf(avaBalanceTemp);
			return avaBalance;
		}
		return avaBalance;
	}
	
	//查询已用额度
	public static String getUsedCredit(String SerialNo) throws Exception
	{
		String already = "";
		BizObjectManager cim = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery ciq = cim.createQuery("ObjectType='jbo.app.BUSINESS_CONTRACT' and ObjectNo=:ObjectNo and "
				+ "CLType in ('0101','0102','0103','0104','0107','0108')").setParameter("ObjectNo", SerialNo);
		BizObject cibo = ciq.getSingleResult(false);
		
		if(cibo != null){
			double appAmt = cibo.getAttribute("BusinessAppAmt").getDouble();
			double avaBalance = cibo.getAttribute("BusinessAvaBalance").getDouble();
			already = String.valueOf(appAmt-avaBalance);
			return already;
		}
		return already;
	}
}
