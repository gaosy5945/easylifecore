package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * �����ճ��������ʽ���������Ϣ����
 * 
 * @author Amarsoft�����Ŷ�
 * 
 */
public final class LoanBOD_UpdateRPTSegment extends TransactionProcedure{

	/**
	 * �������ݴ���
	 */
	public int run() throws Exception {
		
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "psType");
		
		BusinessObject loan = this.relativeObject;
		String businessDate = loan.getString("BusinessDate");
		//�����´λ�����,���»�����Ϣ����RPT�еĻ������ڡ�ʣ����ڹ���
		List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,"Status='1' and NextDueDate=:BusinessDate and PSType like :PSType","BusinessDate",businessDate,"PSType",psType);
		for (BusinessObject rptSegment : rptList) {
			
			
			// û�и�ֵ�ģ��������㣬����Ὣ��ֲ�������ڹ�ֵ���ǵ��������ǰ������ڹ�ʱ���ܻᷢ���仯��
			PMTScript pmtScript = PMTScript.getPMTScript(loan, rptSegment, psType,this.bomanager);
			pmtScript.nextInstalment();//������һ�������ڴΣ��������´λ����ռ���������
		}

		return 1;
	}
}
