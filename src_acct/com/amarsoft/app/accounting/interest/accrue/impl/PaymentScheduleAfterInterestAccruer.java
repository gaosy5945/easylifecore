package com.amarsoft.app.accounting.interest.accrue.impl;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

/**
 * �����ڡ��ڼ������ڲ����������ʼ��㷣Ϣ
 * 
 * @author Amarsoft�����Ŷ�
 *
 */
public class PaymentScheduleAfterInterestAccruer extends PaymentScheduleInterestAccruer {
	
	public List<BusinessObject> getInterestObjects() throws Exception {
		String condition = CashFlowConfig.getInterestAttribute(interestType, "Condition");
		if(StringX.isEmpty(condition)) condition = "";
		else if(!condition.toLowerCase().trim().startsWith("and")) condition = " and "+condition;
		List<BusinessObject> interestObjects=businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, 
				" InteDate < :BusinessDate and InteDate <> null and InteDate <> '' and PSType=:PSType "+condition, "BusinessDate",businessObject.getString("BusinessDate"),"PSType",psType);
		return interestObjects;
	}
}
