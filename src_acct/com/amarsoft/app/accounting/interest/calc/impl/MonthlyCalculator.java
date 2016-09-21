package com.amarsoft.app.accounting.interest.calc.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * ���¼�Ϣ�����ڲ����µ���ͷ��������ռ�Ϣ
 * �������ڴ�ǰ������
 * @author Amarsoft�����Ŷ�
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
		 * ����������Ϣ��֮����·�
		 * ���ڴ�С�µ����ϴν�Ϣ�պ��´ν�Ϣ��֮�����·ݴ�����
		 * �磺�ϴν�Ϣ�գ�2016/06/30�� �´ν�Ϣ�գ�2016/07/31
		 * ������һ���»���һ������һ���ء�
		 * ������Ϊ31�Ƿ�������һ���£�������Ϊ30��ʱ����һ������һ�촦��
		 */
		
		if(!StringX.isEmpty(defaultDueDay) && DateHelper.monthEnd(lastSettleDate) 
				&& lastSettleDate.substring(lastSettleDate.length() - 2).compareTo(defaultDueDay) < 0 
				&& nextSettleDate.endsWith(defaultDueDay)
				&& !lastSettleDate.equals(businessObject.getString("PutOutDate")))
			month = (int)Math.floor(month);
		
		String[] dates = new String[(int)Math.ceil(month)+1];//�Լ�Ϣ���ڽ��а��·ֶΣ���ǰ�����֡�
		dates[0] = lastSettleDate;
		dates[(int)Math.ceil(month)] = nextSettleDate;
		for(int i = 1; i < (int)Math.ceil(month); i ++)
		{
			dates[i] = DateHelper.getRelativeDate(lastSettleDate, DateHelper.TERM_UNIT_MONTH, i);
		}
		
		//������Ҫ������ʼ�պͽ��������ڼ�Ϣ���ڵ�����
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
		
		int yearDays = CashFlowHelper.getYearBaseDay(businessObject);//���׼����
		
		int monthIndex = (int)Math.floor(toIndex);
		
		if(month < Math.ceil(month) && (int)Math.floor(toIndex) == dates.length-1){//���һ�ڲ�����
			monthIndex --;
		}
		
		if(monthIndex > (int)Math.ceil(fromIndex))//��������
		{
			interestRate+=baseAmount*InterestCalculator.getMonthlyRate(monthIndex-(int)Math.ceil(fromIndex), yearDays, rateUnit, rate);
		}
		
		if(fromIndex < Math.ceil(fromIndex))//ǰ�����ͷ���Ϣ
		{
			DailyCalculator calculator = new DailyCalculator();
			calculator.setBusinessObject(businessObject);
			interestRate+=calculator.getInterest(baseAmount, rateUnit, rate, lastSettleDate, nextSettleDate, fromDate, dates[(int)Math.ceil(fromIndex)]);
		}
		
		if(dates[monthIndex].compareTo(toDate) < 0 )//������ͷ���Ϣ
		{
			DailyCalculator calculator = new DailyCalculator();
			calculator.setBusinessObject(businessObject);
			interestRate+=calculator.getInterest(baseAmount, rateUnit, rate, lastSettleDate, nextSettleDate, dates[monthIndex], toDate);
		}
		
		
		return interestRate;
	}
}
