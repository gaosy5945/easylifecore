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
	 * 新增初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("OPERATEDATE", DateX.format(new Date()));
		bo.setAttributeValue("STATUS", "00");//dfp.packageid :因为没有封包等操作，所以借用该字段，表示暂存的出库流水号。用do.status=00表示暂存，未提交出库。
		bo.setAttributeValue("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE");
		bo.setAttributeValue("OBJECTNO", asPage.getParameter("DFPSerialNo"));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("OPERATEUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("OPERATEUSERNAME", curUser.getUserName());
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
	 * 插入前执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		String sPTISerialNo = inserPubTaskInfo(tx);
		bo.setAttributeValue("TASKSERIALNO", sPTISerialNo);
	}
	/**
	 * 插入数据至PUB_TASK_INFO
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
			todo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SerialNo",""));//入库
			todo.setAttributeValue("TASKTYPE", "出库");//
			todo.setAttributeValue("OPERATEDESCRIPTION", "");//
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OPERATEUSERID", sUserId);
			todo.setAttributeValue("OPERATEORGID", sOrgId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//新增PUB_TASK_INFO信息
			sPTISerialNo = todo.getString("SERIALNO");
			return sPTISerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	
	/**
	 * 插入后执行事件
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
	 * 插入数据至Doc_Operation
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
			todo.setAttributeValue("TRANSACTIONCODE", "0070");//入库
			todo.setAttributeValue("TASKSERIALNO", sPTISerialNo);//入库
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OBJECTTYPE", sObjectType);
			todo.setAttributeValue("OBJECTNO", sObjectNo);
			todo.setAttributeValue("OPERATEUSERID", sUseUserId);
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//新增DOC_OPERATION信息
			sDOSerialNo = todo.getString("SERIALNO");
			return sDOSerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	
	/**
	 * 更新前事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
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

	//add by lzq 20150331 更新DFP的packageID ，dfp.packageid :因为没有封包等操作，所以借用该字段，表示暂存的出库流水号。用do.status=0表示暂存，未提交出库。
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
