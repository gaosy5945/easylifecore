package com.amarsoft.app.accounting.cashflow.due.impl;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.due.PeriodScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * ͨ���ڴμ�������
 * 
 * @author xyqu 2014��7��29��
 * 
 */
public class CommonPeriodScript extends PeriodScript {

	public int getTotalPeriod() throws Exception {
		String segFromDate = rptSegment.getString("SegFromDate");
		String segToDate = rptSegment.getString("SegToDate");

		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");
		if (StringX.isEmpty(segToDate)) {
			segToDate = loanMaturityDate;
		}
		if (StringX.isEmpty(segFromDate)) {
			segFromDate = loanPutoutDate;
		}

		String endDate = null;
		String segTermFlag = rptSegment.getString("SegTermFlag");// �������ޱ�־

		if (StringX.isEmpty(segTermFlag)) {// Ϊ��Ĭ��Ϊ��������
			segTermFlag = PeriodScript.SEGTERM_LOAN;
		}
		if (segTermFlag.equals(PeriodScript.SEGTERM_LOAN)) {// ��������
			endDate = loanMaturityDate;
		} else if (segTermFlag.equals(PeriodScript.SEGTERM_SEGMENT)) {// ��������
			endDate = segToDate;
		} else if (segTermFlag.equals(PeriodScript.SEGTERM_FIXED)) {// ָ������
			int segTerm = rptSegment.getInt("SegTerm");// ָ����������
			String segTermUnit = rptSegment.getString("SegTermUnit");// ָ���������޵�λ��Ĭ��Ϊ��M
			endDate = DateHelper.getRelativeDate(segFromDate, segTermUnit, segTerm);
		} else {
			throw new ALSException("ED1023",loan.getKeyString());
		}

		// �ϴν�Ϣ�ձ����ο�ʼ����С��Ϊ�գ���Ĭ���ϴν�Ϣ��Ϊ���ο�ʼ����
		String lastDueDate = rptSegment.getString("LastDueDate");
		if (StringX.isEmpty(lastDueDate) || lastDueDate.compareTo(segFromDate) < 0) {
			lastDueDate = segFromDate;
		}

		String payFrequencyType = rptSegment.getString("PayFrequencyType");// ��������
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType);
		String termUnit = payFrequency.getString("TermUnit");
		int term = payFrequency.getInt("Term");
		
		//���û���������޵�λ�����ޣ���ȡָ�����޵�λ������ֵ
		if(StringX.isEmpty(termUnit) && term == 0){
			termUnit = rptSegment.getString("PayFrequencyUnit");
			term = rptSegment.getInt("PayFrequency");
		}
		
		if (lastDueDate.equals(endDate)) return 1;
		
		String finalInstalmentFlag = rptSegment.getString("FinalInstalmentFlag");// ���ڻ���Լ��
		
		int totalPeriod=1;
		String nextPayDate = DueDateScript.getDueDateScript(loan, rptSegment,psType).generateNextDueDate();
		while(true){
			String nextPayDateTmp=DateHelper.getRelativeDate(nextPayDate, termUnit, term*totalPeriod);
			totalPeriod++;
			if(nextPayDateTmp.compareTo(endDate)>=0 
					|| nextPayDateTmp.startsWith(endDate.substring(0, 8)) && DueDateScript.FINAL_DUEDATE_FLAG_1.equals(finalInstalmentFlag) 
						&& !termUnit.equals(DateHelper.TERM_UNIT_DAY))
			{
				break;
			}
		}
		return totalPeriod+rptSegment.getInt("CurrentPeriod")-1;
	}
}
