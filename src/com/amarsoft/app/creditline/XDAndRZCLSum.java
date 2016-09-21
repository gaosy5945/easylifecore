package com.amarsoft.app.creditline;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * @author T-liuxt
 * ���Ŷ��̨��-��ѯ������µ������ס�������ת�˺�������ˢ����Ƚ��
 */

public class XDAndRZCLSum {

	//��ѯ�����׶��
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
	
	//��ѯ������ת�˶��
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
	
	//��ѯ������ˢ�����
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
