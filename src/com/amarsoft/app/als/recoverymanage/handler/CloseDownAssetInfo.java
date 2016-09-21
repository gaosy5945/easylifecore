package com.amarsoft.app.als.recoverymanage.handler;

import java.util.Date;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.cache.NameCache;

public class CloseDownAssetInfo extends CommonHandler   {
	/**
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String sLISerialNo = asPage.getParameter("LAWCASESERIALNO");
		bo.setAttributeValue("BOOKTYPE","100");//�������̨��
		bo.setAttributeValue("LAWCASESERIALNO",sLISerialNo);
		bo.setAttributeValue("LAWCASENAME",NameCache.getName("LAWCASE_INFO", "LAWCASENAME", "SERIALNO", sLISerialNo));
		bo.setAttributeValue("APPDATE",DateX.format(new Date()));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEORGID", curUser.getOrgID());
		bo.setAttributeValue("OPERATEORGNAME", curUser.getOrgName());
		bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("doc_operation","serialNo",""));
	}

	/**
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEORGID", curUser.getOrgID());
		bo.setAttributeValue("OPERATEORGNAME", curUser.getOrgName());
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
		//bo.setAttributeValue("INPUTUSERNAME", NameManager.getUserName(bo.getAttribute("INPUTUSERID").getString()));
		//bo.setAttributeValue("OPERATEUSERNAME",NameManager.getUserName(bo.getAttribute("OPERATEUSERID").getString()));
	}

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
