package com.amarsoft.app.workflow.manager;

/**
 * 
 */
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;


public abstract class FlowManager{
	protected BusinessObjectManager bomanager = null;
	
	public static FlowManager getFlowManager(BusinessObjectManager bomanager) throws Exception{
		String className = FlowConfig.getFlowManager();
		Class<?> c = Class.forName(className);
		FlowManager fm = ((FlowManager) c.newInstance());
		fm.bomanager = bomanager;
		return fm;
	}
	/**
	 * 流程实例创建（参数上传）
	 * @param bos
	 * @param flowNo
	 * @param userID
	 * @param orgID
	 * @param para
	 * @return 流程实例编号
	 * @throws Exception
	 */
	public abstract String createInstance(String flowObjectType,List<BusinessObject> bos,String flowNo,String userID,String orgID,BusinessObject context) throws Exception;
	/**
	 * 流程实例设置参数
	 * @param flowSerialNo
	 * @param context
	 * @throws Exception
	 */
	public abstract void setInstanceContext(String flowSerialNo,BusinessObject context,String userID,String orgID) throws Exception;
	//查询流程实例信息
	public abstract BusinessObject queryInstance(String flowSerialNo,String userID,String orgID) throws Exception;
	//查询任务
	public abstract BusinessObject queryTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//查询流程实例流转任务   QueryInstanceTask
	public abstract BusinessObject queryInstanceTask(String flowSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//查询流程实例可退回活动列表 QueryReturnAvy
	public abstract BusinessObject queryReturnAvy(String flowSerialNo,String taskSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//查询流程实例当前运行任务查询  QueryInstanceRunningTask
	public abstract BusinessObject queryInstanceRunningTask(String flowSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//退回上一节点	ReturnToLastAvy
	public abstract String returnToLastAvy(String taskSerialNo,String flowSerialNo,String userID,String orgID) throws Exception;
	//回退到指定任务
	public abstract String returnToAppointTask(String taskSerialNo,String appointTaskSerialNo,String userID,String orgID) throws Exception;
	//领取可办流程任务  GetAvlTask
	public abstract String getAvlTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//自动获取可办任务
	public abstract String autoGetAvlTask(BusinessObject taskContext, BusinessObject businessContext, boolean countFlag, String userID, String orgID) throws Exception;
	//退回已领取流程任务 RetGotTask
	public abstract String retGotTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//预提交任务  PreSubmitTask
	public abstract BusinessObject preSubmitTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//提交任务 SubmitTask
	public abstract String submitTask(String taskSerialNo,List<BusinessObject> nextphases,String userID,String orgID) throws Exception;
	//收回任务 WhdrwlTask
	public abstract String whdrwlTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//任务挂起 HangUpTask
	public abstract String hangUpTask(String taskSerialNo,String hangUpTime,String userID,String orgID) throws Exception;
	//恢复任务 ResumeTask
	public abstract String resumeTask(String taskSerialNo,String resumeTime,String userID,String orgID) throws Exception;
	//查询流程任务参与者  QueryAvyPcp  
	public abstract List<BusinessObject> queryAvyPcp(String flowSerialNo,String phaseNo) throws Exception;
	//改派任务 ReasgnTask
	public abstract String reasgnTask(String taskSerialNo,String reasgnUserID,String reasgnOrgID,String reason,String userID,String orgID) throws Exception;
	//查询多流程待办任务 QueryMultiPcsTodoTask
	public abstract BusinessObject queryMultiPcsTodoTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//查询多流程可办任务 QueryMultiPcsAvlTask
	public abstract BusinessObject queryMultiPcsAvlTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//查询多流程已完成任务 QueryMultiPcsFinishedTask
	public abstract BusinessObject queryMultiPcsFinishedTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//查询多流程挂起任务 QueryMultiPcsHangUpTask
	public abstract BusinessObject queryMultiPcsHangUpTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//查询多流程挂起任务 QueryMultiPcsHangUpTask
	public abstract BusinessObject queryMultiPcsAllTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//流程实例删除
	public abstract String deleteInstance(String flowSerialNo,String userID,String orgID) throws Exception;
	//终止流程实例
	public abstract String finishInstance(String flowSerialNo,String userID,String orgID) throws Exception;
}
