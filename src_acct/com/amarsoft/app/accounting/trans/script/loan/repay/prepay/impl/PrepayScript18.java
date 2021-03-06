package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * 全部提前还款
 * @author Amarsoft核算团队
 */

public class PrepayScript18 extends PrepayScript {

	public int run() throws Exception {
		String transDate = this.getSettleDate_TransDate();
		settleInterest(transDate,this.getPrepayPrincipal_PB(transDate),this.getPrepayPrincipal_All());
		createPaymentSchedule();//创建一期提前还款的计划，并产生对应的还款日志
		setPSRestructureFlag("1");
		createJSONLog();
		return 1;
	}
}
