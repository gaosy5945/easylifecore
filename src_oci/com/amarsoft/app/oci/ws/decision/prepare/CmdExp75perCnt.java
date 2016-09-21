package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.AwardCreditInfoParent;
import com.amarsoft.app.crqs2.i.bean.three.RepayInfoParent;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;

/**
 * ���ö��ʹ����ExposureΪ75%�����ÿ�����(�����ǿ���׼���ǿ�)
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
		count = getLoancardCount(count, list);//���ǿ�����
		count = getStandardLoancardCount(count, list2);//׼���ǿ�����
		return count;
	}

	private int getStandardLoancardCount(int count, List<StandardLoancard> list2) {
		for (StandardLoancard sloancard : list2) {
			AwardCreditInfoParent awardCreditInfoParent = sloancard.getAwardCreditInfo();
			String amount3 = awardCreditInfoParent.getCreditLimitAmount();//׼���ǿ����Ŷ��
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
			String amount = awardCreditInfoParent.getCreditLimitAmount();//���ǿ����Ŷ��
			if (amount == null || amount == "") amount = "0";
			Double creditLimitAmount = Double.parseDouble(amount);
			RepayInfoParent repayInfoParent = loancard.getRepayInfo();
			count = getCount(count, creditLimitAmount, repayInfoParent);
		}
		return count;
	}
	
	private int getCount(int count, Double creditLimitAmount,
			RepayInfoParent repayInfoParent) {
		String amount4 = repayInfoParent.getUsedCreditLimitAmount();//���ö��
		if (amount4 == null || amount4 == "") amount4 = "0";
		Double usedCreditLimitAmount = Double.parseDouble(amount4);
		if (creditLimitAmount > 0) {
			double ratio = usedCreditLimitAmount / creditLimitAmount;
			if (ratio >= 0.75) count = count + 1;
		}
		return count;
	}



}
