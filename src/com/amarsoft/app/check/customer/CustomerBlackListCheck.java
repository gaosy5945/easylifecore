package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;


/**
 * 黑名单客户检查
 * @author syang
 * @since 2009/09/15
 * gfTang modified 20140418 
 */
public class CustomerBlackListCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/*取参数*/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.CUSTOMER_INFO",ba.getString("CustomerID"));
				//1.根据客户号或者证件类型、证件号去黑名单中查找
				//2.当前日期必需在开始日期，结束日期之间（包括两端点）
				int cnt = JBOFactory.createBizObjectQuery("jbo.customer.CUSTOMER_LIST",
						"(CustomerID =:CustomerID  or (CertType =:CertType and CertID =:CertID)) and Status='1' and ListType like '70%' "+
				"and (EndDate >=:EndDate or EndDate is null or EndDate = '') and (BeginDate<=:BeginDate or BeginDate is null or BeginDate = '') ")
				.setParameter("CustomerID", customer.getString("CustomerID"))
				.setParameter("CertType", customer.getString("CertType"))
				.setParameter("CertID", customer.getString("CertID"))
				.setParameter("EndDate", DateHelper.getBusinessDate())
				.setParameter("BeginDate", DateHelper.getBusinessDate()).getTotalCount();
				
				if(cnt > 0){
					putMsg( "申请人【"+ba.getString("CustomerName")+"】属于黑名单客户");
				}
			}
		}
		
		/* 返回结果处理  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
