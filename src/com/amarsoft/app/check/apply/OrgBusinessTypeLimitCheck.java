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
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ������Ʒ�޶���
 * @author jqliang
 * @since 2015/03/23
 */

public class OrgBusinessTypeLimitCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
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
			//��ȡ�û����Ļ�����Ʒ�޶�
			ASResultSet cgl = Sqlca.getResultSet(new SqlObject("select sum(LimitAmount) from CL_GROUP_LIMIT where ','||OrgID||',' like :OrgID and ','||ParameterID1||',' like :BusinessType ")
			                   .setParameter("OrgID", "%,"+operateOrgID+",%").setParameter("BusinessType", "%,"+businessType+",%"));
			if(cgl.next()){
				LimitAmount = cgl.getDouble(1);
			}
			cgl.close();
			//��ȡ���иû�����ͬ��Чռ�õĻ�����Ʒ�޶�
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
            
            //����ҵ��ȡ������(δ���ɺ�ͬ����Ч���)
            sSql = "select sum(case when BA.ApproveStatus in('01','02') then"
  			      +" nvl((select BusinessSum from BUSINESS_APPROVE where SerialNo in (select max(SerialNo) from BUSINESS_APPROVE where ApplySerialNo = BA.SerialNo)),nvl(BA.BusinessSum,0)) "
			      +" else "
			      +" 0 "
			      +" end) from Business_Apply BA where BA.OperateOrgID =:OperateOrgID and BA.BusinessType =:BusinessType ";
            double applySum = Sqlca.getDouble(new SqlObject(sSql)
            .setParameter("OperateOrgID", operateOrgID).setParameter("BusinessType", businessType));
            if((allContractSum+applySum)>LimitAmount){
            	//putMsg("�û���["+soperateOrgName+"]��ҵ��Ʒ��["+sBusinessTypeName+"]�Ļ�����Ʒ�޶��ѳ���"+DataConvert.toMoney(allLimitSum+businessSum-LimitAmount));
            	putMsg("�û���["+soperateOrgName+"]��ҵ��Ʒ��["+sBusinessTypeName+"]��ռ�õĽ���ѳ���������Ʒ�޶�"+DataConvert.toMoney(allContractSum+applySum-LimitAmount));
            }
		}
	}
	
}
