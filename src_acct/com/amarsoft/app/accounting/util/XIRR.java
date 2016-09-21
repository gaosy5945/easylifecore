package com.amarsoft.app.accounting.util;

import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.util.Arith;


/**
 * 内部收益率 为投资的回收利率，其中包含不定期支付（负值）和不定期收入（正值）。
 * 
 * @author jshen
 */

public class XIRR {
	static public double evaluate(final List<Double> cashFlows, final List<String> dateFlows, int intBasisYDays,
			String termUnit, int term) throws Exception {
		return evaluate(cashFlows, dateFlows, intBasisYDays, Double.NaN, termUnit, term);
	}

	
	/**
	 * 返回年利率
	 * @param cashFlows
	 * @param dateFlows
	 * @return
	 * @throws Exception
	 */
	static public double evaluate(final List<Double> cashFlows, final List<String> dateFlows) throws Exception {
		double maxRate = 10d;
		double minRate = 0d;
		double result = maxRate/2d;
		final int maxIteration = 100;
		
		for (int i = 1; i <= maxIteration; i++) {
			int size = cashFlows.size();
			double cashFlow = 0-cashFlows.get(0);
			String dateFlow = dateFlows.get(0);
			for (int j = 1; j <= size-1; j++) {
				int idays=DateHelper.getDays(dateFlow, dateFlows.get(j));
				double inte = 0d;
				
				if(j==1){
					inte = Arith.round(cashFlow * result * idays / 360d,2) ;
				}else{
					inte = Arith.round(cashFlow * result / 12d,2) ;
				}
				
				double corp = Arith.round(cashFlows.get(j)-inte,2);
				dateFlow=dateFlows.get(j);	
				//if (corp < 0d ) break;
				if (corp < 0d ) corp=0d;
				
				cashFlow=Arith.round(cashFlow-corp,2);						
			}
			
			if(cashFlow > -0.1d && cashFlow < -0.01d) break;
			
			if(cashFlow>0d) {
				double irrRateTemp = result;
				result=(result+minRate)/2d;
				maxRate = irrRateTemp;
			}
			
			if(cashFlow<0d) {
				double irrRateTemp = result;
				result=(result+maxRate)/2d;
				minRate=irrRateTemp;	
			}
		}
		
		return result;
	}
	
	/**
	 * @author jshen
	 * @serialData 2010/03/26
	 * @param cashFlows
	 * @param dateFlows
	 * @param intBasisYDays
	 *            年基准天数
	 * @param estimatedResult
	 * @return 年利率
	 * @throws Exception
	 */
	static public double evaluate(final List<Double> cashFlows, final List<String> dateFlows, int intBasisYDays,
			final double estimatedResult, String termUnit, int term) throws Exception {
		double result = Double.NaN;

		if (cashFlows != null && cashFlows.size() > 0) {
			if (cashFlows.get(0)!= 0d) {
				final int noOfCashFlows = cashFlows.size();

				double sumCashFlows = 0d;
				int noOfNegativeCashFlows = 0;
				int noOfPositiveCashFlows = 0;
				for (int i = 0; i < noOfCashFlows; i++) {
					sumCashFlows += cashFlows.get(i);
					if (cashFlows.get(i) > 0) {
						noOfPositiveCashFlows++;
					} else if (cashFlows.get(i) < 0) {
						noOfNegativeCashFlows++;
					}
				}

				if (noOfNegativeCashFlows > 0 && noOfPositiveCashFlows > 0) {

					double irrGuess = 0.1;
					if (!Double.isNaN(estimatedResult)) {
						irrGuess = estimatedResult;
						if (irrGuess <= 0d)
							irrGuess = 0.5;
					}

					double irr = 0d;
					if (sumCashFlows < 0) {
						irr = -irrGuess;
					} else {
						irr = irrGuess;
					}
					final double minDistance = 1E-15;

					final double cashFlowStart = cashFlows.get(0);
					final int maxIteration = 100;
					boolean wasHi = false;
					double cashValue = 0d;
					for (int i = 0; i <= maxIteration; i++) {
						cashValue = cashFlowStart;

						for (int j = 1; j < noOfCashFlows; j++) {

							cashValue += cashFlows.get(j)
									/ Math.pow(1.0 + irr,
											XIRR.getIndex(dateFlows.get(0), dateFlows.get(j), termUnit, term, intBasisYDays));
						}

						if (Math.abs(cashValue) < 0.01) {
							result = irr;
							break;
						}

						if (cashValue > 0d) {
							if (wasHi) {
								irrGuess /= 2;
							}

							irr += irrGuess;

							if (wasHi) {
								irrGuess -= minDistance;
								wasHi = false;
							}

						} else {
							irrGuess /= 2;
							irr -= irrGuess;
							wasHi = true;
						}

						if (irrGuess <= minDistance) {
							result = irr;
							break;
						}
					}
				}
			}
		}
		return result;
	}

	public static double getIndex(String beginDate, String endDate, String termUnit, int term, int baseDays)
	throws Exception {
		double n = 0d;
		if (termUnit.equals(DateHelper.TERM_UNIT_YEAR)) {
			n=DateHelper.getDays(beginDate, endDate) / (baseDays * 1.0);
		}
		
		if (termUnit.equals(DateHelper.TERM_UNIT_MONTH)) {
			n=DateHelper.getDays(beginDate, endDate) / (baseDays * 1.0) * 12;
		}
		
		if (termUnit.equals(DateHelper.TERM_UNIT_DAY)) {
			n = DateHelper.getDays(beginDate, endDate);
		}
		return n / (term * 1.0);
	}

	public static void main(String[] args) throws Exception {
		/*double[] cashFlows = { -10000, 1041.67, 1037.5, 1033.33, 1029.17, 1025, 1020.83, 1016.67, 1012.5, 1008.33, 1004.17 };
		String[] dateFlows = { "2014/06/24", "2014/07/24", "2014/08/24", "2014/09/24", "2014/10/24", "2014/11/24",
				"2014/12/24", "2015/01/24", "2015/02/24", "2015/03/24", "2015/04/24" };
		System.out.println(XIRR.evaluate(cashFlows, dateFlows, 360, DateHelper.TERM_UNIT_MONTH, 1) * 12);*/
	}
}
