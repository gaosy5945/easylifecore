package com.amarsoft.app.accounting.trans.script.loan.balancechange;

import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

public class PrincipalInterestChangeCreator  extends TransactionProcedure{
	@Override
	public int run() throws Exception {
		documentObject.setAttributeValue("RelativeObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("RelativeObjectNo", relativeObject.getKeyString());
		documentObject.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTANTS.payment_schedule);
		documentObject.setAttributeValue("Currency", relativeObject.getString("Currency"));
		documentObject.setAttributeValue("TransSerialNo", transaction.getKeyString());
		documentObject.setAttributeValue("PayDate", transaction.getString("TransDate"));
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}
}
