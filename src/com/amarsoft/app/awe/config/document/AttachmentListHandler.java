package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.Transaction;

public class AttachmentListHandler extends CommonHandler {
	@Override
	protected void beforeDelete(JBOTransaction tx, BizObject bo)
			throws Exception {
		String sDocNo = bo.getAttribute("DocNo").getString();
		String sAttachmentNo = bo.getAttribute("AttachmentNo").getString();
		
		//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
		DocumentManage.delDocFile("DOC_ATTACHMENT", "DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'", Transaction.createTransaction(tx));
	}
}
