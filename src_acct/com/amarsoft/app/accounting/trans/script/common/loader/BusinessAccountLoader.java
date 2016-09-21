package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 加载借据的账户信息
 * 
 */
public final class BusinessAccountLoader extends TransactionProcedure{
	@Override
	public int run() throws Exception {
		String mainBizClassName=TransactionConfig.getScriptConfig(transactionCode, scriptID, "MainBizClassName");
		String condition=TransactionConfig.getScriptConfig(transactionCode, scriptID, "Condition");
		if(!StringX.isEmpty(condition) && !condition.trim().toLowerCase().startsWith("and ")) condition="and "+condition;
		condition = "ObjectType=:ObjectType and ObjectNo=:ObjectNo "+condition+" ";
		BusinessObject mainObject=null;
		if(StringX.isEmpty(mainBizClassName))
			mainObject=this.relativeObject;
		else
			mainObject=transaction.getBusinessObject(mainBizClassName);
		List<BusinessObject> interestLogs = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account, condition, "ObjectType",mainObject.getBizClassName(),"ObjectNo",mainObject.getKeyString());
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account,interestLogs);
		return 1;
	}
}
