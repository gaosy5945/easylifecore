package com.amarsoft.app.check.apply;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class InitBaseRateType {
    private String loanType;
    
	public String getLoanType() {
		return loanType;
	}
	public void setLoanType(String loanType) {
		this.loanType = loanType;
	}
    
	/**
	 * 通过六位核心码查询罚息基准利率类型
	 * 张万亮
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String initylylzl(Transaction Sqlca) throws Exception{
		String ylylzl = Sqlca.getString(new SqlObject("select YLYLZL from PRD_PDKLX where Daiklx = :Daiklx").setParameter("Daiklx", loanType));
	    if(ylylzl == null) ylylzl = "210";
		return ylylzl;
	}
}
