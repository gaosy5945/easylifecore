package com.amarsoft.app.accounting.cashflow.pmt.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 标准等额本息
 * 
 */
public class PMTScript1 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		int totalPeriod = rptSegment.getInt("TotalPeriod")-rptSegment.getInt("CurrentPeriod")+1;
		double instalInterestRate=this.getPreiodRate();
		double outstandingBalance = this.getOutStandingPrincipal();// 计算本阶段需要偿还的本金金额
		
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subsidiaryledger = loan.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, " AccountCodeNo=:AccountCodeNo and Status=:Status ", "AccountCodeNo",normalBalanceAccountCodeNo,"Status","1");
		double balance = AccountCodeConfig.getSubledgerBalance(subsidiaryledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		
		double instalmentAmount = 0.0;
		
		if(balance > outstandingBalance) instalmentAmount+= (balance-outstandingBalance)*instalInterestRate;
		
		if (instalInterestRate > 0d)// 利率大于零时计算
			instalmentAmount += outstandingBalance * instalInterestRate
					* (1 + 1 / (java.lang.Math.pow(1 + instalInterestRate, totalPeriod) - 1));
		else {
			instalmentAmount += outstandingBalance / totalPeriod;
		}
		return Arith.round(instalmentAmount, CashFlowHelper.getMoneyPrecision(loan));
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
				&& (!StringX.isEmpty(segToDate) && nextDueDate.compareTo(segToDate) >= 0))
			return outstandingBalance;
		if (!StringX.isEmpty(nextDueDate)
				&& (nextDueDate.compareTo(maturityDate) >= 0))
			return balance;
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
