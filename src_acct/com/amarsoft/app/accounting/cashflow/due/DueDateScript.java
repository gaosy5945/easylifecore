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
 * @author yegang �ڹ���������
 */
public abstract class DueDateScript {
	protected BusinessObject loan;
	protected BusinessObject rptSegment;
	protected String psType;
	
	public final static String FIRST_DUEDATE_FLAG_1 = "01";//�ſ�»���
	public final static String FIRST_DUEDATE_FLAG_2 = "02";//�ſ�²�����
	
	public final static String FINAL_DUEDATE_FLAG_1 = "01";//���һ�ںϲ�
	public final static String FINAL_DUEDATE_FLAG_2 = "02";//���һ�ڲ��
	public final static String FINAL_DUEDATE_FLAG_3 = "03";//�Զ�˳��ֱ�������
	
	/**
	 * ��ȡ�����ռ�������
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
			String payFrequencyType = rptSegment.getString("PayFrequencyType");// ��������
			className=CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType).getString("DueDateScript");
		}

		DueDateScript dueDateScript=null;
		// ��ȻΪ��ʱ��ȡĬ��ֵ
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
	 * ���ݽ�ݺ���ϻ���ƻ������¼��������´λ�����
	 * 
	 * @return ��ϻ���ƻ����´λ�����
	 * @throws Exception
	 */
	public abstract String generateNextDueDate() throws Exception;

	/**
	 * ���ݽ�ݻ���壬ֱ�ӻ�ȡ���ڵ�ǰ������С���´λ�����
	 * 
	 * ע�⣺�˷���ֱ�ӻ�ȡ�������м��㣬�����Ҫ���������´λ����գ���ʹ�÷���<Code>generateNextPayDate</Code>
	 * @return ��ϻ���ƻ����´λ�����
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
	 * ���ݽ�ݻ���壬ֱ�ӻ�ȡС�ڵ�ǰ���������ϴλ�����
	 * 
	 * @return ��ϻ���ƻ����´λ�����
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
	 * ���ݽ�ݺͻ���ƻ������㻹�������б�
	 * 
	 * @return ����ƻ��Ļ��������б�
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
