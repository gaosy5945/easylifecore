package com.amarsoft.app.oci.ws.decision.prepare;


import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.AwardCreditInfoParent;
import com.amarsoft.app.crqs2.i.bean.three.ContractInfo;
import com.amarsoft.app.crqs2.i.bean.two.Loan;
import com.amarsoft.app.crqs2.i.bean.two.Loancard;
import com.amarsoft.app.crqs2.i.bean.two.StandardLoancard;
import com.amarsoft.app.oci.exception.DataFormatException;

/**
 * ���д����ʻ���ڲ�ʱ�䣨�£�
 * 
 * @author t-lizp
 * 
 */
public class CmdMaxLoginMonths implements Command {
	private int YEAR_MONTH = 12;
	
	@Override
	public Object execute(IReportMessage message) throws Exception{
		String beginDate = DateHelper.getBusinessDate();
		CreditDetail detail = message.getCreditDetail();
		if(detail == null) return 0;
		List<Loan> list = detail.getLoan();
		List<Loancard> list2 = detail.getLoancard();
		List<StandardLoancard> list3 = detail.getStandardLoancard();
		beginDate = getLoanBeginDate(beginDate, list);
		beginDate = getLoancardBeginDate(beginDate, list2);
		beginDate = getStandardLoancardBeginDate(beginDate, list3);
		int months = getMonthCount(beginDate,DateHelper.getBusinessDate());
		return months;

	}
	//����׼���ǿ������·�
	private String getStandardLoancardBeginDate(String beginDate,List<StandardLoancard> list3) {
		for (StandardLoancard standardLoancard : list3) {
			AwardCreditInfoParent awardCreditInfoParent = standardLoancard.getAwardCreditInfo();
			String date = awardCreditInfoParent.getOpenDate();
			String openDate = date.substring(0, 4) + "/" + date.substring(5, 7) + "/" + date.substring(8, 10);
			if (beginDate.compareTo(openDate) > 0) beginDate = openDate;//��ȡ����ʱ����뵱ǰ������
		}
		return beginDate;
	}
    //���Ŵ��ǿ������·�,
	private String getLoancardBeginDate(String beginDate, List<Loancard> list2) {
		for (Loancard loancard : list2) {
			AwardCreditInfoParent awardCreditInfoParent = loancard.getAwardCreditInfo();
			String date = awardCreditInfoParent.getOpenDate();
			String openDate = date.substring(0, 4) + "/" + date.substring(5, 7) + "/" + date.substring(8, 10);
			if (beginDate.compareTo(openDate) > 0) beginDate = openDate;//��ȡ����ʱ����뵱ǰ������
		}
		return beginDate;
	}
    //�ױʴ�����·�,
	private String getLoanBeginDate(String beginDate, List<Loan> list) {
		for (Loan loan : list) {
			ContractInfo contractinfo = loan.getContractInfo();
			String date = contractinfo.getOpenDate();
			String openDate = date.substring(0, 4) + "/" + date.substring(5, 7) + "/" + date.substring(8, 10);
			if (beginDate.compareTo(openDate) > 0) beginDate = openDate;//��ȡ����ʱ����뵱ǰ������
		}
		return beginDate;
	}
	
	//�����·�
	private int getMonthCount(String startDate, String endDate) throws DataFormatException {
		if (startDate == null || endDate == null || startDate.length() != 10 || endDate.length() != 10) throw new DataFormatException("���ڸ�ʽ����ȷ");
		int beginYear = Integer.parseInt(startDate.substring(0, 4));
		int endYear = Integer.parseInt(endDate.substring(0, 4));
		int beginMonth = Integer.parseInt(startDate.substring(5, 7));
		int endMonth = Integer.parseInt(endDate.substring(5, 7));
		int result = (endYear - beginYear) * YEAR_MONTH + endMonth -  beginMonth;
		if (result < 0) result = 0;
		return result ;
	}
}