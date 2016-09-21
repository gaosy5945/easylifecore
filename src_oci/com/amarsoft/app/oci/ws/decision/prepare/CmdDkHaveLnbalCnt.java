package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.two.Loan;

/**
 * ���˴����������ʻ�����
 * 
 * @author t-lizp
 * 
 */
public class CmdDkHaveLnbalCnt implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loan> list = detail.getLoan();
		for (Loan loan : list) {
			String state = loan.getState();
//            1��δ���壺�жϱ�����
//			2�����˵ģ��������ΪxxԪ��
//			3��ת�������壺���������� 
//			4������
			if (state.startsWith(Classification.NORMAL_LOAN) || state.startsWith(Classification.OVERDUE_LOAN) || state.startsWith(Classification.BADDEBT_LOAN)) count = getCount(count, loan);
		}
		return count;
	}

	private int getCount(int count, Loan loan) {
		CurrAccountInfo currAccountInfo = loan.getCurrAccountInfo();
		Double balance = Double.parseDouble(currAccountInfo.getBalance());
		if (balance > 0.0) count = count + 1;
		return count;
	}
}