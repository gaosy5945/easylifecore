package com.amarsoft.app.als.report.model;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;


/**
 * ���鱨�����
 * @author  xfliu
 * 2014-04-22
 */
public class ReportManage {
	/**
	 * ��ȡ���鱨���¼����
	 * @param objectNo
	 * @param objectType
	 * @return
	 * @throws Exception 
	 */
	public static BizObject reportRecord(String objectNo,String objectType) throws Exception{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
		bq = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType);
		bo = bq.getSingleResult(false);
		return bo;
	}	
}
