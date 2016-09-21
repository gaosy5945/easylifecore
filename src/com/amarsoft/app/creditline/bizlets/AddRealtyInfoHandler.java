package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class AddRealtyInfoHandler extends CommonHandler{

	/**
	 * @gftang 2013-11-21
	 * 
	 * 业务申请插入房屋用途信息同时插入关联信息
	 */
	public  void afterInsert(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			/*
			 * 业务申请插入房屋用途信息同时插入关联信息
			 * */
			String sObjectType = asPage.getParameter("ObjectType");
			String sObjectNo=asPage.getParameter("ObjectNo");
			String serialNo=bo.getAttribute("SERIALNO").toString();
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.REALTY_RELATIVE");
			tx.join(bm);
			BizObject bo1=bm.newObject();
			bo1.setAttributeValue("SERIALNO",serialNo);
			bo1.setAttributeValue("OBJECTTYPE", sObjectType);
			bo1.setAttributeValue("OBJECTNO", sObjectNo);
			bm.saveObject(bo1);
		}catch(Exception e){
			tx.rollback();
		}
	}
}