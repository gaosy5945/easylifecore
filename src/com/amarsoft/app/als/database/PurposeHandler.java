package com.amarsoft.app.als.database;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class PurposeHandler extends CommonHandler{

	/**
	 * @sldong
	 * ���ݱ�ɾ��������ϵ����
	 * 1.ɾ��������ݹ�����
	 * 2.ɾ��������ݽṹ��
	 * 3.ɾ����ؼ���ָ���
	 */
	public  void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			String sTbName=bo.getAttribute("TBNO").toString();
			//ɾ��������ݹ�����
			BizObjectManager m0=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			tx.join(m0);
			BizObjectQuery bq1=m0.createQuery("Delete From o Where (SourceTBName = :TableName or RelaTBName = :TableName or DestTBName = :TableName)").setParameter("TableName", sTbName);
			bq1.executeUpdate();
			//ɾ��������ݽṹ��
			BizObjectManager m1=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_METADATA");
			tx.join(m1);
			BizObjectQuery bq2 = m1.createQuery("Delete From o Where TBName = :TableName").setParameter("TableName", sTbName);
			bq2.executeUpdate();
			//ɾ����ؼ���ָ���
			BizObjectManager m2 = JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_PERFORMANCE");
			tx.join(m2);
			BizObjectQuery bq3 = m2.createQuery("Delete From o Where TBName = :TableName").setParameter("TableName", sTbName);
			bq3.executeUpdate();
		}catch (Exception e){
			tx.rollback();
		}
	}

}