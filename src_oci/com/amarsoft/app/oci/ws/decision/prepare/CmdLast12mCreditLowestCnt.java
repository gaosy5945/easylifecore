package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.oci.ws.decision.prepare.CommandTool;


/**
 * 申请人征信报告上过去12个月信用卡未还最低还款额的次数(只包含贷记卡)
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
			//呆帐\止付\冻结\核销，赋值16
			if (loancard.getState().startsWith(Classification.BADDEBT_LOANCARD) || loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.FROZEN_LOANCARD)) 
				number = 16;
			//正常状态：取“最近24个月还款记录”里最近12个月的还款记录，并统计逾期出现次数之和；
			if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				PaymentStateParent Latest24MonthPaymentState = loancard.getLatest24MonthPaymentState();
				number = CommandTool.getOverTimeCounts(12,Latest24MonthPaymentState);
			}
			//销户\转出状态：取“最近5年逾期记录”里通过“逾期月份”找出在最近12个月内的逾期记录，并统计逾期出现次数之和。
			if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) {
				Latest5YearOverdueRecordParent latest5YearOverdueRecordParent = loancard.getLatest5YearOverdueRecord();
				if (latest5YearOverdueRecordParent == null) continue;
				number = CommandTool.getOverTimeCounts(12,latest5YearOverdueRecordParent);
			}
			//各笔取最大值
			if (inputNumber < number) inputNumber = number;
		}
		return inputNumber;
	}
}
