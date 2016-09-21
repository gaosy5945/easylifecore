package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getLoanList;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getMaxOverTimeCounts;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;

public class Cmdlast12mMaxOvdPeri implements Command {

	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		int tempCount = 0;
		List<Loan> loanList = getLoanList(message);
		if (loanList == null) return 0;
		for (Loan loan : loanList) {
			tempCount = getLoanOverTimes(loan);
			if (tempCount > count) count = tempCount;//���ʴ���ȡ���ֵ
		}
		return count;
	}

	// ���ÿ�ʴ��� ��ȡ������ڴ���
	private int getLoanOverTimes(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//���ʸ�ֵ4
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { 
			count = 4;
			return count;
		}
		//δ������ȡ�����24���»����¼�������12���µĻ����¼����ȡ�������������
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(12, paymentState);
		}
		//�ѽ����ת�����ȡ�����5�����ڼ�¼����ͨ���������·ݡ��ҳ������12�����ڵ����ڼ�¼����ȡ�������������
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getMaxOverTimeCounts(12, late5year);
		}
		return count;
	}
}
