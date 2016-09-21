package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionHelper;

/**
 * 反冲交易加载
 * 
 */
public final class ReverseTransactionLoader extends BookKeepExecutor {

	@Override
	public int run() throws Exception {
		BusinessObject oldTransaction = this.documentObject;
		TransactionHelper.loadTransaction(oldTransaction, bomanager);
		// 原交易分录
		List<BusinessObject> oldDetailList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.subledger_detail,
				" TransSerialNo=:TransSerialNo ", "TransSerialNo",oldTransaction.getString("SerialNo"));
		oldTransaction.setAttributeValue(BUSINESSOBJECT_CONSTANTS.subledger_detail,oldDetailList);
		return 1;
	}
}
