package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;

/**
 * �������Ƿ������ÿ��˻���¼
 * 
 * @author t-liuyc
 * 
 */
public class CmdCheckCreditActnoFlag implements Command {

	@Override
	public Object execute(IReportMessage message) {
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loancard> loancard = detail.getLoancard();//���ǿ�
		List<StandardLoancard> standardLoancard = detail.getStandardLoancard();//׼���ǿ�
		//������ʾ�еĴ��ǿ�������׼���ǿ�����<>0
		if (loancard.size() + standardLoancard.size() > 0)
			return 1;
		return 0;
	}

}
