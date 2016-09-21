package com.amarsoft.app.accounting.trans.script.common.creator;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 创建反冲交易
 * 
 */
public final class ReverseTransactionCreator extends TransactionProcedure {

	@Override
	public int run() throws Exception {

		String documentType = transaction.getString("DocumentType");
		String documentNo = transaction.getString("DocumentNo");
		BusinessObject oldTransaction = transaction.getBusinessObjectByKey(documentType, documentNo);

		transaction.setAttributeValue("RelativeObjectType", oldTransaction.getString("RelativeObjectType"));
		transaction.setAttributeValue("RelativeObjectNo", oldTransaction.getString("RelativeObjectNo"));
		this.bomanager.updateBusinessObject(transaction);
		return 1;
	}

}
