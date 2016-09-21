package com.amarsoft.app.als.recoverymanage.action;

import java.util.Date;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class RelativeDocumentInfoHandler extends CommonHandler  {

	/**
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("DOCNO", DBKeyHelp.getSerialNo("DOC_LIBRARY","DOCNO",""));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
		bo.setAttributeValue("INPUTTIME", DateHelper.getBusinessDate());
		bo.setAttributeValue("UPDATEUSERIUD", curUser.getUserID());
		bo.setAttributeValue("UPDATETIME", DateHelper.getBusinessDate());
	}

	/**
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("UPDATEUSERIUD", curUser.getUserID());
		bo.setAttributeValue("UPDATETIME", DateHelper.getBusinessDate());
	}

	/**
	 * ����ǰִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		//String sPTISerialNo = inserPubTaskInfo(tx);
		//bo.setAttributeValue("TASKSERIALNO", sPTISerialNo);
	}

	/**
	 * �����ִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("UPDATEUSERIUD", curUser.getUserID());
		bo.setAttributeValue("UPDATETIME", DateHelper.getBusinessDate());
		String sSerialNo = asPage.getParameter("SerialNo");
		String sObjectTable = asPage.getParameter("ObjectTable");
		String sDOCNO = bo.getAttribute("DOCNO").getString();
		if(!StringX.isEmpty(sSerialNo) && !StringX.isEmpty(sObjectTable)&& !StringX.isEmpty(sDOCNO)){
			insertDL( tx, sSerialNo, sObjectTable, sDOCNO);
		}
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
		bo.setAttributeValue("UPDATEUSERIUD", curUser.getUserID());
		bo.setAttributeValue("UPDATETIME", DateHelper.getBusinessDate());
	}
	
	/**
	 * ����DL����Ϣ
	 * @param tx
	 * @return
	 * @throws Exception
	 */
  	@SuppressWarnings("deprecation")
	private String insertDL(JBOTransaction tx,String sSerialNo,String sObjectTable,String sDOCNO) throws Exception{
		try{
	 		BusinessObjectManager businessObjectManager;
	  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
	  		BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_RELATIVE");
			todo.setAttributeValue("DOCNO", sDOCNO);//���
			todo.setAttributeValue("OBJECTTYPE", sObjectTable);//
			todo.setAttributeValue("OBJECTNO", sSerialNo);//
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();
			return "true";
		} catch(Exception e){
			e.printStackTrace();
			return "false";
		}
  	}	
}
