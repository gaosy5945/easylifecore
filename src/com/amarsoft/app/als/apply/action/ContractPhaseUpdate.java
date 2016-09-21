package com.amarsoft.app.als.apply.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.sys.function.model.FunctionBizlet;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ContractPhaseUpdate extends FunctionBizlet{

	/**
	 * 修改合同的阶段类型【code:ContractPhase】
	 */
	public boolean run(JBOTransaction tx, BusinessObject functionParameterPool)
			throws Exception {
		String serialNo = functionParameterPool.getString("SerialNo");
		String flag5 = functionParameterPool.getString("PhaseType");
		
		BizObjectManager bm = JBOFactory.getBizObjectManager(CreditConst.BC_JBOCLASS);
		tx.join(bm);
		BizObject bo = bm.createQuery("SerialNo=:SerialNo")
				.setParameter("SerialNo", serialNo).getSingleResult(true);
		bo.setAttributeValue("Flag5", flag5);
		bm.saveObject(bo);
		return true;
	}
}
