package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 项目额度检查
 * @author 张万亮
 * @since 2014/04/08
 */

public class ApplyPrjSumCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		Boolean flag = true;
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet rs = Sqlca.getResultSet(new SqlObject("select PBI.ProjectType,PBI.ProjectName,PBI.SerialNo from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI where "
						+ "O.ProjectSerialNo = PBI.SerialNo and O.RelativeType = '01' and O.ObjectType = "
						+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				while(rs.next()){
					String prjSerialNo = rs.getStringValue("SerialNo");
					String CLType = Sqlca.getString(new SqlObject("select CLType from CL_INFO where ObjectNo=:ObjectNo and OBJECTTYPE='jbo.prj.PRJ_BASIC_INFO' "
							+ "and ParentSerialNo is null").setParameter("ObjectNo", prjSerialNo));
					if(CLType != null)
					{
						com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", CLType);
						String className = item.getItemDescribe();
						if(className != null)
						{
							Class c = Class.forName(className);
							com.amarsoft.app.als.cl.CreditObject co = (com.amarsoft.app.als.cl.CreditObject)c.newInstance();
							co.load(Sqlca.getConnection(), "jbo.prj.PRJ_BASIC_INFO", prjSerialNo);
							co.calcBalance();
							co.saveData(Sqlca.getConnection());
							if(co.RiskMessage.size()>0)
							{
								putMsg(co.RiskMessage.toString());
								flag = false;
							}
							else if(co.AlarmMessage.size()>0)
							{
								putMsg(co.AlarmMessage.toString());
							}
						}
					}
					String CLType1 = Sqlca.getString(new SqlObject("select CL.CLType from CL_INFO CL,PRJ_RELATIVE PR,APPLY_RELATIVE R,GUARANTY_CONTRACT GC where CL.OBJECTNO=PR.ObjectNo and "
							+ "CL.OBJECTTYPE=PR.OBJECTTYPE and CL.ParentSerialNo is null and PR.ProjectSerialNo=:ProjectSerialNo and PR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and "
							+ "R.APPLYSERIALNO = :ObjectNo AND R.OBJECTTYPE=PR.OBJECTTYPE AND R.OBJECTNO = GC.SerialNo and GC.PROJECTSERIALNO = PR.PROJECTSERIALNO")
							.setParameter("ProjectSerialNo", prjSerialNo).setParameter("ObjectNo", ba.getString("SerialNo")));
					if(CLType1 != null)
					{
						com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", CLType1);
						String className = item.getItemDescribe();
						if(className != null)
						{
							Class c = Class.forName(className);
							com.amarsoft.app.als.cl.CreditObject co = (com.amarsoft.app.als.cl.CreditObject)c.newInstance();
							co.load(Sqlca.getConnection(), "jbo.prj.PRJ_BASIC_INFO", prjSerialNo);
							co.calcBalance();
							co.saveData(Sqlca.getConnection());
							if(co.RiskMessage.size()>0)
							{
								putMsg(co.RiskMessage.toString());
								flag = false;
							}
							else if(co.AlarmMessage.size()>0)
							{
								putMsg(co.AlarmMessage.toString());
							}
						}
					}
				}
				rs.close();
			}
			
		}
		setPass(flag);
		
		return null;
	}
}
