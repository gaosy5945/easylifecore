package com.amarsoft.app.check.apply;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;


import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

/**
 * �����Ѽ��ػ��棬������������SQL����
 * ҵ�����뾭Ӫʵ����Ϣ���
 * @author bhxiao
 * @since 2015/03/19
 */

public class ApplyBVCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ

		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				
				//�жϵ�ǰ�������Ƿ��Ǿ�Ӫ�����������Ϣ
				String businessType = ba.getString("BusinessType");
				String productID = ba.getString("ProductID");
				String selectCheckFalg = "select case when ProductType3='02' then 'true' else 'false' end "
										+ "from PRD_PRODUCT_LIBRARY where ProductID=? ";
				PreparedStatement ps = Sqlca.getConnection().prepareStatement(selectCheckFalg);
				ps.setString(1, productID!=null&&productID.length()>0?productID:businessType);
				ResultSet rs = ps.executeQuery();
				String checkFlag = "";
				if(rs.next()){
					checkFlag = rs.getString(1);
				}
				rs.close();
				ps.close();
				
				String businesstype = productID!=null&&productID.length()>0?productID:businessType;
				if("003".equals(businesstype)||"036".equals(businesstype))
				{
					continue;
				}
				
				if("true".equals(checkFlag)){
					BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
					String selectBV = " objecttype=:ObjectType and objectno=:ObjectNo ";
					List<BusinessObject> bvList = bom.loadBusinessObjects("jbo.app.BUSINESS_INVEST", selectBV, "ObjectNo", ba.getString("SerialNo"),"ObjectType", "jbo.app.BUSINESS_APPLY");
					if(bvList==null||bvList.size()==0){
						putMsg("���˾�Ӫ�࣬���롾"+ba.getString("CustomerName")+"���ľ�Ӫʵ����Ϣδ¼�룡");
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
