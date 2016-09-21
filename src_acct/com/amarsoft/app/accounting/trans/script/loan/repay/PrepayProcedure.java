package com.amarsoft.app.accounting.trans.script.loan.repay;


import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.accounting.trans.script.loan.repay.prepay.PrepayScript;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

/**
 * 提前还款，根据不同的提前还款方式和金额类型，产生对应的提前还款计划和对应的还款日志记录，并更新未来还款计划。
 */
public class PrepayProcedure extends TransactionProcedure {
	
	public int run() throws Exception {
		documentObject.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
		String psType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "PSType");

		String[] keys = CashFlowConfig.getPrepayScriptConfigKeys();
		int cnt=0;
		BusinessObject prepayScript=null;
		for(String key:keys)
		{
			BusinessObject prepayScriptTmp = CashFlowConfig.getPrepayScriptConfig(key);
			String filter=prepayScriptTmp.getString("Filter");
			if(!StringX.isEmpty(filter) && this.documentObject.matchSql(filter, null))
			{
				cnt++;
				prepayScript = prepayScriptTmp;
			}
		}
		
		if(prepayScript == null || cnt==0) throw new ALSException("EC3015");
		else if(cnt > 1) throw new ALSException("EC3016");
		
		String className = prepayScript.getString("Script");
		if(StringX.isEmpty(className)) throw new ALSException("EC3017",prepayScript.getString("id"));
			
		Class c = Class.forName(className);
		PrepayScript ps = (PrepayScript)c.newInstance();
		ps.setPsType(psType);
		ps.setBomanager(bomanager);
		ps.setTransaction(transaction);
		int j = ps.run();
		if( j != 1) return j;
		
		if(StringX.isEmpty(documentObject.getString("PrepayAmt"))) 
			documentObject.setAttributeValue("PrepayAmt", Arith.round(documentObject.getDouble("PrepayPrincipalAmt")+documentObject.getDouble("PrepayInterestAmt"),CashFlowHelper.getMoneyPrecision(relativeObject)));
		documentObject.setAttributeValue("PayAmt", Arith.round(documentObject.getDouble("PrepayPrincipalAmt")+documentObject.getDouble("PrepayInterestAmt"),CashFlowHelper.getMoneyPrecision(relativeObject)));
		documentObject.setAttributeValue("ActualPayAmt", Arith.round(documentObject.getDouble("PrepayPrincipalAmt")+documentObject.getDouble("PrepayInterestAmt"),CashFlowHelper.getMoneyPrecision(relativeObject)));
		bomanager.updateBusinessObject(documentObject);	
		return 1;
	}

}