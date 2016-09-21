package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 存单质押到期日校验
 * @author T-zhangwl
 *
 */

public class DepositTermCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String baMaturityDate = ba.getString("MaturityDate");
				ASResultSet arrs = Sqlca.getResultSet(new SqlObject("Select GR.AssetSerialNo from GUARANTY_RELATIVE GR,APPLY_RELATIVE AR where "
						+ "AR.ApplySerialNo=:BASerialNo and AR.ObjectNo=GR.GCSerialNo and AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.RelativeType='05'").setParameter("BASerialNo", ba.getString("SerialNo")));
				while(arrs.next()){
					String assetSerialNo = arrs.getStringValue("AssetSerialNo");
					String AssetType = Sqlca.getString(new SqlObject("select AssetType from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", assetSerialNo));
					if("10100100100".equals(AssetType)){
						String afMaturityDate = Sqlca.getString(new SqlObject("select AF.MaturityDate from ASSET_FINANCE AF where AssetSerialNo = :AssetSerialNo").setParameter("AssetSerialNo", assetSerialNo));
						if(afMaturityDate == null || "".equals(afMaturityDate)){
							putMsg("请先保存押品信息！");
						}else if(baMaturityDate == null || "".equals(baMaturityDate)){
							int BusinessTerm = ba.getInt("BusinessTerm");
							int BusinessTermDay = ba.getInt("BusinessTermDay");
							baMaturityDate = DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, BusinessTerm);
							baMaturityDate = DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_DAY, BusinessTermDay);
							if(baMaturityDate.compareTo(afMaturityDate) > 0){
								putMsg("贷款到期日【"+baMaturityDate+"】晚于存单到期日【"+afMaturityDate+"】");
							}
						}else{
							if(baMaturityDate.compareTo(afMaturityDate) > 0){
								putMsg("贷款到期日【"+baMaturityDate+"】晚于存单到期日【"+afMaturityDate+"】");
							}
						}
					}
				}
				arrs.close();
				
			}
		}
    	/** 返回结果处理 **/
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
