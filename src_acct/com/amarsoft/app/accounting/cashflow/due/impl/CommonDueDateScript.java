package com.amarsoft.app.accounting.cashflow.due.impl;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 通用还款日期计算引擎
 * 
 * @author xyqu 2014年7月29日
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
		
		// 还款日为空时默认为放款日的对日
		String defaultDueDay = rptSegment.getString("DefaultDueDay");
		String putoutDate = loan.getString("PutOutDate");
		if (StringX.isEmpty(defaultDueDay) || "0".equals(defaultDueDay)) {
			defaultDueDay = putoutDate.substring(8, 10);
		} else if (defaultDueDay.length() < 2) {
			defaultDueDay = "0" + defaultDueDay;
		}
		
		// 偿还周期
		String payFrequencyType = rptSegment.getString("PayFrequencyType");
		BusinessObject payFrequency = CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType);
		String termUnit = payFrequency.getString("TermUnit");
		int term=payFrequency.getInt("Term");
		String startDate = payFrequency.getString("StartDate");
		
		if(StringX.isEmpty(termUnit) && term == 0){
			termUnit = rptSegment.getString("PayFrequencyUnit");
			term = rptSegment.getInt("PayFrequency");
		}
		
		if(!StringX.isEmpty(startDate)) //对于规定计算起始日期的还款周期做该部分特殊处理
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

		//首次还款日期，需要根据首次还款约定判断当月是否还款
		if (lastDueDate.startsWith(segFromDate.substring(0, 8)) && !termUnit.equals(DateHelper.TERM_UNIT_DAY)) {
			String firstInstalmentFlag = rptSegment.getString("FirstInstalmentFlag");// 首期还款约定
			if (StringX.isEmpty(firstInstalmentFlag)) {// 为空时默认首月不还款
				firstInstalmentFlag = FIRST_DUEDATE_FLAG_2;
			}
			if (firstInstalmentFlag.equals(FIRST_DUEDATE_FLAG_1)) { //当首月还款时处理下次还款日
				// 放款月+默认还款日小于放款日期 且 放款月+默认还款日大于月底的情况
				if ((lastDueDate.substring(0, 8) + defaultDueDay).compareTo(lastDueDate) > 0
						&& DateHelper.getEndDateOfMonth(lastDueDate.substring(0, 8) + defaultDueDay).compareTo(
								lastDueDate) > 0) {
					nextPayDate = lastDueDate.substring(0, 8) + defaultDueDay;
				}
			}
		}
		

		if (!termUnit.equals(DateHelper.TERM_UNIT_DAY)) {// 处理超过28号还款日的情况,双周供的不做处理，只有月的才处理
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
				// 超过月底则不用默认日
				if (Integer.parseInt(DateHelper.getEndDateOfMonth(nextPayDate).substring(nextPayDate.length() - 2)) > Integer
						.parseInt(defaultDueDay)) {
					nextPayDate = nextPayDate.substring(0, 8) + defaultDueDay;
				} else {
					nextPayDate = DateHelper.getEndDateOfMonth(nextPayDate);
				}
			}
		}
		
		if (nextPayDate.compareTo(segToDate) >= 0) {//下次还款日超过贷款到期日，则以贷款到期日为准
			nextPayDate = segToDate;
		}
		
		//尾期判断
		String finalInstalmentFlag = rptSegment.getString("FinalInstalmentFlag");// 首期还款约定
		//最后一期合并
		if(FINAL_DUEDATE_FLAG_1.equals(finalInstalmentFlag) 
				&& !termUnit.equals(DateHelper.TERM_UNIT_DAY)
				&& nextPayDate.startsWith(segToDate.substring(0, 8)))
		{
			nextPayDate = segToDate;
		}

		return nextPayDate;
	}
}
