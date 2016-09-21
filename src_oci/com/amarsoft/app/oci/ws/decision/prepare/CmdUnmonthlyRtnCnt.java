package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.ContractInfo;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * ���ű�����ʾ�������������л���Ƶ��Ϊ�ǰ��»����δ�������
 * 
 * @author t-lizp
 * 
 */
public class CmdUnmonthlyRtnCnt implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loan> List = detail.getLoan();
		for (Loan loan : List) {
			String state = loan.getState();
			if (state.startsWith(Classification.SETTLE_LOAN)) continue;
			ContractInfo contractInfo = loan.getContractInfo();
			CurrAccountInfo currAccountInfo = loan.getCurrAccountInfo();
			String amount = currAccountInfo.getBalance();
			if (amount == null || amount == "") amount = "-2";
			Double balance = Double.parseDouble(amount);
			String getPaymentRating = contractInfo.getPaymentRating();
			//�����ڡ����¹黹���ҡ���������0�ı���֮��
			if (!getPaymentRating.startsWith(Classification.MONTHPAYMENT_RATING) && balance > 0.0) count = count + 1;
		}
		return count;
	}
}