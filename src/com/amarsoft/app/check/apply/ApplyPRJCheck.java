package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ�����Լ��
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyPRJCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
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
						putMsg("���롾"+ba.getString("CustomerName")+"����һ�ַ�����ҵ�񣬵��ǻ�û�й���������Ŀ��");
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
