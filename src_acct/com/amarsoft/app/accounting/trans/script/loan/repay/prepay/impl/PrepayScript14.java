package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript14 extends PrepayScript {

	public int run() throws Exception {
		settleInterest(this.getSettleDate_NextDueDate(),this.getPrepayPrincipal_P(),this.getPrepayPrincipal_All());
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("1");
		createJSONLog();
		return 1;
	}
}