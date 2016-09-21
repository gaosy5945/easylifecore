package com.amarsoft.app.accounting.util;

import java.util.List;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

/**
 * 针对Loan对象进行操作的公用方法集合
 */
public final class LoanHelper {
	

	/**
	 * 获取主对象关联对应对象执行账务余额
	 * @param subledgers
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(List<BusinessObject> subledgers,Object... parameters) throws Exception {
		BusinessObject subledger = BusinessObjectHelper.getBusinessObjectByAttributes(subledgers,parameters);
		if(subledger == null)  return 0.0d;
		else
		{
			return AccountCodeConfig.getSubledgerBalance(subledger, AccountCodeConfig.Balance_DateFlag_CurrentDay);
		}
	}
	
	/**
	 * 通过对象类型、对象编号、客户账科目好获取贷款账户余额
	 * @param relativeObjectType
	 * @param relativeObjectNo
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(String relativeObjectType,String relativeObjectNo,String accountCodeNo) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> subledgers = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.subsidiary_ledger, "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and Status=:Status", "RelativeObjectType",relativeObjectType,"RelativeObjectNo",relativeObjectNo,"Status","1");
		return getSubledgerBalance(subledgers,"AccountCodeNo",accountCodeNo);
	}
}