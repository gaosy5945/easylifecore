package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 项目详细信息处理类
 * @author Administrator
 *
 */

public class ProjectInfoHandler extends CommonHandler {
	
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("", "");
		bo.setAttributeValue("", "");
		bo.setAttributeValue("", "");
		bo.setAttributeValue("", "");
		bo.setAttributeValue("", "");
	}

}
