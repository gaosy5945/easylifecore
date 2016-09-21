package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.oci.ws.decision.prepare.CommandTool;


/**
 * ���������ű����Ϲ�ȥ12�������ÿ�δ����ͻ����Ĵ���(ֻ�������ǿ�)
 * 
 * @author t-lizp
 * 
 */
public class CmdLast12mCreditLowestCnt implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int inputNumber = 0;
		int number = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> List = detail.getLoancard();
		for (Loancard loancard : List) {
			//����\ֹ��\����\��������ֵ16
			if (loancard.getState().startsWith(Classification.BADDEBT_LOANCARD) || loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.FROZEN_LOANCARD)) 
				number = 16;
			//����״̬��ȡ�����24���»����¼�������12���µĻ����¼����ͳ�����ڳ��ִ���֮�ͣ�
			if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				PaymentStateParent Latest24MonthPaymentState = loancard.getLatest24MonthPaymentState();
				number = CommandTool.getOverTimeCounts(12,Latest24MonthPaymentState);
			}
			//����\ת��״̬��ȡ�����5�����ڼ�¼����ͨ���������·ݡ��ҳ������12�����ڵ����ڼ�¼����ͳ�����ڳ��ִ���֮�͡�
			if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) {
				Latest5YearOverdueRecordParent latest5YearOverdueRecordParent = loancard.getLatest5YearOverdueRecord();
				if (latest5YearOverdueRecordParent == null) continue;
				number = CommandTool.getOverTimeCounts(12,latest5YearOverdueRecordParent);
			}
			//����ȡ���ֵ
			if (inputNumber < number) inputNumber = number;
		}
		return inputNumber;
	}
}
