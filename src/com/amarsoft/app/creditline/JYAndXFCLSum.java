package com.amarsoft.app.creditline;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class JYAndXFCLSum {
	//查询经营额度总额
	public static String getJYCLSum(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0106' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
		List<BizObject> DataLast = q.getResultList(false);
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			Double BusinessAppAmt = bo.getAttribute("BusinessAppAmt").getDouble();
			Temp += BusinessAppAmt;
			}
		}
		String BAA = String.valueOf(Temp);
		return BAA;
	}
	
	//查询经营额度可用金额 
	public static String getJYCLSumUse(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0106' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
		List<BizObject> DataLast = q.getResultList(false);
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			Double BusinessAvaBalance = bo.getAttribute("BusinessAvaBalance").getDouble();
			Temp += BusinessAvaBalance;
			}
		}
		String BAB = String.valueOf(Temp);
		return BAB;
	}
	
	//查询消费额度总额
	public static String getXFCLSum(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0105' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
		List<BizObject> DataLast = q.getResultList(false);
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			Double BusinessAppAmt = bo.getAttribute("BusinessAppAmt").getDouble();
			Temp += BusinessAppAmt;
			}
		}
		String BAA = String.valueOf(Temp);
		return BAA;
	}
	
	//查询消费额度可用金额
	public static String getXFCLSumUse(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0105' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
		List<BizObject> DataLast = q.getResultList(false);
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			Double BusinessAvaBalance = bo.getAttribute("BusinessAvaBalance").getDouble();
			Temp += BusinessAvaBalance;
			}
		}
		String BAB = String.valueOf(Temp);
		return BAB;
	}
}
