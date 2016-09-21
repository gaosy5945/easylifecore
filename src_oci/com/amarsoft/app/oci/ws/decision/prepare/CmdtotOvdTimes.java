package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getLoanList;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getOverTimeCounts;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getOverTimeAheadCount;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * ���������ű����ϴ����ۼ����ڴ���ȡ���ֵ�������ַ�����״̬�ļ�¼
 * 
 * @author t-liuyc
 * 
 */
public class CmdtotOvdTimes implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		int tempCount = 0;
		List<Loan> loanList = getLoanList(message);
		if (loanList == null) return 0;
		for (Loan loan : loanList) {
			tempCount = getWorstStat(loan);
			if (tempCount > count) count = tempCount;//���ʴ���ȡ���ֵ
		}
		return count;
	}

	private int getWorstStat(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//	���ʸ�ֵ16
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { 
			count = 16;
			return count;
		}
		//δ������ȡ�����24���»����¼����ͳ�����ڳ��ִ���֮�ͼ��ϡ����5�����ڼ�¼����ʵ��Ϊǰ36���£��������·ݵĳ��ִ�����
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			String paymentBeginMonth = paymentState.getBeginMonth();
			count = getOverTimeCounts(24, paymentState);			
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) 
				count = getOverTimeAheadCount(36,paymentBeginMonth,late5year)+count; //ǰ36���µ����ڴ���
		}
		//�ѽ����ת�����ȡ�����5�����ڼ�¼����ͨ���������·ݡ��ҳ���ȫ�������ڼ�¼����ͳ�����ڴ�������֮�͡�
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getOverTimeCounts(60, late5year);
		}
		return count;
	}
}
