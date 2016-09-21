package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 账户处理类
 * @author Administrator
 *
 */
public class ProjectAccountHandler extends CommonHandler {
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		super.initDisplayForAdd(bo);
		bo.setAttributeValue("objectNo", asPage.getParameter("ObjectNo"));
		bo.setAttributeValue("objectType","Project");
	}

}
