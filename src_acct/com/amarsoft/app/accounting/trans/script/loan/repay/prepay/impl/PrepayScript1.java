package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript1 extends PrepayScript {

	public int run() throws Exception {
		double prepayPrincipal = this.getPrepayPrincipal_P();
		settleInterest(this.getSettleDate_TransDate(),prepayPrincipal,prepayPrincipal);
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("2");
		createJSONLog();
		return 1;
	}
}
