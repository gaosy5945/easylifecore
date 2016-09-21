package com.amarsoft.app.als.appConfig;

import java.util.Date;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class BoardInfoHandler  extends CommonHandler  {

	/**
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("BOARDNO", DBKeyHelp.getSerialNo("BOARD_LIST","BOARDNO",""));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());//
		bo.setAttributeValue("INPUTUSERName", curUser.getUserName());//
		bo.setAttributeValue("SHOWTOORG", curUser.getOrgID());//
		bo.setAttributeValue("INPUTTIME",DateHelper.getBusinessDate());
		bo.setAttributeValue("INPUTORGName", curUser.getOrgName());
	}

	/**
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
	}

	/**
	 * ����ǰִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		String sObjectType = "jbo.sys.BOARD_LIST";
		String sObjectNo = bo.getAttribute("BOARDNO").getString();
		String sDocNo = inserDocLibrary(tx);
		if(StringX.isEmpty(sDocNo)){
			 ARE.getLog().debug("------------����DOC_LIBRARY���ɹ���------------");
		}else{
			sDocNo = insertDocRelative( tx, sDocNo, sObjectType, sObjectNo) ;
		}
		if(StringX.isEmpty(sDocNo)){
			 ARE.getLog().debug("------------����DOC_RELATIVE���ɹ���------------");
		}else{
			bo.setAttributeValue("DOCNO", sDocNo);
		}
		
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
	/**
	 * ����������DOC_LIBRARY
	 * @param 
	 * @throws Exception 
	 */
  	private String inserDocLibrary(JBOTransaction tx) throws Exception{
  		BusinessObjectManager businessObjectManager;
  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
		String sUserId = curUser.getUserID();
		String sOrgId = curUser.getOrgID();
		String sDocNo = DBKeyHelp.getSerialNo("DOC_LIBRARY","DOCNO","");
		try{
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_LIBRARY");
			//businessObjectManager.generateObjectNo(todo);
			todo.setAttributeValue("DOCNO", sDocNo);//
			todo.setAttributeValue("INPUTUSERID", sUserId);//
			todo.setAttributeValue("INPUTORGID", sOrgId);//
			todo.setAttributeValue("INPUTTIME", DateHelper.getBusinessDate());
			todo.setAttributeValue("UPDATEUSERIUD", sUserId);
			todo.setAttributeValue("UPDATETIME", DateHelper.getBusinessDate());
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//����PUB_TASK_INFO��Ϣ
			sDocNo = todo.getString("DOCNO");
			return sDocNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	
  	/**
	 * ����������DOC_RELATIVE
	 * @param 
	 * @throws Exception 
	 */
  	private String insertDocRelative(JBOTransaction tx,String sDocNo,String sObjectType,String sObjectNo ) throws Exception{
  		BusinessObjectManager businessObjectManager;
  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
		try{
			//sDOSerialNo = DBKeyHelp.getSerialNo("DOC_RELATIVE","DOCNO",""); 
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_RELATIVE");
			todo.generateKey();
			todo.setAttributeValue("DOCNO", sDocNo);
			todo.setAttributeValue("OBJECTTYPE", sObjectType);//
			todo.setAttributeValue("OBJECTNO", sObjectNo);//
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();
			sDocNo = todo.getString("DOCNO");
			return sDocNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	
}
