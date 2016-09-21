package com.amarsoft.app.accounting.cashflow.due;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.impl.CommonDueDateScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;

/**
 * @author yegang 期供计算引擎
 */
public abstract class DueDateScript {
	protected BusinessObject loan;
	protected BusinessObject rptSegment;
	protected String psType;
	
	public final static String FIRST_DUEDATE_FLAG_1 = "01";//放款当月还款
	public final static String FIRST_DUEDATE_FLAG_2 = "02";//放款当月不还款
	
	public final static String FINAL_DUEDATE_FLAG_1 = "01";//最后一期合并
	public final static String FINAL_DUEDATE_FLAG_2 = "02";//最后一期拆分
	public final static String FINAL_DUEDATE_FLAG_3 = "03";//自动顺延直至贷款到期
	
	/**
	 * 获取还款日计算引擎
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	public static DueDateScript getDueDateScript(BusinessObject loan, BusinessObject rptSegment, String psType) throws Exception {
		BusinessObject parameter = BusinessObject.createBusinessObject();
		parameter.setAttributeValue("PSType", psType);
		String className = BusinessComponentConfig.getComponentValue(loan,rptSegment, parameter,"DueDateScript","value");
		if (StringX.isEmpty(className)) {
			String payFrequencyType = rptSegment.getString("PayFrequencyType");// 还款周期
			className=CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType).getString("DueDateScript");
		}

		DueDateScript dueDateScript=null;
		// 依然为空时，取默认值
		if (StringX.isEmpty(className)) {
			dueDateScript= new CommonDueDateScript();
		}
		else{
			Class<?> c = Class.forName(className);
			dueDateScript = (DueDateScript) c.newInstance();
		}
		dueDateScript.loan=loan;
		dueDateScript.rptSegment=rptSegment;
		dueDateScript.psType=psType;
		return dueDateScript;
	}

	/**
	 * 根据借据和组合还款计划，重新计算生成下次还款日
	 * 
	 * @return 组合还款计划的下次还款日
	 * @throws Exception
	 */
	public abstract String generateNextDueDate() throws Exception;

	/**
	 * 根据借据还款定义，直接获取大于当前日期最小的下次还款日
	 * 
	 * 注意：此方法直接获取，并进行计算，如果需要重新生成下次还款日，请使用方法<Code>generateNextPayDate</Code>
	 * @return 组合还款计划的下次还款日
	 * @throws Exception
	 */
	public static String getNextDueDate(BusinessObject loan,String psType) throws Exception{
		String nextDueDate="";
		List<BusinessObject> rptSegments = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
					" PSType like :PSType and Status=:Status ", 
					"PSType",psType,"Status","1");
		
		if(rptSegments == null || rptSegments.isEmpty()) return loan.getString("MaturityDate");
		for(BusinessObject a:rptSegments){
			String nextDueDateTemp = a.getString("NextDueDate");
			if(!StringX.isEmpty(a.getString("SegToDate")) && a.getString("SegToDate").compareTo(loan.getString("BusinessDate"))<=0 )
				continue;
			if(!StringX.isEmpty(a.getString("SegFromDate")) && a.getString("SegFromdate").compareTo(loan.getString("BusinessDate"))>0 )
				continue;
			
			if(StringX.isEmpty(nextDueDate))
				nextDueDate = nextDueDateTemp;
			if(StringX.isEmpty(nextDueDateTemp) || nextDueDateTemp.compareTo(loan.getString("BusinessDate"))<0)
				continue;
			if(nextDueDateTemp.compareTo(nextDueDate)<=0) nextDueDate=nextDueDateTemp;
		}
		
		if(StringX.isEmpty(nextDueDate)) nextDueDate = loan.getString("MaturityDate");
		
		return nextDueDate;
	}
	
	/**
	 * 根据借据还款定义，直接获取小于当前日期最大的上次还款日
	 * 
	 * @return 组合还款计划的下次还款日
	 * @throws Exception
	 */
	public static String getLastDueDate(BusinessObject loan,String psType) throws Exception{
		String lastDueDate="";
		List<BusinessObject> rptSegments = loan.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, 
					" PSType like :PSType and Status=:Status ", 
					"PSType",psType,"Status","1");
		
		if(rptSegments == null || rptSegments.isEmpty()) return loan.getString("PutOutDate");
		
		for(BusinessObject a:rptSegments){
			
			if(!StringX.isEmpty(a.getString("SegFromDate")) && a.getString("SegFromDate").compareTo(loan.getString("BusinessDate"))>=0)
				continue;
			
			String lastDueDateTemp = a.getString("LastDueDate");
			if(StringX.isEmpty(lastDueDateTemp))
				continue;
			if(StringX.isEmpty(lastDueDate))
				lastDueDate = lastDueDateTemp;
			
			if(lastDueDateTemp.compareTo(lastDueDate)>=0 && lastDueDateTemp.compareTo(loan.getString("BusinessDate"))<=0) 
				lastDueDate=lastDueDateTemp;
		}
		if(StringX.isEmpty(lastDueDate)) lastDueDate = loan.getString("PutOutDate");
		
		return lastDueDate;
	}
	
	/**
	 * 根据借据和还款计划，计算还款日期列表
	 * 
	 * @return 还款计划的还款日期列表
	 * @throws Exception
	 */
	public List<String> getDueDateList() throws Exception {
		rptSegment = rptSegment.clone();
		ArrayList<String> payDateList = new ArrayList<String>();

		String segFromDate = rptSegment.getString("SegFromDate");
		String segToDate = rptSegment.getString("SegToDate");

		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");
		if (segToDate == null || segToDate.length() == 0)
			segToDate = loanMaturityDate;
		if (segFromDate == null || segFromDate.length() == 0)
			segFromDate = loanPutoutDate;

		while (true) {
			String payDate = this.generateNextDueDate();
			rptSegment.setAttributeValue("LastDueDate", payDate);
			if (payDate.compareTo(segToDate) >= 0) {
				payDateList.add(payDate);
				break;
			} else {
				payDateList.add(payDate);
			}
		}
		return payDateList;
	}

}
