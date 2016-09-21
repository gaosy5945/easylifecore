package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 上海公积金是否已划拨检查
 * @author zhangwl
 * @since 2014/04/09
 */

public class checkTransferStatus extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String BusinessType = ba.getString("BusinessType");
				String orgID = Sqlca.getString(new SqlObject("select OrgID from ORG_BELONG where BelongOrgID = :BelongOrgID and OrgID = '9800'").setParameter("BelongOrgID", ba.getString("OperateOrgID")));
				if(("100".equals(BusinessType) || "102".equals(BusinessType) || "101".equals(BusinessType)) && "9800".equals(orgID)){
					String transferStatus = Sqlca.getString(new SqlObject("select TransferStatus from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", ba.getString("SerialNo")));
					if(!"2".equals(transferStatus)){
						putMsg("公积金还未划拨！");
					}
				}
				List<BusinessObject> arbaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(arbaList != null && !arbaList.isEmpty())
				{
					for(BusinessObject arba:arbaList)
					{
						String arBusinessType = arba.getString("BusinessType");
						if(("100".equals(arBusinessType) || "102".equals(arBusinessType) || "101".equals(arBusinessType)) && "9800".equals(orgID)){
							String transferStatus = Sqlca.getString(new SqlObject("select TransferStatus from BUSINESS_PUTOUT where ApplySerialNo = :ApplySerialNo").setParameter("ApplySerialNo", arba.getString("SerialNo")));
							if(!"2".equals(transferStatus)){
								putMsg("公积金还未划拨！");
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
