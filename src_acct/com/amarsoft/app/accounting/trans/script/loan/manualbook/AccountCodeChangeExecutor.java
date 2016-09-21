package com.amarsoft.app.accounting.trans.script.loan.manualbook;

import java.util.List;

import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * ��Ŀ�����������������֣���Ŀ�˵��������п�Ŀ�ı�� ��������������
 * 
 */
public class AccountCodeChangeExecutor extends BookKeepExecutor {

	public int run() throws Exception {
		List<BusinessObject> details=documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail);
		this.updateLedgerAccount(details);
		transaction.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail, details);
		// ���·ֻ���
		updateLedgerAccount(details);
		return 1;
	}
}