package com.amarsoft.app.accounting.trans.script.loan.repay.prepay.impl;

import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;

/**
 * ȫ����ǰ����
 * @author Amarsoft�����Ŷ�
 */

public class PrepayScript8 extends PrepayScript {

	public int run() throws Exception {
		String transDate = this.getSettleDate_TransDate();
		settleInterest(transDate,this.getPrepayPrincipal_PB(transDate),this.getPrepayPrincipal_All());
		createPaymentSchedule();//����һ����ǰ����ļƻ�����������Ӧ�Ļ�����־
		setPSRestructureFlag("2");
		createJSONLog();
		return 1;
	}
}
