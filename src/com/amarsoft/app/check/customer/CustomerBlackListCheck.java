package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;


/**
 * �������ͻ����
 * @author syang
 * @since 2009/09/15
 * gfTang modified 20140418 
 */
public class CustomerBlackListCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/*ȡ����*/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.CUSTOMER_INFO",ba.getString("CustomerID"));
				//1.���ݿͻ��Ż���֤�����͡�֤����ȥ�������в���
				//2.��ǰ���ڱ����ڿ�ʼ���ڣ���������֮�䣨�������˵㣩
				int cnt = JBOFactory.createBizObjectQuery("jbo.customer.CUSTOMER_LIST",
						"(CustomerID =:CustomerID  or (CertType =:CertType and CertID =:CertID)) and Status='1' and ListType like '70%' "+
				"and (EndDate >=:EndDate or EndDate is null or EndDate = '') and (BeginDate<=:BeginDate or BeginDate is null or BeginDate = '') ")
				.setParameter("CustomerID", customer.getString("CustomerID"))
				.setParameter("CertType", customer.getString("CertType"))
				.setParameter("CertID", customer.getString("CertID"))
				.setParameter("EndDate", DateHelper.getBusinessDate())
				.setParameter("BeginDate", DateHelper.getBusinessDate()).getTotalCount();
				
				if(cnt > 0){
					putMsg( "�����ˡ�"+ba.getString("CustomerName")+"�����ں������ͻ�");
				}
			}
		}
		
		/* ���ؽ������  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
