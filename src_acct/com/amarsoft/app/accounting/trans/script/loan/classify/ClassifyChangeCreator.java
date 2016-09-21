package com.amarsoft.app.accounting.trans.script.loan.classify;

import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 风险分类变更创建
 */
public class ClassifyChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		documentObject.setAttributeValue("LoanClassifyResult", relativeObject.getString("ClassifyResult"));
		documentObject.setAttributeValue("ClassifyMonth", DateHelper.getBusinessDate().substring(0, 7));
		documentObject.setAttributeValue("ClassifyDate", DateHelper.getBusinessDate());
		documentObject.setAttributeValue("LoanClassifyResult", relativeObject.getString("ClassifyResult"));
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}