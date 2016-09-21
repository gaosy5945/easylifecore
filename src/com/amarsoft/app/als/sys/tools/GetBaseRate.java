package com.amarsoft.app.als.sys.tools;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * @author t-shenj
 *
 */
public class GetBaseRate {
	private int loanTerm; // µÇÂ¼ÓÃ»§
	
	public int getLoanTerm() {
		return loanTerm;
	}

	public void setLoanTerm(String loanTerm) {
		this.loanTerm = Integer.valueOf(loanTerm);
	}

	public String getBaseRate(JBOTransaction tx) throws Exception{
		double baserate = 0d;
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.app.PUB_RATE_INFO",tx)
				.createQuery("SELECT RATEVALUE "+
						 " FROM O "+
						 " WHERE "+
						 " term = (case "+
						       "  when :loanTerm > 0 and :loanTerm <= 6 then "+
						       "   6 "+
						       "  when :loanTerm > 6 and :loanTerm <= 12 then "+
						       "   12 "+
						       "  when :loanTerm > 12 and :loanTerm <= 60 then "+
						       "   60 "+
						       "  when :loanTerm > 60 and :loanTerm <= 360 then "+
						       "   360 "+
						       "  else "+
						       "   1188 "+
						       " end) "+
						   " AND EFFECTDATE = (SELECT MAX(EFFECTDATE) FROM PUB_RATE_INFO)")
						   .setParameter("loanTerm", loanTerm);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		
		if(bos!=null && bos.size()>0){
			baserate = Double.parseDouble(bos.get(0).getAttribute("RATEVALUE").toString());
		}
		return String.valueOf(baserate);
	}
}
