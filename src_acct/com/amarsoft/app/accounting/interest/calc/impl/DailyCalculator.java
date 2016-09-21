package com.amarsoft.app.accounting.interest.calc.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.DateHelper;

/**
 * ���ռ�Ϣ
 * @author Amarsoft�����Ŷ�
 */
public class DailyCalculator extends InterestCalculator{

	@Override
	public double getInterest(double baseAmount, String rateUnit, double rate, String lastSettleDate,String nextSettleDate, String fromDate, String toDate) throws Exception {
		if(fromDate.compareTo(lastSettleDate) < 0) throw new Exception("��Ϣ�ղ���С���ϴν�Ϣ�ա�");
		if(toDate.compareTo(nextSettleDate) > 0) throw new Exception("�����ղ��ô����´ν�Ϣ�ա�");
		if(fromDate.compareTo(toDate) > 0) throw new Exception("�����ղ��ô�����Ϣ�ա�");
		
		// ���׼����
		int yearDays = CashFlowHelper.getYearBaseDay(businessObject);
		// ������Ϣ
		int inteDays = DateHelper.getDays(fromDate, toDate);
		double dailyRate = InterestCalculator.getDailyRate(inteDays, yearDays, rateUnit, rate);// ������

		return dailyRate*baseAmount;
	}

}
