package com.amarsoft.app.accounting.cashflow.pmt.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * µÈ¶î±¾½ð
 */
public class PMTScript2 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		int totalPeriod = rptSegment.getInt("TotalPeriod")-rptSegment.getInt("CurrentPeriod")+1;
		double outstandingBalance = super.getOutStandingPrincipal();
		if (totalPeriod == 0) return 0.0d;
		double instalmentAmount = outstandingBalance / totalPeriod;
		return Arith.round(instalmentAmount, CashFlowHelper.getMoneyPrecision(loan));
	}

	public double getPrincipalAmount() throws Exception {
		double outstandingBalance = getOutStandingPrincipal();
		double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
		String normalBalanceAccountCodeNo=CashFlowConfig.getAmountCodeAttibute(CashFlowConfig.getPaymentScheduleAttribute(psType, "PrincipalAmountCode"),"NormalBalanceAccountCode");
		BusinessObject subsidiaryledger = loan.getBusinessObjectBySql(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, " AccountCodeNo=:AccountCodeNo and Status=:Status ", "AccountCodeNo",normalBalanceAccountCodeNo,"Status","1");
		double balance = AccountCodeConfig.getSubledgerBalance(subsidiaryledger,AccountCodeConfig.Balance_DateFlag_CurrentDay);
		
		String nextDueDate = rptSegment.getString("NextDueDate");
		String segToDate = rptSegment.getString("SegToDate");
		String maturityDate = loan.getString("MaturityDate");
		if (!StringX.isEmpty(nextDueDate)
				&& (!StringX.isEmpty(segToDate) && nextDueDate.compareTo(segToDate) >= 0))
			return outstandingBalance;
		else if (!StringX.isEmpty(nextDueDate)
				&& (nextDueDate.compareTo(maturityDate) >= 0))
			return balance;
		else
			return instalmentAmt;
	}

}
