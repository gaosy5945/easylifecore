package com.amarsoft.app.accounting.trans.script.loan.duedaychange;

import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * Ĭ�ϻ����ձ������
 */
public class DefaultDueDayChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	 
	}

}