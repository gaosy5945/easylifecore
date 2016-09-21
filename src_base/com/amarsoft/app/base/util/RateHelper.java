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
	public static final String RateFloatType_PRECISION = "0";// �ٷֱȸ���
	public static final String RateFloatType_POINTS = "1";// ���㸡��
	
	public static final String RateMode_Fix = "2";// �̶�����
	public static final String RateMode_Float = "1";// ��������

	public static final String RateUnit_Year = "01";// ������
	public static final String RateUnit_Month = "02";// ������
	public static final String RateUnit_Day = "03";// ������
	
	private static BusinessObjectCache rateCache=new BusinessObjectCache(100);
	
	
	public static void clear() 
	{
		if(rateCache == null)
			rateCache = new BusinessObjectCache(100);
		else
			rateCache.clear();
	}
	
	/**
	 * �ж������ʱ����Ƿ���ڻ�׼��������
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
	 * ��һ�����ʵ�λ������ת��Ϊ��һ�����ʵ�λ�����ʣ���������ת��Ϊ�����ʣ�������ת��Ϊ�����ʵ�
	 * 
	 * @param yearDays
	 *            ���׼����
	 * @param rateUnit
	 *            ԭ���ʵ�λ
	 * @param rate
	 *            ԭ����
	 * @param newRateUnit
	 *            �����ʵ�λ
	 * @return ת���������ֵ
	 * @throws Exception 
	 */
	public static double getRate(int yearDays, String rateUnit, double rate, String newRateUnit) throws Exception {
		if (rateUnit.equals(newRateUnit)){
			return rate;
		}

		if (RateHelper.RateUnit_Year.equals(rateUnit) && RateHelper.RateUnit_Month.equals(newRateUnit)) {
			return rate / 100 / 12 * 1000;// �����ʣ�ǧ�ֱ�
		} else if (RateHelper.RateUnit_Year.equals(rateUnit)
				&& RateHelper.RateUnit_Day.equals(newRateUnit)) {
			return rate / 100 / yearDays * 10000;// �����ʣ���ֱ�
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)
				&& RateHelper.RateUnit_Year.equals(newRateUnit)) {
			return rate / 1000 * 12 * 100;// �����ʣ��ٷֱ�
		} else if (RateHelper.RateUnit_Month.equals(rateUnit)
				&& RateHelper.RateUnit_Day.equals(newRateUnit)) {
			return rate / 1000 * 12 / yearDays * 10000;// �����ʣ���ֱ�
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)
				&& RateHelper.RateUnit_Month.equals(newRateUnit)) {
			return rate / 10000 * yearDays / 12 * 1000;// �����ʣ�ǧ�ֱ�
		} else if (RateHelper.RateUnit_Day.equals(rateUnit)
				&& RateHelper.RateUnit_Year.equals(newRateUnit)) {
			return rate / 10000 * yearDays * 100;// �����ʣ��ٷֱ�
		} else {
			throw new ALSException("ED1001",RateHelper.RateUnit_Year+"\\"+RateHelper.RateUnit_Month+"\\"+RateHelper.RateUnit_Day,rateUnit);
		}
	}
	
	/**
	 * ���ݱ��֡���׼�������͡��������͡����ޡ���Ч���ڻ�ȡ���ʵ���
	 * @param currency
	 * @param baseRateType
	 * @param termUnit
	 * @param term
	 * @param effectDate
	 * @return ��׼���ʵ���
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency, String baseRateType,
			String termUnit, int term, String effectDate) throws Exception {

		List<BusinessObject> rateList = getBaseRateList(baseRateType, currency,
				effectDate);
		if (rateList == null || rateList.size() == 0) {
			throw new ALSException("ED1019",baseRateType);
		}

		// ��ȡ��׼���ʵ���
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
	 * �����׼����
	 * @param loan
	 * @param rateSegment
	 * @return ��׼����
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
	 * ��ȡ��������
	 * @param loan
	 * @param rateSegment
	 * @return ��������
	 * @throws Exception
	 */
	public static double getBusinessRate(BusinessObject loan, BusinessObject rateSegment) throws Exception {
		// ����ǹ̶�ģʽ,��ִ�����ʲ���
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
			// �����ʸ�������Ϊ����ʱ,ִ������ = ��׼����+��������
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
	 *            ���� �μ�����Currency
	 * @param baseRateType
	 *            �������ͣ��μ�����BaseRateType
	 * @param putOutDate
	 *            ��������
	 * @param maturityDate
	 *            ������
	 * @param effectDate
	 * 			      ��Ч����
	 * @return ���ʵ���
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency, String baseRateType,
			String putoutDate, String maturityDate, String effectDate)
			throws Exception {
		int term = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));// ����ȡ��
		return RateHelper.getBaseRateGrade(currency, baseRateType,
				DateHelper.TERM_UNIT_MONTH, term, effectDate);
	}
	
	/**
	 * ǰ��ֻ��ͨ��String��ʽ����
	 * @param Currency
	 *            ���֣��μ�����Currency
	 * @param YearDays
	 *            ���׼���� Ӣʽ���� 365 �������� 360�����ﴫ����Ҫ�ǽ���������������Ҫ��
	 * @param BaseRateType
	 *            �������ͣ��μ�����BaseRateType
	 * @param RateUnit
	 *            ���ʵ�λ���μ�����RateUnit
	 * @param putOutDate
	 *            ��������
	 * @param maturityDate
	 *            ������
	 * @param effectDate
	 * 			       ��Ч����
	 * @return ���ض�Ӧ���ʵ�λ������ֵ
	 * @throws Exception
	 */
	public static String getBaseRate(String currency, String yearDays,
			String baseRateType, String RateUnit, String putoutDate,
			String maturityDate, String effectDate) throws Exception {
		return String.valueOf(getBaseRate(currency,Integer.parseInt(yearDays),baseRateType,RateUnit,putoutDate,maturityDate,effectDate));
	}
	/**
	 * @param Currency
	 *            ���֣��μ�����Currency
	 * @param YearDays
	 *            ���׼���� Ӣʽ���� 365 �������� 360�����ﴫ����Ҫ�ǽ���������������Ҫ��
	 * @param BaseRateType
	 *            �������ͣ��μ�����BaseRateType
	 * @param RateUnit
	 *            ���ʵ�λ���μ�����RateUnit
	 * @param putOutDate
	 *            ��������
	 * @param maturityDate
	 *            ������
	 * @param effectDate
	 * 			       ��Ч����
	 * @return ���ض�Ӧ���ʵ�λ������ֵ
	 * @throws Exception
	 */
	public static double getBaseRate(String currency, int yearDays,
			String baseRateType, String RateUnit, String putoutDate,
			String maturityDate, String effectDate) throws Exception {
		int term = (int)Math.ceil(DateHelper.getMonths(putoutDate, maturityDate));//����ȡ��
		return RateHelper.getBaseRate(currency, yearDays, baseRateType,
				RateUnit, DateHelper.TERM_UNIT_MONTH, term, effectDate);
	}

	/**
	 * @param Currency
	 *            ���֣��μ�����Currency
	 * @param YearDays
	 *            ���׼���� Ӣʽ���� 365 �������� 360�����ﴫ����Ҫ�ǽ���������������Ҫ��
	 * @param BaseRateType
	 *            �������ͣ��μ�����BaseRateType
	 * @param RateUnit
	 *            ���ʵ�λ���μ�����RateUnit
	 * @param TermUnit
	 *            ���޵�λ���μ�����TermUnit
	 * @param Term
	 *            ����
	 * @param effectDate
	 * 			       ��Ч����
	 * @return ���ض�Ӧ���ʵ�λ������ֵ
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
		// �����׼����
		for (int i = 0; i < rateList.size(); i++) {
			BusinessObject rateAttributes = rateList.get(i);
			if (DateHelper.TERM_UNIT_DAY.equals(termUnit)) {
				term = term / 30;
			} else if (DateHelper.TERM_UNIT_YEAR.equals(termUnit)) {
				term = term * 12;
			}
			// �ж������Ƿ������ʲ�����
			if (term <= rateAttributes.getInt("Term")) {
				if (i < rateList.size() - 1) {
					if (term == rateAttributes.getInt("Term")
							|| term > rateList.get(i + 1).getInt("Term")) {
						baseRate = rateAttributes.getDouble("RATEVALUE");
						// �������ʵ�λת��
						baseRate = RateHelper.getRate(yearDays,
								rateAttributes.getString("RateUnit"), baseRate,
								RateUnit);
						if (baseRate > 0d) {
							break;
						}
					}
				} else if (i == rateList.size() - 1) {
					baseRate = rateAttributes.getDouble("RATEVALUE");
					// �������ʵ�λת��
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
	 * ������Ч����ȡ��������
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
