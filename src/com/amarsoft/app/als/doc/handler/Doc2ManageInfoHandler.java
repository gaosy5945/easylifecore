package com.amarsoft.app.als.doc.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class Doc2ManageInfoHandler extends CommonHandler{
	
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		BizObjectManager bomdfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
		tx.join(bomdfp);
		BizObjectQuery boqdfp = bomdfp.createQuery(" SerialNo in(select DO.ObjectNo from jbo.doc.DOC_OPERATION DO where DO.SerialNo = :SerialNo) ");
		boqdfp.setParameter("SerialNo", bo.getAttribute("SerialNo").getString());
		BizObject bodfp = boqdfp.getSingleResult(true);
		if(bodfp != null)
		{
			bodfp.setAttributeValue("POSITION", bo.getAttribute("POSITION").getString());
		}
		bomdfp.saveObject(bodfp);
	}

}
