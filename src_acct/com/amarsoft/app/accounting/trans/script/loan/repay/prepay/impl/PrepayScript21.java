package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript21 extends PrepayScript {

	public int run() throws Exception {
		settleInterest(getSettleDate_TransDate(),getPrepayPrincipal_All(),getPrepayPrincipal_All());
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("1");
		createJSONLog();
		return 1;
	}
}
