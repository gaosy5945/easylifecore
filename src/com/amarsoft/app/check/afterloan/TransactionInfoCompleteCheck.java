package com.amarsoft.app.check.afterloan;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;

public class TransactionInfoCompleteCheck extends AlarmBiz {

	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> transactions = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(transactions == null || transactions.isEmpty())
			this.putMsg("���׻�����Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject transaction : transactions){
				String transStatus = transaction.getString("TransStatus");
				if(!"0".equals(transStatus))
				{
					this.putMsg("���ȱ��潻����Ϣ���ύ��");
				}
			}
		}
		
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}

}
