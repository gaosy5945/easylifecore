package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 数据已加载缓存，本类中无需再SQL加载
 * 业务申请信息机构产品限额检查
 * @author jqliang
 * @since 2015/03/23
 */

public class OrgBusinessTypeLimitCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息

		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				checkOrgTypeLimit(ba,Sqlca);
				List<BusinessObject> baaList = ba.getBusinessObjects("jbo.app.BUSINESS_APPLY");
				if(baaList != null)
				{
					for(BusinessObject baa:baaList){
						checkOrgTypeLimit(baa,Sqlca);
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
	
	public void checkOrgTypeLimit(BusinessObject ba,Transaction Sqlca) throws Exception{
		String serialNo = ba.getString("SerialNo");
		String businessType = ba.getString("BusinessType");
		String operateOrgID = ba.getString("OperateOrgID");
		double businessSum = ba.getDouble("BusinessSum");
		double LimitAmount = 0.00;
		double allContractSum = 0.00;
		int iNum = 0;
		String soperateOrgName = Sqlca.getString(new SqlObject("select OrgName from Org_Info where OrgID=:OrgID").setParameter("OrgID", operateOrgID));
		String sBusinessTypeName = Sqlca.getString(new SqlObject("select TypeName from Business_Type where TypeNo=:TypeNo").setParameter("TypeNo", businessType));
		
		ASResultSet rs = Sqlca.getResultSet(new SqlObject("select count(SerialNo) from CL_GROUP_LIMIT where ','||OrgID||',' like :OrgID and ','||ParameterID1||',' like :BusinessType and Status='1' and ToDate>=:SysDate")
        .setParameter("OrgID", "%,"+operateOrgID+",%").setParameter("BusinessType", "%,"+businessType+",%").setParameter("SysDate", DateHelper.getBusinessDate()));
		if(rs.next()){
			iNum = rs.getInt(1);
		}
		rs.close();
		if(iNum>0){
//			String sControlType = Sqlca.getString(new SqlObject("select ControlType from CL_GROUP_LIMIT where OrgID = :OrgID and ','||ParameterID1||',' like :BusinessType ")
//               .setParameter("OrgID", operateOrgID).setParameter("BusinessType", "%,"+businessType+",%"));
			//获取该机构的机构产品限额
			ASResultSet cgl = Sqlca.getResultSet(new SqlObject("select sum(LimitAmount) from CL_GROUP_LIMIT where ','||OrgID||',' like :OrgID and ','||ParameterID1||',' like :BusinessType ")
			                   .setParameter("OrgID", "%,"+operateOrgID+",%").setParameter("BusinessType", "%,"+businessType+",%"));
			if(cgl.next()){
				LimitAmount = cgl.getDouble(1);
			}
			cgl.close();
			//获取所有该机构合同有效占用的机构产品限额
			String sSql = " select sum(case when BC.Revolveflag = '1' and BC.MATURITYDATE >=:SysDate then nvl(BC.BusinessSum,0)"+
			           " when BC.Revolveflag = '1' and BC.MATURITYDATE <:SysDate then nvl(BC.Balance,0)"+
					   " when BC.Contractstatus in('01','02') then nvl(BC.BusinessSum,0)"+
			           " when BC.CONTRACTSTATUS in('03','04') then nvl(BC.Balance,0) else 0 end)"+
					   " from business_contract BC where BC.OperateOrgID =:OperateOrgID and BC.BusinessType =:BusinessType ";
			ASResultSet aps = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SysDate", DateHelper.getBusinessDate())
                       .setParameter("OperateOrgID", operateOrgID).setParameter("BusinessType", businessType));
            if(aps.next()){
            	allContractSum = aps.getDouble(1);
            }
            aps.close();
            
            //申请业务取申请金额(未生成合同的有效金额)
            sSql = "select sum(case when BA.ApproveStatus in('01','02') then"
  			      +" nvl((select BusinessSum from BUSINESS_APPROVE where SerialNo in (select max(SerialNo) from BUSINESS_APPROVE where ApplySerialNo = BA.SerialNo)),nvl(BA.BusinessSum,0)) "
			      +" else "
			      +" 0 "
			      +" end) from Business_Apply BA where BA.OperateOrgID =:OperateOrgID and BA.BusinessType =:BusinessType ";
            double applySum = Sqlca.getDouble(new SqlObject(sSql)
            .setParameter("OperateOrgID", operateOrgID).setParameter("BusinessType", businessType));
            if((allContractSum+applySum)>LimitAmount){
            	//putMsg("该机构["+soperateOrgName+"]该业务品种["+sBusinessTypeName+"]的机构产品限额已超出"+DataConvert.toMoney(allLimitSum+businessSum-LimitAmount));
            	putMsg("该机构["+soperateOrgName+"]该业务品种["+sBusinessTypeName+"]的占用的金额已超出机构产品限额"+DataConvert.toMoney(allContractSum+applySum-LimitAmount));
            }
		}
	}
	
}
