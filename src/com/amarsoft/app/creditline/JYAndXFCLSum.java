package com.amarsoft.app.creditline;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class JYAndXFCLSum {
	//��ѯ��Ӫ����ܶ�
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
	
	//��ѯ��Ӫ��ȿ��ý�� 
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
	
	//��ѯ���Ѷ���ܶ�
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
	
	//��ѯ���Ѷ�ȿ��ý��
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
