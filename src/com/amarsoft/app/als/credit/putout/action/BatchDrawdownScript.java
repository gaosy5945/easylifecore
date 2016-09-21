package com.amarsoft.app.als.credit.putout.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

public class BatchDrawdownScript extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		BusinessObject bbo = transaction.getBusinessObject("jbo.app.BAT_BUSINESS");
		List<BusinessObject> bps = bomanager.loadBusinessObjects("jbo.app.BUSINESS_PUTOUT", "BatchSerialNo=:BatchSerialNo", "BatchSerialNo",bbo.getKeyString());
		for(BusinessObject bp:bps)
		{
			SendLoanInfo sli = new SendLoanInfo();
			sli.setPutoutNo(bp.getKeyString());
			sli.setUserID(transaction.getString("InputUserID"));
			sli.setOrgID(transaction.getString("InputOrgID"));
			sli.Determine(bomanager.getTx());
		}
		return 1;
	}

}
