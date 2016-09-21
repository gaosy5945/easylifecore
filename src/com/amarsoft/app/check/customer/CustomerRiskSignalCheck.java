package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * Ԥ���ͻ����
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerRiskSignalCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		//���ÿͻ��Ƿ��������Ч��Ԥ����Ϣ
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
		
				String sSql = " select count(1) from RISK_WARNING_OBJECT RWO,RISK_WARNING_SIGNAL RWS  "
							  + " where RWO.ObjectType=:ObjectType and RWO.ObjectNo=:ObjectNo "
							  + " and RWO.SignalSerialNo = RWS.SerialNo and RWS.Status = '1' ";
				SqlObject so = new SqlObject(sSql);
				so.setParameter("ObjectType", "jbo.customer.CUSTOMER_INFO");
				so.setParameter("ObjectNo", ba.getString("CustomerID"));
				int cnt = Integer.parseInt(Sqlca.getString(so));
				
				if( cnt > 0  ){
					putMsg("���롾"+ba.getString("CustomerName")+"��������Ч��Ԥ���ź�");
				}
			}
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
