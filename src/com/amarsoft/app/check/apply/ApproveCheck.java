package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 审查岗是否调用了评级
 * @author 张万亮
 * @since 2015/03/25
 */
public class ApproveCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				String relaBusinessType = Sqlca.getString(new SqlObject("select BusinessType from BUSINESS_CONTRACT where SerialNo in(select AR.ObjectNo from APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_CONTRACT' and AR.RelativeType = '06')").setParameter("ApplySerialNo",ba.getString("SerialNo")));
				if(relaBusinessType != null && "999".equals(relaBusinessType))//999额度项下的不控制
				{
					
				}
				else
				{
					BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
					List<BusinessObject> relaBas = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType = '04')", "ApplySerialNo",ba.getString("SerialNo"));
					if(relaBas != null && relaBas.size() > 0)
					{
						String approveModel = ProductAnalysisFunctions.getComponentOptionalValue(relaBas.get(0), "PRD04-04", "CreditApproveModel","0010", "02");
						if(approveModel != null && "01".equals(approveModel)) {
							boolean flag = false;
							ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from INTF_RDS_OUT_MESSAGE where ObjectType='jbo.app.BUSINESS_APPLY'"
									+ " and ObjectNo=:ObjectNo and CallType='02' and ReturnCode='0' and FlowStatus in ('1','2')").setParameter("ObjectNo", relaBas.get(0).getString("SerialNo")));
							if(rs.next()){
								flag = true;
							}
							if(!flag){
								putMsg("您还没有调用过评级决策引擎！");
							}
							rs.close();
						}
					}
					else
					{
						String approveModel = ProductAnalysisFunctions.getComponentOptionalValue(ba, "PRD04-04", "CreditApproveModel","0010", "02");
						if(approveModel != null && "01".equals(approveModel)) {
							boolean flag = true;
							/*
							ASResultSet rs = Sqlca.getResultSet(new SqlObject("select * from INTF_RDS_OUT_MESSAGE where ObjectType='jbo.app.BUSINESS_APPLY'"
									+ " and ObjectNo=:ObjectNo and CallType='02' and ReturnCode='0' and FlowStatus in ('1','2')").setParameter("ObjectNo", ba.getString("SerialNo")));
							if(rs.next()){
								flag = true;
							}
							if(!flag){
								putMsg("您还没有调用过评级决策引擎！");
							}
							rs.close();
							*/
						}
					}
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
