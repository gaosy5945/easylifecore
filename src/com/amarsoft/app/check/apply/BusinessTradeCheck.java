package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ������Ϣ�Ƿ�¼��
 * @author zhangwl
 * @since 2014/03/25
 */

public class BusinessTradeCheck extends AlarmBiz {
	
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
				String businessType = ba.getString("BusinessType");
				
				ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from BUSINESS_TRADE where ObjectType = 'jbo.app.BUSINESS_APPLY' "
						+ "and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				if(rs.next()){
					flag = true;
				}
				if(!flag){
					if("004".equals(businessType)){
						putMsg("���롾"+ba.getString("CustomerName")+"��δ¼������������Ϣ��");
					}else{
						putMsg("���롾"+ba.getString("CustomerName")+"��δ¼������Ʒ������Ϣ��");
					}
				}
				rs.close();
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
