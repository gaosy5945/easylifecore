package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class ImportTodoListHandler extends CommonHandler{

	public  void afterInsert(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			String objectType = "jbo.customer.CUSTOMER_LIST";
			String operateOrgID = bo.getAttribute("OPERATEORGID").getString();
			String operateUserID = bo.getAttribute("OPERATEUSERID").getString();
			String phaseOpinion = bo.getAttribute("PHASEOPINION").getString();
			String inputDate = bo.getAttribute("INPUTDATE").getString();
			String inputOrgID = bo.getAttribute("INPUTORGID").getString();
			String inputUserID = bo.getAttribute("INPUTUSERID").getString();
			String serialNo=bo.getAttribute("SERIALNO").toString();
			String todoType=bo.getAttribute("TODOTYPE").toString();
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
			tx.join(bm);
			BizObject bo1=bm.newObject();
			bo1.setAttributeValue("TRACEOBJECTTYPE", objectType);
			bo1.setAttributeValue("TRACEOBJECTNO", serialNo);
			bo1.setAttributeValue("OPERATEORGID", operateOrgID);
			bo1.setAttributeValue("OPERATEUSERID", operateUserID);
			bo1.setAttributeValue("PHASEOPINION",phaseOpinion);
			bo1.setAttributeValue("INPUTDATE",inputDate);
			bo1.setAttributeValue("INPUTORGID",inputOrgID);
			bo1.setAttributeValue("INPUTUSERID",inputUserID);
			bo1.setAttributeValue("TODOTYPE",todoType);
			bm.saveObject(bo1);
		}catch(Exception e){
			tx.rollback();
		}
	}
	
}
