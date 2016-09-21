package com.amarsoft.app.als.customer.partner.handler;

import java.util.Date;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 初始化code配置模板参数
 * @author Administrator
 *
 */

public class CodeDeployHandler extends CommonHandler {
	
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("CodeNo", asPage.getParameter("CodeNo"));
		bo.setAttributeValue("InputUser", curUser.getUserID());
		bo.setAttributeValue("InputTime", DateX.format(new Date()));
		bo.setAttributeValue("InputOrg", curUser.getOrgID());

	}
	
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)throws Exception {
		bo.setAttributeValue("UpdateTime", DateX.format(new Date()));
		bo.setAttributeValue("UpdateUser", curUser.getUserID());
		bo.setAttributeValue("SortNo", bo.getAttribute("ItemNo"));
	}
}
