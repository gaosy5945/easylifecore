package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.three.CurrOverdueParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;


/**
 * 申请人当前贷款状态
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
//			判断是否有“呆账或逾期”，如果有直接计1；
			if (loan.getState().startsWith(Classification.OVERDUE_LOAN) ||
					loan.getState().startsWith(Classification.BADDEBT_LOAN)) return 1;
			CurrAccountInfo curinfo = loan.getCurrAccountInfo();
			if (curinfo.getStateEndMonth() != null) continue;
//			判断是否有“五级分类”≠正常，如果有，计1；
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
	//			判断是否有“当前逾期期数”≠0，如果有，计1
				if (!"0".equals(curDue.getCurrOverdueAmount())) return 1;
	//			判断是否有“当前逾期金额”≠0，如果有，计1
				if (!"0".equals(curDue.getCurrOverdueCyc())) return 1;
			}
		}
		return 0;//	其他，计0
	}
}
