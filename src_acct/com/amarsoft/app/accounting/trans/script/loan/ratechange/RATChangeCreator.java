package com.amarsoft.app.accounting.trans.script.loan.ratechange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 利率变更创建
 */
public class RATChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		List<BusinessObject> oldRateList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, 
				"ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status and (SegToDate=null or SegToDate='' or SegToDate >:BusinessDate)",
				"ObjectType",relativeObject.getBizClassName(),"ObjectNo",relativeObject.getKeyString(),"Status","1","BusinessDate",relativeObject.getString("BusinessDate"));
		for(BusinessObject rate:oldRateList)
		{
			BusinessObject newRate = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
			newRate.setAttributes(rate);
			newRate.generateKey(true);
			newRate.setAttributeValue("ObjectType", documentObject.getBizClassName());
			newRate.setAttributeValue("ObjectNo", documentObject.getKeyString());
			newRate.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(newRate);
			
			if("01".equals(rate.getString("RateType")))
			{
				documentObject.setAttributeValue("OLDLoanRateTermID", newRate.getString("TermID"));
				documentObject.setAttributeValue("LoanRateTermID", newRate.getString("TermID"));
			}
		}

		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		return 1;
	}

}