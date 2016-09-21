package com.amarsoft.app.accounting.trans.script.loan.writeoff;


import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 贷款核销/售出创建
 */
public class WriteOffCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}