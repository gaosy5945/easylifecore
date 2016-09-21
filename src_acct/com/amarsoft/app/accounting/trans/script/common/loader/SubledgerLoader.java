package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 关联分户信息加载，主要加载未销户的分户信息
 * 
 * @author xyqu 2014年7月30日
 * 
 */
public final class SubledgerLoader  extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		String mainBizClassName=TransactionConfig.getScriptConfig(transactionCode, scriptID, "MainBizClassName");
		String condition=TransactionConfig.getScriptConfig(transactionCode, scriptID, "Condition");
		if(!StringX.isEmpty(condition) && !condition.trim().toLowerCase().startsWith("and ")) condition="and "+condition;
		condition = "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo "+condition+" ";
		BusinessObject mainObject=null;
		if(StringX.isEmpty(mainBizClassName))
			mainObject=this.relativeObject;
		else
			mainObject=transaction.getBusinessObject(mainBizClassName);
		List<BusinessObject> subledgers = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, condition, "RelativeObjectType",mainObject.getBizClassName(),"RelativeObjectNo",mainObject.getKeyString());
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger,subledgers);
		return 1;
	}
}
