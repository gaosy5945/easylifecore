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
	 * 数据表删除后续关系处理
	 * 1.删除相关数据关联表
	 * 2.删除相关数据结构表
	 * 3.删除相关技术指标表
	 */
	public  void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			String sTbName=bo.getAttribute("TBNO").toString();
			//删除相关数据关联表
			BizObjectManager m0=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			tx.join(m0);
			BizObjectQuery bq1=m0.createQuery("Delete From o Where (SourceTBName = :TableName or RelaTBName = :TableName or DestTBName = :TableName)").setParameter("TableName", sTbName);
			bq1.executeUpdate();
			//删除相关数据结构表
			BizObjectManager m1=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_METADATA");
			tx.join(m1);
			BizObjectQuery bq2 = m1.createQuery("Delete From o Where TBName = :TableName").setParameter("TableName", sTbName);
			bq2.executeUpdate();
			//删除相关技术指标表
			BizObjectManager m2 = JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_PERFORMANCE");
			tx.join(m2);
			BizObjectQuery bq3 = m2.createQuery("Delete From o Where TBName = :TableName").setParameter("TableName", sTbName);
			bq3.executeUpdate();
		}catch (Exception e){
			tx.rollback();
		}
	}

}