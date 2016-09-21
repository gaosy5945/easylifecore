package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 放款时计算IRR,产生IRR还款计划，并产生投资收益计划。
 */
public final class CreateIRRPaymentScheduleCreator extends TransactionProcedure{

	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");

		List<BusinessObject> paymentSchedules = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate>:BusinessDate and (FinishDate=null or FinishDate='') and PSType <> :PSType ", 
				"BusinessDate",relativeObject.getString("BusinessDate"),"PSType",psType);
		if(paymentSchedules == null || paymentSchedules.isEmpty()) return 1;
		
		//对还款计划进行处理，将费用和本金、利息进行合并
		String lastDuedate=DueDateScript.getLastDueDate(relativeObject, "1");
		int cnt = 1;
		String maxDate = (String)BusinessObjectHelper.getMaxValue(paymentSchedules, "PayDate");
		String minDate = DateHelper.getRelativeDate(lastDuedate, DateHelper.TERM_UNIT_MONTH, cnt);
		
		int currentPeriod = (Integer)BusinessObjectHelper.getMinValue(paymentSchedules, "PeriodNo");
		
		double irrPrincipalBalance=0d;
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger=relativeObject.getBusinessObjectByAttributes(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo",normalBalanceAccountCodeNo);
		if(subledger!=null){
			irrPrincipalBalance=AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);//取贷款余额信息
		}
		else{
			irrPrincipalBalance=relativeObject.getDouble("BusinessSum");
		}
		
		List<Double> cashFlowList = new ArrayList<Double>();
		cashFlowList.add(new Double(0.0d-irrPrincipalBalance));
		while(minDate.compareTo(maxDate) <= 0)
		{
			List<BusinessObject> tmps = BusinessObjectHelper.getBusinessObjectsBySql(paymentSchedules, "PayDate like :PayDate", "PayDate", minDate.substring(0, 7));
			double d = 0.0d;
			for(BusinessObject tmp:tmps)
			{
				d+=tmp.getDouble("PayPrincipalAmt") + tmp.getDouble("PayInterestAmt");
			}
			cashFlowList.add(d);
			cnt++;
			minDate = DateHelper.getRelativeDate(lastDuedate, DateHelper.TERM_UNIT_MONTH, cnt);
		}
		
		
		double[] cashFlows = new double[cashFlowList.size()];
		for (int i=0;i< cashFlowList.size();i++) {
			cashFlows[i]=cashFlowList.get(i);
		}

		double irrRate = evaluate(cashFlows); //内部月收益率
		
		
		List<BusinessObject> l=relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "RateType=:RateType and Status=:Status", "RateType","04","Status","1");
		for(BusinessObject rateSegment:l){
			rateSegment.setAttributeValue("SegToDate", lastDuedate);
			rateSegment.setAttributeValue("Stauts", "2");
			bomanager.updateBusinessObject(rateSegment);
		}
		
		//IRR，年化利率，百分比
		BusinessObject IRRRateSegment=BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
		IRRRateSegment.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTANTS.loan);
		IRRRateSegment.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		IRRRateSegment.setAttributeValue("RateType", "04");
		IRRRateSegment.setAttributeValue("RateUnit", RateHelper.RateUnit_Month);
		IRRRateSegment.setAttributeValue("Status", "1");
		IRRRateSegment.setAttributeValue("BusinessRate",  irrRate * 1000);
		IRRRateSegment.setAttributeValue("SegFromDate", lastDuedate);
		bomanager.updateBusinessObject(IRRRateSegment);
		relativeObject.setAttributeValue("IRRRate", irrRate * 100);
		relativeObject.appendBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, IRRRateSegment);
		
		List<BusinessObject> oldPSList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PayDate>:BusinessDate and (FinishDate=null or FinishDate='') and PSType=:PSType", 
				"BusinessDate",relativeObject.getString("BusinessDate"),"PSType",psType);
		relativeObject.removeBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, oldPSList);
		this.bomanager.deleteBusinessObjects(oldPSList);
		

		//产生IRR还款计划
		//		4、第N期的IRR利息（最后一期）=【平息当期（本金+利息+服务费）-IRR（本金）】*平息月利率/（平息月利率+平息月服务费率）
		//		5、第N期的IRR服务费（最后一期）=【平息当期（本金+利息+服务费）-IRR（本金）】*平息服务费率/（平息月利率+平息月服务费率）
		//		7、第N期的IRR本金（最后一期）=第N-1期剩余IRR本金
		//		8、IRR超期费用=平息金额
		//		9、IRR代偿费=平息金额

		String payPrincipalAttributeID="",principalBalanceAttributeID="";
		String principalAmountCode=CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode");
		if(!StringX.isEmpty(principalAmountCode)){
			payPrincipalAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "PS.PayAttributeID");
			principalBalanceAttributeID=CashFlowConfig.getAmountCodeAttibute(principalAmountCode, "PS.BalanceAttributeID");
		}
		
		List<Object> psTypes = BusinessObjectHelper.getDistinctValues(paymentSchedules, "PSType");
		
		BusinessObject psRate = BusinessObject.createBusinessObject();
		double rate = 0d;
		for(int i = 0; i < psTypes.size() ; i++)
		{
			double d = 0d;
			String irrAmountCode = CashFlowConfig.getPaymentScheduleAttribute((String)psTypes.get(i), "IRRAmountCode");
			String interestType = CashFlowConfig.getAmountCodeAttibute(irrAmountCode, "InterestType");
			String[] rateTypes = CashFlowConfig.getRateTypes(interestType);
			
			List<BusinessObject> rates = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, "RateType in(:RateType) and Status=:Status", "RateType",rateTypes,"Status","1");
			for(BusinessObject r:rates)
			{
				d = RateHelper.getRate(CashFlowHelper.getYearBaseDay(relativeObject), r.getString("RateUnit"), r.getDouble("BusinessRate"), RateHelper.RateUnit_Month)/1000.0d;
				rate +=d;
			}
			
			psRate.setAttributeValue((String)psTypes.get(i), d);
		}
		
		maxDate = (String)BusinessObjectHelper.getMaxValue(paymentSchedules, "PayDate");
		cnt = 1;
		minDate = DateHelper.getRelativeDate(lastDuedate, DateHelper.TERM_UNIT_MONTH, cnt);
		
		while(minDate.compareTo(maxDate) <= 0)
		{
			List<BusinessObject> tmps = BusinessObjectHelper.getBusinessObjectsBySql(paymentSchedules, "PayDate like :PayDate", "PayDate", minDate.substring(0, 7));

			double totalAmt = 0d;
			for(BusinessObject tmp:tmps)
			{
				totalAmt += tmp.getDouble("PayPrincipalAmt") + tmp.getDouble("PayInterestAmt");
			}
			
			double irrPrincipal=0d;
			BusinessObject prirrpayment = null;
			List<BusinessObject> prilist = new ArrayList<BusinessObject>();
			if(DateHelper.getRelativeDate(lastDuedate, DateHelper.TERM_UNIT_MONTH, cnt+1).compareTo(maxDate) > 0){
				irrPrincipal=irrPrincipalBalance;
				for(int i = 0; i < psTypes.size() ; i++)
				{
					BusinessObject irrpayment = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
					irrpayment.generateKey();
					irrpayment.setAttributeValue("ObjectType", relativeObject.getBizClassName());
					irrpayment.setAttributeValue("ObjectNo", relativeObject.getString("SerialNo"));
					irrpayment.setAttributeValue("RelativeObjectType", relativeObject.getBizClassName());
					irrpayment.setAttributeValue("RelativeObjectNo", relativeObject.getString("SerialNo"));
					irrpayment.setAttributeValue("PeriodNo", currentPeriod);
					irrpayment.setAttributeValue("Currency", relativeObject.getString("Currency"));
					irrpayment.setAttributeValue("PSType", psType);
					irrpayment.setAttributeValue("PayDate", minDate);
					irrpayment.setAttributeValue("AutoPayFlag", CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag"));
					irrpayment.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
					irrpayment.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
					irrpayment.setAttributeValue("Status", "1");
					
					
					if("1".equals(psTypes.get(i))){
						irrpayment.setAttributeValue(payPrincipalAttributeID,irrPrincipal);
						irrPrincipalBalance = Arith.round(irrPrincipalBalance - irrPrincipal, CashFlowHelper.getMoneyPrecision(relativeObject));
						irrpayment.setAttributeValue(principalBalanceAttributeID, irrPrincipalBalance);
						prirrpayment = irrpayment;
					}
					else
					{
						prilist.add(irrpayment);
					}
					double inte = 0d;
					if(rate > 0d)
						inte =Arith.round((totalAmt-irrPrincipal)*psRate.getDouble((String)psTypes.get(i))/rate,CashFlowHelper.getMoneyPrecision(relativeObject));
					
					irrpayment.setAttributeValue("PayInterestAmt", inte);
					relativeObject.appendBusinessObject(irrpayment.getBizClassName(), irrpayment);
					bomanager.updateBusinessObject(irrpayment);
				}
			}
			else{
				double totalInte = 0d;
				for(int i = 0; i < psTypes.size() ; i++)
				{
					BusinessObject irrpayment = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.payment_schedule);
					irrpayment.generateKey();
					irrpayment.setAttributeValue("ObjectType", relativeObject.getBizClassName());
					irrpayment.setAttributeValue("ObjectNo", relativeObject.getString("SerialNo"));
					irrpayment.setAttributeValue("RelativeObjectType", relativeObject.getBizClassName());
					irrpayment.setAttributeValue("RelativeObjectNo", relativeObject.getString("SerialNo"));
					irrpayment.setAttributeValue("PeriodNo", currentPeriod);
					irrpayment.setAttributeValue("Currency", relativeObject.getString("Currency"));
					irrpayment.setAttributeValue("PSType", psType);
					irrpayment.setAttributeValue("PayDate", minDate);
					irrpayment.setAttributeValue("AutoPayFlag", CashFlowConfig.getPaymentScheduleAttribute(psType, "AutoPayFlag"));
					irrpayment.setAttributeValue("PayItemCode", CashFlowConfig.getPaymentScheduleAttribute(psType, "PayItemCode"));
					irrpayment.setAttributeValue("Direction", CashFlowConfig.getPaymentScheduleAttribute(psType, "Direction"));
					irrpayment.setAttributeValue("Status", "1");
					
					
					if("1".equals(psTypes.get(i))){
						prirrpayment = irrpayment;
					}
					else
					{
						prilist.add(irrpayment);
					}
					double inte = 0d;
					if(rate > 0d)
						inte =Arith.round(irrPrincipalBalance*irrRate*psRate.getDouble((String)psTypes.get(i))/rate,CashFlowHelper.getMoneyPrecision(relativeObject));
					totalInte += inte;
					irrpayment.setAttributeValue("PayInterestAmt", inte);
					relativeObject.appendBusinessObject(irrpayment.getBizClassName(), irrpayment);
					bomanager.updateBusinessObject(irrpayment);
				}
				irrPrincipal = Arith.round(totalAmt - totalInte, CashFlowHelper.getMoneyPrecision(relativeObject));
				prirrpayment.setAttributeValue(payPrincipalAttributeID,irrPrincipal);
				irrPrincipalBalance = Arith.round(irrPrincipalBalance - irrPrincipal, CashFlowHelper.getMoneyPrecision(relativeObject));
				prirrpayment.setAttributeValue(principalBalanceAttributeID, irrPrincipalBalance);
			}
			
			currentPeriod++;
			for(BusinessObject pri:prilist)
			{
				pri.setAttributeValue("ParentSerialNo", prirrpayment.getKeyString());
			}
			
			cnt++;
			minDate = DateHelper.getRelativeDate(lastDuedate, DateHelper.TERM_UNIT_MONTH, cnt);
		}
		
		return 1;
	}
	
	public double evaluate(final double[] cashFlows) {
		return evaluate(cashFlows,Double.NaN);
	}
	public double evaluate(final double[] cashFlows,final double estimatedResult) {
		double result = Double.NaN;

		if (cashFlows != null && cashFlows.length > 0) {
			if (cashFlows[0] != 0d) {
				final int noOfCashFlows = cashFlows.length;

				double sumCashFlows = 0d;
				int noOfNegativeCashFlows = 0;
				int noOfPositiveCashFlows = 0;
				for (int i = 0; i < noOfCashFlows; i++) {
					sumCashFlows += cashFlows[i];
					if (cashFlows[i] > 0) {
						noOfPositiveCashFlows++;
					} else if (cashFlows[i] < 0) {
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

					final double cashFlowStart = cashFlows[0];
					final int maxIteration = 100;
					boolean wasHi = false;
					double cashValue = 0d;
					for (int i = 0; i <= maxIteration; i++) {
						cashValue = cashFlowStart;

						for (int j = 1; j < noOfCashFlows; j++) {
							cashValue += cashFlows[j] / Math.pow(1d + irr, j);
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
}
