package com.amarsoft.app.accounting.trans.script.loan.termchange;


import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 期限变更创建
 */
public class TermChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("OLDMaturityDate", relativeObject.getString("MaturityDate"));//原到期日设置
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}