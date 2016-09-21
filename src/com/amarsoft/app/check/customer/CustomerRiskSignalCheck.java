package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 预警客户检查
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerRiskSignalCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		//检查该客户是否存在已生效的预警信息
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
		
				String sSql = " select count(1) from RISK_WARNING_OBJECT RWO,RISK_WARNING_SIGNAL RWS  "
							  + " where RWO.ObjectType=:ObjectType and RWO.ObjectNo=:ObjectNo "
							  + " and RWO.SignalSerialNo = RWS.SerialNo and RWS.Status = '1' ";
				SqlObject so = new SqlObject(sSql);
				so.setParameter("ObjectType", "jbo.customer.CUSTOMER_INFO");
				so.setParameter("ObjectNo", ba.getString("CustomerID"));
				int cnt = Integer.parseInt(Sqlca.getString(so));
				
				if( cnt > 0  ){
					putMsg("申请【"+ba.getString("CustomerName")+"】存在生效的预警信号");
				}
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
