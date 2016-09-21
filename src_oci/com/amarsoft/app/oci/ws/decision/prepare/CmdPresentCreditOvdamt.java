package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrOverdueParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;


/**
 * 申请人当前信用卡拖欠金额(只包含贷记卡)
 * 
 * @author t-lizp
 * 
 */
public class CmdPresentCreditOvdamt implements Command {

	@Override
	public Object execute(IReportMessage message) {
		Double amount = 0.0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> list = detail.getLoancard();
		for (Loancard loancard : list) {
			CurrOverdueParent currOverdueParent = loancard.getCurrOverdue();
			if (currOverdueParent == null) continue;
			String amount1 = currOverdueParent.getCurrOverdueAmount();
			if (amount1 == null || amount1 == "") amount1 = "0";
			Double currOverdueAmount = Double.parseDouble(amount1);
			amount = amount + currOverdueAmount;//累计所有记录的“逾期金额”
		}
		return amount;
	}
}