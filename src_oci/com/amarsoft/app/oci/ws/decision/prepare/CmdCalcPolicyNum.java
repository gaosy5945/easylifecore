package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.ContractInfo;
import com.amarsoft.app.crqs2.i.bean.two.Loan;



/**
 * �����������ۼ�ס������
 * @author t-lizp
 *
 */
public class CmdCalcPolicyNum implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		count = getCount(message, count);
		return count;
	}

	private int getCount(IReportMessage message, int count) {
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return count;
		List<Loan> list = detail.getLoan();
		for (Loan loan : list) {
			loan.getAnnounceInfo();
			ContractInfo contractinfo = loan.getContractInfo();
			//����ȫ��������ʾ����ϸ����֡�ס������ı����ϼ�������ֻͳ�ƴ�������Ϊ��11������ס������Ĵ��
			if (contractinfo.getType().startsWith(Classification.IND_HOUSE_LOAN)) count = count + 1;
		}
		return count;
	}
}