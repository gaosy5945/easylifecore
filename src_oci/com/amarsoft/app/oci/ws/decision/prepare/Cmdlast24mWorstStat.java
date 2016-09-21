package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getLoanList;
import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getMaxOverTimeCounts;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * 申请人征信报告上过去24个月内贷款的最差还款状态
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
			//各笔贷款取最大值
			if (tempCount > count) count = tempCount;
		}
		return count;
	}

	private int getWorstStat(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//呆帐赋值4
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { // 呆账赋值4
			count = 4;
			return count;
		}
		//未结清贷款：取“最近24个月还款记录”里最近24个月的还款记录，并取最大逾期期数；
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(24, paymentState);
		}
		//已结清或转出贷款：取“最近5年逾期记录”里通过“逾期月份”找出在最近24个月内的逾期记录，并取最大逾期期数；
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getMaxOverTimeCounts(24, late5year);
		}
		return count;
	}
}
