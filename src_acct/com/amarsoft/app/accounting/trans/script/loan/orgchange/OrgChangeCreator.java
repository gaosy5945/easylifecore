package com.amarsoft.app.accounting.trans.script.loan.orgchange;

import com.amarsoft.app.base.trans.TransactionProcedure;

public class OrgChangeCreator  extends TransactionProcedure{
	@Override
	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		documentObject.setAttributeValue("OldAccountingOrgID", relativeObject.getString("AccountingOrgID"));
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}
}
