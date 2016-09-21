package com.amarsoft.app.accounting.trans.script.loan.subject;

import com.amarsoft.app.base.trans.TransactionProcedure;

public class SubjectChangeCreator  extends TransactionProcedure{
	@Override
	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}
}
