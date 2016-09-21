package com.amarsoft.app.accounting.cashflow;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;

/**
 * 还款区段信息操作方法，包括获取还款区段的剩余本金、获取期供计算脚本、还款日计算脚本以及还款期数计算脚本等。
 * 
 * @author xyqu 2014年7月29日
 */

public class CashFlowHelper{
	
	public static double getPrincipalBalance(BusinessObject loan,String psType) throws Exception{
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger=loan.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",normalBalanceAccountCodeNo);
		double balance = AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);// 取贷款余额信息
		return balance;
	}
	
	/**
	 * 通过筛选条件获取年基准天数
	 * @author xjzhao@amarsoft.com
	 * @since 1.0
	 */
	public static int getYearBaseDay(BusinessObject bo) throws Exception{
		String[] keys = CashFlowConfig.getYearBaseDayConfigKeys();
		int cnt = 0;//判断满足条件个数
		int yearDay = 360;
		for(String key:keys)
		{
			BusinessObject yb = CashFlowConfig.getYearBaseDayConfig(key);
			
			String filter = yb.getString("Filter");
					
			if(StringX.isEmpty(filter) || bo.matchSql(filter, null))
			{
				yearDay = yb.getInt("value");
				cnt ++;
			}
		}
		
		if(cnt < 1)
		{
			throw new ALSException("EC3001");
		}
		else if(cnt > 1){
			throw new ALSException("EC3002");
		}
		
		return yearDay;
	}
	
	/**
	 * 通过筛选条件获取数值保留几位小数点
	 * type 输入值域 MONEY、RATE两类
	 * @author xjzhao@amarsoft.com
	 * @since 1.0 2015/10/12
	 */
	private static int getNumberPrecision(String type,BusinessObject bo) throws Exception{
		String[] keys = CashFlowConfig.getNumberPrecisionConfigKeys();
		int cnt = 0;//判断满足条件个数
		int numberPrecision = 0;
		for(String key:keys)
		{
			BusinessObject yb = CashFlowConfig.getNumberPrecisionConfig(key);
			String ntype = yb.getString("Type");
			String filter = yb.getString("Filter");
			if(ntype.equalsIgnoreCase(type))
			{
					
				if(StringX.isEmpty(filter) || bo.matchSql(filter, null))
				{
					numberPrecision = yb.getInt("value");
					cnt ++;
				}
			}
		}
		
		if(cnt < 1)
		{
			throw new ALSException("EC3003");
		}
		else if(cnt > 1){
			throw new ALSException("EC3004");
		}
		
		return numberPrecision;
	}
	
	/**
	 * 通过筛选条件获取金额保留几位小数点
	 * @author xjzhao@amarsoft.com
	 * @since 1.0 2015/10/12
	 */
	public static int getMoneyPrecision(BusinessObject bo) throws Exception{
		return CashFlowHelper.getNumberPrecision("MONEY", bo);
	}
	
	/**
	 * 通过筛选条件获取利率保留几位小数点
	 * @author xjzhao@amarsoft.com
	 * @since 1.0 2015/10/12
	 */
	public static int getRatePrecision(BusinessObject bo) throws Exception{
		return CashFlowHelper.getNumberPrecision("RATE", bo);
	}
	
	/**
	 * 通过筛选条件获取还款顺序规则
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String getPayRuleType(BusinessObject bo) throws Exception{
		String[] keys = CashFlowConfig.getPayRuleConfigKeys();
		int cnt = 0;//判断满足条件个数
		String payRuleType="";
		for(String key:keys)
		{
			BusinessObject prc = CashFlowConfig.getPayRuleConfig(key);
			String filter = prc.getString("Filter");
					
			if(StringX.isEmpty(filter) || bo.matchSql(filter, null))
			{
				payRuleType = prc.getString("id");
				cnt ++;
			}
		}
		
		if(cnt < 1)
		{
			throw new ALSException("EC3013");
		}
		else if(cnt > 1){
			throw new ALSException("EC3014");
		}
		
		return payRuleType;
	}
}
