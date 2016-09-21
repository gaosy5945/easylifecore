package com.amarsoft.app.accounting.cashflow.pmt.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.interest.calc.InterestCalculator;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 灵活等额本息
 * 
 */
public class PMTScript5 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		double installmentAmt = rptSegment.getDouble("SegInstalmentAmt");

		//获取未来还款日期
		List<BusinessObject> paymentScheduleList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "PSType=:PSType and PayDate>:PayDate", "PSType",psType,"PayDate",loan.getString("BusinessDate"));
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subledger = loan.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "AccountCodeNo=:AccountCodeNo and Status=:Status", "AccountCodeNo",normalBalanceAccountCodeNo,"Status","1");
		
		double principalBalance_O = AccountCodeConfig.getSubledgerBalance(subledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		if (principalBalance_O <= 0d)
			return 0d;

		double installmentAmt_Max = principalBalance_O;
		double installmentAmt_Min = 0.01;
		int j = 0;
		while (j++ < 1000) {
			double principalBalance = principalBalance_O;
			installmentAmt = Arith.round((installmentAmt_Max + installmentAmt_Min) / 2,
					CashFlowHelper.getMoneyPrecision(loan));
			String lastDueDate = DueDateScript.getLastDueDate(loan,psType);

			for (BusinessObject ps : paymentScheduleList) {
				String payDate = ps.getString("PayDate");
				double installmentInterestRate = 0d;
				String amountCodes = CashFlowConfig.getPaymentScheduleAttribute(psType, "AmountCode");
				String[] amountCodeArray=amountCodes.split(",");
				for(String amountCode:amountCodeArray){
					String interestType=CashFlowConfig.getAmountCodeAttibute(amountCode, "InterestType");
					if(interestType.isEmpty()) continue;
					List<BusinessObject> rateList = this.getRateSegments(interestType);
					for(BusinessObject rateTerm:rateList){
						installmentInterestRate += InterestCalculator.getInterestCalculator(loan,interestType,psType)
								.getInterest(1.0, rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), lastDueDate, payDate, lastDueDate, payDate);
					}
				}
				double interestAmount = Arith.round(
						Math.floor(principalBalance * installmentInterestRate * 100) / 100.0,
						CashFlowHelper.getMoneyPrecision(loan));
				ps.setAttributeValue("PayInterestAmt", interestAmount);

				// 计算本金
				double principalAmount = 0d;
				double fixInstallmentAmt = ps.getDouble("FixPayInstalmentAmt");
				if (fixInstallmentAmt < 0d) {
					continue;
				} else if (fixInstallmentAmt > 0d) {
					principalAmount = fixInstallmentAmt - interestAmount;
				} else {// 如果未指定还款金额，则判断是否指定了还本金额
					double fixPrincipalAmt = ps.getDouble("FixPayPrincipalAmt");
					if (fixPrincipalAmt == 0d) {
						principalAmount = Arith.round(installmentAmt - interestAmount,
								CashFlowHelper.getMoneyPrecision(loan));
					} else {
						principalAmount = fixPrincipalAmt;
					}
				}

				ps.setAttributeValue("PayPrincipalAmt", principalAmount);
				if (principalAmount < 0d) {
					principalAmount = 0d;
				}
				principalBalance = Arith.round(principalBalance - principalAmount,
						CashFlowHelper.getMoneyPrecision(loan));

				lastDueDate = payDate;
			}

			if (Math.abs(principalBalance) < 0.01 * (paymentScheduleList.size() - 1)) {
				break;
			} else if (principalBalance < 0d) {
				installmentAmt_Max = installmentAmt;
			} else {
				installmentAmt_Min = installmentAmt;
			}
		}
		return Arith.round(installmentAmt, CashFlowHelper.getMoneyPrecision(loan));
	}

	public double getPrincipalAmount() throws Exception {
		double outstandingBalance = getOutStandingPrincipal();
		double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subsidiaryledger = loan.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, " AccountCodeNo=:AccountCodeNo and Status=:Status ", "AccountCodeNo",normalBalanceAccountCodeNo,"Status","1");
		double balance = AccountCodeConfig.getSubledgerBalance(subsidiaryledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);

		double installInterestRate = this.getInterestRate();
		String nextDueDate = rptSegment.getString("NextDueDate");
		String segToDate = rptSegment.getString("SegToDate");
		String maturityDate = loan.getString("MaturityDate");
		if (!StringX.isEmpty(nextDueDate)
				&& (!StringX.isEmpty(segToDate) && nextDueDate.compareTo(segToDate) >= 0 || nextDueDate
						.compareTo(maturityDate) >= 0))
			return outstandingBalance;
		if (instalmentAmt <= balance * installInterestRate) {
			return 0.0d;
		} else {
			double principalAmt = Arith.round(
					instalmentAmt
							- Arith.round(balance * installInterestRate, CashFlowHelper.getMoneyPrecision(loan)),
							CashFlowHelper.getMoneyPrecision(loan));
			if (principalAmt > rptSegment.getDouble("SegRPTBalance")
					&& CashFlowConfig.SEGRPTAMOUNT_SEG_AMT.equals(rptSegment.getString("SegRPTAmountFlag"))) {
				principalAmt = Arith.round(rptSegment.getDouble("SegRPTBalance"),
						CashFlowHelper.getMoneyPrecision(loan));
			}
			return principalAmt;
		}
	}

}
