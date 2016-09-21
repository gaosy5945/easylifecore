package com.amarsoft.app.accounting.trans.script.loan.manualbook;

import java.util.List;

import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * 科目调整，包含两个部分：科目账调整、银行科目的变更 不包含机构调整
 * 
 */
public class AccountCodeChangeExecutor extends BookKeepExecutor {

	public int run() throws Exception {
		List<BusinessObject> details=documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail);
		this.updateLedgerAccount(details);
		transaction.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail, details);
		// 更新分户账
		updateLedgerAccount(details);
		return 1;
	}
}