package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �Ƿ�����������������ƻ�
 * @author ������
 * @since 2014/03/04
 */

public class BaApplyInfoCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				if("052".equals(ba.getString("ProductID"))){
					String customerID = ba.getString("CustomerID");
					String serialNo = ba.getString("SerialNo");
					ASResultSet ra = Sqlca.getResultSet(new SqlObject("select * from BUSINESS_APPLY where CustomerID = :CustomerID and ProductID = :ProductID and"
							+ " (ApproveStatus in ('01','02','03') or ApproveStatus is null) and SerialNo <> :SerialNo").setParameter("CustomerID", customerID)
							.setParameter("SerialNo", serialNo).setParameter("ProductID", ba.getString("ProductID")));
					if(ra.next()){
						putMsg("���롾"+ba.getString("CustomerName")+"�������������������ƻ�");
					}
					ra.close();
				}
				if("051".equals(ba.getString("ProductID"))){
					String customerID = ba.getString("CustomerID");
					String serialNo = ba.getString("SerialNo");
					ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from BUSINESS_APPLY where CustomerID = :CustomerID and ProductID = :ProductID and"
							+ " (ApproveStatus in ('01','02','03') or ApproveStatus is null) and SerialNo <> :SerialNo").setParameter("CustomerID", customerID)
							.setParameter("SerialNo", serialNo).setParameter("ProductID", ba.getString("ProductID")));
					if(rs.next()){
						putMsg("���롾"+ba.getString("CustomerName")+"����������������ҵ��");
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
