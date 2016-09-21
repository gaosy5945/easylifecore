package com.amarsoft.app.accounting.trans.script.loan.rptchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 还款方式变更创建
 */
public class RPTChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");
		List<BusinessObject> oldRptList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
				"ObjectType=:ObjectType and ObjectNo=:ObjectNo and PSType like :PSType and Status=:Status ",
				"ObjectType",relativeObject.getBizClassName(),"ObjectNo",relativeObject.getKeyString(),"PSType",psType+"%","Status","1");
		for(BusinessObject rpt:oldRptList)
		{
			BusinessObject newRpt = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment);
			newRpt.setAttributes(rpt);
			newRpt.generateKey(true);
			newRpt.setAttributeValue("ObjectType", documentObject.getBizClassName());
			newRpt.setAttributeValue("ObjectNo", documentObject.getKeyString());
			newRpt.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(newRpt);
			
			documentObject.setAttributeValue("OLDRPTTermID", newRpt.getString("TermID"));
			documentObject.setAttributeValue("RPTTermID", newRpt.getString("TermID"));
		}

		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}