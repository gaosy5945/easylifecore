package com.amarsoft.app.accounting.cashflow.due;

import com.amarsoft.app.accounting.cashflow.due.impl.CommonPeriodScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;

/**
 * 期供计算引擎之期次计算
 * 
 * @author yegang
 */
public abstract class PeriodScript {
	//区段期限标识SEGTermFlag
	public final static String SEGTERM_LOAN = "1";     //贷款期限
	public final static String SEGTERM_SEGMENT = "2";  //区段期限
	public final static String SEGTERM_FIXED = "3";//指定期限
	
	protected BusinessObject loan;
	protected BusinessObject rptSegment;
	protected String psType;
	/**
	 * 获取还款日计算引擎
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	public static PeriodScript getPeriodScript(BusinessObject loan, BusinessObject rptSegment, String psType) throws Exception {
		BusinessObject parameter = BusinessObject.createBusinessObject();
		parameter.setAttributeValue("PSType", psType);
		String className = BusinessComponentConfig.getComponentValue(loan,rptSegment, parameter,"PeriodScript","value");
		if (StringX.isEmpty(className)) {
			String payFrequencyType = rptSegment.getString("PayFrequencyType");// 还款周期
			className=CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType).getString("DueDateScript");
		}

		PeriodScript script=null;
		// 依然为空时，取默认值
		if (StringX.isEmpty(className)) {
			script= new CommonPeriodScript();
		}
		else{
			Class<?> c = Class.forName(className);
			script = (PeriodScript) c.newInstance();
		}
		script.loan=loan;
		script.rptSegment=rptSegment;
		script.psType = psType;
		return script;
	}

	/**
	 * 根据借据和分段偿还信息计算贷款总偿还期次
	 * 
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	public abstract int getTotalPeriod() throws Exception;

}
