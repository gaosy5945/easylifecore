package com.amarsoft.app.accounting.trans.script.loan.autopayflagchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 执行自动还款变更交易逻辑
 * 
 */
// TODO:需考虑还款计划中的自动还款标识是否需更新。还款计划除本息外，还有费用。需考虑如何实现本息和费用的分别自动扣款处理
public final class AutoPayFlagChangeExecutor extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		String autoPayFlag = this.documentObject.getString("AutoPayFlag");// 是否自动扣款
		List<BusinessObject> pslist = this.relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "(FinishDate is null or FinishDate ='')");
		for(BusinessObject ps:pslist){
			ps.setAttributeValue("AutoPayFlag", autoPayFlag);
			bomanager.updateBusinessObject(ps);
		}
		return 1;
	}

}