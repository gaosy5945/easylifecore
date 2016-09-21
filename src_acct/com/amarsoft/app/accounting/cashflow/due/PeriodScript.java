package com.amarsoft.app.accounting.cashflow.due;

import com.amarsoft.app.accounting.cashflow.due.impl.CommonPeriodScript;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;

/**
 * �ڹ���������֮�ڴμ���
 * 
 * @author yegang
 */
public abstract class PeriodScript {
	//�������ޱ�ʶSEGTermFlag
	public final static String SEGTERM_LOAN = "1";     //��������
	public final static String SEGTERM_SEGMENT = "2";  //��������
	public final static String SEGTERM_FIXED = "3";//ָ������
	
	protected BusinessObject loan;
	protected BusinessObject rptSegment;
	protected String psType;
	/**
	 * ��ȡ�����ռ�������
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	public static PeriodScript getPeriodScript(BusinessObject loan, BusinessObject rptSegment, String psType) throws Exception {
		BusinessObject parameter = BusinessObject.createBusinessObject();
		parameter.setAttributeValue("PSType", psType);
		String className = BusinessComponentConfig.getComponentValue(loan,rptSegment, parameter,"PeriodScript","value");
		if (StringX.isEmpty(className)) {
			String payFrequencyType = rptSegment.getString("PayFrequencyType");// ��������
			className=CashFlowConfig.getPayFrequencyTypeConfig(payFrequencyType).getString("DueDateScript");
		}

		PeriodScript script=null;
		// ��ȻΪ��ʱ��ȡĬ��ֵ
		if (StringX.isEmpty(className)) {
			script= new CommonPeriodScript();
		}
		else{
			Class<?> c = Class.forName(className);
			script = (PeriodScript) c.newInstance();
		}
		script.loan=loan;
		script.rptSegment=rptSegment;
		script.psType = psType;
		return script;
	}

	/**
	 * ���ݽ�ݺͷֶγ�����Ϣ��������ܳ����ڴ�
	 * 
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	public abstract int getTotalPeriod() throws Exception;

}
