package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript19 extends PrepayScript {

	public int run() throws Exception {
		String nextDueDate = this.getSettleDate_NextDueDate();
		settleInterest(nextDueDate,this.getPrepayPrincipal_PB(nextDueDate),this.getPrepayPrincipal_All());
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("1");
		createJSONLog();
		return 1;
	}
}
