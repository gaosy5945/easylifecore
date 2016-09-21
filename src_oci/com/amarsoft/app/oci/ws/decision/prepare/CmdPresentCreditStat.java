package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrOverdueParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;


/**
 * 申请人当前信用卡状态(只包含贷记卡)
 * 
 * @author t-lizp
 * 
 */
public class CmdPresentCreditStat implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int inputNumber = 0;
		int number = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> List = detail.getLoancard();
		for (Loancard loancard : List) {
			number = getNumberStateNot1(number, loancard);
			if (loancard.getState().startsWith(Classification.NORMAL_LOANCARD)) {
				CurrOverdueParent currOverdueParent = loancard.getCurrOverdue();
				if (currOverdueParent == null) continue;
				String amount = currOverdueParent.getCurrOverdueAmount();
				if (amount == null || amount == "") amount = "0";
				Double currOverdueAmount = Double.parseDouble(amount);
//				账户状态=正常，且“当前逾期总额”=0，录入0
				if (currOverdueAmount == 0.0) number = 0;
//				账户状态=正常，且“当前逾期总额”＞0，录入2
				if (currOverdueAmount > 0) number = 2;
			}
			if (inputNumber < number) inputNumber = number;//	有多张贷记卡的，最终选择最大的数字填入
		}
		return inputNumber;
	}

	private int getNumberStateNot1(int number, Loancard loancard) {
//		账户状态=未激活，录入0
		if (loancard.getState().startsWith(Classification.NOTACTIVATED_LOANCARD)) number = 0;
//		账户状态=销户，录入1
		if (loancard.getState().startsWith(Classification.CANCELLATION_LOANCARD)) number = 1;
//		账户状态=止付,冻结,呆账,核销，录入3
		if (loancard.getState().startsWith(Classification.STOPPAYMENT_LOANCARD) || loancard.getState().startsWith(Classification.FROZEN_LOANCARD) || loancard.getState().startsWith(Classification.BADDEBT_LOANCARD)) {
			number = 3;
		}
		return number;
	}
}
