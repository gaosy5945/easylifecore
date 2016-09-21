package com.amarsoft.app.als.docmanage.handler;

import java.util.Date;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class Doc2OutApplyInfoHandler extends CommonHandler  {

	/**
	 * 新增初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("OPERATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("STATUS", "01");
		bo.setAttributeValue("OBJECTTYPE", "jbo.app.BUSINESS_CONTRACT");
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
		bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("doc_operation","serialNo",""));
	}

	/**
	 * 编辑（更新）初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		//bo.setAttributeValue("INPUTUSERNAME", NameManager.getUserName(bo.getAttribute("INPUTUSERID").getString()));
		//bo.setAttributeValue("OPERATEUSERNAME",NameManager.getUserName(bo.getAttribute("OPERATEUSERID").getString()));
	}


	
	/**
	 * 更新前事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		if(bo.getAttribute("TASKSERIALNO").getString() == null 
			|| "".equals(bo.getAttribute("TASKSERIALNO").getString()))
		{
			bo.setAttributeValue("TASKSERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SERIALNO",""));
		}
	}

	/**
	 * 更新后事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

}
