package com.amarsoft.app.accounting.trans.script.loan.subject;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
/**
 * 科目调整
 * */
public class SubjectChangeExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		
		List<BusinessObject> subsidiaryLedgers = relativeObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger);
		
		for(BusinessObject subsidiaryLedger:subsidiaryLedgers)
		{
			
		}
		
		
		return 1;
	}
	
}
