package com.amarsoft.app.als.customer.partner.handler;

import java.util.Date;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * 合作方机构详情处理类
 * @author dqchen
 *
 */
public class AgencyInfoHandler extends CommonHandler {
	//初始化部分参数
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		
		bo.setAttributeValue("InputDate", DateX.format(new Date()));
		bo.setAttributeValue("InputUserID", curUser.getUserID());
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());
		bo.setAttributeValue("SerialNo", DBKeyHelp.getSerialNo());
		bo.setAttributeValue("AgencyType", asPage.getParameter("AgencType"));
	}
	
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("UpdateDate", DateX.format(new Date()));
	}
}
