package com.amarsoft.app.check.afterloan;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;

public class TransactionInfoCompleteCheck extends AlarmBiz {

	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> transactions = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(transactions == null || transactions.isEmpty())
			this.putMsg("交易基本信息未找到，请检查！");
		else
		{
			for(BusinessObject transaction : transactions){
				String transStatus = transaction.getString("TransStatus");
				if(!"0".equals(transStatus))
				{
					this.putMsg("请先保存交易信息再提交。");
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
