package com.amarsoft.app.accounting.cashflow.due.impl;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.cashflow.due.PeriodScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 通用期次计算引擎
 * 
 * @author xyqu 2014年7月29日
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
		String segTermFlag = rptSegment.getString("SegTermFlag");// 区段期限标志

		if (StringX.isEmpty(segTermFlag)) {// 为空默认为贷款期限
			segTermFlag = PeriodScript.SEGTERM_LOAN;
		}
		if (segTermFlag.equals(PeriodScript.SEGTERM_LOAN)) {// 贷款期限
			endDate = loanMaturityDate;
		} else if (segTermFlag.equals(PeriodScript.SEGTERM_SEGMENT)) {// 区段期限
			endDate = segToDate;
		} else if (segTermFlag.equals(PeriodScript.SEGTERM_FIXED)) {// 指定期限
			int segTerm = rptSegment.getInt("SegTerm");// 指定区段期限
			String segTermUnit = rptSegment.getString("SegTermUnit");// 指定区段期限单位，默认为月M
			endDate = DateHelper.getRelativeDate(segFromDate, segTermUnit, segTerm);
		} else {
			throw new ALSException("ED1023",loan.getKeyString());
		}

		// 上次结息日比区段开始日期小或为空，则默认上次结息日为区段开始日期
		String lastDueDate = rptSegment.getString("LastDueDate");
		if (StringX.isEmpty(lastDueDate) || lastDueDate.compareTo(segFromDate) < 0) {
			lastDueDate = segFromDate;
		}

		String payFrequencyType = rptSegment.getString("PayFrequencyType");// 偿还周期
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType);
		String termUnit = payFrequency.getString("TermUnit");
		int term = payFrequency.getInt("Term");
		
		//如果没有配置期限单位、期限，则取指定期限单位和期限值
		if(StringX.isEmpty(termUnit) && term == 0){
			termUnit = rptSegment.getString("PayFrequencyUnit");
			term = rptSegment.getInt("PayFrequency");
		}
		
		if (lastDueDate.equals(endDate)) return 1;
		
		String finalInstalmentFlag = rptSegment.getString("FinalInstalmentFlag");// 首期还款约定
		
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
