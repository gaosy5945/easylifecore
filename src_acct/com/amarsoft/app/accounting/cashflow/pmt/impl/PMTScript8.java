package com.amarsoft.app.accounting.cashflow.pmt.impl;


import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;

/**
 * 指定还款额
 * 
 */
public class PMTScript8 extends PMTScript {

	public double getInstalmentAmount() throws Exception {
		rptSegment.setAttributeValue("SegInstalmentAmt", rptSegment.getDouble("SegRPTAmount"));
		return rptSegment.getDouble("SegInstalmentAmt");
	}
	
	public double getPrincipalAmount() throws Exception {
		return 0;
	}
}
