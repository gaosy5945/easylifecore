package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * ������Ϣ���洦����
 * @author Administrator
 *
 */

public class WarterCraftInfoHandler extends CommonHandler {
	
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		String serialno = asPage.getParameter("SerialNo");
		//����������ϵ
		new PartnerProjectInfo(serialno).
			initProjectRelative(tx, CustomerConst.PARTNER_RELATIVE_TYPE_7, bo.getAttribute("SerialNo").getString(), "");
	}

}
