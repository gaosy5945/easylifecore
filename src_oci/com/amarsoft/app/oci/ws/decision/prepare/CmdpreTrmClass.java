package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.three.CurrOverdueParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * �����˵�ǰ����״̬
 * 
 * @author t-liuyc
 * 
 */
public class CmdpreTrmClass implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return 0;
		List<Loan> loanList = detail.getLoan();
		for (Loan loan : loanList) {
//			�ж��Ƿ��С����˻����ڡ��������ֱ�Ӽ�1��
			if (loan.getState().startsWith(Classification.OVERDUE_LOAN) ||
					loan.getState().startsWith(Classification.BADDEBT_LOAN)) return 1;
			CurrAccountInfo curinfo = loan.getCurrAccountInfo();
			if (curinfo.getStateEndMonth() != null) continue;
//			�ж��Ƿ��С��弶���ࡱ������������У���1��
			String classify = curinfo.getClass5State(); 
			if(classify!=null){
	 			if (classify.startsWith(Classification.NORMAL_CLASS_5STATE_ATTENSTION) ||
	 					classify.startsWith(Classification.NORMAL_CLASS_5STATE_LOS) ||
	 					classify.startsWith(Classification.NORMAL_CLASS_5STATE_SEC) ||
	 					classify.startsWith(Classification.NORMAL_CLASS_5STATE_SUS) ) 
					return 1;
			}
			CurrOverdueParent curDue = loan.getCurrOverdue();
			if(curDue!=null){
	//			�ж��Ƿ��С���ǰ������������0������У���1
				if (!"0".equals(curDue.getCurrOverdueAmount())) return 1;
	//			�ж��Ƿ��С���ǰ���ڽ���0������У���1
				if (!"0".equals(curDue.getCurrOverdueCyc())) return 1;
			}
		}
		return 0;//	��������0
	}
}
