package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrOverdueParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;


/**
 * �����˵�ǰ���ÿ�״̬(ֻ�������ǿ�)
 * 
 * @author t-lizp
 * 
 */
public class CmdPresentCreditStat implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int inputNumber = 0;
		int number = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> List = detail.getLoancard();
		for (Loancard loancard : List) {
			number = getNumberStateNot1(number, loancard);
			if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				CurrOverdueParent currOverdueParent = loancard.getCurrOverdue();
				if (currOverdueParent == null) continue;
				String amount = currOverdueParent.getCurrOverdueAmount();
				if (amount == null || amount == "") amount = "0";
				Double currOverdueAmount = Double.parseDouble(amount);
//				�˻�״̬=�������ҡ���ǰ�����ܶ=0��¼��0
				if (currOverdueAmount == 0.0) number = 0;
//				�˻�״̬=�������ҡ���ǰ�����ܶ��0��¼��2
				if (currOverdueAmount > 0) number = 2;
			}
			if (inputNumber < number) inputNumber = number;//	�ж��Ŵ��ǿ��ģ�����ѡ��������������
		}
		return inputNumber;
	}

	private int getNumberStateNot1(int number, Loancard loancard) {
//		�˻�״̬=δ���¼��0
		if (loancard.getState().startsWith(Classification.NOTACTIVATED_LOANCARD)) number = 0;
//		�˻�״̬=������¼��1
		if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) number = 1;
//		�˻�״̬=ֹ��,����,����,������¼��3
		if (loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.FROZEN_LOANCARD) || loancard.getState().startsWith(Classification.BADDEBT_LOANCARD)) {
			number = 3;
		}
		return number;
	}
}
