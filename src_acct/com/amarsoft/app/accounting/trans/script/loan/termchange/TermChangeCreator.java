package com.amarsoft.app.accounting.trans.script.loan.termchange;


import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * ���ޱ������
 */
public class TermChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("OLDMaturityDate", relativeObject.getString("MaturityDate"));//ԭ����������
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}