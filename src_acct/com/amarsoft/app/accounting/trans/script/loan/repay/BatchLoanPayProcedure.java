package com.amarsoft.app.accounting.trans.script.loan.repay;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

public class BatchLoanPayProcedure extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		List<BusinessObject> transactions = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.transaction, "ParentTransSerialNo=:ParentTransSerialNo", "ParentTransSerialNo",transaction.getKeyString());
		for(BusinessObject transaction:transactions)
		{
			transaction = TransactionHelper.loadTransaction(transaction, bomanager);
			TransactionHelper.executeTransaction(transaction, bomanager);
		}
		return 1;
	}

}
