package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.List;

import com.amarsoft.app.accounting.interest.rate.reprice.RepriceMethod;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;

/**
 * ����ţ����½����Ϣ
 * 
 * @author xyqu 2014��8��1��
 * 
 */
public final class DrawdownScript_InitRepriceDate  extends TransactionProcedure{

	public int run() throws Exception {
		List<BusinessObject> rateList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rate_segment,"Status=:Status", "Status","1");
		for (BusinessObject a : rateList) {
			if(StringX.isEmpty(a.getString("RepriceType"))) continue;
			String nextRepriceDate = RepriceMethod.getRepriceMethod(a.getString("RepriceType")).getNextRepriceDate(relativeObject,a);// �´����ʵ�����
			a.setAttributeValue("NextRepriceDate", nextRepriceDate);
			bomanager.updateBusinessObject(a);
		}
		return 1;
	}
}
