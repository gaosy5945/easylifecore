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
 * 申请人征信报告上贷款累计逾期次数取最大值包括各种非正常状态的记录
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
			if (tempCount > count) count = tempCount;//各笔贷款取最大值
		}
		return count;
	}

	private int getWorstStat(Loan loan) throws Exception {
		int count = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//	呆帐赋值16
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) { 
			count = 16;
			return count;
		}
		//未结清贷款：取“最近24个月还款记录”里统计逾期出现次数之和加上“最近5年逾期记录”（实际为前36个月）里逾期月份的出现次数。
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			String paymentBeginMonth = paymentState.getBeginMonth();
			count = getOverTimeCounts(24, paymentState);			
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) 
				count = getOverTimeAheadCount(36,paymentBeginMonth,late5year)+count; //前36个月的逾期次数
		}
		//已结清或转出贷款：取“最近5年逾期记录”里通过“逾期月份”找出在全部的逾期记录，并统计逾期次数出现之和。
		if (loan.getState().startsWith(Classification.SETTLE_LOAN) || loan.getState().startsWith(Classification.ROLLOUT_LOAN)) {
			late5year = loan.getLatest5YearOverdueRecord();
			if (late5year != null) count = getOverTimeCounts(60, late5year);
		}
		return count;
	}
}
