package com.amarsoft.app.als.docmanage.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class DocOutApproveAction {
	//����
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	/**
	 * ��������ͨ��
	 * @param tx
	 * @return
	 */
	public String doApprove(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sPTISerialNo = (String)inputParameter.getValue("PTISerialNo");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sDocType = (String)inputParameter.getValue("DocType");
		String sTransactionCode = (String)inputParameter.getValue("TransactionCode");
		String sOrgID = (String)inputParameter.getValue("OrgID");
		String sReturnFlag = "false";
		String sApproveFlag = doApprove(sPTISerialNo,sUserId);
		sReturnFlag = sApproveFlag;
		if(("true"==sApproveFlag || "true".equals(sApproveFlag))){
			boolean falg = updatePubTaskInfo( sPTISerialNo, sTransactionCode,  sUserId,  sOrgID);
			if(falg){
				sReturnFlag = "true";
			}
		} 
		return sReturnFlag;
	}
	
	
	/**
	 * �������������Ϣ��
	 * @param sPTISerialNo
	 * @param sTransactionCode
	 * @param sUserId
	 * @param sOrgID
	 * @return
	 */
	private boolean updatePubTaskInfo(String sPTISerialNo,String sTransactionCode, String sUserId, String sOrgID) {
		boolean flag = false;
  		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.PUB_TASK_INFO");
			BizObjectQuery bq = m.createQuery("update O set TASKTYPE=:TASKTYPE,OPERATEORGID=:OPERATEORGID,"
					+ "OPERATEUSERID=:OPERATEUSERID,OPERATEDATE=:OPERATEDATE,INPUTUSERID=:INPUTUSERID,"
					+ "INPUTORGID=:INPUTORGID,INPUTDATE=:INPUTDATE,Status=:Status WHERE serialNo=:SerialNo");
			int i = bq.setParameter("TASKTYPE",sTransactionCode)
					  .setParameter("OPERATEORGID", sOrgID)
					  .setParameter("OPERATEUSERID", sUserId)
					  .setParameter("OPERATEDATE", DateHelper.getBusinessDate())
					  .setParameter("INPUTUSERID", sUserId)
					  .setParameter("INPUTORGID", sOrgID)
					  .setParameter("INPUTDATE", DateHelper.getBusinessDate())
					  .setParameter("STATUS", "01")
					  .setParameter("SerialNo",sPTISerialNo).executeUpdate();	
			if(i>0){
				flag = true;
			}
			
		} catch(Exception e){ 
			e.printStackTrace();
			flag = false;
		}
		return flag ;
		
	}
	
	
	/**
	 * ���������˻�
	 * @param tx
	 * @return
	 * @throws Exception 
	 */
	public String doBack(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sPTISerialNo = (String)inputParameter.getValue("PTISerialNo");
		String sUserId = (String)inputParameter.getValue("UserId");
		if( doBack(sPTISerialNo,"04",sUserId)){
			return "true";
		}else{
			return "false";
		}
	}
	public boolean doBack(String sPTISerialNo,String sTatus,String sUserId) throws Exception{
		updateOperation(sPTISerialNo,sUserId,sTatus);
		return true;
	}
	/**
	 * ��������ͨ��
	 * @param sPTISerialNo
	 * @return
	 */
	public String doApprove(String sPTISerialNo,String sUserId)  throws Exception{
		//����PTISerialNo����DO������DO���� DFI��DFP
		BizObject dobo = updateOperation(sPTISerialNo, sUserId,"03");
		if(dobo!=null){
			String status = "04";
			if("0030".equals(dobo.getAttribute("TransactionCode").getString()))
			{
				status = "05";
			}
			updateFilePackage(dobo.getAttribute("ObjectNo").getString(), status);
			return "true";
		}else {
			return "false";
		}
	}
	
	/**
	 * ����PTISerialNo����DO
	 *     ����״̬��status��01,������ύ,02,������,03,����ͨ��
	 * @param sPTISerialNo
	 * @return
	 */
	public BizObject updateOperation(String sPTISerialNo,String userID,String status) throws Exception{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
		tx.join(bm);
		BizObject bo = bm.createQuery("  O.TASKSERIALNO=:TASKSERIALNO and O.TRANSACTIONCODE in('0020','0030') ").setParameter("TASKSERIALNO", sPTISerialNo).getSingleResult(true); 
		if(bo==null){
		} else {
			bo.setAttributeValue("Status", status);
			bo.setAttributeValue("OperateUserID", userID);
			bo.setAttributeValue("OperateDate", DateHelper.getBusinessDate());
			bm.saveObject(bo);
		}                            
		return  bo;
	}

	
	/**
	 * �������� DFP
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFilePackage(String sSerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("update O set LASTOPERATEDATE=UPDATEDATE,UPDATEDATE=:UPDATEDATE,Status=:Status where serialNo = :SerialNo");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sSerialNo).executeUpdate();	
			return true;
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
			return false;
		}
  	}	
	/**
	 * �������� DFI
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFileInfo(String sSerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_INFO");
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS where SerialNo in(:SerialNo)");
			bq.setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sSerialNo.replace("@", "','")).executeUpdate();	
			return true;
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
			return false;
		}
  	}	

	/**
	 * ����������Doc_Operation
	 * @param 
	 * @throws Exception 
	 */
  	private String insertDocOperation(String sPTISerialNo) throws Exception{
  		businessObjectManager =  this.getBusinessObjectManager();
  		String sObjectType = "";
  		String sObjectNo = "";
  		String sUseUserId = "";
  		String sUseOrgId = "";
  		String sDOSerialNo = "";
		String sUserId =  (String)inputParameter.getValue("UserId");
		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId)sUserId="";
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId)sOrgId="";
		
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			BizObject bo = bm.createQuery("  O.TASKSERIALNO=:TASKSERIALNO and O.TRANSACTIONCODE in('0020','0030') ").setParameter("TASKSERIALNO", sPTISerialNo).getSingleResult(false); 
			if(bo==null){
			} else {
				sDOSerialNo = bo.getAttribute("SERIALNO").getString();
				sObjectType = bo.getAttribute("OBJECTTYPE").getString();
				sObjectNo = bo.getAttribute("OBJECTNO").getString();
				sUseUserId = bo.getAttribute("USEUSERID").getString();
				sUseOrgId = bo.getAttribute("USEORGID").getString();
			}                            
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
			todo.generateKey();
			//todo.setAttributeValue("SERIALNO", sDOSerialNo);
			todo.setAttributeValue("TRANSACTIONCODE", "0070");//��ȡ
			todo.setAttributeValue("OBJECTTYPE", sObjectType);
			todo.setAttributeValue("OBJECTNO", sObjectNo);
			todo.setAttributeValue("OPERATEUSERID", sUseUserId);
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("USEUSERID", sUseUserId);
			todo.setAttributeValue("USEORGID", sUseOrgId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//����DOC_OPERATION��Ϣ
			sDOSerialNo = todo.getString("SERIALNO");
			return sDOSerialNo;
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
			return "";
		}
  	}	
  	
  	
  	/**
  	 * �������ú� ���ҵ������״̬
  	 * @param sDOSerialNO  ����������ˮ��
  	 * @param sStatus   ���óɹ����״̬ 06  ������
  	 * @return
  	 * @throws Exception
  	 */
  	public String  updateOperation(JBOTransaction tx){
  		String sDOSerialNO = (String) inputParameter.getValue("DOSerialNo");
  		String sUserID = (String) inputParameter.getValue("UserID");
  		String sReturnValue = " ";
		try {
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			tx.join(bm);
			BizObjectQuery bq = bm.createQuery("UPDATE O SET STATUS=:Status WHERE SERIALNO in (SELECT do.OBJECTNO FROM jbo.doc.DOC_OPERATION do WHERE do.SERIALNO =:SerialNo)");
			int i = bq.setParameter("Status", "06").setParameter("SerialNo", sDOSerialNO).executeUpdate();   
			if(i>0){
				sReturnValue = "true";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			sReturnValue = "false";
		}
  		return sReturnValue;
  	}
  	
  	
  	
  	
}
