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
 * @since 2014/04/09
 */

public class checkIfhasAccount extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet bp = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", ba.getString("SerialNo")));
				while(bp.next()){
					String objectNo = bp.getStringValue("SerialNo");
					String MFCustomerID = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
							+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo",objectNo));
					if(MFCustomerID == null){
						putMsg("�����˻�δ¼�룡");
					}
				}
				bp.close();
				List<BusinessObject> arbaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbaList != null && !arbaList.isEmpty())
				{
					for(BusinessObject arba:arbaList)
					{
						ASResultSet bps = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", arba.getString("SerialNo")));
						while(bps.next()){
							String objectNo = bps.getStringValue("SerialNo");
							String MFCustomerID = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
									+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo",objectNo));
							if(MFCustomerID == null){
								putMsg("�����˻�δ¼�룡");
							}
						}
						bps.close();
					}
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
