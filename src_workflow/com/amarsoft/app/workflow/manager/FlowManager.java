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
	 * ����ʵ�������������ϴ���
	 * @param bos
	 * @param flowNo
	 * @param userID
	 * @param orgID
	 * @param para
	 * @return ����ʵ�����
	 * @throws Exception
	 */
	public abstract String createInstance(String flowObjectType,List<BusinessObject> bos,String flowNo,String userID,String orgID,BusinessObject context) throws Exception;
	/**
	 * ����ʵ�����ò���
	 * @param flowSerialNo
	 * @param context
	 * @throws Exception
	 */
	public abstract void setInstanceContext(String flowSerialNo,BusinessObject context,String userID,String orgID) throws Exception;
	//��ѯ����ʵ����Ϣ
	public abstract BusinessObject queryInstance(String flowSerialNo,String userID,String orgID) throws Exception;
	//��ѯ����
	public abstract BusinessObject queryTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//��ѯ����ʵ����ת����   QueryInstanceTask
	public abstract BusinessObject queryInstanceTask(String flowSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//��ѯ����ʵ�����˻ػ�б� QueryReturnAvy
	public abstract BusinessObject queryReturnAvy(String flowSerialNo,String taskSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//��ѯ����ʵ����ǰ���������ѯ  QueryInstanceRunningTask
	public abstract BusinessObject queryInstanceRunningTask(String flowSerialNo,int startNum,int pageNum, String userID, String orgID) throws Exception;
	//�˻���һ�ڵ�	ReturnToLastAvy
	public abstract String returnToLastAvy(String taskSerialNo,String flowSerialNo,String userID,String orgID) throws Exception;
	//���˵�ָ������
	public abstract String returnToAppointTask(String taskSerialNo,String appointTaskSerialNo,String userID,String orgID) throws Exception;
	//��ȡ�ɰ���������  GetAvlTask
	public abstract String getAvlTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//�Զ���ȡ�ɰ�����
	public abstract String autoGetAvlTask(BusinessObject taskContext, BusinessObject businessContext, boolean countFlag, String userID, String orgID) throws Exception;
	//�˻�����ȡ�������� RetGotTask
	public abstract String retGotTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//Ԥ�ύ����  PreSubmitTask
	public abstract BusinessObject preSubmitTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//�ύ���� SubmitTask
	public abstract String submitTask(String taskSerialNo,List<BusinessObject> nextphases,String userID,String orgID) throws Exception;
	//�ջ����� WhdrwlTask
	public abstract String whdrwlTask(String taskSerialNo,String userID,String orgID) throws Exception;
	//������� HangUpTask
	public abstract String hangUpTask(String taskSerialNo,String hangUpTime,String userID,String orgID) throws Exception;
	//�ָ����� ResumeTask
	public abstract String resumeTask(String taskSerialNo,String resumeTime,String userID,String orgID) throws Exception;
	//��ѯ�������������  QueryAvyPcp  
	public abstract List<BusinessObject> queryAvyPcp(String flowSerialNo,String phaseNo) throws Exception;
	//�������� ReasgnTask
	public abstract String reasgnTask(String taskSerialNo,String reasgnUserID,String reasgnOrgID,String reason,String userID,String orgID) throws Exception;
	//��ѯ�����̴������� QueryMultiPcsTodoTask
	public abstract BusinessObject queryMultiPcsTodoTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//��ѯ�����̿ɰ����� QueryMultiPcsAvlTask
	public abstract BusinessObject queryMultiPcsAvlTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//��ѯ��������������� QueryMultiPcsFinishedTask
	public abstract BusinessObject queryMultiPcsFinishedTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//��ѯ�����̹������� QueryMultiPcsHangUpTask
	public abstract BusinessObject queryMultiPcsHangUpTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//��ѯ�����̹������� QueryMultiPcsHangUpTask
	public abstract BusinessObject queryMultiPcsAllTask(BusinessObject taskContext,BusinessObject businessContext,int startNum,int pageNum,boolean countFlag,String userID,String orgID) throws Exception;
	//����ʵ��ɾ��
	public abstract String deleteInstance(String flowSerialNo,String userID,String orgID) throws Exception;
	//��ֹ����ʵ��
	public abstract String finishInstance(String flowSerialNo,String userID,String orgID) throws Exception;
}
