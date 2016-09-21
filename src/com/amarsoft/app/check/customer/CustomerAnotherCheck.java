package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �ͻ���Ϣ�����Լ��
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerAnotherCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.IND_INFO", ba.getString("CustomerID"));
				if(customer == null) putMsg("δ�ҵ������ˡ�"+ba.getString("CustomerName")+"���ͻ���Ϣ");
				String customerID = ba.getString("CustomerID");
				ASResultSet ii = Sqlca.getResultSet(new SqlObject("select II.Marriage from IND_INFO II where II.CustomerID = :CustomerID and II.Marriage in('20','21','22','23')")
										.setParameter("CUSTOMERID", customerID));
				if(ii.next()){
					String relativeCustomerID = Sqlca.getString(new SqlObject("select RELATIVECUSTOMERID from CUSTOMER_RELATIVE where RELATIONSHIP = '2007'and CUSTOMERID = :CUSTOMERID")
										.setParameter("CUSTOMERID", customerID));
					if(!"".equals(relativeCustomerID)){
						Boolean flag = false;
					    String amount = Sqlca.getString(new SqlObject("select AMOUNT from CUSTOMER_FINANCE where CustomerID = :CustomerID and FinancialItem = '3050' ")
										.setParameter("CUSTOMERID", relativeCustomerID));
						if(amount != null && !"".equals(amount)){
							double Amount = Double.parseDouble(amount);
							if(Amount > 0){
								flag = true;
							}
						}
						if(!flag){
							putMsg("���롾"+ba.getString("CustomerName")+"����ż��������Ϣδ¼�룡");
						}
						String TempSaveFlag = Sqlca.getString(new SqlObject("Select TempSaveFlag from IND_INFO where CustomerID = :CustomerID").setParameter("CustomerID", relativeCustomerID));
						if(TempSaveFlag == null || !"0".equals(TempSaveFlag)){
							putMsg("�뱣�����롾"+ba.getString("CustomerName")+"������ż��Ϣ��");
						}
					}
				}
				ii.close();
			}
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
