package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript7 extends PrepayScript {

	public int run() throws Exception {
		String nextDueDate = getSettleDate_NextDueDate();
		double prepayPrincipal = this.getPrepayPrincipal_PI(nextDueDate);
		settleInterest(nextDueDate,prepayPrincipal,prepayPrincipal);
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("2");
		createJSONLog();
		return 1;
	}
}
