package com.amarsoft.app.oci.ws.decision.prepare;

import static com.amarsoft.app.oci.ws.decision.prepare.CommandTool.getMaxOverTimeCounts;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.four.OverdueRecord;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.three.RepayInfoParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;

public class CmdtillNowMaxOvdPeri implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		int tempCount = 0;
		CreditDetail detail = message.getCreditDetail();
		if(detail == null) return 0;
		List<Loan> loanList = detail.getLoan();
		List<Loancard> loanCardList = detail.getLoancard();
		List<StandardLoancard> sLoancardList = detail.getStandardLoancard();
		for (Loan loan : loanList) {
			tempCount = runLoan(loan);
			if (tempCount > count) count = tempCount;//	取最大值
		}
		for (Loancard loancard : loanCardList) {
			tempCount = runLoanCard(loancard);
			if (tempCount > count) count = tempCount;//	取最大值
		}
		for (StandardLoancard standardLoancard : sLoancardList) {
			tempCount = runSLoanCard(standardLoancard);
			if (tempCount > count) count = tempCount;//	取最大值
		}
		return count;
	}

	private int runSLoanCard(StandardLoancard standardLoancard)
			throws Exception {
		int count = 0;
		int temp = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//对于呆帐\止付\冻结\核销，直接记录为7。
		if (standardLoancard.getState().startsWith(Classification.BADDEBT_LOANCARD) || standardLoancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || standardLoancard.getState().startsWith(Classification.FROZEN_LOANCARD)) { 
			count = 7;
			return count;
		}
		//对于未激活帐户，逾期期数为0。
		if (standardLoancard.getState().startsWith(Classification.NOTACTIVATED_LOANCARD)) { 
			count = 0;
			return count;
		}
		//对于已销户\转出，计算销户日期往前推24个月是否存在“逾期月份”，取最大一期的逾期持续月数。
		if (standardLoancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) count = getStandardLoancardCount(standardLoancard, count);
		//正常，取最近24个月内最大的逾期。
		if (standardLoancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
			paymentState = standardLoancard.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(24, paymentState);
		}
		return count;
	}

	private int getStandardLoancardCount(StandardLoancard standardLoancard,int count) {
		int temp;
		Latest5YearOverdueRecordParent late5year;
		late5year = standardLoancard.getLatest5YearOverdueRecord();
		if (late5year != null) {
			RepayInfoParent repayInfoParent = standardLoancard.getRepayInfo();
			String stateEndDate = repayInfoParent.getStateEndDate();
			int stateEndMonth = Integer.parseInt(stateEndDate.substring(0, 4) + stateEndDate.substring(5, 7));
			List<OverdueRecord> oRList = late5year.getOverdueRecord();
			for (OverdueRecord overdueRecord : oRList) {
				String month = overdueRecord.getMonth();
				int lMonth = Integer.parseInt(month.substring(0, 4) + month.substring(5, 7));
				if ((stateEndMonth - 200) < lMonth && stateEndMonth > lMonth) {
					temp = Integer.parseInt(overdueRecord.getLastMonths());
					if (temp > count) count = temp;
				}
			}
		}
		return count;
	}

	private int runLoanCard(Loancard loancard) throws Exception {
		int count = 0;
		int temp = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//对于呆帐\止付\冻结\核销，直接记录为7。
		if (loancard.getState().startsWith(Classification.BADDEBT_LOANCARD) || loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.FROZEN_LOANCARD)) { 
			count = 7;
			return count;
		}
		//对于未激活帐户，逾期期数为0。
		if (loancard.getState().startsWith(Classification.NOTACTIVATED_LOANCARD)) {
			count = 0;
			return count;
		}
		//对于已销户\转出，计算销户日期往前推24个月是否存在“逾期月份”，取最大一期的逾期持续月数。
		if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) count = getLoanCardStateCount(loancard, count);
		//正常，取最近24个月内最大的逾期。
		if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
			paymentState = loancard.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(24, paymentState);
		}
		return count;
	}

	private int getLoanCardStateCount(Loancard loancard, int count) {
		int temp;
		Latest5YearOverdueRecordParent late5year;
		late5year = loancard.getLatest5YearOverdueRecord();
		if (late5year != null) {
			RepayInfoParent repayInfoParent = loancard.getRepayInfo();
			String stateEndDate = repayInfoParent.getStateEndDate();
			int stateEndMonth = Integer.parseInt(stateEndDate.substring(0, 4) + stateEndDate.substring(5, 7));
			List<OverdueRecord> oRList = late5year.getOverdueRecord();
			for (OverdueRecord overdueRecord : oRList) {
				String month = overdueRecord.getMonth();
				int lMonth = Integer.parseInt(month.substring(0, 4) + month.substring(5, 7));
				if ((stateEndMonth - 200) < lMonth && stateEndMonth > lMonth) {
					temp = Integer.parseInt(overdueRecord.getLastMonths());
					if (temp > count) count = temp;
				}
		    }
		}
		return count;
	}

	private int runLoan(Loan loan) throws Exception {
		int count = 0;
		int temp = 0;
		PaymentStateParent paymentState;
		Latest5YearOverdueRecordParent late5year;
		//对于呆账贷款，直接记录为7。
		if (loan.getState().startsWith(Classification.BADDEBT_LOAN)) {
			count = 7;
			return count;
		}
		//对于未结清贷款，可以取到24个月还款状态里最大的逾期期数。
		if (loan.getState().startsWith(Classification.NORMAL_LOAN) || loan.getState().startsWith(Classification.OVERDUE_LOAN)) {
			paymentState = loan.getLatest24MonthPaymentState();
			count = getMaxOverTimeCounts(24, paymentState);
		}
		//对于转出贷款，通过转出日期计算转出日往前推24个月是否存在“逾期月份”，取最大一期的逾期持续月数。
		if (loan.getState().startsWith(Classification.ROLLOUT_LOAN)) count = getLoanStateCount(loan, count);
		//对于结清类，通过结清日期计算结清日期往前推24个月是否存在“逾期月份”，取最大一期的逾期持续月数。
		if (loan.getState().startsWith(Classification.SETTLE_LOAN)) count = getLoanStateCount(loan, count);
		return count;
	}

	private int getLoanStateCount(Loan loan, int count) {
		int temp;
		Latest5YearOverdueRecordParent late5year;
		late5year = loan.getLatest5YearOverdueRecord();
		if (late5year != null) {
			CurrAccountInfo currAccountInfo = loan.getCurrAccountInfo();
			String stateEndDate = currAccountInfo.getStateEndDate();
			int stateEndMonth = Integer.parseInt(stateEndDate.substring(0, 4) + stateEndDate.substring(5, 7));
			List<OverdueRecord> oRList = late5year.getOverdueRecord();
			for (OverdueRecord overdueRecord : oRList) {
				String month = overdueRecord.getMonth();
				int lMonth = Integer.parseInt(month.substring(0, 4) + month.substring(5, 7));
				if ((stateEndMonth - 200) < lMonth && stateEndMonth > lMonth) {
					temp = Integer.parseInt(overdueRecord.getLastMonths());
					if (temp > count) count = temp;
				}
			}			
		}
		return count;
	}
}
