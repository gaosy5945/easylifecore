package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript6 extends PrepayScript {

	public int run() throws Exception {
		String transDate = getSettleDate_TransDate();
		double prepayPrincipal = this.getPrepayPrincipal_PI(transDate);
		settleInterest(transDate,prepayPrincipal,prepayPrincipal);
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("2");
		createJSONLog();
		return 1;
	}
}
