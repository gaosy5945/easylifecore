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
 * @since 2014/04/09
 */

public class checkIfhasAccount extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet bp = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", ba.getString("SerialNo")));
				while(bp.next()){
					String objectNo = bp.getStringValue("SerialNo");
					String MFCustomerID = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
							+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo",objectNo));
					if(MFCustomerID == null){
						putMsg("还款账户未录入！");
					}
				}
				bp.close();
				List<BusinessObject> arbaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbaList != null && !arbaList.isEmpty())
				{
					for(BusinessObject arba:arbaList)
					{
						ASResultSet bps = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", arba.getString("SerialNo")));
						while(bps.next()){
							String objectNo = bps.getStringValue("SerialNo");
							String MFCustomerID = Sqlca.getString(new SqlObject("Select AccountNo from ACCT_BUSINESS_ACCOUNT where ObjectType = 'jbo.app.BUSINESS_PUTOUT' "
									+ "and ObjectNo = :ObjectNo and AccountIndicator = '01' and AccountNo is not null").setParameter("ObjectNo",objectNo));
							if(MFCustomerID == null){
								putMsg("还款账户未录入！");
							}
						}
						bps.close();
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
