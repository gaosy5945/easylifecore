package com.amarsoft.app.accounting.interest.calc.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.DateHelper;

public class ProportionCalculator extends InterestCalculator{

	@Override
	public double getInterest(double baseAmount, String rateUnit, double rate, String lastSettleDate,String nextSettleDate, String fromDate, String toDate) throws Exception {
		String nextMonthDate = DateHelper.getRelativeDate(fromDate, DateHelper.TERM_UNIT_MONTH, 1);
		if(!DateHelper.monthEnd(nextMonthDate)){
			if(DateHelper.monthEnd(nextSettleDate)) nextMonthDate=DateHelper.getEndDateOfMonth(nextMonthDate);
			else if (nextSettleDate.substring(8, 10).compareTo(nextMonthDate.substring(8, 10)) > 0) {//根据下次结息日的日期部分修正大小月结息日期
				nextMonthDate = nextMonthDate.substring(0, 8) + nextSettleDate.substring(8, 10);
				if (nextMonthDate.compareTo(DateHelper.getEndDateOfMonth(nextMonthDate)) > 0) {
					nextMonthDate = DateHelper.getEndDateOfMonth(nextMonthDate);
				}
			}
		}
		
		// 年基准天数
		int yearDays = CashFlowHelper.getYearBaseDay(businessObject);
		// 计算利息
		int inteDays = DateHelper.getDays(fromDate, toDate);
		double interest = baseAmount*InterestCalculator.getMonthlyRate(1, yearDays,
				rateUnit, rate)*inteDays / DateHelper.getDays(fromDate, nextMonthDate);
		return interest;
	}

}
