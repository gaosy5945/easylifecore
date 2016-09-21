package com.amarsoft.app.accounting.trans.script.loan.termchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 还款方式变更执行
 */
public class TermChangeExecutor extends TransactionProcedure{

	public int run() throws Exception {
		relativeObject.setAttributeValue("MaturityDate", documentObject.getString("MaturityDate"));
		//设置重新生成期供和还款计划
		List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1' ");
		for(BusinessObject rptSegment:rptList)
		{
			rptSegment.setAttributeValue("PSRestructureFlag", "2");
		}
		bomanager.updateBusinessObject(relativeObject);
		return 1;
	}

}