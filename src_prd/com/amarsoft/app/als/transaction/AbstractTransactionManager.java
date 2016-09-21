package com.amarsoft.app.als.transaction;

import java.util.List;

import com.amarsoft.app.als.businessobject.action.BusinessObjectCopier;
import com.amarsoft.app.als.businessobject.action.BusinessObjectCreator;
import com.amarsoft.app.als.businessobject.action.BusinessObjectDeleter;
import com.amarsoft.app.als.businessobject.action.BusinessObjectLoader;
import com.amarsoft.app.als.businessobject.action.BusinessObjectSaver;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectKey;

/**
 * 基础交易类
 *
 */
public abstract class AbstractTransactionManager implements
		BusinessObjectLoader, BusinessObjectDeleter, BusinessObjectSaver,
		BusinessObjectCopier, BusinessObjectCreator {

	public abstract BusinessObject getTransactionConfig(
			BusinessObject transaction) throws Exception;

	public final int executeScript(BusinessObject transaction,
			String scriptType, BusinessObjectManager bomanager)
			throws Exception {
		BusinessObject transactionConfig = getTransactionConfig(transaction);

		List<BusinessObject> scriptList = TransactionConfig
				.getTransactionConfig(
						transactionConfig.getString("TransactionCode"))
				.getBusinessObjectsByAttributes(
						TransactionConfig.JBO_NAME_PROCEDURE_CONFIG, "Type",
						scriptType);
		if (scriptList == null || scriptList.isEmpty())
			// String desc ="交易{" +
			// transactionDefinition.getString("TransactionCode") +
			// "}未定义类型为{"+scriptType+"}的逻辑单元!";
			// throw
			// ALSException.newException(ACCOUNT_CONSTANTS.SYS_FUNCTION_MODULE,
			// "TRANS0001", "", desc);
			return 1;
		for (BusinessObject script : scriptList) {
			String scriptID = script.getString("ID");
			String scriptClass = script.getString("CLASS");
			if (scriptClass != null && !"".equals(scriptClass)) {
				Class<?> c = Class.forName(scriptClass);
				TransactionProcedure transactionScript = (TransactionProcedure) c
						.newInstance();
				transactionScript.setTransaction(transaction);
				transactionScript.create(transaction, script, bomanager).run();
				/*
				 * transactionScript.create(
				 * transactionConfig.getString("TransactionCode"), script,
				 * bomanager).run();
				 */

			} else {
				String desc = "交易{"
						+ transactionConfig.getString("TransactionCode")
						+ "}的执行脚本{" + scriptID + "}未定义属性{class}!";
				throw new Exception(desc);
			}
		}
		return 1;
	}

	@Override
	public abstract BusinessObject create(BizObjectClass bizObjectClass,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception;

	@Override
	public abstract List<BusinessObject> copy(
			List<BusinessObject> businessObjectList,
			BusinessObject systemParameters, BusinessObjectManager bomanager)
			throws Exception;

	@Override
	public abstract int save(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception;

	public abstract int delete(BizObjectKey[] objectKeyArray,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception;

	public abstract List<BusinessObject> load(BizObjectKey[] bizObjectKeyArray,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception;
}