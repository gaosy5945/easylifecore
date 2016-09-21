package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.Date;

import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

/**
 * ������Ϣ���£���Ҫ��������״̬���������ڵȵĸ���
 * 
 */
public final class UpdateTransactionExecutor extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		//�������ڣ�Ϊ��ʱĬ��Ϊ��ǰ�������
		String transDate = transaction.getString("TransDate");
		if (StringX.isEmpty(transDate)){
			transaction.setAttributeValue("TransDate", DateHelper.getBusinessDate());
		}

		//��������
		transaction.setAttributeValue("OccurDate", DateHelper.getBusinessDate());
		transaction.setAttributeValue("OccurTime", DateX.format(new Date(), DateHelper.AMR_NOMAL_FULLTIME_FORMAT));

		//�жϽ���״̬��Ϊ0���������
		transaction.setAttributeValue("TransStatus", TransactionConfig.TRANSACTION_STATUS_1);
		bomanager.updateBusinessObject(transaction);
		return 1;
	}

}
