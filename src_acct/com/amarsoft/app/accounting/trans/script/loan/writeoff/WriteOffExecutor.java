package com.amarsoft.app.accounting.trans.script.loan.writeoff;

import com.amarsoft.app.base.trans.TransactionProcedure;


/**
 * 贷款核销/售出执行
 */
public class WriteOffExecutor extends TransactionProcedure{

	public int run() throws Exception { 
		String oldStauts = relativeObject.getString("BusinessStatus");
		if(!oldStauts.equals("0")){
			throw new Exception("贷款状态不是正常状态，请检查!");
		}
		if(transactionCode.equals("3006")){
			relativeObject.setAttributeValue("BusinessStatus", "1");
			bomanager.updateBusinessObject(relativeObject);
			return 1;
		}else if(transactionCode.equals("3007")){
			relativeObject.setAttributeValue("BusinessStatus", "2");
			bomanager.updateBusinessObject(relativeObject);
			return 1;
		}else{
			throw new Exception("交易【"+transactionCode+"】未定义!");
		}
	}
}