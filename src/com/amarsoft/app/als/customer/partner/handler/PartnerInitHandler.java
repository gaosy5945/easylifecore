package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * �������ͻ���ʼ���Ȳ���
 * @author Administrator
 *
 */
public class PartnerInitHandler extends CommonHandler {
	
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("PartnerType", asPage.getParameter("PartnerType"));
	}

	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		//new CustomerPartner(tx,bo,curUser).save();
	}

}
