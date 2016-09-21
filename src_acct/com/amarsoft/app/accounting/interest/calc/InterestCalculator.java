package com.amarsoft.app.accounting.interest.calc;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

public abstract class InterestCalculator {
	// 计息模式
	public static final String COMPOUNDINTERESTFLAG_COMP = "1";// 计息模式-复利
	public static final String COMPOUNDINTERESTFLAG_SINGLE = "2";// 计息模式-单利
		
	protected BusinessObject businessObject=null;
	protected String interestType=null;
	protected String defaultDueDay=null;//默认还款日
	
	public void setBusinessObject(BusinessObject businessObject) {
		this.businessObject = businessObject;
	}

	/**
	 * 获取利息计算处理类实例，如果还款方式上有定义计算处理类，优先使用
	 * @param loan
	 * @param interestType
	 * @param psType  还款计划类型，对于贷款正常还款计划必须传入，需要通过它获取还款方式的计算利息规则，其他默认null即可
	 * @return
	 * @throws Exception
	 */
	public static InterestCalculator getInterestCalculator(BusinessObject businessObject,String interestType,String psType) throws Exception {
		String className = CashFlowConfig.getInterestAttribute(interestType, "InterestCalculatorScript");
		String defaultDueDay=null;
		if(psType != null && StringX.isEmpty(className))
		{
			List<BusinessObject> rptList=businessObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
					"(SegFromDate=null or SegFromDate='' or SegFromDate<= :BusinessDate) and (SegToDate=null or SegToDate='' or SegToDate > :BusinessDate) and PSType like :PSType and Status=:Status "
					, "PSType",psType,"Status","1","BusinessDate",businessObject.getString("BusinessDate"));
			for(BusinessObject rptSegment:rptList)
			{
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("PSType", psType);
				if(StringX.isEmpty(className))
				{
					className = BusinessComponentConfig.getComponentValue(businessObject,rptSegment,parameter, "InterestCalculatorScript", "value");
				}
				else{
					String classNameTmp = BusinessComponentConfig.getComponentValue(businessObject,rptSegment,parameter, "InterestCalculatorScript", "value");
					if(!className.equals(classNameTmp))
					{
						throw new ALSException("EC3010");
					}
				}
				
				String defaultDueDayTmp = rptSegment.getString("DefaultDueDay");
				if(defaultDueDayTmp.length() < 2) {
					defaultDueDayTmp = "0" + defaultDueDayTmp;
				}
				
				if(StringX.isEmpty(defaultDueDay))
				{
					defaultDueDay = defaultDueDayTmp;
				}else{
					if(!defaultDueDay.equals(defaultDueDayTmp))
					{
						throw new ALSException("EC3022");
					}
				}
			}
			
			if(StringX.isEmpty(className)) throw new ALSException("EC3009");
		}
		
		Class<?> c = Class.forName(className);
		InterestCalculator p=(InterestCalculator) c.newInstance();
		p.businessObject=businessObject;
		p.interestType=interestType;
		p.defaultDueDay=defaultDueDay;
		return p;
	}
	
	/**
	 * 将利率转换为月利率
	 * 
	 * @param baseAmount 基数
	 * @param inteMonths 利息月数
	 * @param yearDays 年基准天数，传入日利率时使用
	 * @param rateUnit 利率单位
	 * @param rate 利率
	 * @return 保留12位小数的月利率值
	 * @throws LoanException
	 */
	public static double getMonthlyRate(int inteMonths, int yearDays, String rateUnit, double rate)
			throws Exception {
		double monthlyRate = 0d;
		if (RateHelper.RateUnit_Year.equals(rateUnit)) {
			monthlyRate = inteMonths * rate / 12.0 / 100.0;
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)) {
			monthlyRate = inteMonths * rate / 1000.0;
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)) {
			monthlyRate = inteMonths * rate * yearDays / 12.0 / 10000.0;
		} else {
			throw new ALSException("ED1012",rateUnit);
		}

		return Arith.round(monthlyRate, 12);
	}

	/**
	 * 计算贷款日利率
	 * 
	 * @param baseAmount 基数
	 * @param inteDays 利息天数
	 * @param yearDays 年基准天数
	 * @param rateUnit 利率单位
	 * @param rate 利率
	 * @return 保留15位小数的日利率
	 * @throws LoanException
	 */
	public static double getDailyRate(double inteDays, int yearDays, String rateUnit, double rate)
			throws Exception {
		double dailyRate = 0d;
		if (RateHelper.RateUnit_Year.equals(rateUnit)) {
			dailyRate = inteDays * rate / yearDays / 100.00d;
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)) {
			dailyRate =  inteDays * rate * 12.0 / yearDays / 1000.00d;
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)) {
			dailyRate =  inteDays * rate / 10000.00d;
		} else {
			throw new ALSException("ED1012",rateUnit);
		}
		return Arith.round(dailyRate, 15);
	}

	/**
	 * 根据还款频率计算周期利率
	 * 
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @param paymentFrequenceCode
	 * @return
	 * @throws Exception
	 */
	public static double getInstalmentRate(int yearDays, String rateUnit, double rate,
			String payFrequenceType) throws Exception {
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequenceType);
		if (payFrequency == null) {
			throw new ALSException("EC3007",payFrequenceType);
		}
		double instalmentRate = 0d;
		String termUnit = payFrequency.getString("TermUnit");
		int term = payFrequency.getInt("Term");
		if (term <= 0) {
			term = 1;
		}
		if (yearDays == 0) yearDays = 360;
		if (termUnit.equalsIgnoreCase(DateHelper.TERM_UNIT_MONTH)) {
			instalmentRate = getMonthlyRate(term, yearDays, rateUnit, rate);
		} else if (termUnit.equalsIgnoreCase(DateHelper.TERM_UNIT_DAY)) {
			instalmentRate = getDailyRate(term, yearDays, rateUnit, rate);
		} else {
			throw new ALSException("EC3008",payFrequenceType,termUnit);
		}
		return instalmentRate;
	}
	
	/**
	 * 计算指定金额利息
	 * @param baseAmount 指定金额
	 * @param rateUnit 利率单位
	 * @param rate 利率
	 * @param lastSettleDate 上次结息日
	 * @param nextSettleDate 下次结息日
	 * @param fromDate 计算起息日  其值需要大于等于上次结息日
	 * @param toDate 计算到期日 其值需要小于等于下次结息日
	 * @return
	 * @throws Exception
	 */
	public abstract double getInterest(double baseAmount,String rateUnit, double rate,String lastSettleDate,String nextSettleDate,
			String fromDate, String toDate) throws Exception;
	
	public double getInterest(double baseAmount,BusinessObject rateSegment, String lastSettleDate,String nextSettleDate, String fromDate, String toDate) throws Exception {
		String segFromDate = rateSegment.getString("SegFromDate");
		if (!StringX.isEmpty(segFromDate) && segFromDate.compareTo(fromDate) > 0) {
			fromDate = segFromDate;
		}
		String segToDate = rateSegment.getString("SegToDate");
		if (!StringX.isEmpty(segToDate) && segToDate.compareTo(toDate) < 0) {
			toDate = segToDate;
		}
		if (toDate.compareTo(fromDate) < 0) return 0d;

		double interest=getInterest(baseAmount, rateSegment.getString("RateUnit"),
				rateSegment.getDouble("BusinessRate"), lastSettleDate, nextSettleDate, fromDate, toDate);
		return interest;
	}
}
