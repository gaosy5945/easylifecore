package com.amarsoft.app.als.customer.common.action;

/**
 * @Author:������
 * �������ͻ�������Ϣҳ����µ�ent_info�е��Ƿ������ſͻ��ֶ�
*/

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class PartnerCustomerQualifacationHandler extends CommonHandler{
	
	protected  void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
		tx.join(bm);
		String customerID = bo.getAttribute("customerID").getString();
		String wbCrtCustomer = bo.getAttribute("wbCrtCustomer").getString();
		bm.createQuery("update O set WBCRTCUSTOMER=:wbCrtCustomer,UPDATEDATE=:updateDate Where customerID=:customerID")
		  .setParameter("wbCrtCustomer", wbCrtCustomer).setParameter("updateDate", DateHelper.getBusinessDate())
		  .setParameter("customerID", customerID)
		  .executeUpdate();
	}
}
