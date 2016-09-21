package com.amarsoft.app.urge;

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
import com.amarsoft.awe.util.DBKeyHelp;

public class CollSelectListAction {
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
	 * ������䣬��������գ������Σ����䣬����CT������Ϣ
	 * @param tx
	 * @return
	 */
	public String collSelectAllot(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sCTSerialNoList = (String)inputParameter.getValue("CTSerialNoList");
		try {
			sReturnValues = updateCT( "", sOperateUserId, sOperateOrgId, sUserId, sOrgId,sCTSerialNoList,"1");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * ������� ��������գ����Σ���1.����PTI������Ϣ��2.����CT������Ϣ
	 * @param tx
	 * @return
	 */
	public String outCollSelectAllot(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sCTSerialNoList = (String)inputParameter.getValue("CTSerialNoList");
		String sTaskName = (String)inputParameter.getValue("TaskName"); 
		String sTaskSerialNo=(String)inputParameter.getValue("TaskSerialNo");
		//��ѯ�Ƿ���ڵ�ǰ�������κ�
		String IsHaveFlag="no";
		String sPTISerialNo="";
		BizObjectManager bmcl;
		try {
			bmcl = JBOFactory.getBizObjectManager("jbo.app.PUB_TASK_INFO");
			BizObjectQuery boqcl = bmcl.createQuery("O.SERIALNO=:TASKSERIALNO");
			boqcl.setParameter("TASKSERIALNO", sTaskSerialNo);
			BizObject bocl = boqcl.getSingleResult(false);
			if(bocl!=null)
			{
				IsHaveFlag="yes";
			}else{
				IsHaveFlag="no";
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		if("yes".equals(IsHaveFlag)){
			sPTISerialNo=sTaskSerialNo;
		}else{
			sPTISerialNo= inserPubTaskInfo( sOrgId, sUserId, sOperateUserId, sOperateOrgId, sTaskName);
		}
		if("".equals(sPTISerialNo) || sPTISerialNo.length() == 0){
			
		}else{
			sReturnValues = updateCT( sPTISerialNo, sOperateUserId, sOperateOrgId, sUserId, sOrgId,sCTSerialNoList,"1");
		}
		return sReturnValues;
	}
	
	/**
	 * ��������������
	 * @param tx
	 * @return
	 */
	public String outCollChange(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sReturnValues = "false";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sPTISerialNoList = (String)inputParameter.getValue("PTISerialNoList");
		String sPTIReturn = updatePTI(sPTISerialNoList,sOperateUserId);
		if("true".equals(sPTIReturn) || sPTIReturn == "true"){
			sReturnValues = updateCTOperator( sPTISerialNoList, sOperateUserId, sUserId,"1");
		}
		return sReturnValues;
	}
	/**
	 * �����������
	 * @param tx
	 * @return
	 */
	public String CollChange(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "false";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sCTSerialNoList = (String)inputParameter.getValue("CTSerialNoList");
		sReturnValues = updateCTOperateUserId( sCTSerialNoList, sOperateUserId, sUserId,"1");
		return sReturnValues;
	}
	
	public String closeColl(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "false";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sSerialNoList = (String)inputParameter.getValue("SerialNoList");
		String closeType = (String)inputParameter.getValue("CloseType");
		sReturnValues = closeCT( sSerialNoList, sUserId, closeType);
		return sReturnValues;
	}
	
	/**
	 * ɾ��PTI
	 * @param sPTISerialNo
	 */
	public void deletePTI(String sPTISerialNo){
		BizObjectManager m;
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.PUB_TASK_INFO");
			m.createQuery("delete O where serialno = '"+sPTISerialNo+"' ").executeUpdate();	
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * ����������PUB_TASK_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private String inserPubTaskInfo(String sOrgId,String sUserId,String sOperationUserId,String sOperationOrgId,String sTaskName){
  		String sPTISerialNo="";
		try{
			businessObjectManager =  this.getBusinessObjectManager();
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.app.PUB_TASK_INFO");
			todo.generateKey();
			todo.setAttributeValue("OPERATEDESCRIPTION", "�������");
			todo.setAttributeValue("TASKTYPE", "�������");
			todo.setAttributeValue("TASKNAME", sTaskName);//���
			todo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SERIALNO",""));//���
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OPERATEUSERID", sOperationUserId);
			todo.setAttributeValue("OPERATEORGID", sOperationOrgId);
			todo.setAttributeValue("STATUS", "01");
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("INPUTORGID", sOrgId);
			todo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());

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
  	 * ����ѡ�����ε�ִ������Ϣ��
  	 * @param sPTISerialNoList
  	 * @param sOperateUserId
  	 * @return
  	 * @throws Exception 
  	 */
  	public String updatePTI(String sPTISerialNoList,String sOperateUserId) throws Exception{
  		String sReturnFlag = "false";
  		BizObjectManager m;
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.PUB_TASK_INFO");
			BizObjectQuery bq = m.createQuery("update O set  OPERATEUSERID=:OPERATEUSERID,UPDATEDATE=:UPDATEDATE where serialNo in(:SerialNo)");
			bq.setParameter("OPERATEUSERID",sOperateUserId).setParameter("UPDATEDATE",DateHelper.getBusinessDate()).setParameter("SerialNo", sPTISerialNoList.replace("@", "','")).executeUpdate();	
			sReturnFlag = "true";
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			sReturnFlag = "false";
		}
  		return sReturnFlag;
  	}
  	
  	/**
  	 * �ر�����
  	 * @param sSerialNoList ��ˮ��
  	 * @param sUserId �Ǽ���
  	 * @param closeType  �ر����ͣ�1-���У�2-���У�3-�����������
  	 * @return
  	 */
  	public String closeCT(String sSerialNoList,String sUserId,String closeType){
  		String sReturnFlag = "false";
  		BizObjectManager m;
  		String sWhereSql = " 1=2 ";
  		if("3".equals(closeType) || "3" == closeType){
  			sWhereSql = " TASKBATCHNO in('"+sSerialNoList.replace("@", "','")+"') ";
  		}else if("2".equals(closeType) || "2" == closeType){
  			sWhereSql = " SerialNo in('"+sSerialNoList.replace("@", "','")+"') ";
  		}else if("1".equals(closeType) || "1" == closeType){
  			sWhereSql = " SerialNo in('"+sSerialNoList.replace("@", "','")+"') ";
  		}
		try {
			m = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
			m.createQuery("update O set  STATUS='5' where " + sWhereSql).executeUpdate();	
			sReturnFlag = "true";
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			sReturnFlag = "false";
		}
  		return sReturnFlag;
  	}
  	
  	/**
  	 * ����ѡ�����εĴ�����Ϣ
  	 * @param sPTISerialNoList
  	 * @param sOperateUserId
  	 * @param sUserId
  	 * @return
  	 */
  	public String updateCTOperator(String sPTISerialNoList,String sOperateUserId,String sUserId,String sStatus){
  		String sReturnFlag = "false";
  		BizObjectManager m;
		try {
			m = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
			BizObjectQuery bq = m.createQuery("update O set  OPERATEUSERID=:OPERATEUSERID ,STATUS=:STATUS where TASKBATCHNO in(:TASKBATCHNO)");
			bq.setParameter("OPERATEUSERID",sOperateUserId).setParameter("STATUS",StringX.isEmpty(sStatus)? "0":sStatus).setParameter("TASKBATCHNO", sPTISerialNoList.replace("@", "','")).executeUpdate();	
			sReturnFlag = "true";
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			sReturnFlag = "false";
		}
  		return sReturnFlag;
  	}
  	/**
  	 * ����ѡ��de������Ϣ
  	 * @param sCTSerialNoList
  	 * @param sOperateUserId
  	 * @param sUserId
  	 * @return
  	 */
  	public String updateCTOperateUserId(String sCTSerialNoList,String sOperateUserId,String sUserId,String sStatus){
  		String sReturnFlag = "false";
  		BizObjectManager m;
		try {
			m = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
			BizObjectQuery bq = m.createQuery("update O set  OPERATEUSERID=:OPERATEUSERID,STATUS=:STATUS  where SerialNo in(:SerialNo)");
			bq.setParameter("OPERATEUSERID",sOperateUserId).setParameter("STATUS",StringX.isEmpty(sStatus)? "0":sStatus).setParameter("SerialNo", sCTSerialNoList.replace("@", "','")).executeUpdate();	
			sReturnFlag = "true";
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			sReturnFlag = "false";
		}
  		return sReturnFlag;
  	}
  	/**
  	 * ����CT����Ϣ
  	 * @param sTaskBatchNo  ���κţ�ֻ��������յ�ʱ�򴫵�Ϊ�ǿգ�
  	 * @param sOperateUserId �����ˣ�ִ����/��������
  	 * @param sOperateOrgId	��������������У�����û�У�
  	 * @param sUserId �Ǽ���
  	 * @param sOrgId �Ǽǻ���
  	 * @param sCTSerialNoList ������ˮ�� �� ��@���ŷָ�
  	 * @param sStatus ������Ϣ״̬��0-�����գ�δ������䣩��1-�����У�Ϊ���յǼǣ���2-��ִ�У��ѵǼǴ��ս������5-�ѹرգ�����ල�йر����񣩣�3-��ŵ���4-�ѻ���
  	 * @return
  	 */
  	public String updateCT(String sTaskBatchNo,String sOperateUserId,String sOperateOrgId,String sUserId,String sOrgId,String sCTSerialNoList,String sStatus) {
  		String sReturnFlag = "false";
  		StringBuffer sSetSql = new StringBuffer();
  		try{
  	  		sSetSql.append(" OPERATEUSERID='").append(sOperateUserId).append("' ");
  	  		sSetSql.append(",").append(" OPERATEORGID='").append(sOperateOrgId).append("' ");
  	  		sSetSql.append(",").append(" INPUTUSERID='").append(sUserId).append("' ");
  	  		sSetSql.append(",").append(" INPUTORGID='").append(sOrgId).append("' ");
  	  		if("".equals(sTaskBatchNo)||sTaskBatchNo.length() == 0){
  	  			sSetSql.append(",").append(" COLLECTIONMETHOD='' ");
  	  		}else{
  	  			sSetSql.append(",").append(" TASKBATCHNO='").append(sTaskBatchNo).append("' ");
  	  			sSetSql.append(",").append(" COLLECTIONMETHOD='5' ");
  	  		}
	  		sSetSql.append(",").append(" INPUTDATE='").append(DateHelper.getBusinessDate()).append("' ");
	  		sSetSql.append(",").append(" STATUS='").append(StringX.isEmpty(sStatus)? "0":sStatus).append("' ");
	  		
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
  			BizObjectQuery bq = m.createQuery("update O set "+sSetSql.toString()+"  where serialNo in('" + sCTSerialNoList.replace("@", "','") + "')");
  			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate()).executeUpdate();	
  			sReturnFlag = "true";
  		} catch(Exception e){
  				e.printStackTrace();
  				sReturnFlag = "false";
  		}
  		return sReturnFlag;
  	}


/**
	 * ����CT����Ϣ
	 * @param sTaskBatchNo  ���κţ�ֻ��������յ�ʱ�򴫵�Ϊ�ǿգ�
	 * @param sOperateUserId �����ˣ�ִ����/��������
	 * @param sOperateOrgId	��������������У�����û�У�
	 * @param sUserId �Ǽ���
	 * @param sOrgId �Ǽǻ���
	 * @param sCTSerialNoList ������ˮ�� �� ��@���ŷָ�
	 * @param sStatus ������Ϣ״̬��0-�����գ�δ������䣩��1-�����У�Ϊ���յǼǣ���2-��ִ�У��ѵǼǴ��ս������5-�ѹرգ�����ල�йر����񣩣�3-��ŵ���4-�ѻ���
	 * @return
	 */
	public String updateCT1(String sTaskBatchNo,String sUserId,String sOrgId,String sCTSerialNoList,String sStatus) {
		String sReturnFlag = "false";
		StringBuffer sSetSql = new StringBuffer();
		try{
	  		sSetSql.append(" OPERATEUSERID='").append(sUserId).append("' ");
	  		sSetSql.append(",").append(" OPERATEORGID='").append(sOrgId).append("' ");
	  		sSetSql.append(",").append(" INPUTUSERID='").append(sUserId).append("' ");
	  		sSetSql.append(",").append(" INPUTORGID='").append(sOrgId).append("' ");
	  		if("".equals(sTaskBatchNo) || "" == sTaskBatchNo || sTaskBatchNo.length() == 0){
	  		}else{
	  			sSetSql.append(",").append(" TASKBATCHNO='").append(sTaskBatchNo).append("' ");
	  			sSetSql.append(",").append(" COLLECTIONMETHOD='5' ");
	  		}
  		sSetSql.append(",").append(" INPUTDATE='").append(DateHelper.getBusinessDate()).append("' ");
  		sSetSql.append(",").append(" STATUS='").append(StringX.isEmpty(sStatus)? "0":sStatus).append("' ");
  		
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
			BizObjectQuery bq = m.createQuery("update O set "+sSetSql.toString()+"  where serialNo in('" + sCTSerialNoList.replace("@", "','") + "')");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate()).executeUpdate();	
			sReturnFlag = "true";
		} catch(Exception e){
				e.printStackTrace();
				sReturnFlag = "false";
		}
		return sReturnFlag;
	}
}