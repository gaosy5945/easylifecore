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
 * 购房附属信息要素:是否以此标的为抵押 的校验
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyHouseCheck2 extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				boolean flag1 = false;
				boolean flag2 = true;
				ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from BUSINESS_TRADE where ObjectType = 'jbo.app.BUSINESS_APPLY' "
						+ "and ObjectNo = :ObjectNo").setParameter("ObjectNo", ba.getString("SerialNo")));
				if(rs.next()){
					String isCollateral = rs.getString("IsCollateral");
					if("1".equals(isCollateral)){//此标的作为抵押
						String assetSerialNo = rs.getString("AssetSerialNo");
						ASResultSet grrs = Sqlca.getResultSet(new SqlObject("select * from GUARANTY_RELATIVE where AssetSerialNo=:AssetSerialNo").setParameter("AssetSerialNo", assetSerialNo));
						while(grrs.next()){
							String gcSerialNo = grrs.getString("GCSerialNo");
							ASResultSet gcrs = Sqlca.getResultSet(new SqlObject("select * from APPLY_RELATIVE where ApplySerialNo=:ApplySerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo and RelativeType='05' ").setParameter("ApplySerialNo", ba.getString("SerialNo")).setParameter("ObjectNo", gcSerialNo));
							if(gcrs.next()){
								flag1 = true;
								gcrs.close();
								break;
							}
							gcrs.close();
						}
						grrs.close();
						if(!flag1){
							putMsg("申请【"+ba.getString("CustomerName")+"】以所购标的作为抵押，但担保信息中无该押品！");
						}
					}
					else if("0".equals(isCollateral)){//不以此标的作为抵押
						String assetSerialNo = rs.getString("AssetSerialNo");
						ASResultSet grrs = Sqlca.getResultSet(new SqlObject("select * from GUARANTY_RELATIVE where AssetSerialNo=:AssetSerialNo").setParameter("AssetSerialNo", assetSerialNo));
						while(grrs.next()){
							String gcSerialNo = grrs.getString("GCSerialNo");
							ASResultSet gcrs = Sqlca.getResultSet(new SqlObject("select * from APPLY_RELATIVE where ApplySerialNo=:ApplySerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo and RelativeType='05' ").setParameter("ApplySerialNo", ba.getString("SerialNo")).setParameter("ObjectNo", gcSerialNo));
							if(gcrs.next()){
								flag2 = false;
								gcrs.close();
								break;
							}
							gcrs.close();
						}
						grrs.close();
						if(!flag2){
							putMsg("申请【"+ba.getString("CustomerName")+"】不以所购标的作为抵押，但担保信息中存在该押品！");
						}
					}
					else{}
				}
				else{
					putMsg("申请【"+ba.getString("CustomerName")+"】未录入购房或购车附属信息！");
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
