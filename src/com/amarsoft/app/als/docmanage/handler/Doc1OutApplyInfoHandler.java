package com.amarsoft.app.als.docmanage.handler;

import java.util.Date;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class Doc1OutApplyInfoHandler  extends CommonHandler  {

	/**
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("OPERATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("STATUS", "00");//dfp.packageid :��Ϊû�з���Ȳ��������Խ��ø��ֶΣ���ʾ�ݴ�ĳ�����ˮ�š���do.status=00��ʾ�ݴ棬δ�ύ���⡣
		bo.setAttributeValue("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE");
		bo.setAttributeValue("OBJECTNO", asPage.getParameter("DFPSerialNo"));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("doc_operation","serialNo",""));
	}

	/**
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
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
		String sPTISerialNo = inserPubTaskInfo(tx);
		bo.setAttributeValue("TASKSERIALNO", sPTISerialNo);
	}
	/**
	 * ����������PUB_TASK_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private String inserPubTaskInfo(JBOTransaction tx) throws Exception{
  		BusinessObjectManager businessObjectManager;
  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
		String sPTISerialNo = "";
		String sUserId = curUser.getUserID();
		String sOrgId = curUser.getOrgID();
		try{
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.app.PUB_TASK_INFO");
			//businessObjectManager.generateObjectNo(todo);
			todo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SerialNo",""));//���
			todo.setAttributeValue("TASKTYPE", "����");//
			todo.setAttributeValue("OPERATEDESCRIPTION", "");//
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OPERATEUSERID", sUserId);
			todo.setAttributeValue("OPERATEORGID", sOrgId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//����PUB_TASK_INFO��Ϣ
			sPTISerialNo = todo.getString("SERIALNO");
			return sPTISerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
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
		/*String sUseUserId = bo.getAttribute("USEUSERID").getString();
		String sUseOrgId = bo.getAttribute("USEORGID").getString();
		String sObjectType = bo.getAttribute("OBJECTTYPE").getString();
		String sObjectNo = bo.getAttribute("OBJECTNO").getString();
		String sPTISerialNo = bo.getAttribute("TASKSERIALNO").getString();
		if(!StringX.isEmpty(sUseUserId) || !StringX.isEmpty(sUseOrgId)){
			insertDocOperation( tx, sObjectType, sObjectNo,sPTISerialNo,sUseUserId);
		}*/
		String sNextDOSerialNo = bo.getAttribute("SERIALNO").getString();
		String sDFPSerialNo = bo.getAttribute("OBJECTNO").getString();
		if(!StringX.isEmpty(sNextDOSerialNo) || !StringX.isEmpty(sDFPSerialNo)){
			//updateDFP( sNextDOSerialNo, sDFPSerialNo);
		}
	}
	/**
	 * ����������Doc_Operation
	 * @param 
	 * @throws Exception 
	 */
  	private String insertDocOperation(JBOTransaction tx,String sObjectType,String sObjectNo,String sPTISerialNo,String sUseUserId) throws Exception{
  		BusinessObjectManager businessObjectManager;
  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
		String sDOSerialNo = "";
		String sUserId = curUser.getUserID();
		try{
			//sDOSerialNo = DBKeyHelp.getSerialNo("Doc_Operation","SerialNo",""); 
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
			todo.generateKey();
			//todo.setAttributeValue("SERIALNO", sDOSerialNo);
			todo.setAttributeValue("TRANSACTIONCODE", "0070");//���
			todo.setAttributeValue("TASKSERIALNO", sPTISerialNo);//���
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OBJECTTYPE", sObjectType);
			todo.setAttributeValue("OBJECTNO", sObjectNo);
			todo.setAttributeValue("OPERATEUSERID", sUseUserId);
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//����DOC_OPERATION��Ϣ
			sDOSerialNo = todo.getString("SERIALNO");
			return sDOSerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
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
	}

	//add by lzq 20150331 ����DFP��packageID ��dfp.packageid :��Ϊû�з���Ȳ��������Խ��ø��ֶΣ���ʾ�ݴ�ĳ�����ˮ�š���do.status=0��ʾ�ݴ棬δ�ύ���⡣
	private String updateDFP(String sNextDOSerialNo,String sDFPSerialNo) throws Exception{
		String sReturnFlag = "";
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("UPDATE O SET PACKAGEID=:PACKAGEID WHERE SERIALNO =:SERIALNO");
			bq.setParameter("PACKAGEID",sNextDOSerialNo)
			  .setParameter("SERIALNO", sDFPSerialNo).executeUpdate();	
			sReturnFlag = "true";
		} catch(Exception e){
			e.printStackTrace();
			sReturnFlag = "false";
		}
		return sReturnFlag;
	}
}
