package com.amarsoft.app.accounting.interest.calc.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 按月计息，存在不满月等零头天情况按日计息
 * 按照日期从前往后拆分
 * @author Amarsoft核算团队
 */

public class MonthlyCalculator extends InterestCalculator{

	@Override
	public double getInterest(double baseAmount, String rateUnit, double rate, String lastSettleDate,String nextSettleDate, String fromDate, String toDate) throws Exception {
		if(fromDate.compareTo(lastSettleDate) < 0) throw new ALSException("EC3019");
		if(toDate.compareTo(nextSettleDate) > 0) throw new ALSException("EC3020");
		if(fromDate.compareTo(toDate) > 0) throw new ALSException("EC3021");
		
		
		double interestRate=0d;
		double month = DateHelper.getMonths(lastSettleDate, nextSettleDate);
		/**
		 * 修正两个结息日之间的月份
		 * 由于大小月导致上次结息日和下次结息日之间算月份存在误差：
		 * 如：上次结息日：2016/06/30， 下次结息日：2016/07/31
		 * 到底算一个月还是一个月零一天呢。
		 * 还款日为31是非首期算一个月，还款日为30日时按照一个月零一天处理。
		 */
		
		if(!StringX.isEmpty(defaultDueDay) && DateHelper.monthEnd(lastSettleDate) 
				&& lastSettleDate.substring(lastSettleDate.length() - 2).compareTo(defaultDueDay) < 0 
				&& nextSettleDate.endsWith(defaultDueDay)
				&& !lastSettleDate.equals(businessObject.getString("PutOutDate")))
			month = (int)Math.floor(month);
		
		String[] dates = new String[(int)Math.ceil(month)+1];//对计息周期进行按月分段，从前往后拆分。
		dates[0] = lastSettleDate;
		dates[(int)Math.ceil(month)] = nextSettleDate;
		for(int i = 1; i < (int)Math.ceil(month); i ++)
		{
			dates[i] = DateHelper.getRelativeDate(lastSettleDate, DateHelper.TERM_UNIT_MONTH, i);
		}
		
		//计算需要计算起始日和结束日所在计息周期的区段
		double fromIndex=0d,toIndex=0d;
		
		for(int i = 0; i < dates.length ; i ++)
		{
			if(i==dates.length-1){
				if(fromDate.equals(dates[i]))
					fromIndex = i;
				if(toDate.equals(dates[i]))
					toIndex = i;
			}
			else
			{
				if(fromDate.equals(dates[i]))
					fromIndex = i;
				if(fromDate.compareTo(dates[i]) > 0 && fromDate.compareTo(dates[i+1]) < 0)
					fromIndex = i+0.5;
				if(toDate.equals(dates[i]))
					toIndex = i;
				if(toDate.compareTo(dates[i]) > 0 && toDate.compareTo(dates[i+1]) < 0)
					toIndex = i+0.5;
			}
		}
		
		int yearDays = CashFlowHelper.getYearBaseDay(businessObject);//年基准天数
		
		int monthIndex = (int)Math.floor(toIndex);
		
		if(month < Math.ceil(month) && (int)Math.floor(toIndex) == dates.length-1){//最后一期不满期
			monthIndex --;
		}
		
		if(monthIndex > (int)Math.ceil(fromIndex))//计算整月
		{
			interestRate+=baseAmount*InterestCalculator.getMonthlyRate(monthIndex-(int)Math.ceil(fromIndex), yearDays, rateUnit, rate);
		}
		
		if(fromIndex < Math.ceil(fromIndex))//前半段零头天计息
		{
			DailyCalculator calculator = new DailyCalculator();
			calculator.setBusinessObject(businessObject);
			interestRate+=calculator.getInterest(baseAmount, rateUnit, rate, lastSettleDate, nextSettleDate, fromDate, dates[(int)Math.ceil(fromIndex)]);
		}
		
		if(dates[monthIndex].compareTo(toDate) < 0 )//后半段零头天计息
		{
			DailyCalculator calculator = new DailyCalculator();
			calculator.setBusinessObject(businessObject);
			interestRate+=calculator.getInterest(baseAmount, rateUnit, rate, lastSettleDate, nextSettleDate, dates[monthIndex], toDate);
		}
		
		
		return interestRate;
	}
}
