package com.amarsoft.app.accounting.trans.script.loan.accountchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 存款账号信息变更执行脚本
 * 
 * @author Amarsoft团队
 * 
 */
public class BusinessAccountChangeExecutor extends TransactionProcedure {

	public int run() throws Exception {
		String accountIndicator=TransactionConfig.getScriptConfig(transactionCode, scriptID, "AccountIndicator");
		List<BusinessObject> oldAccountList = this.relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.business_account,
				"Status='1' and AccountIndicator in(:AccountIndicator)","AccountIndicator",accountIndicator.split(","));
		for (BusinessObject oldAccount : oldAccountList) {
			oldAccount.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(oldAccount);
		}
		//更新贷款账号信息
		List<BusinessObject> newAccountList = documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account);
		for (BusinessObject newAccount : newAccountList) {// 将变更记录账户设置为已执行，增加贷款对应账户信息
			BusinessObject newBo = BusinessObject.createBusinessObject(newAccount.getBizClassName());
			newBo.setAttributes(newAccount);
			newBo.generateKey(true);
			newBo.setAttributeValue("ObjectType", relativeObject.getBizClassName());
			newBo.setAttributeValue("ObjectNo", relativeObject.getKeyString());
			newBo.setAttributeValue("Status", "1");
			bomanager.updateBusinessObject(newBo);
		}
		
		return 1;
	}
}