package com.amarsoft.app.als.recoverymanage.handler;

import java.util.Date;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.cache.NameCache;

public class OutCloseDownAssetInfo extends CommonHandler   {
	/**
	 * 新增初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
	}

	/**
	 * 编辑（更新）初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
/*		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEORGID", curUser.getOrgID());
		bo.setAttributeValue("OPERATEORGNAME", curUser.getOrgName());
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("WITHDRAWDATE", DateX.format(new Date()));
		bo.setAttributeValue("BOOKTYPE","110");//退出查封类型台账
*/	}

	/**
	 * 插入前执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
	}
	/**
	 * 插入后执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
	}
	/**
	 * 更新前事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEORGID", curUser.getOrgID());
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("WITHDRAWDATE", DateX.format(new Date()));
		bo.setAttributeValue("BOOKTYPE","110");//退出查封类型台账
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
