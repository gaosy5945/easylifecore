package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.Transaction;

/**
 * �Զ�����̽�����ݴ�״̬���
 * 
 * @author ckxu
 * @since 2015/12/21
 *
 */
public class MarketCustomerSaveFlagCheck extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		// ��ȡ�������������ͺͶ�����
		String flowSerialNo = (String) this.getAttribute("FlowSerialNo");
		if (flowSerialNo == null) {
			putMsg("���������Ϣδ�ҵ������飡");
			setPass(false);
			return false;
		}
		// ��ȡ��Ŀ��ϢȻ���ȡ�ͻ���Ϣ
		// ��ȡCustomerrID
		@SuppressWarnings("unchecked")
		List<BizObject> bos = JBOFactory
				.createBizObjectQuery("jbo.flow.FLOW_BUSINESSINFO",
						"FlowSerialNo=:FlowSerialNo")
				.setParameter("FlowSerialNo", flowSerialNo)
				.getResultList(false);
		if (bos == null || bos.size() < 1) {
			putMsg("���������Ϣδ�ҵ������飡");
			setPass(false);
			return false;
		}
		BusinessObject ba = BusinessObject.convertFromBizObject(bos.get(0));
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		BusinessObject ent = bom.loadBusinessObject("jbo.customer.ENT_INFO",
				"CUSTOMERID", ba.getAttribute("CustomerID").getString());
		String tempSave = ent.getAttribute("TEMPSAVEFLAG").getString();
		if (ent != null && tempSave.equals("1"))
			putMsg("�����ˡ�" + ba.getString("CustomerName") + "����Ϣ״̬Ϊ�ݴ棬�뱣����Ϣ");

		/* ���ؽ������ */
		if (messageSize() > 0)
			setPass(false);
		else
			setPass(true);
		return false;
	}
}
