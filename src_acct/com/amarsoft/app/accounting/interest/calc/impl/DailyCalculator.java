package com.amarsoft.app.accounting.interest.calc.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 按日计息
 * @author Amarsoft核算团队
 */
public class DailyCalculator extends InterestCalculator{

	@Override
	public double getInterest(double baseAmount, String rateUnit, double rate, String lastSettleDate,String nextSettleDate, String fromDate, String toDate) throws Exception {
		if(fromDate.compareTo(lastSettleDate) < 0) throw new Exception("起息日不得小于上次结息日。");
		if(toDate.compareTo(nextSettleDate) > 0) throw new Exception("到期日不得大于下次结息日。");
		if(fromDate.compareTo(toDate) > 0) throw new Exception("到期日不得大于起息日。");
		
		// 年基准天数
		int yearDays = CashFlowHelper.getYearBaseDay(businessObject);
		// 计算利息
		int inteDays = DateHelper.getDays(fromDate, toDate);
		double dailyRate = InterestCalculator.getDailyRate(inteDays, yearDays, rateUnit, rate);// 日利率

		return dailyRate*baseAmount;
	}

}
