package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * ��ȡ�������
 * @author t-wangyp1
 *
 */
public class GetGuarantyValue {
	//��Ŀ��ģ���
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
	
	//��Ŀ�������
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
	
	//��ȡ��Ŀ�������
	public static String getProjectCreditType(String ObjectType) throws Exception
	{
		String ProjectCreditType = "";
		if("jbo.prj.PRJ_BASIC_INFO".equals(ObjectType)){
			ProjectCreditType = "��ģ���";
		}else{
			ProjectCreditType = "�������";
		}
		return ProjectCreditType;
	}
}
