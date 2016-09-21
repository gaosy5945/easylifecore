package com.amarsoft.app.als.apply.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * �����ļ��ϴ���������ɾ��
 * @author ������
 *
 */
public class DocLibraryListHandler extends CommonHandler {

	
	BizObject bo;
	BizObjectManager bm;
	JBOTransaction tx;
	protected void beforeDelete(JBOTransaction tx,BizObject bo) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_ATTACHMENT");
		BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.doc.DOC_RELATIVE");
		tx.join(bm1);
		tx.join(bm);
		bm.createQuery("delete from o where DocNo=:docNo").setParameter("docNo", bo.getAttribute("DocNo").getString())
		.executeUpdate();
		bm1.createQuery("delete from o where DocNo=:docNo").setParameter("docNo", bo.getAttribute("DocNo").getString())
		.executeUpdate();
	}
}
