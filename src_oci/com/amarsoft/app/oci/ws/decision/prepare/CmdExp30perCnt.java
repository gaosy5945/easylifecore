package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.AwardCreditInfoParent;
import com.amarsoft.app.crqs2.i.bean.three.RepayInfoParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;


/**
 * 信用额度使用率Exposure为30%的信用卡个数(只包含贷记卡)
 * 
 * @author t-lizp
 * 
 */
public class CmdExp30perCnt implements Command {

	@Override
	public Object execute(IReportMessage message) {
		int count = 0;
		CreditDetail detail = message.getCreditDetail();
		if(detail == null) return 0;
		List<Loancard> list = detail.getLoancard();
		for (Loancard loancard : list) {
			Double creditLimitAmount = getLimitAmout(loancard);//授信额度
			Double usedCreditLimitAmount = getUsedAmount(loancard);//已用额度
			if (creditLimitAmount > 0) {
				double ratio = usedCreditLimitAmount / creditLimitAmount;
				if (ratio > 0.3) count = count + 1;
			}
		}
		return count;
	}

	private Double getUsedAmount(Loancard loancard) {
		RepayInfoParent repayInfoParent = loancard.getRepayInfo();
		String amount2 = repayInfoParent.getUsedCreditLimitAmount();
		if (amount2 == null || amount2 == "") amount2 = "0";
		Double usedCreditLimitAmount = Double.parseDouble(amount2);
		return usedCreditLimitAmount;
	}

	private Double getLimitAmout(Loancard loancard) {
		AwardCreditInfoParent awardCreditInfoParent = loancard.getAwardCreditInfo();
		String amount = awardCreditInfoParent.getCreditLimitAmount();
		if (amount == null || amount == "") amount = "0";
		Double creditLimitAmount = Double.parseDouble(amount);
		return creditLimitAmount;
	}

}
