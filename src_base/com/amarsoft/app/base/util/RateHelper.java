package com.amarsoft.app.base.util;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

public class RateHelper{
	public static final String RateFloatType_PRECISION = "0";// 百分比浮动
	public static final String RateFloatType_POINTS = "1";// 基点浮动
	
	public static final String RateMode_Fix = "2";// 固定利率
	public static final String RateMode_Float = "1";// 浮动利率

	public static final String RateUnit_Year = "01";// 年利率
	public static final String RateUnit_Month = "02";// 月利率
	public static final String RateUnit_Day = "03";// 日利率
	
	private static BusinessObjectCache rateCache=new BusinessObjectCache(100);
	
	
	public static void clear() 
	{
		if(rateCache == null)
			rateCache = new BusinessObjectCache(100);
		else
			rateCache.clear();
	}
	
	/**
	 * 判断在利率表中是否存在基准利率类型
	 * @param baseRateType
	 * @return
	 * @throws Exception
	 */
	public static boolean exists(String baseRateType,String currency,String effectDate) throws Exception{
		if(StringX.isEmpty(baseRateType)) return false;
		
		List<BusinessObject> baseRateList =  getBaseRateList(baseRateType,currency,effectDate);
		if(baseRateList.isEmpty()) return false;
		else return true;
	}
	/**
	 * 将一种利率单位的利率转换为另一种利率单位的利率，如年利率转换为日利率，日利率转换为年利率等
	 * 
	 * @param yearDays
	 *            年基准天数
	 * @param rateUnit
	 *            原利率单位
	 * @param rate
	 *            原利率
	 * @param newRateUnit
	 *            新利率单位
	 * @return 转换后的利率值
	 * @throws Exception 
	 */
	public static double getRate(int yearDays, String rateUnit, double rate, String newRateUnit) throws Exception {
		if (rateUnit.equals(newRateUnit)){
			return rate;
		}

		if (RateHelper.RateUnit_Year.equals(rateUnit) && RateHelper.RateUnit_Month.equals(newRateUnit)) {
			return rate / 100 / 12 * 1000;// 月利率，千分比
		} else if (RateHelper.RateUnit_Year.equals(rateUnit)
				&& RateHelper.RateUnit_Day.equals(newRateUnit)) {
			return rate / 100 / yearDays * 10000;// 日利率，万分比
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)
				&& RateHelper.RateUnit_Year.equals(newRateUnit)) {
			return rate / 1000 * 12 * 100;// 年利率，百分比
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)
				&& RateHelper.RateUnit_Day.equals(newRateUnit)) {
			return rate / 1000 * 12 / yearDays * 10000;// 日利率，万分比
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)
				&& RateHelper.RateUnit_Month.equals(newRateUnit)) {
			return rate / 10000 * yearDays / 12 * 1000;// 月利率，千分比
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)
				&& RateHelper.RateUnit_Year.equals(newRateUnit)) {
			return rate / 10000 * yearDays * 100;// 年利率，百分比
		} else {
			throw new ALSException("ED1001",RateHelper.RateUnit_Year+"\\"+RateHelper.RateUnit_Month+"\\"+RateHelper.RateUnit_Day,rateUnit);
		}
	}
	
	/**
	 * 根据币种、基准利率类型、期限类型、期限、生效日期获取利率档次
	 * @param currency
	 * @param baseRateType
	 * @param termUnit
	 * @param term
	 * @param effectDate
	 * @return 基准利率档次
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency, String baseRateType,
			String termUnit, int term, String effectDate) throws Exception {

		List<BusinessObject> rateList = getBaseRateList(baseRateType, currency,
				effectDate);
		if (rateList == null || rateList.size() == 0) {
			throw new ALSException("ED1019",baseRateType);
		}

		// 获取基准利率档次
		int size = rateList.size();
		for (int i = 0; i < size; i++) {
			BusinessObject rateAttributes = rateList.get(i);
			if (DateHelper.TERM_UNIT_DAY.equals(termUnit)) {
				term = term / 30;
			} else if (DateHelper.TERM_UNIT_YEAR.equals(termUnit)) {
				term = term * 12;
			}

			int configTerm = rateAttributes.getInt("Term");

			if (term <= configTerm) {
				String configTermUnit = rateAttributes.getString("TermUnit");
				if (i < size - 1 && term > rateList.get(i + 1).getInt("Term")) {
					return configTerm + "@" + configTermUnit;
				} else if (i == rateList.size() - 1) {
					return configTerm + "@" + configTermUnit;
				}
			}
		}
		return "@";
	}
	
	/**
	 * 计算基准利率
	 * @param loan
	 * @param rateSegment
	 * @return 基准利率
	 * @throws Exception
	 */
	public static double getBaseRate(BusinessObject loan, BusinessObject rateSegment) throws Exception {
		double baseRate = 0d;
		String baseRateType = rateSegment.getString("BaseRateType");
		if (StringX.isEmpty(baseRateType)) return 0d;
		String rateUnit = rateSegment.getString("RateUnit");
		String putoutDate = loan.getString("PutoutDate");
		String MaturityDate = loan.getString("MaturityDate");
		String baseRateGrade = rateSegment.getString("BaseRateGrade");
		if (baseRateGrade == null || "".equals(baseRateGrade) || baseRateGrade.split("@").length < 2) {
			baseRateGrade = RateHelper.getBaseRateGrade(loan.getString("Currency"), baseRateType, putoutDate,
					MaturityDate, loan.getString("BusinessDate"));
			rateSegment.setAttributeValue("BaseRateGrade", baseRateGrade);
		}

		int term = Integer.valueOf(baseRateGrade.split("@")[0]);
		String termUnit = baseRateGrade.split("@")[1];
		baseRate = RateHelper.getBaseRate(loan.getString("Currency"), CashFlowHelper.getYearBaseDay(loan), baseRateType,
				rateUnit, termUnit, term, loan.getString("BusinessDate"));
		return baseRate;
	}
	
	/**
	 * 获取贷款利率
	 * @param loan
	 * @param rateSegment
	 * @return 贷款利率
	 * @throws Exception
	 */
	public static double getBusinessRate(BusinessObject loan, BusinessObject rateSegment) throws Exception {
		// 如果是固定模式,则执行利率不变
		// String rateMode = rateSegment.getString("RateMode");
		String rateFloatType = rateSegment.getString("RateFloatType");
		double baseRate = rateSegment.getDouble("BaseRate");
		double rateFloat = rateSegment.getDouble("rateFloat");
		double businessRate = rateSegment.getDouble("BusinessRate");

		if (baseRate == 0d) {
			return businessRate;
		} else {
			if (RateHelper.RateFloatType_PRECISION.equals(rateFloatType)) {
				businessRate = baseRate + baseRate * rateFloat * 0.01;
			}
			// 当利率浮动类型为基点时,执行利率 = 基准利率+浮动幅度
			else if (RateHelper.RateFloatType_POINTS.equals(rateFloatType)) {
				businessRate = baseRate + rateFloat / 100.0;
			} else {
				throw new ALSException("ED1020",rateFloatType);
			}
			if (businessRate < 0d) {
				throw new ALSException("ED1021",String.valueOf(businessRate));
			}
			return Arith.round(businessRate, ACCOUNT_CONSTANTS.Number_Precision_Rate);
		}
	}
	
	/**
	 * @param Currency
	 *            币种 参见代码Currency
	 * @param baseRateType
	 *            利率类型：参见代码BaseRateType
	 * @param putOutDate
	 *            发放日期
	 * @param maturityDate
	 *            到期日
	 * @param effectDate
	 * 			      生效日期
	 * @return 利率档次
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency, String baseRateType,
			String putoutDate, String maturityDate, String effectDate)
			throws Exception {
		int term = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));// 向上取整
		return RateHelper.getBaseRateGrade(currency, baseRateType,
				DateHelper.TERM_UNIT_MONTH, term, effectDate);
	}
	
	/**
	 * 前端只能通过String方式访问
	 * @param Currency
	 *            币种：参见代码Currency
	 * @param YearDays
	 *            年基准天数 英式币种 365 其他币种 360，这里传入主要是解决存量贷款的特殊要求
	 * @param BaseRateType
	 *            利率类型：参见代码BaseRateType
	 * @param RateUnit
	 *            利率单位：参见代码RateUnit
	 * @param putOutDate
	 *            发放日期
	 * @param maturityDate
	 *            到期日
	 * @param effectDate
	 * 			       生效日期
	 * @return 返回对应利率单位的利率值
	 * @throws Exception
	 */
	public static String getBaseRate(String currency, String yearDays,
			String baseRateType, String RateUnit, String putoutDate,
			String maturityDate, String effectDate) throws Exception {
		return String.valueOf(getBaseRate(currency,Integer.parseInt(yearDays),baseRateType,RateUnit,putoutDate,maturityDate,effectDate));
	}
	/**
	 * @param Currency
	 *            币种：参见代码Currency
	 * @param YearDays
	 *            年基准天数 英式币种 365 其他币种 360，这里传入主要是解决存量贷款的特殊要求
	 * @param BaseRateType
	 *            利率类型：参见代码BaseRateType
	 * @param RateUnit
	 *            利率单位：参见代码RateUnit
	 * @param putOutDate
	 *            发放日期
	 * @param maturityDate
	 *            到期日
	 * @param effectDate
	 * 			       生效日期
	 * @return 返回对应利率单位的利率值
	 * @throws Exception
	 */
	public static double getBaseRate(String currency, int yearDays,
			String baseRateType, String RateUnit, String putoutDate,
			String maturityDate, String effectDate) throws Exception {
		int term = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));//向上取整
		return RateHelper.getBaseRate(currency, yearDays, baseRateType,
				RateUnit, DateHelper.TERM_UNIT_MONTH, term, effectDate);
	}

	/**
	 * @param Currency
	 *            币种：参见代码Currency
	 * @param YearDays
	 *            年基准天数 英式币种 365 其他币种 360，这里传入主要是解决存量贷款的特殊要求
	 * @param BaseRateType
	 *            利率类型：参见代码BaseRateType
	 * @param RateUnit
	 *            利率单位：参见代码RateUnit
	 * @param TermUnit
	 *            期限单位：参见代码TermUnit
	 * @param Term
	 *            期限
	 * @param effectDate
	 * 			       生效日期
	 * @return 返回对应利率单位的利率值
	 * @throws Exception
	 */
	public static double getBaseRate(String currency, int yearDays,
			String baseRateType, String RateUnit, String termUnit, int term,
			String effectDate) throws Exception {
		double baseRate = 0.0;
		List<BusinessObject> rateList = getBaseRateList(baseRateType, currency,
				effectDate);
		if (rateList == null || rateList.size() == 0) {
			throw new ALSException("ED1022",baseRateType);
		}
		// 计算基准利率
		for (int i = 0; i < rateList.size(); i++) {
			BusinessObject rateAttributes = rateList.get(i);
			if (DateHelper.TERM_UNIT_DAY.equals(termUnit)) {
				term = term / 30;
			} else if (DateHelper.TERM_UNIT_YEAR.equals(termUnit)) {
				term = term * 12;
			}
			// 判断期限是否在利率参数内
			if (term <= rateAttributes.getInt("Term")) {
				if (i < rateList.size() - 1) {
					if (term == rateAttributes.getInt("Term")
							|| term > rateList.get(i + 1).getInt("Term")) {
						baseRate = rateAttributes.getDouble("RATEVALUE");
						// 进行利率单位转换
						baseRate = RateHelper.getRate(yearDays,
								rateAttributes.getString("RateUnit"), baseRate,
								RateUnit);
						if (baseRate > 0d) {
							break;
						}
					}
				} else if (i == rateList.size() - 1) {
					baseRate = rateAttributes.getDouble("RATEVALUE");
					// 进行利率单位转换
					baseRate = RateHelper.getRate(yearDays,
							rateAttributes.getString("RateUnit"), baseRate,
							RateUnit);
					if (baseRate > 0d) {
						break;
					}
				}
			}
		}
		if (baseRate <= 0) {
			throw new ALSException("ED1022",baseRateType);
		}
		return Arith.round(baseRate,8);
	}
	
	/**
	 * 根据生效日期取利率配置
	 * 
	 * @param baseRateType
	 * @param currency
	 * @param effectDate
	 * @return
	 * @throws Exception
	 */
	private static List<BusinessObject> getBaseRateList(String baseRateType,
			String currency, String effectDate) throws Exception {
		
		String cacheKey="RateType="+baseRateType+",Currency="+currency+",effectDate="+effectDate;
		List<BusinessObject> rateList = (List<BusinessObject>)rateCache.getCacheObject(cacheKey);
		if (rateList == null){
			BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
			rateList=bomanager.loadBusinessObjects("jbo.app.PUB_RATE_INFO",  
					"Status = '1' and RateType='"+baseRateType+"' and Currency='"+currency+"' "
					+ " and EFFECTDATE = (select max(RI.EFFECTDATE) from jbo.app.PUB_RATE_INFO RI where RI.Status = '1' and RI.RateType='"+baseRateType+"' and RI.Currency='"+currency+"' and RI.EFFECTDATE<='"+effectDate+"')"
					+ " order by Term desc");
			rateCache.setCache(cacheKey, rateList);
		}
		return rateList;
	}
}
