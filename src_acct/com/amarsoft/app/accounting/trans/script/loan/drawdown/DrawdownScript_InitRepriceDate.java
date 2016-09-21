package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.List;

import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * 贷款发放，更新借据信息
 * 
 * @author xyqu 2014年8月1日
 * 
 */
public final class DrawdownScript_InitRepriceDate  extends TransactionProcedure{

	public int run() throws Exception {
		List<BusinessObject> rateList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,"Status=:Status", "Status","1");
		for (BusinessObject a : rateList) {
			if(StringX.isEmpty(a.getString("RepriceType"))) continue;
			String nextRepriceDate = RepriceMethod.getRepriceMethod(a.getString("RepriceType")).getNextRepriceDate(relativeObject,a);// 下次利率调整日
			a.setAttributeValue("NextRepriceDate", nextRepriceDate);
			bomanager.updateBusinessObject(a);
		}
		return 1;
	}
}
