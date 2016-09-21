package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 根据起始日和期限计算到期日
 * @author rant
 *
 */

public class CalcMaturity  {
	private String loanTermFlag=null;
	private String loanTerm=null;
	private String putOutDate=null;
	public String getLoanTermFlag() {
		return loanTermFlag;
	}

	public void setLoanTermFlag(String loanTermFlag) {
		this.loanTermFlag = loanTermFlag;
	}

	public String getLoanTerm() {
		return loanTerm;
	}

	public void setLoanTerm(String loanTerm) {
		this.loanTerm = loanTerm;
	}

	public String getPutOutDate() {
		return putOutDate;
	}

	public void setPutOutDate(String putOutDate) {
		this.putOutDate = putOutDate;
	}

	public Object calcMaturity(JBOTransaction tx) throws Exception {
		//期限标志
		String sLoanTermFlag =  this.loanTermFlag;
		//贷款期限
		String sLoanTerm = this.loanTerm;
		//业务起始日
		String sPutOutDate = this.putOutDate;
		
		//将空值转化为空字符串
		if(sLoanTermFlag == null) sLoanTermFlag = "";
		if(sLoanTerm == null) sLoanTerm = "";
		if(sPutOutDate == null) sPutOutDate = "";
		
		//定义变量
		int iLoanTerm = Integer.parseInt(sLoanTerm);
		String sMaturity = DateHelper.getRelativeDate(sPutOutDate, sLoanTermFlag, iLoanTerm);
		if(sMaturity == null) sMaturity = "";
		
		return sMaturity;
	}


}
