package com.amarsoft.app.accounting.trans.script.loan.classify;


import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 风险分类变更执行
 */
public class ClassifyChangeExecutor extends TransactionProcedure{

	public int run() throws Exception {
		
		relativeObject.setAttributeValue("ClassifyResult", documentObject.getString("ClassifyResult"));
		bomanager.updateBusinessObject(relativeObject);
		return 1;
	}

}