package com.amarsoft.app.accounting.cashflow.pmt.impl;

import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.are.lang.StringX;

/**
 * ���ڸ�Ϣ���ڻ����ڹ����㡣�����ڸ�Ϣ���ڻ�����ʽ��Ϊһ�ֻ������ʽ �������ڲ����򻹿����������
 * 
 */
public final class PMTScript11 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		return 0;
	}

	public double getPrincipalAmount() throws Exception {
		double outstandingBalance = super.getOutStandingPrincipal();
		String nextDueDate = rptSegment.getString("NEXTDUEDATE");
		String segToDate = rptSegment.getString("SegToDate");
		String maturityDate = loan.getString("MaturityDate");
		if (!StringX.isEmpty(nextDueDate)
				&& (!StringX.isEmpty(segToDate) && nextDueDate.compareTo(segToDate) >= 0 || nextDueDate
						.compareTo(maturityDate) >= 0)) {
			return outstandingBalance;
		} else {
			return 0;
		}
	}

}
