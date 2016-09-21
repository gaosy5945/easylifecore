package com.amarsoft.app.check.afterloan;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;

public class LoanRateChangeCheck extends AlarmBiz {

	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> transList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(transList == null || transList.isEmpty())
			this.putMsg("交易基本信息未找到，请检查！");
		else
		{
			for(BusinessObject trans : transList){
				ARE.getLog().trace("测试贷后变更校验信息！"+trans.getString("SerialNo"));
				BusinessObject relative = (trans.getBusinessObjects(trans.getString("RelativeObjectType"))).get(0);
				ARE.getLog().trace("测试贷后变更校验信息！关联对象："+relative.getString("SerialNo"));
				BusinessObject document = (trans.getBusinessObjects(trans.getString("DocumentObjectType"))).get(0);
				ARE.getLog().trace("测试贷后变更校验信息！关联交易对象："+document.getString("SerialNo"));
				
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
