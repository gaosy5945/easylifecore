package com.amarsoft.app.creditline;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * @author T-liuxt
 * 授信额度台账-查询额度项下的消贷易、融资易转账和融资易刷卡额度金额
 */

public class XDAndRZCLSum {

	//查询消贷易额度
	public static String getXDCL(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0102' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
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
	
	//查询融资易转账额度
	public static String getRZZZCL(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0103' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
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
	
	//查询融资易刷卡额度
	public static String getRZSKCL(String SerialNo) throws Exception
	{
		Double Temp = 0.0;
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery q = bm.createQuery("CLType='0104' and Status not in ('50','60') and RootSerialNo=:RootSerialNo").setParameter("RootSerialNo", SerialNo);
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
}
