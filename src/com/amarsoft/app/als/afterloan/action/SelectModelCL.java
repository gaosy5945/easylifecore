package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class SelectModelCL {

	//查询项目的规模额度
	public static String selectModelCL(String SerialNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and parentSerialNo is null"); 
		boq.setParameter("ObjectNo", SerialNo);
		boq.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO");
		BizObject bo = boq.getSingleResult(false);
		String bsuinessAppAmt = "";
		if(bo!=null)
		{
			bsuinessAppAmt = bo.getAttribute("BUSINESSAPPAMT").toString();
		}
		return bsuinessAppAmt;
	}

	//查询项目的担保额度
	public static String selectGuarantyCL(String SerialNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		BizObjectQuery boq = bm.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType=:ObjectType"); 
		boq.setParameter("ProjectSerialNo", SerialNo);
		boq.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
		BizObject bo = boq.getSingleResult(false);
		String sObjectNo = "";
		String GuarnatyValue = "";
		if(bo!=null)
		{
			sObjectNo = bo.getAttribute("ObjectNo").toString();
		}
		if(sObjectNo==null) sObjectNo="";
		
		bm=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		boq = bm.createQuery("SerialNo=:SerialNo"); 
		boq.setParameter("SerialNo",sObjectNo);
		bo = boq.getSingleResult(false);
		if(bo!=null)
		{
			GuarnatyValue = bo.getAttribute("GUARANTYVALUE").toString();
		}
		return GuarnatyValue;
	}
	
}
