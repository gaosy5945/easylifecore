package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ��Ŀ��ϸ��Ϣ������
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
