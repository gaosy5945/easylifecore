package com.amarsoft.app.accounting.cashflow.ps;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;

/**
 * ����ƻ������ű�
 */
public abstract class PaymentScheduleCreator {
	protected BusinessObjectManager bomanager=null;
	protected String psType=null;
	protected String rptTermID=null;
	
	public static PaymentScheduleCreator getPaymentScheduleCreator(String psType,String rptTermID,String rptSegTermID,BusinessObjectManager bomanager) throws Exception {
		BusinessObject parameter = BusinessObject.createBusinessObject();
		parameter.setAttributeValue("PSType", psType);
		
		BusinessObject component = null;
		if(StringX.isEmpty(rptSegTermID))
		{
			component = BusinessComponentConfig.getComponent(rptTermID);
		}
		else
		{
			component = BusinessComponentConfig.getComponent(rptTermID).getBusinessObjectBySql("ChildrenComponent", "ID=:ID", "ID",rptSegTermID);
		}
		
		String className = BusinessComponentConfig.getComponentParameter(component, "PaymentScheduleScript",parameter).getString("Value");
		Class<?> c = Class.forName(className); 
		PaymentScheduleCreator p=(PaymentScheduleCreator) c.newInstance();
		p.rptTermID=rptTermID;
		p.psType=psType;
		p.bomanager=bomanager;
		return p;
	}
	
	/**
	 * ��������ƻ��б�
	 * 
	 * @param loan ���ڴ������
	 * @param toDate ������
	 * @param bom
	 * @return
	 * @throws Exception
	 */
	public abstract List<BusinessObject> createPaymentScheduleList(BusinessObject loan,int futurePeriod) throws Exception;
}
