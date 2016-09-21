package com.amarsoft.app.check.afterloan;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;

public class LoanRateChangeCheck extends AlarmBiz {

	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> transList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(transList == null || transList.isEmpty())
			this.putMsg("���׻�����Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject trans : transList){
				ARE.getLog().trace("���Դ�����У����Ϣ��"+trans.getString("SerialNo"));
				BusinessObject relative = (trans.getBusinessObjects(trans.getString("RelativeObjectType"))).get(0);
				ARE.getLog().trace("���Դ�����У����Ϣ����������"+relative.getString("SerialNo"));
				BusinessObject document = (trans.getBusinessObjects(trans.getString("DocumentObjectType"))).get(0);
				ARE.getLog().trace("���Դ�����У����Ϣ���������׶���"+document.getString("SerialNo"));
				
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
