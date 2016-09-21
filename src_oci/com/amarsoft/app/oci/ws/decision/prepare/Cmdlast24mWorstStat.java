package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getLoanList;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getMaxOverTimeCounts;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * ���������ű����Ϲ�ȥ24�����ڴ��������״̬
 * 
 * @author t-liuyc
 * 
 */
public class Cmdlast24mWorstStat implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		int tempCount = 0;
		List<Loan> loanList = getLoanList(message);
		if (loanList == null) return 0;
		for (Loan loan : loanList) {
			tempCount = getWorstStat(loan);
			//���ʴ���ȡ���ֵ
			if (tempCount > count) count = tempCount;
		}
		return count;
	}

	private int getWorstStat(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//���ʸ�ֵ4
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { // ���˸�ֵ4
			count = 4;
			return count;
		}
		//δ������ȡ�����24���»����¼�������24���µĻ����¼����ȡ�������������
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(24, paymentState);
		}
		//�ѽ����ת�����ȡ�����5�����ڼ�¼����ͨ���������·ݡ��ҳ������24�����ڵ����ڼ�¼����ȡ�������������
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getMaxOverTimeCounts(24, late5year);
		}
		return count;
	}
}
