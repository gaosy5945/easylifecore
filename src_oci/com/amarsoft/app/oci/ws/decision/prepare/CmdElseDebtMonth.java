package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.List;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.four.FellbackSum;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.one.InfoSummary;
import com.amarsoft.app.crqs2.i.bean.three.CurrAccountInfo;
import com.amarsoft.app.crqs2.i.bean.three.FellbackSummary;
import com.amarsoft.app.crqs2.i.bean.two.Loan;
import com.amarsoft.app.crqs2.i.bean.two.OverdueAndFellback;

/**
 * 申请人其他债务月偿付额
 * 
 * @author t-lizp
 * 
 */
public class CmdElseDebtMonth implements Command {

	@Override
	public Object execute(IReportMessage message) {
		Double amount = 0.0;
				
		CreditDetail detail = message.getCreditDetail();
		if(detail!=null){ 	
			List<Loan> list = detail.getLoan();
			amount = getNormalAmount(amount, list);
		}
		
		return amount;
	}
	
	private Double getNormalAmount(Double amount, List<Loan> list) {
		for (Loan loan : list) {
			String amount1;
			CurrAccountInfo currAccountInfo = loan.getCurrAccountInfo();
			if(loan.getState().startsWith(Classification.BADDEBT_LOAN)){ //状态为呆账计算其余额
				amount1 = currAccountInfo.getBalance();
			}
			else{ //其他计算其月还款额(正常，逾期)
				amount1 = currAccountInfo.getScheduledPaymentAmount();
			}		
			if (amount1 == null || amount1 == "") amount1 = "0";
			Double scheduledPaymentAmount = Double.parseDouble(amount1);
			amount = amount + scheduledPaymentAmount;
		}
		return amount;
	}

}
