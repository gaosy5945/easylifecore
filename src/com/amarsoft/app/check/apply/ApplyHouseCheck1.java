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

public class ApplyHouseCheck1 extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from BUSINESS_TRADE where ObjectType = 'jbo.app.BUSINESS_APPLY' "
						+ "and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				if(rs.next()){
					String FundBusinessSum = Sqlca.getString(new SqlObject("select BA.BusinessSum from BUSINESS_APPLY BA,APPLY_RELATIVE AR where "
							+ "AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and BA.SerialNo = AR.ObjectNo and AR.RelativeType = '07' and AR.ApplySerialNo = :ApplySerialNo")
								.setParameter("ApplySerialNo", ba.getString("SerialNo")));
					if(FundBusinessSum == null) FundBusinessSum = "0";
					String ContractAmount = rs.getString("ContractAmount");
					String FirstPayAmount = rs.getString("FirstPayAmount");
					String BusinessSum = ba.getString("BusinessSum");
					double fundBusinessSum = Double.parseDouble(FundBusinessSum);
					double contractAmount = Double.parseDouble(ContractAmount);
					double firstPayAmount = Double.parseDouble(FirstPayAmount);
					double businessSum = Double.parseDouble(BusinessSum);
					double sum = businessSum + firstPayAmount + fundBusinessSum; 
					double amount = contractAmount - firstPayAmount - businessSum - fundBusinessSum;
					if(Math.abs(amount) >= 0.0000001){
						putMsg("申请【"+ba.getString("CustomerName")+"】贷款金额与首付款的和【"+sum+"】不等于购买总价【"+contractAmount+"】！");
					}
				}
				rs.close();
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
