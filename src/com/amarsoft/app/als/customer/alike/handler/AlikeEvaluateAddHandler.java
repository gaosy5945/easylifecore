package com.amarsoft.app.als.customer.alike.handler;

import java.util.List;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * ��ʼ�����ڿͻ�������Ϣ����Ҫ��
 * @author wmZhu
 * @date 2014-4-23
 */
public class AlikeEvaluateAddHandler extends CommonHandler{

	@SuppressWarnings("deprecation")
	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("ObjectNo", asPage.getParameter("CustomerID"));
		bo.setAttributeValue("ObjectType", asPage.getParameter("ObjectType"));
		bo.setAttributeValue("UserID", curUser.getUserID());
		bo.setAttributeValue("OrgID", curUser.getOrgID());
		bo.setAttributeValue("EvaluateDate", StringFunction.getToday());
	}

	@Override
	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("EVALUATE_RECORD", "SERIALNO"));
	}

	@Override
	protected void beforeDelete(JBOTransaction tx, BizObject bo)
			throws Exception {
		String serialNo = bo.getAttribute("SerialNo").getString();
		String objectType = bo.getAttribute("ObjectType").getString();
		String objectNo = bo.getAttribute("ObjectNo").getString();
		//ɾ��������ϸ��Ϣ
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.EVALUATE_DATA);
		tx.join(bom);
		@SuppressWarnings("unchecked")
		List<BizObject> list = bom.createQuery("SerialNo=:serialNo and ObjectType=:objectType and ObjectNo=:objectNo")
						.setParameter("serialNo", serialNo).setParameter("objectType", objectType)
						.setParameter("objectNo", objectNo).getResultList(true);
		for (BizObject bizObject : list) {
			bom.deleteObject(bizObject);
		}
	}
}
