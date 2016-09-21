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
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
	}

	/**
	 * �༭�����£���ʼ��
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
		bo.setAttributeValue("BOOKTYPE","110");//�˳��������̨��
*/	}

	/**
	 * ����ǰִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
	}
	/**
	 * �����ִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
	}
	/**
	 * ����ǰ�¼�
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
		bo.setAttributeValue("BOOKTYPE","110");//�˳��������̨��
	}

	/**
	 * ���º��¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

}
