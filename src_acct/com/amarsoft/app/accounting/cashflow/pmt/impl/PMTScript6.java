/**
 * 
 */
package com.amarsoft.app.accounting.cashflow.pmt.impl;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.due.PeriodScript;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * ����˫�ܹ����ȶ
 * @author xjzhao
 */

public class PMTScript6 extends PMTScript {
	
	/**
	 * ˫�ܹ��¹�����
	 * �����˫�ܹ������ڴΣ��¹����ǵȶϢ�¹���1/2
	 */
	public double getInstalmentAmount() throws Exception {
		
		String paymentFrequencyType=rptSegment.getString("PayFrequencyType");//��������
		//���㱾�׶���Ҫ�����ı�����
		double outstandingBalance= super.getOutStandingPrincipal();
		rptSegment.setAttributeValue("PayFrequencyType", "1");//����
		PeriodScript periodScript = PeriodScript.getPeriodScript(loan, rptSegment, psType);
		int totalPeriod =  periodScript.getTotalPeriod();
		rptSegment.setAttributeValue("PayFrequencyType", paymentFrequencyType);//��ԭ
		
		double instalmentAmt = 0.0;
		double installInterestRate = this.getInterestRate();
		//�����ڴ�Ϊ��ʱ��˵����Ҫһ���Գ���
		if(totalPeriod == 0){
			
			instalmentAmt = outstandingBalance+outstandingBalance * installInterestRate;
		}
		else{
			
			double preiodRate=this.getPreiodRate();
			//���㹫ʽ
    		if(Math.abs(preiodRate) < 0.000000001 )
    			instalmentAmt = outstandingBalance/totalPeriod/2;
    		else
    			instalmentAmt = outstandingBalance * preiodRate * (1d + 1d / (java.lang.Math.pow(1d + preiodRate,totalPeriod) - 1));
    		//�ȶϢ�㷨���¹���һ��
    		instalmentAmt = Arith.round(instalmentAmt/2d,2);
    		if(Math.abs(installInterestRate) < 0.000000001)
    		{
    			int cterm = (int)java.lang.Math.floor(outstandingBalance/instalmentAmt);
    			instalmentAmt = outstandingBalance/cterm;
    		}
    		else
    		{
	    		int cterm = (int)java.lang.Math.floor(java.lang.Math.log10(instalmentAmt/
					(instalmentAmt-outstandingBalance*installInterestRate))/java.lang.Math.log10(1+installInterestRate));
			
		    	instalmentAmt = outstandingBalance * installInterestRate * (1d + 1d / (java.lang.Math.pow(1d + installInterestRate,cterm) - 1));
    		}
		}
    	return Arith.round(instalmentAmt,2);
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
