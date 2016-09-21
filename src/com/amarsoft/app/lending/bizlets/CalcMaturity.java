package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ������ʼ�պ����޼��㵽����
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
		//���ޱ�־
		String sLoanTermFlag =  this.loanTermFlag;
		//��������
		String sLoanTerm = this.loanTerm;
		//ҵ����ʼ��
		String sPutOutDate = this.putOutDate;
		
		//����ֵת��Ϊ���ַ���
		if(sLoanTermFlag == null) sLoanTermFlag = "";
		if(sLoanTerm == null) sLoanTerm = "";
		if(sPutOutDate == null) sPutOutDate = "";
		
		//�������
		int iLoanTerm = Integer.parseInt(sLoanTerm);
		String sMaturity = DateHelper.getRelativeDate(sPutOutDate, sLoanTermFlag, iLoanTerm);
		if(sMaturity == null) sMaturity = "";
		
		return sMaturity;
	}


}
