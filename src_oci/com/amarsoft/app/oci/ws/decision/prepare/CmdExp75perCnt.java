package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.AwardCreditInfoParent;
import com.amarsoft.app.crqs2.i.bean.three.RepayInfoParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;

/**
 * 信用额度使用率Exposure为75%的信用卡个数(含贷记卡和准贷记卡)
 * 
 * @author t-lizp
 * 
 */
public class CmdExp75perCnt implements Command {

	@Override
	public Object execute(IReportMessage message) {
		int count = 0;
		CreditDetail detail = message.getCreditDetail();
		if(detail == null) return 0;
		List<Loancard> list = detail.getLoancard();
		List<StandardLoancard> list2 = detail.getStandardLoancard();
		count = getLoancardCount(count, list);//贷记卡个数
		count = getStandardLoancardCount(count, list2);//准贷记卡个数
		return count;
	}

	private int getStandardLoancardCount(int count, List<StandardLoancard> list2) {
		for (StandardLoancard sloancard : list2) {
			AwardCreditInfoParent awardCreditInfoParent = sloancard.getAwardCreditInfo();
			String amount3 = awardCreditInfoParent.getCreditLimitAmount();//准贷记卡授信额度
			if (amount3 == null || amount3 == "") amount3 = "0";
			Double creditLimitAmount = Double.parseDouble(amount3);
			RepayInfoParent repayInfoParent = sloancard.getRepayInfo();
			count = getCount(count, creditLimitAmount, repayInfoParent);
		}
		return count;
	}

	private int getLoancardCount(int count, List<Loancard> list) {
		for (Loancard loancard : list) {
			AwardCreditInfoParent awardCreditInfoParent = loancard.getAwardCreditInfo();
			String amount = awardCreditInfoParent.getCreditLimitAmount();//贷记卡授信额度
			if (amount == null || amount == "") amount = "0";
			Double creditLimitAmount = Double.parseDouble(amount);
			RepayInfoParent repayInfoParent = loancard.getRepayInfo();
			count = getCount(count, creditLimitAmount, repayInfoParent);
		}
		return count;
	}
	
	private int getCount(int count, Double creditLimitAmount,
			RepayInfoParent repayInfoParent) {
		String amount4 = repayInfoParent.getUsedCreditLimitAmount();//已用额度
		if (amount4 == null || amount4 == "") amount4 = "0";
		Double usedCreditLimitAmount = Double.parseDouble(amount4);
		if (creditLimitAmount > 0) {
			double ratio = usedCreditLimitAmount / creditLimitAmount;
			if (ratio >= 0.75) count = count + 1;
		}
		return count;
	}



}
