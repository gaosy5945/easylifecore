/**
 * 
 */
package com.amarsoft.app.accounting.cashflow.pmt.impl;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.cashflow.due.PeriodScript;
import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.are.util.Arith;

/**
 * ����˫�ܹ����ȱ���
 * @author yegang
 */
public class PMTScript7 extends PMTScript {
	
	public double getInstalmentAmount() throws Exception {
    	int totalPeriod=rptSegment.getInt("TotalPeriod");
		String payFrequencyType=rptSegment.getString("PayFrequencyType");//��������
		rptSegment.setAttributeValue("PayFrequencyType", "1");//����
		
		PeriodScript periodScript = PeriodScript.getPeriodScript(loan, rptSegment, psType);
		totalPeriod =  periodScript.getTotalPeriod();
		rptSegment.setAttributeValue("PayFrequencyType", payFrequencyType);//��ԭ����
		
		double outstandingBalance = super.getOutStandingPrincipal();
		if (totalPeriod == 0) return outstandingBalance;
		double instalmentAmount = outstandingBalance / totalPeriod;
		return Arith.round(instalmentAmount/2.0d, CashFlowHelper.getMoneyPrecision(loan));
	}
	
	public double getPrincipalAmount() throws Exception {
		return rptSegment.getDouble("SegInstalmentAmt");
	}

}
