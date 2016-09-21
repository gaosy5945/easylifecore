package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AttachmentAction {

	private String docNo;
	private String attachmentNo;

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public String getAttachmentNo() {
		return attachmentNo;
	}

	public void setAttachmentNo(String attachmentNo) {
		this.attachmentNo = attachmentNo;
	}

	public String deleteAttachment(JBOTransaction tx){
		try{
			//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
			Transaction Sqlca =Transaction.createTransaction(tx);
			DocumentManage.delDocFile("DOC_ATTACHMENT", "DocNo='"+docNo+"' and AttachmentNo='"+attachmentNo+"'",Sqlca);
			
			SqlObject asql = new SqlObject("delete from DOC_ATTACHMENT where DocNo = :DocNo and AttachmentNo = :AttachmentNo ");
			asql.setParameter("DocNo", docNo).setParameter("AttachmentNo", attachmentNo);
			Sqlca.executeSQL(asql);
			return "SUCCESS";
		} catch (Exception e) {
			ARE.getLog().debug("ɾ��ʧ�ܣ�");
			return "FAILED";
		}
	}
}
