package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ��������Ϣ�����Լ��
 * ����������ϢҪ��:�Ƿ��Դ˱��Ϊ��Ѻ ��У��
 * @author zhangwl
 * @since 2014/03/25
 */

public class ApplyHouseCheck2 extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
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
					if("1".equals(isCollateral)){//�˱����Ϊ��Ѻ
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
							putMsg("���롾"+ba.getString("CustomerName")+"�������������Ϊ��Ѻ����������Ϣ���޸�ѺƷ��");
						}
					}
					else if("0".equals(isCollateral)){//���Դ˱����Ϊ��Ѻ
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
							putMsg("���롾"+ba.getString("CustomerName")+"���������������Ϊ��Ѻ����������Ϣ�д��ڸ�ѺƷ��");
						}
					}
					else{}
				}
				else{
					putMsg("���롾"+ba.getString("CustomerName")+"��δ¼�빺���򹺳�������Ϣ��");
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
