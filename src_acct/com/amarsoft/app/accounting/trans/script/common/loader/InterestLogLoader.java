package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 加载已结息的利息日志。针对冲销交易时可能需要。
 * 
 * @author xyqu 2014年8月1日
 * 
 */
public final class InterestLogLoader extends TransactionProcedure {
	@Override
	public int run() throws Exception {
		String condition=TransactionConfig.getScriptConfig(transactionCode, scriptID, "Condition");
		condition = "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo "+condition+" ";
		
		String mainBizClassName=TransactionConfig.getScriptConfig(transactionCode, scriptID, "MainBizClassName");
		BusinessObject mainObject=null;
		if(StringX.isEmpty(mainBizClassName))
			mainObject=this.relativeObject;
		else
			mainObject=transaction.getBusinessObject(mainBizClassName);
		List<BusinessObject> interestLogs = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.interest_log, condition, "RelativeObjectType",mainObject.getBizClassName(),"RelativeObjectNo",mainObject.getKeyString());
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.interest_log,interestLogs);
		return 1;
	}
}
