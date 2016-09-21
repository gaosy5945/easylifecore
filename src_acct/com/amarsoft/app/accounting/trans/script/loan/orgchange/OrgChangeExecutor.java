package com.amarsoft.app.accounting.trans.script.loan.orgchange;

import com.amarsoft.app.base.trans.TransactionProcedure;
/**
 * Ö´ÐÐ»ú¹¹ 
 * */
public class OrgChangeExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		String oldOrgId = relativeObject.getString("AccountingOrgID");
		String newOrgId = documentObject.getString("AccountingOrgID");
		relativeObject.setAttributeValue("OldAccountingOrgID", oldOrgId);
		relativeObject.setAttributeValue("AccountingOrgID", newOrgId);
		bomanager.updateBusinessObject(relativeObject);
		return 1;
	}
	
}
