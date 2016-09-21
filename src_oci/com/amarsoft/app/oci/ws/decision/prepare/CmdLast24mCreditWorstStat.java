package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;
import com.amarsoft.app.oci.ws.decision.prepare.CommandTool;

/**
 * 申请人征信报告上过去24个月内信用卡的最差还款状态(含贷记卡和准贷记卡)
 * 
 * @author t-lizp
 * 
 */
public class CmdLast24mCreditWorstStat implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int inputNumber = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> List = detail.getLoancard();
		inputNumber = getLoancardNumber(inputNumber, List);
		List<StandardLoancard> List2 = detail.getStandardLoancard();
		inputNumber = getStandardLoancardNumber(inputNumber, List2);
		return inputNumber;
	}

	private int getStandardLoancardNumber(int inputNumber,
			List<StandardLoancard> List2) throws Exception {
		for (StandardLoancard standardLoancard : List2) {
			int number = 0;
			//呆帐\止付\冻结\核销，赋值4
			if (standardLoancard.getState().startsWith(Classification.FROZEN_LOANCARD) || standardLoancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || standardLoancard.getState().startsWith(Classification.BADDEBT_LOANCARD)) 
				number = 4;
			//正常状态：取“最近24个月还款记录”里最近24个月的还款记录，并取逾期最大值；
			if (standardLoancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				PaymentStateParent Latest24MonthPaymentState = standardLoancard.getLatest24MonthPaymentState();
				number = CommandTool.getMaxOverTimeCounts(24,Latest24MonthPaymentState);
			}
			//销户\转出状态：取“最近5年逾期透支记录”里通过“逾期透支月份”找出在最近24个月内的逾期记录，并统计逾期期数最大值。
			if (standardLoancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) {
				Latest5YearOverdueRecordParent latest5YearOverdueRecordParent = standardLoancard.getLatest5YearOverdueRecord();
				if (latest5YearOverdueRecordParent == null) continue;
				number = CommandTool.getMaxOverTimeCounts(24,latest5YearOverdueRecordParent);
			}
			//各笔取最大值
			if (inputNumber < number)
				inputNumber = number;
		}
		return inputNumber;
	}

	private int getLoancardNumber(int inputNumber, List<Loancard> List)
			throws Exception {
		for (Loancard loancard : List) {
			int number = 0;
			//呆帐\止付\冻结\核销，赋值4
			if (loancard.getState().startsWith(Classification.FROZEN_LOANCARD) || loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.BADDEBT_LOANCARD)) 
				number = 4;
			////正常状态：取“最近24个月还款记录”里最近24个月的还款记录，并取逾期最大值；
			if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				PaymentStateParent Latest24MonthPaymentState = loancard.getLatest24MonthPaymentState();
				number = CommandTool.getMaxOverTimeCounts(24,Latest24MonthPaymentState);
			}
			////销户\转出状态：取“最近5年逾期透支记录”里通过“逾期透支月份”找出在最近24个月内的逾期记录，并统计逾期期数最大值。
			if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) {
				Latest5YearOverdueRecordParent latest5YearOverdueRecordParent = loancard.getLatest5YearOverdueRecord();
				if (latest5YearOverdueRecordParent == null) continue;
				number = CommandTool.getMaxOverTimeCounts(24,latest5YearOverdueRecordParent);
			}
			////各笔取最大值
			if (inputNumber < number) inputNumber = number;
		}
		return inputNumber;
	}
}
