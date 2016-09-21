package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyPRJCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				boolean flag = false;
				if("001".equals(ba.getString("BusinessType")) || "032".equals(ba.getString("BusinessType")) || "033".equals(ba.getString("BusinessType"))){
					ASResultSet rs = Sqlca.getResultSet(new SqlObject("select PBI.ProjectType,PBI.ProjectName,PBI.SerialNo from PRJ_RELATIVE O, PRJ_BASIC_INFO PBI where "
							+ "O.ProjectSerialNo = PBI.SerialNo and O.RelativeType = '01' and O.ObjectType = "
							+ "'jbo.app.BUSINESS_APPLY' and O.OBJECTNO = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
					if(rs.next()){
						flag = true;
					}
					if(!flag){
						putMsg("申请【"+ba.getString("CustomerName")+"】是一手房贷款业务，但是还没有关联合作项目！");
					}
					rs.close();
				}
			}
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
