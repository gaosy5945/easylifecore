package com.amarsoft.app.accounting.trans.script.loan.duedaychange;

import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 默认还款日变更创建
 */
public class DefaultDueDayChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	 
	}

}