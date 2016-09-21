package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息完整性检查
 * @author zhangwl
 * @since 2014/03/25
 */

public class checkAccount extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		boolean flag = true;
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String phaseType = (String)this.getAttribute("PhaseType");
				String mfCustomerID = Sqlca.getString(new SqlObject("Select mfCustomerID from CUSTOMER_INFO where CustomerID = :CustomerID")
										.setParameter("CustomerID", ba.getString("CustomerID")));
				if(mfCustomerID == null){mfCustomerID="";}
				String AccountNo = "";
				String objectType = "";
				String objectNo = "";
				if(!"".equals(phaseType) || phaseType != null){
					if("0090".equals(phaseType)){
						objectType = "jbo.app.BUSINESS_PUTOUT";
						objectNo = Sqlca.getString(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", ba.getString("SerialNo")));
						if(objectNo == null){objectNo="";}
						AccountNo = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
									+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo", objectNo));
					}else{
						AccountNo = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_APPLY' "
									+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null")
						.setParameter("ObjectNo", ba.getString("SerialNo")));
						objectType = "jbo.app.BUSINESS_APPLY";
						objectNo = ba.getString("SerialNo");
					}
				}
				List<BusinessObject> arbaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbaList != null && !arbaList.isEmpty())
				{
					for(BusinessObject arba:arbaList){
						mfCustomerID = Sqlca.getString(new SqlObject("Select mfCustomerID from CUSTOMER_INFO where CustomerID = :CustomerID")
						.setParameter("CustomerID", arba.getString("CustomerID")));
						if(mfCustomerID == null){mfCustomerID="";}
						if(!"".equals(phaseType) || phaseType != null){
							if("0090".equals(phaseType)){
								objectType = "jbo.app.BUSINESS_PUTOUT";
								objectNo = Sqlca.getString(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", arba.getString("SerialNo")));
								if(objectNo == null){objectNo="";}
								AccountNo = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
										+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo", objectNo));
							}else{
								objectType = "jbo.app.BUSINESS_APPLY";
								objectNo = arba.getString("SerialNo");
								AccountNo = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_APPLY' "
										+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null")
								.setParameter("ObjectNo", arba.getString("SerialNo")));
							}
						}
					}
				}
			}
		}
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		return null;
	}
}
