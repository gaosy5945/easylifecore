package com.amarsoft.app.accounting.trans.script.loan.autopayflagchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * ִ���Զ������������߼�
 * 
 */
// TODO:�迼�ǻ���ƻ��е��Զ������ʶ�Ƿ�����¡�����ƻ�����Ϣ�⣬���з��á��迼�����ʵ�ֱ�Ϣ�ͷ��õķֱ��Զ��ۿ��
public final class AutoPayFlagChangeExecutor extends TransactionProcedure {

	@Override
	public int run() throws Exception {
		String autoPayFlag = this.documentObject.getString("AutoPayFlag");// �Ƿ��Զ��ۿ�
		List<BusinessObject> pslist = this.relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.payment_schedule, "(FinishDate is null or FinishDate ='')");
		for(BusinessObject ps:pslist){
			ps.setAttributeValue("AutoPayFlag", autoPayFlag);
			bomanager.updateBusinessObject(ps);
		}
		return 1;
	}

}