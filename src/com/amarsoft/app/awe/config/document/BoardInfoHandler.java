package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class BoardInfoHandler extends CommonHandler {
	
	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		//流水号字段赋值，主键BoardNo已由JBOManager处理
		bo.setAttributeValue("DocNo", DBKeyHelp.getSerialNo("DOC_LIBRARY","DocNo",""));
	}
}
