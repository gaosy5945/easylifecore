package com.amarsoft.app.awe.config.dw.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class QuickMenuInfoHandler extends CommonHandler {

	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String sMenuName = asPage.getParameter("MenuName");
		
		bo.setAttributeValue("ForUser", curUser.getUserID());
		bo.setAttributeValue("QuickName", sMenuName);
		bo.setAttributeValue("QuickParams", asPage.getParameter("MenuID"));
		bo.setAttributeValue("MenuName", sMenuName);
	}
}
