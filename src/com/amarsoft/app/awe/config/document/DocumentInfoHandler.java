package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class DocumentInfoHandler extends CommonHandler {

	/**
	 *  ���������ʼ������
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		
		bo.setAttributeValue("UserID",curUser.getUserID());
		bo.setAttributeValue("UserName",curUser.getUserName());
		bo.setAttributeValue("OrgID", curUser.getOrgID());
		bo.setAttributeValue("OrgName", curUser.getOrgName());
		bo.setAttributeValue("DocImportance","01");
		bo.setAttributeValue("DocDate",DateX.format(new java.util.Date()));
	}
	
	/**
	 * ��Ч�Լ��
	 */
	protected boolean validityCheck(BizObject bo, boolean isInsert) {
		try {
			//У����������Ƿ���ڵ�ǰ����
			String sDocDate = bo.getAttribute("DocDate").getString(); //��������
			String sToday = StringFunction.getToday(); //��ǰ����
			if (!StringX.isEmpty(sDocDate) && sDocDate.compareTo(sToday) > 0){
				errors = "�������ڱ������ڵ�ǰ���ڣ�";
				return false;
			}
		} catch (JBOException e) {
			ARE.getLog().debug(e);
			errors = e.getMessage();
			return false;
		}
		return true;
	}
	
	protected void afterInsert(com.amarsoft.are.jbo.JBOTransaction tx, BizObject bo) throws Exception {
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.DOC_RELATIVE");
		BizObject dr = bm.newObject();
		dr.setAttributeValue("DocNo", dr.getAttribute("DocNo").getString());
		dr.setAttributeValue("ObjectType", dr.getAttribute("ObjectType").getString());
		dr.setAttributeValue("ObjectNo", dr.getAttribute("ObjectNo").getString());
		bm.saveObject(dr);
	};
}
