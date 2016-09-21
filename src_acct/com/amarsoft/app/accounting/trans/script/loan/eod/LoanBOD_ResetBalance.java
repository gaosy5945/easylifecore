package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;


/**
 * 贷款日初处理入口
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class LoanBOD_ResetBalance extends TransactionProcedure{


	public int run() throws Exception {
		BusinessObject loan = transaction.getBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		String businessDate = loan.getString("BusinessDate");// 贷款处理时间

		//将发生额归零
		List<BusinessObject> subledgers = loan.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger);
		for (BusinessObject subledger : subledgers) {
			subledger.setAttributeValue("DEBITAMTDAY", 0d);
			subledger.setAttributeValue("CREDITAMTDAY", 0d);
			if (businessDate.endsWith("/01")) {
				subledger.setAttributeValue("DEBITAMTMONTH", 0d);
				subledger.setAttributeValue("CREDITAMTMONTH", 0d);
			}
			if (businessDate.endsWith("/01/01")) {
				subledger.setAttributeValue("DEBITAMTYEAR", 0d);
				subledger.setAttributeValue("CREDITAMTYEAR", 0d);
			}
			this.bomanager.updateBusinessObject(subledger);
		}
		return 1;
	}

}