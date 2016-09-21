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
 * 等额递变
 * 
 */
public class PMTScript3 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		int totalPeriod = rptSegment.getInt("TotalPeriod")-rptSegment.getInt("CurrentPeriod")+1;
		double installInterestRate = this.getInterestRate();
		double outstandingBalance = super.getOutStandingPrincipal();
		double instalmentAmount = 0d;
		int gainCyc = rptSegment.getInt("GainCyc");
		double gainAmount = rptSegment.getDouble("GainAmount");

		int pAtt03 = 1;
		if (gainCyc > 0) {
			pAtt03 = rptSegment.getInt("CurrentPeriod")-1 - ((rptSegment.getInt("CurrentPeriod")-1) / gainCyc) * gainCyc; // 当前期次-1-最近一次变化期次
		}

		int iCTerm = totalPeriod + pAtt03;
		double dN3 = 0d;
		double dN4 = 0d;
		double dN5 = 0d;
		double dN6 = 0d;
		if (installInterestRate <= 0.0d) {
			double n;
			if (gainCyc > 0)
				n = Math.ceil((totalPeriod - rptSegment.getInt("CurrentPeriod")+1 - pAtt03) / (gainCyc * 1.0));
			else {
				n = totalPeriod - rptSegment.getInt("CurrentPeriod")+1;
				gainCyc = 1;
				gainAmount = 0;
			}
			instalmentAmount = (outstandingBalance * 2 / n - (n - 1) * gainAmount * gainCyc) / 2.0 / gainCyc;
		} else {
			if (iCTerm - gainCyc <= 0) {
				dN3 = outstandingBalance * java.lang.Math.pow((1 + installInterestRate), totalPeriod) + gainAmount
						* getFV(installInterestRate, totalPeriod);
				dN4 = 0d;
				dN5 = 1d;
				dN6 = 0d;
				instalmentAmount = (dN3 - dN4 / dN5) / (dN6 + getFV(installInterestRate, totalPeriod)) - gainAmount;
			} else {
				dN3 = outstandingBalance * java.lang.Math.pow((1 + installInterestRate), gainCyc - pAtt03)
						+ gainAmount * getFV(installInterestRate, gainCyc - pAtt03);
				dN4 = gainAmount
						* (java.lang.Math.pow((1 + installInterestRate), iCTerm - gainCyc) - (iCTerm - gainCyc)
								* (java.lang.Math.pow((1 + installInterestRate), gainCyc) - 1d) / gainCyc - 1);
				dN5 = (java.lang.Math.pow((1 + installInterestRate), gainCyc) - 1d) * installInterestRate
						* java.lang.Math.pow((1 + installInterestRate), iCTerm - gainCyc);
				dN6 = (java.lang.Math.pow((1 + installInterestRate), iCTerm - gainCyc) - 1d)
						/ (installInterestRate * java.lang.Math.pow((1 + installInterestRate), iCTerm - gainCyc));
				instalmentAmount = (dN3 - dN4 / dN5) / (dN6 + getFV(installInterestRate, gainCyc - pAtt03))
						- gainAmount;
			}
		}

		if (instalmentAmount < 0d)
			instalmentAmount = 0d;
		return Arith.round(instalmentAmount, CashFlowHelper.getMoneyPrecision(loan));
	}

	public void nextInstalment() throws Exception {
		super.nextInstalment();
		//更新期供...
		int m = 0;
		double dComp = 0d;
		double mAmt = 0d;
		int gainCyc = rptSegment.getInt("GainCyc");
		double gainAmount = rptSegment.getDouble("GainAmount");
		if(gainAmount != 0 && gainCyc != 0){
			//当前期次是递变期次的整数倍时，判断是否对月供增加递变幅度
			dComp = (rptSegment.getInt("CurrentPeriod")-1)%gainCyc;
			if(dComp == 0 && (rptSegment.getInt("CurrentPeriod")-1) != 0) m = 1;
			else m = 0;
		}
		//等额递增(减)还款法
		mAmt = rptSegment.getDouble("SegInstalmentAmt") + gainAmount * m;
		if(mAmt<0d) mAmt = 0d;
		rptSegment.setAttributeValue("SegInstalmentAmt", Arith.round(mAmt, CashFlowHelper.getMoneyPrecision(loan)));
	}

	private double getFV(double rate, int periods) {
		return (Math.pow((1d + rate), periods) - 1d) / rate;
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
