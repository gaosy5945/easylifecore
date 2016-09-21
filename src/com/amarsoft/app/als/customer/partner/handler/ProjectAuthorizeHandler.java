package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 委托人详情处理类
 * @author Administrator
 *
 */
public class ProjectAuthorizeHandler extends CommonHandler {
	
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		super.initDisplayForAdd(bo);
		
	}
	
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		super.afterInsert(tx, bo);
		String projectNo = asPage.getParameter("ProjectNo");
		new PartnerProjectInfo(projectNo).initProjectRelative(tx, CustomerConst.PARTNER_RELATIVE_TYPE_9,
				bo.getAttribute("serialNo").getString(), bo.getAttribute("ConsignerName").getString());
	}
}
