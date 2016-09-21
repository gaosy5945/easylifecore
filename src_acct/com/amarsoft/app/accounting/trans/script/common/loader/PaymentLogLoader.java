package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 加载还款明细信息
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class PaymentLogLoader extends TransactionProcedure {
	@Override
	public int run() throws Exception {
		String condition=TransactionConfig.getScriptConfig(transactionCode, scriptID, "Condition");
		if(!StringX.isEmpty(condition) && !condition.trim().toLowerCase().startsWith("and ")) condition="and "+condition;
		condition = "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo "+condition+" order by paydate";
		String mainBizClassName=TransactionConfig.getScriptConfig(transactionCode, scriptID, "MainBizClassName");
		BusinessObject mainObject=null;
		if(StringX.isEmpty(mainBizClassName))
			mainObject=this.relativeObject;
		else
			mainObject=transaction.getBusinessObject(mainBizClassName);
		List<BusinessObject> paymentLogs = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_log, condition, "RelativeObjectType",mainObject.getBizClassName(),"RelativeObjectNo",mainObject.getKeyString());
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_log,paymentLogs);
		return 1;
	}
}
