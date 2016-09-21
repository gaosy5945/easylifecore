package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;

/**
 * 申请人是否有信用卡账户记录
 * 
 * @author t-liuyc
 * 
 */
public class CmdCheckCreditActnoFlag implements Command {

	@Override
	public Object execute(IReportMessage message) {
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> loancard = detail.getLoancard();//贷记卡
		List<StandardLoancard> standardLoancard = detail.getStandardLoancard();//准贷记卡
		//信用提示中的贷记卡笔数＋准贷记卡笔数<>0
		if (loancard.size() + standardLoancard.size() > 0)
			return 1;
		return 0;
	}

}
