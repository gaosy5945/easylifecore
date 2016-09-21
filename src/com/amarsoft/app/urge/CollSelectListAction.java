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
	//参数
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
	 * 任务分配，非外包催收（非批次）分配，更新CT催收信息
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
	 * 任务分配 ，外包催收（批次），1.新增PTI批次信息，2.更新CT催收信息
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
		//查询是否存在当前任务批次号
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
	 * 外包催收任务调整
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
	 * 催收任务调整
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
	 * 删除PTI
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
	 * 插入数据至PUB_TASK_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private String inserPubTaskInfo(String sOrgId,String sUserId,String sOperationUserId,String sOperationOrgId,String sTaskName){
  		String sPTISerialNo="";
		try{
			businessObjectManager =  this.getBusinessObjectManager();
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.app.PUB_TASK_INFO");
			todo.generateKey();
			todo.setAttributeValue("OPERATEDESCRIPTION", "外包催收");
			todo.setAttributeValue("TASKTYPE", "外包催收");
			todo.setAttributeValue("TASKNAME", sTaskName);//入库
			todo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SERIALNO",""));//入库
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OPERATEUSERID", sOperationUserId);
			todo.setAttributeValue("OPERATEORGID", sOperationOrgId);
			todo.setAttributeValue("STATUS", "01");
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("INPUTORGID", sOrgId);
			todo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());

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
  	 * 更新选中批次的执行人信息，
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
  	 * 关闭任务
  	 * @param sSerialNoList 流水号
  	 * @param sUserId 登记人
  	 * @param closeType  关闭类型：1-总行，2-分行，3-外包（批量）
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
  	 * 更新选中批次的催收信息
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
  	 * 更新选中de催收信息
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
  	 * 更新CT表信息
  	 * @param sTaskBatchNo  批次号（只有外包催收的时候传的为非空）
  	 * @param sOperateUserId 处理人（执行人/合作方）
  	 * @param sOperateOrgId	处理机构（或许有，或许没有）
  	 * @param sUserId 登记人
  	 * @param sOrgId 登记机构
  	 * @param sCTSerialNoList 催收流水号 串 以@符号分割
  	 * @param sStatus 催收信息状态：0-待催收（未任务分配），1-催收中（为催收登记），2-已执行（已登记催收结果），5-已关闭（任务监督中关闭任务），3-承诺还款，4-已还款
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
	 * 更新CT表信息
	 * @param sTaskBatchNo  批次号（只有外包催收的时候传的为非空）
	 * @param sOperateUserId 处理人（执行人/合作方）
	 * @param sOperateOrgId	处理机构（或许有，或许没有）
	 * @param sUserId 登记人
	 * @param sOrgId 登记机构
	 * @param sCTSerialNoList 催收流水号 串 以@符号分割
	 * @param sStatus 催收信息状态：0-待催收（未任务分配），1-催收中（为催收登记），2-已执行（已登记催收结果），5-已关闭（任务监督中关闭任务），3-承诺还款，4-已还款
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