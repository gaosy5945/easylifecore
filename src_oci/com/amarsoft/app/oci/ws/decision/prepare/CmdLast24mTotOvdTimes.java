package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getLoanList;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getOverTimeCounts;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;

/**
 * �����˹�ȥ24���´����ۼ����ڴ���
 * 
 * @author t-liuyc
 * 
 */
public class CmdLast24mTotOvdTimes implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		int tempCount = 0;
		List<Loan> loanList = getLoanList(message);
		if (loanList == null) return 0;
		for (Loan loan : loanList) {
			tempCount = getLoanOverTimes(loan);
			//ȡ���ֵ
			if (tempCount > count) count = tempCount;
		}
		return count;
	}

	// ���ÿ�ʴ��� ��ȡ���ڴ���
	private int getLoanOverTimes(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//���ʸ�ֵ4
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { 
			count = 4;
			return count;
		}
		//δ������ȡ�����24���»����¼�������24���µĻ����¼����ͳ�����ڳ��ִ���֮�ͣ�
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			count = getOverTimeCounts(24, paymentState);
		}
		//�ѽ����ת�����ȡ�����5�����ڼ�¼����ͨ���������·ݡ��ҳ������2���ڵ����ڼ�¼����ͳ�����ڴ�������֮�͡�
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getOverTimeCounts(24, late5year);
		}
		return count;
	}
}
