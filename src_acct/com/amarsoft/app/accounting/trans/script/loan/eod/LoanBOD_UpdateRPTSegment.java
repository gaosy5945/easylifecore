package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.pmt.PMTScript;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * 贷款日初处理，还款方式及其相关信息更新
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class LoanBOD_UpdateRPTSegment extends TransactionProcedure{

	/**
	 * 进行数据处理
	 */
	public int run() throws Exception {
		
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "psType");
		
		BusinessObject loan = this.relativeObject;
		String businessDate = loan.getString("BusinessDate");
		//到了下次还款日,更新还款信息，如RPT中的还款日期、剩余金额、期供等
		List<BusinessObject> rptList = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment,"Status='1' and NextDueDate=:BusinessDate and PSType like :PSType","BusinessDate",businessDate,"PSType",psType);
		for (BusinessObject rptSegment : rptList) {
			
			
			// 没有赋值的，都不重算，否则会将移植过来的期供值覆盖掉，造成提前还款保持期供时可能会发生变化。
			PMTScript pmtScript = PMTScript.getPMTScript(loan, rptSegment, psType,this.bomanager);
			pmtScript.nextInstalment();//进入下一个还款期次，并更新下次还款日及其他属性
		}

		return 1;
	}
}
