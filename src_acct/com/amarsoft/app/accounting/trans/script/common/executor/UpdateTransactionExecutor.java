package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.Date;

import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

/**
 * 交易信息更新，主要包括交易状态、交易日期等的更新
 * 
 */
public final class UpdateTransactionExecutor extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		//交易日期，为空时默认为当前会计日期
		String transDate = transaction.getString("TransDate");
		if (StringX.isEmpty(transDate)){
			transaction.setAttributeValue("TransDate", DateHelper.getBusinessDate());
		}

		//操作日期
		transaction.setAttributeValue("OccurDate", DateHelper.getBusinessDate());
		transaction.setAttributeValue("OccurTime", DateX.format(new Date(), DateHelper.AMR_NOMAL_FULLTIME_FORMAT));

		//判断交易状态，为0才允许记账
		transaction.setAttributeValue("TransStatus", TransactionConfig.TRANSACTION_STATUS_1);
		bomanager.updateBusinessObject(transaction);
		return 1;
	}

}
