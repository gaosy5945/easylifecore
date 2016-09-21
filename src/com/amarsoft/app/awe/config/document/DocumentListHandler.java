package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.Transaction;

public class DocumentListHandler extends CommonHandler {
	@Override
	protected void beforeDelete(JBOTransaction tx, BizObject bo)
			throws Exception {
		//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
		DocumentManage.delDocFile("DOC_ATTACHMENT", "DocNo='"+bo.getAttribute("DocNo").getString()+"'", Transaction.createTransaction(tx));
	}
	
	@Override
	protected void afterDelete(JBOTransaction tx, BizObject bo)
			throws Exception {
		DocumentManage.delDocRelative(bo.getAttribute("DocNo").getString(), Transaction.createTransaction(tx));
	}
}
