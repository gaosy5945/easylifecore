package com.amarsoft.app.accounting.cashflow.pmt.impl;

import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;

/**
 * 用于费用计划计算
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
	 * 获取贷款金额
	 */
	public double getOutStandingPrincipal() throws Exception {
		return loan.getDouble("BusinessSum");
	}
}
