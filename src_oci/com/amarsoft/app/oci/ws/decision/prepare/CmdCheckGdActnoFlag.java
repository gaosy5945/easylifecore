package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.InfoSummary;
import com.amarsoft.app.crqs2.i.bean.three.CreditSummaryCue;

/**
 * 申请人是否有个贷账户记录
 * 
 * @author t-liuyc
 * 
 */
public class CmdCheckGdActnoFlag implements Command {

	@Override
	public Object execute(IReportMessage message) {
		InfoSummary summary =  message.getInfoSummary();
		if (summary == null) return 0;
	    CreditSummaryCue csc = summary.getCreditCue().getCreditSummaryCue();	    	
	    int otherC = Integer.parseInt(csc.getOtherLoanCount());
	    int businessHouseC = Integer.parseInt(csc.getPerBusinessHouseLoanCount());
	    int houseC = Integer.parseInt(csc.getPerHouseLoanCount());	    	    
	    if (houseC + otherC + businessHouseC>0) 
	    	return 1;
		return 0;
	}
}
