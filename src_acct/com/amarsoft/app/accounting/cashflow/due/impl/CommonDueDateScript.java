package com.amarsoft.app.accounting.cashflow.due.impl;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * ͨ�û������ڼ�������
 * 
 * @author xyqu 2014��7��29��
 * 
 */
public final class CommonDueDateScript extends DueDateScript {

	public String generateNextDueDate() throws Exception {
		String segFromDate = rptSegment.getString("SegFromDate");
		String segToDate = rptSegment.getString("SegToDate");

		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");

		if (StringX.isEmpty(segToDate)) {
			segToDate = loanMaturityDate;
		}else if(segToDate.compareTo(loanMaturityDate)>0){
			segToDate = loanMaturityDate;
		}
		
		if (StringX.isEmpty(segFromDate)) {
			segFromDate = loanPutoutDate;
		}

		String lastDueDate = rptSegment.getString("LastDueDate");
		if (StringX.isEmpty(lastDueDate)) {
			lastDueDate = segFromDate;
		}
		
		// ������Ϊ��ʱĬ��Ϊ�ſ��յĶ���
		String defaultDueDay = rptSegment.getString("DefaultDueDay");
		String putoutDate = loan.getString("PutOutDate");
		if (StringX.isEmpty(defaultDueDay) || "0".equals(defaultDueDay)) {
			defaultDueDay = putoutDate.substring(8, 10);
		} else if (defaultDueDay.length() < 2) {
			defaultDueDay = "0" + defaultDueDay;
		}
		
		// ��������
		String payFrequencyType = rptSegment.getString("PayFrequencyType");
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType);
		String termUnit = payFrequency.getString("TermUnit");
		int term=payFrequency.getInt("Term");
		String startDate = payFrequency.getString("StartDate");
		
		if(StringX.isEmpty(termUnit) && term == 0){
			termUnit = rptSegment.getString("PayFrequencyUnit");
			term = rptSegment.getInt("PayFrequency");
		}
		
		if(!StringX.isEmpty(startDate)) //���ڹ涨������ʼ���ڵĻ����������ò������⴦��
		{
			if(DateHelper.getEndDateOfMonth(startDate).compareTo(startDate.substring(0, 8)+defaultDueDay) < 0)
				startDate = DateHelper.getEndDateOfMonth(startDate);
			else
				startDate = startDate.substring(0, 8)+defaultDueDay;
			
			while(startDate.compareTo(lastDueDate) < 0)
			{
				startDate = DateHelper.getRelativeDate(startDate, termUnit,term);
			}
			
			if(!startDate.equals(lastDueDate))
			{
				lastDueDate = DateHelper.getRelativeDate(startDate, termUnit,-term);
			}
		}
		
		String nextPayDate=null;
		
		if(term>0)	nextPayDate = DateHelper.getRelativeDate(lastDueDate, termUnit,term);
		else return segToDate;

		//�״λ������ڣ���Ҫ�����״λ���Լ���жϵ����Ƿ񻹿�
		if (lastDueDate.startsWith(segFromDate.substring(0, 8)) && !termUnit.equals(DateHelper.TERM_UNIT_DAY)) {
			String firstInstalmentFlag = rptSegment.getString("FirstInstalmentFlag");// ���ڻ���Լ��
			if (StringX.isEmpty(firstInstalmentFlag)) {// Ϊ��ʱĬ�����²�����
				firstInstalmentFlag = FIRST_DUEDATE_FLAG_2;
			}
			if (firstInstalmentFlag.equals(FIRST_DUEDATE_FLAG_1)) { //�����»���ʱ�����´λ�����
				// �ſ���+Ĭ�ϻ�����С�ڷſ����� �� �ſ���+Ĭ�ϻ����մ����µ׵����
				if ((lastDueDate.substring(0, 8) + defaultDueDay).compareTo(lastDueDate) > 0
						&& DateHelper.getEndDateOfMonth(lastDueDate.substring(0, 8) + defaultDueDay).compareTo(
								lastDueDate) > 0) {
					nextPayDate = lastDueDate.substring(0, 8) + defaultDueDay;
				}
			}
		}
		

		if (!termUnit.equals(DateHelper.TERM_UNIT_DAY)) {// ������28�Ż����յ����,˫�ܹ��Ĳ�������ֻ���µĲŴ���
			if (defaultDueDay.compareTo("28") > 0) {
				nextPayDate = nextPayDate.substring(0, 8) + defaultDueDay;
				String tmp = DateHelper.getEndDateOfMonth(nextPayDate);
				if (tmp.compareTo(nextPayDate) < 0) {
					nextPayDate = tmp;
				}
			}
			if (defaultDueDay.length() > 0) {
				if (defaultDueDay.length() == 1) {
					defaultDueDay = "0" + defaultDueDay;
				}
				// �����µ�����Ĭ����
				if (Integer.parseInt(DateHelper.getEndDateOfMonth(nextPayDate).substring(nextPayDate.length() - 2)) > Integer
						.parseInt(defaultDueDay)) {
					nextPayDate = nextPayDate.substring(0, 8) + defaultDueDay;
				} else {
					nextPayDate = DateHelper.getEndDateOfMonth(nextPayDate);
				}
			}
		}
		
		if (nextPayDate.compareTo(segToDate) >= 0) {//�´λ����ճ���������գ����Դ������Ϊ׼
			nextPayDate = segToDate;
		}
		
		//β���ж�
		String finalInstalmentFlag = rptSegment.getString("FinalInstalmentFlag");// ���ڻ���Լ��
		//���һ�ںϲ�
		if(FINAL_DUEDATE_FLAG_1.equals(finalInstalmentFlag) 
				&& !termUnit.equals(DateHelper.TERM_UNIT_DAY)
				&& nextPayDate.startsWith(segToDate.substring(0, 8)))
		{
			nextPayDate = segToDate;
		}

		return nextPayDate;
	}
}
