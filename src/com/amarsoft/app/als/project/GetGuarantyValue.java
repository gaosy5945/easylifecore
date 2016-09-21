package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * 获取担保额度
 * @author t-wangyp1
 *
 */
public class GetGuarantyValue {
	//项目规模额度
	public static String getGMValue(String SerialNo) throws Exception
	{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO' and ParentSerialNo is null").setParameter("ObjectNo", SerialNo);
		BizObject pr = q.getSingleResult(false);
		String GMValue = "";
		if(pr != null){
			GMValue = pr.getAttribute("BusinessAppAmt").getString();
		}
		return GMValue;
	}
	
	//项目担保额度
	public static String getGuarantyValue(String SerialNo) throws Exception
	{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");

		BizObjectQuery q = table.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'").setParameter("ProjectSerialNo", SerialNo);
		BizObject pr = q.getSingleResult(false);
		String GuarantyValue = "";
		if(pr != null){
			String ObjectNo = pr.getAttribute("ObjectNo").getString();
			
			BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");

			BizObjectQuery qGC = tableGC.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ParentSerialNo is null").setParameter("ObjectNo", ObjectNo);
			BizObject prGC = qGC.getSingleResult(false);
			
			if(prGC != null){
				GuarantyValue = prGC.getAttribute("BusinessAppAmt").getString();
			}
		}
		return GuarantyValue;
	}
	
	//获取项目额度类型
	public static String getProjectCreditType(String ObjectType) throws Exception
	{
		String ProjectCreditType = "";
		if("jbo.prj.PRJ_BASIC_INFO".equals(ObjectType)){
			ProjectCreditType = "规模额度";
		}else{
			ProjectCreditType = "担保额度";
		}
		return ProjectCreditType;
	}
}
