package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * 全部提前还款
 * @author Amarsoft核算团队
 */

public class PrepayScript7 extends PrepayScript {

	public int run() throws Exception {
		String nextDueDate = getSettleDate_NextDueDate();
		double prepayPrincipal = this.getPrepayPrincipal_PI(nextDueDate);
		settleInterest(nextDueDate,prepayPrincipal,prepayPrincipal);
		createPaymentSchedule();//创建一期提前还款的计划，并产生对应的还款日志
		setPSRestructureFlag("2");
		createJSONLog();
		return 1;
	}
}
