package com.amarsoft.app.accounting.cashflow.pmt.impl;

import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;

/**
 * ���ڷ��üƻ�����
 * 
 */
public final class PMTScript12 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		return 0;
	}

	public double getPrincipalAmount() throws Exception {
		return 0;
	}
	
	/**
	 * ��ȡ������
	 */
	public double getOutStandingPrincipal() throws Exception {
		return loan.getDouble("BusinessSum");
	}
}
