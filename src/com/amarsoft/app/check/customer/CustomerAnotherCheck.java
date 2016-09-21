package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 客户信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerAnotherCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.IND_INFO", ba.getString("CustomerID"));
				if(customer == null) putMsg("未找到申请人【"+ba.getString("CustomerName")+"】客户信息");
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
							putMsg("申请【"+ba.getString("CustomerName")+"】配偶的收入信息未录入！");
						}
						String TempSaveFlag = Sqlca.getString(new SqlObject("Select TempSaveFlag from IND_INFO where CustomerID = :CustomerID").setParameter("CustomerID", relativeCustomerID));
						if(TempSaveFlag == null || !"0".equals(TempSaveFlag)){
							putMsg("请保存申请【"+ba.getString("CustomerName")+"】的配偶信息！");
						}
					}
				}
				ii.close();
			}
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
