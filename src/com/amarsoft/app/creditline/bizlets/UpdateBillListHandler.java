package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 
 * @author gftang 2013-12-19
 * ɾ��ʱ�������ҵ����Ʊ����Ϣ
 * modify by lyin 2014-01-20
 */

public class UpdateBillListHandler extends CommonHandler {

	public  void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		updateBillInfo(tx,bo);
	}
	
	/**
	 * ����ҵ���������Ϣ
	 * @param bo
	 * @throws Exception
	 */
	public void updateBillInfo(JBOTransaction tx,BizObject bo) throws Exception {
		/**
		 * ��������
		 */
		String sObjectNo = asPage.getParameter("ObjectNo");
		String sObjectType = asPage.getParameter("ObjectType");
		BizObjectManager bm1 = null;
		BizObjectManager bm2 = null;
		BizObject bo2 = null;
		int count =0;
		double billSum = 0.0;
		
		String serialNo= bo.getAttribute("SerialNo").getString();
		bm1 = JBOFactory.getBizObjectManager("jbo.app.BILL_INFO");
		tx.join(bm1);
		BizObjectQuery bq = bm1
				.createQuery("select count(*),sum(billsum) from o where objectNo=:objectNo and objectType=:objectType and serialNo<>:serialNo");
		BizObject bo1 = bq.setParameter("objectNo", sObjectNo)
				.setParameter("objectType", sObjectType).setParameter("serialNo", serialNo).getSingleResult(false);
		
		//count = bo1.getAttribute("1").getInt();//db2�¿��ã�oracle�º�̨����
		//billSum = bo1.getAttribute("2").getDouble();
		count = bo1.getAttribute(54).getInt();
		billSum = bo1.getAttribute(55).getDouble();
		
		//��ȡ��ؽ׶ε�ҵ���
		if (sObjectType.equals("CreditApply")) {
			bm2 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		} else if (sObjectType.equals("ApproveApply")) {
			bm2 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		} else if (sObjectType.equals("BusinessContract")) {
			bm2 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		}
		
		//�������ҵ����ֶ�ֵ
		bo2 = bm2.createQuery("serialNo=:serialNo")
				.setParameter("serialNo", sObjectNo).getSingleResult(true);
		bo2.setAttributeValue("BusinessSum", billSum);
		bo2.setAttributeValue("BillNum", count);
		bm2.saveObject(bo2);
		}
	}