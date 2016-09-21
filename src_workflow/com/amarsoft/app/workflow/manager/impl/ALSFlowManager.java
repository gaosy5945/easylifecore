package com.amarsoft.app.workflow.manager.impl;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.interdata.IData;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.pcp.IFlowPcp;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.manage.NameManager;

public class ALSFlowManager extends FlowManager {

	@Override
	public String createInstance(String flowObjectType,List<BusinessObject> bos, String flowNo,
			String userID, String orgID, BusinessObject context) throws Exception {
		if(bos == null || bos.isEmpty()) throw new Exception("�޷���ʼ�����̡�δ������ȷ�Ķ�����Ϣ�������飡");
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		BusinessObject flowCatalog = FlowConfig.getFlowCatalog(flowNo,flowVersion);
		if(flowCatalog == null) throw new Exception("ϵͳδά�������̰汾��"+flowNo+","+flowVersion+"�������飡");
		
		//��ȡ���̶������
		List<BusinessObject> paraList = FlowConfig.getFlowCatalogPara(flowNo, flowVersion);
		
		String result="";
		//����ʵ��ID
		String instanceID = "";
		String[] keys = new String[bos.size()];
		String objectType="";
		for(int i = 0; i < bos.size(); i ++)
		{
			keys[i] = bos.get(i).getKeyString();
			if(StringX.isEmpty(objectType)) objectType = bos.get(i).getBizClassName();
			else if(!bos.get(i).getBizClassName().equals(objectType))
				throw new ALSException("ED1034");
		}
		//��ȡ�������������Ϣ
		List<BusinessObject> fos = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "ObjectType=:ObjectType and ObjectNo in(:ObjectNos)", "ObjectType",flowObjectType,"ObjectNos",keys);
		if(fos.size() == 0)
		{
			
			//��ȡҵ�����
			String className = FlowConfig.getFlowObjectType(flowObjectType).getString("Script");//��ȡȡ���߼�
			Class<?> c = Class.forName(className);
			IData data = (IData)c.newInstance();
			
			for(BusinessObject bo:bos)
			{
				data.transfer(bo);
			}
			bos = data.group(bos);
			
			context.setAttributeValue("OrgID", orgID);
			context.setAttributeValue("UserID", userID);
			//��ȡ������
			context = FlowHelper.getContext(paraList,bos,context,bomanager);
			
			/**
			 * ����ʵ��������ʼ-ʵ����Ŀ��ʹ���ⲿ���̿ɸ�����Ҫ���ò����޸ĳ��ⲿ���̽ӿ�
			 */
			String phaseNo = FlowConfig.getFlowCatalog(flowNo, flowVersion).getString("DefaultPhaseNo");
			BusinessObject fi = BusinessObject.createBusinessObject("jbo.flow.FLOW_INSTANCE");
			fi.generateKey();
			instanceID = fi.getKeyString();
			result+=instanceID;
			fi.setAttributeValue("PHASETYPE", FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("PhaseType"));
			fi.setAttributeValue("FLOWNO", flowNo);
			fi.setAttributeValue("FLOWVERSION", flowVersion);
			fi.setAttributeValue("CREATEORGID", orgID);
			fi.setAttributeValue("CREATEUSERID", userID);
			fi.setAttributeValue("PHASENO", phaseNo);
			fi.setAttributeValue("CREATETIME", DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT));
			fi.setAttributeValue("FLOWSTATE", FlowHelper.FLOWSTATE_RUNNING);
			fi.setAttributeValue("PARAMETER", context.toXMLString());
			bomanager.updateBusinessObject(fi);
			
			BusinessObject ft = BusinessObject.createBusinessObject("jbo.flow.FLOW_TASK");
			ft.generateKey();
			result+="@"+phaseNo+"@"+ft.getString("TaskSerialNo");
			ft.setAttributeValue("FLOWSERIALNO", instanceID);
			ft.setAttributeValue("PHASENO", phaseNo);
			ft.setAttributeValue("USERID", userID);
			ft.setAttributeValue("ORGID", orgID);
			String time = DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT);
			ft.setAttributeValue("CREATETIME", time);
			ft.setAttributeValue("BEGINTIME", time);
			ft.setAttributeValue("TASKSTATE", FlowHelper.TASKSTATE_RUNNING);
			bomanager.updateBusinessObject(ft);
			
			
			String businessTable = FlowConfig.getFlowCatalog(flowNo, flowVersion).getString("BusinessTable");
			if(!StringX.isEmpty(businessTable))
			{
				BusinessObject bt = BusinessObject.createBusinessObject(businessTable);
				bt.setAttributeValue("FLOWSERIALNO", instanceID);
				bt.setAttributes(context);
				bomanager.updateBusinessObject(bt);
			}
			
			/**
			 * ����ʵ����������
			 */
			
			for(BusinessObject bo:bos)
			{
				BusinessObject fo = BusinessObject.createBusinessObject("jbo.flow.FLOW_OBJECT");
				fo.setAttributeValue("FLOWSERIALNO", instanceID);
				fo.setAttributeValue("OBJECTTYPE", flowObjectType);
				fo.setAttributeValue("OBJECTNO", bo.getKeyString());
				fo.setAttributeValue("FLOWNO", flowNo);
				fo.setAttributeValue("FLOWVERSION", flowVersion);
				fo.setAttributeValue("ORGID", orgID);
				fo.setAttributeValue("USERID", userID);
				bomanager.updateBusinessObject(fo);
			}
		}else
		{
			BusinessObject flowObject = fos.get(0);
			instanceID = flowObject.getString("FlowSerialNo");

			for(BusinessObject bo:bos)
			{
				boolean flag = false;//�Ƿ����
				for(BusinessObject fo:fos)
				{
					if(bo.getKeyString().equals(fo.getString("ObjectNo")))
					{
						flag = true;
					}
				}
				
				if(!flag)//���������
				{
					BusinessObject fo = BusinessObject.createBusinessObject("jbo.flow.FLOW_OBJECT");
					fo.setAttributeValue("FLOWSERIALNO", instanceID);
					fo.setAttributeValue("OBJECTTYPE", bo.getBizClassName());
					fo.setAttributeValue("OBJECTNO", bo.getKeyString());
					fo.setAttributeValue("FLOWNO", flowNo);
					fo.setAttributeValue("FLOWVERSION", flowVersion);
					fo.setAttributeValue("ORGID", orgID);
					fo.setAttributeValue("USERID", userID);
					bomanager.updateBusinessObject(fo);
				}
			}
		}
		bomanager.updateDB();
		
		return result;
	}

	
	public void setInstanceContext(String flowSerialNo, BusinessObject context,
			String userID, String orgID)
			throws Exception {
		//������¼
		bomanager.getBizObjectManager("jbo.flow.FLOW_INSTANCE").createQuery("update o set flowstate=flowstate where SerialNo=:SerialNo").setParameter("SerialNo", flowSerialNo);
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", flowSerialNo);
		String parameterString = fi.getString("Parameter");
		InputStream in = new ByteArrayInputStream(parameterString.getBytes(ARE.getProperty("CharSet","GBK")));
		Document document = new Document(in);
		in.close();
		BusinessObject parameter = BusinessObject.createBusinessObject(document.getRootElement());
		parameter.setAttributes(context);
		
		fi.setAttributeValue("PARAMETER", parameter.toXMLString());
		
		String businessTable = FlowConfig.getFlowCatalog(fi.getString("FlowNo"), fi.getString("FlowVersion")).getString("BusinessTable");
		if(!StringX.isEmpty(businessTable))
		{
			BusinessObject bt = bomanager.loadBusinessObject(businessTable, "FlowSerialNo",flowSerialNo);
			bt.setAttributes(context);
			bomanager.updateBusinessObject(bt);
		}
		bomanager.updateBusinessObject(fi);
		bomanager.updateDB();
	}

	public BusinessObject queryInstance(String flowSerialNo,String userID,String orgID) throws Exception{
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", flowSerialNo);
		String paramater = fi.getString("Parameter");
		
		InputStream in = new ByteArrayInputStream(paramater.getBytes(ARE.getProperty("CharSet","GBK")));
		Document document = new Document(in);
		in.close();
		
		fi.setAttributes(BusinessObject.createBusinessObject(document.getRootElement()));
		return fi;
	}
	
	public BusinessObject queryTask(String taskSerialNo,String userID,String orgID) throws Exception{
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return bomanager.keyLoadBusinessObject("jbo.flow.FLOW_TASK", taskSerialNo);
	}
	
	public BusinessObject queryInstanceTask(String flowSerialNo,
			int startNum, int pageNum, String userID, String orgID)
			throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = queryInstance(flowSerialNo,userID,orgID);
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo order by TaskSerialNo", "FlowSerialNo",flowSerialNo);
		fi.setAttributeValue("TaskCount", fts.size());
		String flowName = FlowConfig.getFlowCatalog(fi.getString("FlowNo"), fi.getString("FlowVersion")).getString("FlowName");
		
		List<BusinessObject> tasks;
		if(startNum < 0 || startNum > fts.size() || startNum+pageNum < 0 || pageNum < 0) return fi;
		if(startNum + pageNum >= fts.size()) tasks=fts.subList(startNum, fts.size());
		else
		{
			tasks = fts.subList(startNum, startNum + pageNum);
		}
		
		for(BusinessObject task:tasks)
		{
			task.setAttributeValue("FlowName", flowName);
			task.setAttributeValue("FlowNo", fi.getString("FlowNo"));
			task.setAttributeValue("FlowVersion", fi.getString("FlowVersion"));
			task.setAttributeValue("CreateUserID", fi.getString("CreateUserID"));
			task.setAttributeValue("CreateOrgID", fi.getString("CreateOrgID"));
			task.setAttributeValue("FlowState", fi.getString("FlowState"));
			task.setAttributeValue("FinishTime", fi.getString("FinishTime"));
			task.setAttributeValue("PhaseName", FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), task.getString("PhaseNo")).getString("PhaseName"));
			
			task.setAttributeValue("UserName", NameManager.getUserName(task.getString("UserID")));
			task.setAttributeValue("OrgName", NameManager.getOrgName(task.getString("OrgID")));
		}
		fi.appendBusinessObjects("jbo.flow.FLOW_TASK",tasks);
		
		return fi;
	}

	public BusinessObject queryReturnAvy(String flowSerialNo,String taskSerialNo,
			int startNum, int pageNum, String userID, String orgID)
			throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = queryInstance(flowSerialNo,userID,orgID);
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo order by TaskSerialNo", "FlowSerialNo",flowSerialNo);
		List<BusinessObject> frs = bomanager.loadBusinessObjects("jbo.flow.FLOW_RELATIVE", "FlowSerialNo=:FlowSerialNo",  "FlowSerialNo",flowSerialNo);
		List<BusinessObject> results = new ArrayList<BusinessObject>();
		while(true)
		{
			BusinessObject tmp = BusinessObjectHelper.getBusinessObjectByAttributes(frs, "NextSerialNo",taskSerialNo);
			if(tmp == null)
				break;
			
			results.add(BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",tmp.getString("TaskSerialNo")));
		}
		fi.setAttributeValue("TaskCount", results.size());
		
		if(startNum < 0 || startNum > results.size() || startNum+pageNum < 0 || pageNum < 0) return fi;
		if(startNum + pageNum >= results.size()) fi.appendBusinessObjects("jbo.flow.FLOW_TASK", results.subList(startNum, results.size()));
		else
			fi.appendBusinessObjects("jbo.flow.FLOW_TASK",results.subList(startNum, startNum + pageNum));
		
		return fi;
	}

	//��ǰ���е�����
	public BusinessObject queryInstanceRunningTask(String flowSerialNo,
			int startNum, int pageNum, String userID, String orgID)
			throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = queryInstance(flowSerialNo,userID,orgID);
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo and State in(:State) order by TaskSerialNo", "FlowSerialNo",flowSerialNo,"State",new String[]{FlowHelper.TASKSTATE_AVY,FlowHelper.TASKSTATE_HANDUP,FlowHelper.TASKSTATE_RUNNING});
		fi.setAttributeValue("TaskCount", fts.size());
		if(startNum < 1 || startNum > fts.size() || startNum+pageNum < 1 || pageNum < 0) return fi;
		if(startNum + pageNum-1 >= fts.size()) fi.appendBusinessObjects("jbo.flow.FLOW_TASK", fts.subList(startNum-1, fts.size()-1));
		else
			fi.appendBusinessObjects("jbo.flow.FLOW_TASK",fts.subList(startNum-1, startNum + pageNum-2));
		return fi;
	}
	
	public String returnToLastAvy(String taskSerialNo,String flowSerialNo, String userID,
			String orgID) throws Exception {
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		//������¼
		bomanager.getBizObjectManager("jbo.flow.FLOW_INSTANCE").createQuery("update o set flowstate=flowstate where SerialNo=:SerialNo").setParameter("SerialNo", flowSerialNo);
		
		
		//������ڲ��н�����������
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo order by TaskSerialNo", "FlowSerialNo",flowSerialNo);
		List<BusinessObject> frs = bomanager.loadBusinessObjects("jbo.flow.FLOW_RELATIVE", "FlowSerialNo=:FlowSerialNo",  "FlowSerialNo",flowSerialNo);
		
		BusinessObject task = BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",taskSerialNo);
		if(FlowHelper.TASKSTATE_FININSHED.equals(task.getString("TaskState"))){
			bomanager.rollback();
			return "false@�������ѽ����������ٷ����˻ء�";//�������ѽ����������ٷ���
		}
		
		List<BusinessObject> lastfrs = BusinessObjectHelper.getBusinessObjectsByAttributes(frs, "NextTaskSerialNo",taskSerialNo);
		if(lastfrs.isEmpty()) throw new ALSException("ED4001",taskSerialNo);
		for(BusinessObject lastfr:lastfrs)
		{
			BusinessObject lastft = BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",lastfr.getString("TaskSerialNo"));
			//��������ǰ���¼�
			BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",lastfr.getString("FlowSerialNo")).get(0);
			lastfr.setAttributes(fo);
			lastfr.setAttributes(lastft);
			
			String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
			Class<?> c = Class.forName(className);
			IData data = (IData)c.newInstance();
			List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",lastfr.getString("FlowSerialNo"));
			for(BusinessObject bo:boList)
			{
				data.transfer(bo);
			}
		
			BusinessObject flowPhase = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), lastfr.getString("PhaseNo"));
			if(flowPhase != null)
			{
				String preScript = flowPhase.getString("PreScript");
				if(preScript != null && !"".equals(preScript))
				{
					for(BusinessObject bo:boList)
					{
						try{
							FlowHelper.ExecuteScript(preScript,bo,lastfr,bomanager.getTx());
						}catch(Exception ex)
						{
							throw ex;
						}
					}
				}
			}
			
			List<BusinessObject> ets = FlowHelper.endTask(lastfr.getString("TaskSerialNo"),fts,frs,bomanager);
			//���´����Ͻ׶�����
			BusinessObject ft = BusinessObject.createBusinessObject("jbo.flow.FLOW_TASK");
			ft.generateKey();
			ft.setAttributeValue("FLOWSERIALNO", flowSerialNo);
			ft.setAttributeValue("PHASENO", lastfr.getString("PhaseNo"));
			ft.setAttributeValue("USERID", lastfr.getString("UserID"));
			ft.setAttributeValue("ORGID", lastfr.getString("OrgID"));
			String time = DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT);
			ft.setAttributeValue("CREATETIME", time);
			ft.setAttributeValue("BEGINTIME", time);
			ft.setAttributeValue("TASKSTATE", FlowHelper.TASKSTATE_RUNNING);
			bomanager.updateBusinessObject(ft);
			
			for(BusinessObject et:ets)
			{
				BusinessObject fr = BusinessObject.createBusinessObject("jbo.flow.FLOW_RELATIVE");
				fr.setAttributeValue("TaskSerialNo", et.getString("TaskSerialNo"));
				fr.setAttributeValue("NextTaskSerialNo", ft.getString("TaskSerialNo"));
				fr.setAttributeValue("FlowSerialNo", flowSerialNo);
				bomanager.updateBusinessObject(fr);
			}
		}
		bomanager.updateDB();
		return "true@�˻سɹ���";
	}
	

	@Override
	public String returnToAppointTask(String taskSerialNo, String appointTaskSerialNo,
			String userID, String orgID)
			throws Exception {
		//�ڲ����ݴ���
		BusinessObject lastft=queryTask(appointTaskSerialNo, userID, orgID);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",lastft.getString("FlowSerialNo")).get(0);
		lastft.setAttributes(fo);
		
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",lastft.getString("FlowSerialNo"));
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
	
		BusinessObject flowPhase = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), lastft.getString("PhaseNo"));
		if(flowPhase != null)
		{
			String preScript = flowPhase.getString("PreScript");
			if(preScript != null && !"".equals(preScript))
			{
				for(BusinessObject bo:boList)
				{
					try{
						FlowHelper.ExecuteScript(preScript,bo,lastft,bomanager.getTx());
					}catch(Exception ex)
					{
						throw ex;
					}
				}
			}
		}
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		String flowSerialNo = lastft.getString("FlowSerialNo");
		//������¼
		bomanager.getBizObjectManager("jbo.flow.FLOW_INSTANCE").createQuery("update o set flowstate=flowstate where SerialNo=:SerialNo").setParameter("SerialNo", flowSerialNo);
		
		
		//������ڲ��н�����������
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo order by TaskSerialNo", "FlowSerialNo",flowSerialNo);
		List<BusinessObject> frs = bomanager.loadBusinessObjects("jbo.flow.FLOW_RELATIVE", "FlowSerialNo=:FlowSerialNo",  "FlowSerialNo",flowSerialNo);
		
		BusinessObject task = BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",taskSerialNo);
		if(FlowHelper.TASKSTATE_FININSHED.equals(task.getString("TaskState"))){
			bomanager.rollback();
			return "false@�������ѽ����������ٷ����˻ء�";//�������ѽ����������ٷ���
		}
		
		BusinessObject appointTask = BusinessObjectHelper.getBusinessObjectByAttributes(fts, "TaskSerialNo",appointTaskSerialNo);
		
		List<BusinessObject> ets = FlowHelper.endTask(appointTask.getString("TaskSerialNo"),fts,frs,bomanager);
		//���´����Ͻ׶�����
		BusinessObject ft = BusinessObject.createBusinessObject("jbo.flow.FLOW_TASK");
		ft.generateKey();
		ft.setAttributeValue("FLOWSERIALNO", flowSerialNo);
		ft.setAttributeValue("PHASENO", appointTask.getString("PhaseNo"));
		ft.setAttributeValue("USERID", appointTask.getString("UserID"));
		ft.setAttributeValue("ORGID", appointTask.getString("OrgID"));
		String time = DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT);
		ft.setAttributeValue("CREATETIME", time);
		ft.setAttributeValue("BEGINTIME", time);
		ft.setAttributeValue("TASKSTATE", FlowHelper.TASKSTATE_RUNNING);
		bomanager.updateBusinessObject(ft);
		
		for(BusinessObject et:ets)
		{
			BusinessObject fr = BusinessObject.createBusinessObject("jbo.flow.FLOW_RELATIVE");
			fr.setAttributeValue("TaskSerialNo", et.getString("TaskSerialNo"));
			fr.setAttributeValue("NextTaskSerialNo", ft.getString("TaskSerialNo"));
			fr.setAttributeValue("FlowSerialNo", flowSerialNo);
			bomanager.updateBusinessObject(fr);
		}
		bomanager.updateDB();
		
		return "true@�˻سɹ���";
	}

	@Override
	public String getAvlTask(String taskSerialNo, String userID, String orgID) throws Exception {
		//�ڲ������߼�
		BusinessObject ft = queryTask(taskSerialNo, userID, orgID);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",ft.getString("FlowSerialNo")).get(0);
		ft.setAttributes(fo);
		
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",ft.getString("FlowSerialNo"));
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
		ft.setAttributeValue("CurUserID", "");
		ft.setAttributeValue("CurOrgID", "");
		
		BusinessObject flowModel = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), ft.getString("PhaseNo"));
		className = flowModel.getString("ParticipantFilterScript");
		com.amarsoft.app.workflow.filter.IFlowFilter filter = null;
		if(className != null && !"".equals(className))
		{
			c = Class.forName(className);
			filter = (com.amarsoft.app.workflow.filter.IFlowFilter)c.newInstance();
		}
		
		if(filter == null || filter != null && filter.run(boList, ft, userID, bomanager))
		{
			//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
			BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
			int r = bom.createQuery("update O set UserID=:UserID,OrgID=:OrgID,TaskState=:TaskState where TaskSerialNo=:TaskSerialNo and (TaskState = :TaskState1 and (UserID is null or UserID='') or UserID=:UserID and TaskState=:TaskState2) ")
				.setParameter("UserID", userID)
				.setParameter("OrgID", orgID)
				.setParameter("TaskState", FlowHelper.TASKSTATE_RUNNING)
				.setParameter("TaskSerialNo", taskSerialNo)
				.setParameter("TaskState1", FlowHelper.TASKSTATE_AVY)
				.setParameter("TaskState2", FlowHelper.TASKSTATE_HANDUP)
				.executeUpdate();
			
			if(r >= 1)
			{
				List<BusinessObject> fts = new ArrayList<BusinessObject>();
				fts.add(ft);
				fts = FlowHelper.QueryObjectFromMessage(fts, bomanager);
				return "true@�����ȡ�ɹ���@"+fts.get(0).getString("TaskSerialNo")+"@"+fts.get(0).getString("FlowSerialNo")+"@"+fts.get(0).getString("PhaseNo")+"@"+fts.get(0).getString("FunctionID");
			}
			else 
			{
				bomanager.rollback();
				return "false@�����ȡʧ�ܣ����ܸñ������ѱ���ȡ��״̬����ȷ��";
			}
		}else
		{
			bomanager.rollback();
			return "false@��ȡʧ�ܣ�������û�иñ�ҵ����Ȩ�ޡ�";
		}
	}
		
	@Override
	public String autoGetAvlTask(BusinessObject taskContext, BusinessObject businessContext,boolean countFlag, String userID, String orgID) throws Exception{
		int i = 0;
		while(true)
		{
			BusinessObject fi = this.queryMultiPcsAvlTask(taskContext, businessContext, i, i+1, countFlag, userID, orgID);
			List<BusinessObject> fts = fi.getBusinessObjects("jbo.flow.FLOW_TASK");
			if(fts == null || fts.isEmpty()){
				bomanager.rollback();
				return "false@û�пɰ�������Ի�ȡ��";
			}
			fts = FlowHelper.QueryObjectFromMessage(fts, bomanager);
			String s = getAvlTask(fts.get(0).getString("TaskSerialNo"),userID,orgID);
			if(s.startsWith("true")) return s;
			i++;
		}
	}

	@Override
	public String retGotTask(String taskSerialNo, String userID, String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject ft = this.queryTask(taskSerialNo, userID, orgID);
		BusinessObject fi = this.queryInstance(ft.getString("FlowSerialNo"), userID, orgID);
		BusinessObject nextFlowPhaseConfig = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), ft.getString("PhaseNo"));
		String className = nextFlowPhaseConfig.getString("ParticipantScript");
		if(StringX.isEmpty(className))
			className = "com.amarsoft.app.workflow.pcp.FlowUserPcp";
		Class<?> c = Class.forName(className);
		IFlowPcp fpcp = (IFlowPcp)c.newInstance();
		String pool = fpcp.getFlowPool(fi, nextFlowPhaseConfig, bomanager);
		
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		int r = bom.createQuery("update O set UserID=null,OrgID=null,TaskState=:TaskState,Pool=:Pool where TaskSerialNo=:TaskSerialNo and (UserID=:UserID and TaskState=:TaskState1) ")
			.setParameter("UserID", userID)
			.setParameter("OrgID", orgID)
			.setParameter("TaskState", FlowHelper.TASKSTATE_AVY)
			.setParameter("Pool", pool)
			.setParameter("TaskSerialNo", taskSerialNo)
			.setParameter("TaskState1", FlowHelper.TASKSTATE_RUNNING)
			.executeUpdate();
		
		if(r >= 1)
		{
			return "true@�����˻�����سɹ���";
		}
		else 
		{
			bomanager.rollback();
			return "false@�����˻������ʧ�ܣ����ܸñ������ѱ��˻ػ�״̬����ȷ��";
		}
	}

	@Override
	public BusinessObject preSubmitTask(String taskSerialNo, String userID, String orgID) throws Exception {
		
		BusinessObject ft= queryTask(taskSerialNo, userID, orgID);
		BusinessObject fo= bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo", "FlowSerialNo",ft.getString("FlowSerialNo")).get(0);
		
		//��ȡ���̶������
		List<BusinessObject> paraList = FlowConfig.getFlowPhasePara(fo.getString("FlowNo"), fo.getString("FlowVersion"),ft.getString("PhaseNo"));
		//��ȡҵ��������߼�
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",ft.getString("FlowSerialNo"));
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
		BusinessObject context = BusinessObject.createBusinessObject();
		if(ft != null ){
			context.setAttributes(ft);
			String phaseActionType = DataConvert.toString(ft.getString("PhaseActionType"));
			String phaseAction = DataConvert.toString(ft.getString("PhaseAction"));
			String phaseAction1 = DataConvert.toString(ft.getString("PhaseAction1"));
			String phaseAction2 = DataConvert.toString(ft.getString("PhaseAction2"));
			if(!"".equals(phaseActionType) && CodeCache.getItem("BPMPhaseActionType", phaseActionType) != null)
			{
				phaseActionType = CodeCache.getItem("BPMPhaseActionType", phaseActionType).getItemAttribute();
			}
			if(!"".equals(phaseAction) && CodeCache.getItem("BPMPhaseAction", phaseAction) != null)
			{
				phaseAction = CodeCache.getItem("BPMPhaseAction", phaseAction).getItemAttribute();
			}
			if(!"".equals(phaseAction1) && CodeCache.getItem("BPMPhaseAction", phaseAction1) != null)
			{
				phaseAction1 = CodeCache.getItem("BPMPhaseAction", phaseAction1).getItemAttribute();
			}
			
			if(!"".equals(phaseAction2) && CodeCache.getItem("BPMPhaseAction", phaseAction2) != null)
			{
				phaseAction2 = CodeCache.getItem("BPMPhaseAction", phaseAction2).getItemAttribute();
			}
			context.setAttributeValue("PhaseActionType", phaseActionType);
			context.setAttributeValue("PhaseAction", phaseAction);
			context.setAttributeValue("PhaseAction1", phaseAction1);
			context.setAttributeValue("PhaseAction2", phaseAction2);
		}
		context.setAttributes(fo);
		context.setAttributeValue("CurUserID", userID);
		context.setAttributeValue("CurOrgID", orgID);
		
		
		//��ȡ������
		context = FlowHelper.getContext(paraList,boList,context,bomanager);
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", ft.getString("FlowSerialNo"));
		String paramater = fi.getString("Parameter");
		InputStream in = new ByteArrayInputStream(paramater.getBytes(ARE.getProperty("CharSet","GBK")));
		Document document = new Document(in);
		in.close();
		
		BusinessObject iContext = BusinessObject.createBusinessObject(document.getRootElement());
		iContext.setAttributes(context);
		
		BusinessObject flowPhase = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"),ft.getString("PhaseNo"));
		List<BusinessObject> nextPhaseConfigs = flowPhase.getBusinessObjects("nextphase");
		List<BusinessObject> nextPhases = new ArrayList<BusinessObject>();
		for(BusinessObject nextPhaseConfig:nextPhaseConfigs)
		{
			if(iContext.matchSql(nextPhaseConfig.getString("filter"), null))
			{
				BusinessObject nextPhase = BusinessObject.createBusinessObject("NextPhase");
				nextPhase.generateKey();
				nextPhases.add(nextPhase);
				List<BusinessObject> phasesConfig = nextPhaseConfig.getBusinessObjects("phaseNo");
				HashMap<String,BusinessObject> hm = new LinkedHashMap<String,BusinessObject>();
				for(BusinessObject phaseConfig:phasesConfig)
				{
					String id = phaseConfig.getString("id");
					BusinessObject np = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), id);
					if(hm.get(id) ==  null)
					{
						BusinessObject nd = BusinessObject.createBusinessObject("Phase");
						nd.generateKey();
						nd.setAttributeValue("ID", id);
						nd.setAttributeValue("Name", np.getString("PhaseName"));
						
						if("X".equalsIgnoreCase(phaseConfig.getString("COUNT")))
							nd.setAttributeValue("Count", "X");
						else
							nd.setAttributeValue("Count", 1);
						hm.put(id, nd);
					}
					else
					{
						if(!"X".equalsIgnoreCase(hm.get(id).getString("COUNT")))
							hm.get(id).setAttributeValue("Count", hm.get(id).getInt("Count")+1);
					}
				}
				
				String name = "";
				String id="";
				for(String key:hm.keySet().toArray(new String[0]))
				{
					BusinessObject o = hm.get(key);
					name+=o.getString("Name")+"/";
					id+=key+"/";
					nextPhase.appendBusinessObject("Phase", o);
					
					BusinessObject fp = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), o.getString("id"));
					className = fp.getString("ParticipantScript");
					if(StringX.isEmpty(className))
						className = "com.amarsoft.app.workflow.pcp.FlowUserPcp";
					Class<?> cl = Class.forName(className);
					IFlowPcp fpcp = (IFlowPcp)cl.newInstance();
					List<BusinessObject> users = fpcp.getFlowUsers(fi,fp,bomanager);
					
					className = fp.getString("ParticipantFilterScript");
					com.amarsoft.app.workflow.filter.IFlowFilter filter = null;
					if(className != null && !"".equals(className))
					{
						c = Class.forName(className);
						filter = (com.amarsoft.app.workflow.filter.IFlowFilter)c.newInstance();
					}
					
					for(BusinessObject user:users)
					{
						if(filter == null || filter != null && filter.run(boList, context, user.getString("UserID"), bomanager))
						{
							o.appendBusinessObject(user.getBizClassName(), user);
						}
					}
				}
				
				if(!StringX.isEmpty(name)) name = name.substring(0, name.length()-1);
				
				nextPhase.setAttributeValue("Name", name);
				nextPhase.setAttributeValue("ID", id);
			}
		}
		fi.appendBusinessObjects("NextPhase", nextPhases);
		return fi;
	}

	@Override
	public String submitTask(String taskSerialNo,List<BusinessObject> nextPhases,String userID, String orgID) throws Exception {
		if(nextPhases == null || nextPhases.isEmpty()){
			bomanager.rollback();
			return "false@����ѡ����һ�׶Ρ�";
		}
		BusinessObject ft = queryTask(taskSerialNo, userID, orgID);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",ft.getString("FlowSerialNo")).get(0);
		//��ȡ���̶������
		List<BusinessObject> paraList = FlowConfig.getFlowPhasePara(fo.getString("FlowNo"), fo.getString("FlowVersion"),ft.getString("PhaseNo"));
		//��ȡҵ���������
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",fo.getString("FlowSerialNo"));
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
		BusinessObject context = BusinessObject.createBusinessObject();
		context.setAttributes(fo);
		String phaseActionType = "",phaseAction = "",phaseAction1 = "",phaseAction2 = "";
		context.setAttributes(ft);
		phaseActionType = DataConvert.toString(ft.getString("PhaseActionType"));
		phaseAction = DataConvert.toString(ft.getString("PhaseAction"));
		phaseAction1 = DataConvert.toString(ft.getString("PhaseAction1"));
		phaseAction2 = DataConvert.toString(ft.getString("PhaseAction2"));
		if(!"".equals(phaseActionType) && CodeCache.getItem("BPMPhaseActionType", phaseActionType) != null)
		{
			phaseActionType = CodeCache.getItem("BPMPhaseActionType", phaseActionType).getItemAttribute();
		}
		if(!"".equals(phaseAction) && CodeCache.getItem("BPMPhaseAction", phaseAction) != null)
		{
			phaseAction = CodeCache.getItem("BPMPhaseAction", phaseAction).getItemAttribute();
		}
		if(!"".equals(phaseAction1) && CodeCache.getItem("BPMPhaseAction", phaseAction1) != null)
		{
			phaseAction1 = CodeCache.getItem("BPMPhaseAction", phaseAction1).getItemAttribute();
		}
		if(!"".equals(phaseAction2) && CodeCache.getItem("BPMPhaseAction", phaseAction2) != null)
		{
			phaseAction2 = CodeCache.getItem("BPMPhaseAction", phaseAction2).getItemAttribute();
		}
		context.setAttributeValue("CurUserID", userID);
		context.setAttributeValue("CurOrgID", orgID);
		context.setAttributeValue("PhaseActionType", phaseActionType);
		context.setAttributeValue("PhaseAction", phaseAction);
		context.setAttributeValue("PhaseAction1", phaseAction1);
		context.setAttributeValue("PhaseAction2", phaseAction2);
		
		/**
		 * �ڲ������߼�����
		 */
		//��ǰ�׶�
		BusinessObject flowModel = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"),ft.getString("PhaseNo"));
		String postScript = flowModel.getString("PostScript");
		if(postScript != null && !"".equals(postScript))
		{
			for(BusinessObject bo:boList)
			{
				
				try{
					FlowHelper.ExecuteScript(postScript,bo,context,bomanager.getTx());
				}catch(InvocationTargetException ex){
					ex.printStackTrace();
					throw new Exception(ex.getTargetException().getMessage()+" PostScriptִ�д���");
				}
			}
		}
		
		//��һ�׶�
		for(BusinessObject nextPhase:nextPhases)
		{
			BusinessObject nextFlowModel = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"),nextPhase.getString("ID"));
			if(nextFlowModel != null)
			{
				context.setAttributeValue("NextPhaseNo", nextPhase.getString("NextPhaseNo"));
				String preScript = nextFlowModel.getString("PreScript");
				if(preScript != null && !"".equals(preScript))
				{
					for(BusinessObject bo:boList)
					{
						try{
							FlowHelper.ExecuteScript(preScript,bo,context,bomanager.getTx());
						}catch(InvocationTargetException ex)
						{
							ex.printStackTrace();
							throw new Exception(ex.getTargetException().getMessage()+" PreScriptִ�д���");
						}
					}
				}
			}
		}
		
		//��ȡ������
		context = FlowHelper.getContext(paraList,boList,context,bomanager);
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		//������¼
		bomanager.getBizObjectManager("jbo.flow.FLOW_INSTANCE").createQuery("update o set flowstate=flowstate where SerialNo=:SerialNo").setParameter("SerialNo", ft.getString("FlowSerialNo")).executeUpdate();
		int r = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK").createQuery("update o set taskstate=taskstate where TaskSerialNo=:TaskSerialNo and TaskState=:TaskState").setParameter("TaskSerialNo", taskSerialNo).setParameter("TaskState", FlowHelper.TASKSTATE_RUNNING).executeUpdate();
		if(r<=0)
		{
			bomanager.rollback();
			return "false@��������Ѿ��ύ�������ظ��ύ��";
		}
		
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", ft.getString("FlowSerialNo"));
		String paramater = fi.getString("Parameter");
		InputStream in = new ByteArrayInputStream(paramater.getBytes(ARE.getProperty("CharSet","GBK")));
		Document document = new Document(in);
		in.close();
		
		BusinessObject iContext = BusinessObject.createBusinessObject(document.getRootElement());
		iContext.setAttributes(context);
		
		BusinessObject flowPhase = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"),ft.getString("PhaseNo"));
		List<BusinessObject> nextPhaseConfigs = flowPhase.getBusinessObjects("nextphase");
		boolean flag = false;
		for(BusinessObject nextPhaseConfig:nextPhaseConfigs)
		{
			if(iContext.matchSql(nextPhaseConfig.getString("filter"), null))
			{
				List<BusinessObject> phasesConfig = nextPhaseConfig.getBusinessObjects("phaseNo");
				HashMap<String,BusinessObject> hm = new HashMap<String,BusinessObject>();
				for(BusinessObject phaseConfig:phasesConfig)
				{
					String id = phaseConfig.getString("id");
					BusinessObject np = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), id);
					if(hm.get(id) ==  null)
					{
						BusinessObject nd = BusinessObject.createBusinessObject("Phase");
						nd.setAttributeValue("ID", id);
						nd.setAttributeValue("Name", np.getString("PhaseName"));
						if("X".equalsIgnoreCase(phaseConfig.getString("COUNT")))
							nd.setAttributeValue("Count", "X");
						else
							nd.setAttributeValue("Count", 1);
						hm.put(id, nd);
					}
					else
					{
						if(!"X".equalsIgnoreCase(hm.get(id).getString("Count")))
							hm.get(id).setAttributeValue("Count", hm.get(id).getInt("Count")+1);
					}
				}
				
				int size = 0;
				for(BusinessObject bo:nextPhases)
				{
					BusinessObject tmp = hm.get(bo.getString("ID"));
					if(tmp != null && ("X".equalsIgnoreCase(tmp.getString("COUNT")) || tmp.getInt("Count") == bo.getInt("Count") ))
					{
						size++;
					}
				}
				
				if(size ==  nextPhases.size() && size == hm.size())
				{
					flag = true;
					//������ǰ�׶�
					String time = DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT);
					ft.setAttributeValue("EndTime", time);
					ft.setAttributeValue("TaskState", FlowHelper.TASKSTATE_FININSHED);
					bomanager.updateBusinessObject(ft);
					for(BusinessObject bo:nextPhases)
					{
						String nextPhaseNo = bo.getString("ID");
						List<BusinessObject> users = bo.getBusinessObjects("jbo.sys.USER_INFO");
						int Count = bo.getInt("Count");
						if(users != null && Count != users.size() && users.size()!=0)
						{
							bomanager.rollback();
							return "false@ѡ��Ĳ����û������̽ڵ㲻ƥ�䡣";
						}
						
						
						BusinessObject nextFlowPhaseConfig = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), nextPhaseNo);
						className = nextFlowPhaseConfig.getString("ParticipantScript");
						if(StringX.isEmpty(className))
							className = "com.amarsoft.app.workflow.pcp.FlowUserPcp";
						c = Class.forName(className);
						IFlowPcp fpcp = (IFlowPcp)c.newInstance();
						String pool = fpcp.getFlowPool(fi, nextFlowPhaseConfig, bomanager);
						
						for(int i = 0 ; i < Count; i ++)
						{
							
							//����������ϵδ�ж�
							
							BusinessObject nft = BusinessObject.createBusinessObject("jbo.flow.FLOW_TASK");
							nft.generateKey();
							nft.setAttributeValue("FLOWSERIALNO", ft.getString("FlowSerialNo"));
							nft.setAttributeValue("PHASENO", nextPhaseNo);
							if(users == null || users.size()==0)
							{
								nft.setAttributeValue("Pool", pool);
								nft.setAttributeValue("TASKSTATE", FlowHelper.TASKSTATE_AVY);
							}
							else{
								nft.setAttributeValue("USERID", users.get(i).getString("USERID"));
								nft.setAttributeValue("ORGID", users.get(i).getString("ORGID"));
								nft.setAttributeValue("BEGINTIME", time);
								nft.setAttributeValue("TASKSTATE", FlowHelper.TASKSTATE_RUNNING);
							}
							
							nft.setAttributeValue("CREATETIME", time);
							
							bomanager.updateBusinessObject(nft);
							
							BusinessObject fr = BusinessObject.createBusinessObject("jbo.flow.FLOW_RELATIVE");
							fr.setAttributeValue("TaskSerialNo", ft.getString("TaskSerialNo"));
							fr.setAttributeValue("NextTaskSerialNo", nft.getString("TaskSerialNo"));
							fr.setAttributeValue("FlowSerialNo", ft.getString("FlowSerialNo"));
							bomanager.updateBusinessObject(fr);
						}
					}
				}
				
			}
		}
		
		if(!flag)
		{
			bomanager.rollback();
			return "false@δ�ҵ�ƥ������̽ڵ㣬������ѡ��";
		}
		
		bomanager.updateDB();
		
		return "true@�ύ�ɹ���";
	}

	@Override
	public String whdrwlTask(String taskSerialNo, String userID, String orgID) throws Exception {
		BusinessObject ft = queryTask(taskSerialNo, userID, orgID);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",ft.getString("FlowSerialNo")).get(0);
		ft.setAttributes(fo);
		
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//��ȡȡ���߼�
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",ft.getString("FlowSerialNo"));
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
	
		BusinessObject flowPhase = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), ft.getString("PhaseNo"));
		if(flowPhase != null)
		{
			String preScript = flowPhase.getString("PreScript");
			if(preScript != null && !"".equals(preScript))
			{
				for(BusinessObject bo:boList)
				{
					try{
						FlowHelper.ExecuteScript(preScript,bo,ft,bomanager.getTx());
					}catch(Exception ex)
					{
						throw ex;
					}
				}
			}
		}
		
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		int r = bom.createQuery("update O set TaskState=:TaskState,EndTime=null where TaskSerialNo=:TaskSerialNo and TaskState in(:TaskState1,:TaskState2) ")
			.setParameter("TaskState", FlowHelper.TASKSTATE_RUNNING)
			.setParameter("TaskSerialNo", taskSerialNo)
			.setParameter("TaskState1", FlowHelper.TASKSTATE_FININSHED)
			.setParameter("TaskState2", FlowHelper.TASKSTATE_ARTIFICIALEND)
			.executeUpdate();
		if(r >= 1)
		{
			List<BusinessObject> frs = bomanager.loadBusinessObjects("jbo.flow.FLOW_RELATIVE", "FlowSerialNo=:FlowSerialNo",  "FlowSerialNo",ft.getString("FlowSerialNo"));
			
			String s = FlowHelper.deleteTask(taskSerialNo, frs, bomanager);
			
			if(s.startsWith("false")) return s;
			return "true@�����ջسɹ���";
		}
		else 
		{
			bomanager.rollback();
			return "false@�����ջ�ʧ�ܣ�����δ�ҵ��ñ������ñ�����״̬����ȷ��";
		}
	}

	@Override
	public String hangUpTask(String taskSerialNo, String hangUpTime,String userID,String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		int r = bom.createQuery("update O set TaskState=:TaskState where TaskSerialNo=:TaskSerialNo and TaskState in(:TaskState1) ")
			.setParameter("TaskState", FlowHelper.TASKSTATE_HANDUP)
			.setParameter("TaskSerialNo", taskSerialNo)
			.setParameter("TaskState1", FlowHelper.TASKSTATE_RUNNING)
			.executeUpdate();
		
		if(r >= 1)
		{
			return "true@�������ɹ���";
		}
		else
		{
			bomanager.rollback();
			return "false@�������ʧ�ܣ�����δ�ҵ��ñ������ñ�����״̬����ȷ��";
		}
	}
	
	@Override
	public String resumeTask(String taskSerialNo, String resumeTime,String userID,String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		int r = bom.createQuery("update O set TaskState=:TaskState where TaskSerialNo=:TaskSerialNo and TaskState in(:TaskState1) ")
			.setParameter("TaskState", FlowHelper.TASKSTATE_RUNNING)
			.setParameter("TaskSerialNo", taskSerialNo)
			.setParameter("TaskState1", FlowHelper.TASKSTATE_HANDUP)
			.executeUpdate();
		
		if(r >= 1)
		{
			return "true@����ָ��ɹ���";
		}
		else 
		{
			bomanager.rollback();
			return "false@����ָ�ʧ�ܣ�����δ�ҵ��ñ������ñ�����״̬����ȷ��";
		}
	}

	@Override
	public List<BusinessObject> queryAvyPcp(String flowSerialNo,
			String phaseNo) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", flowSerialNo);
		BusinessObject fp = FlowConfig.getFlowPhase(fi.getString("FlowNo"), fi.getString("FlowVersion"), phaseNo);
		String className = fp.getString("ParticipantScript");
		if(StringX.isEmpty(className))
			className = "com.amarsoft.app.workflow.pcp.FlowUserPcp";
		Class<?> c = Class.forName(className);
		IFlowPcp fpcp = (IFlowPcp)c.newInstance();
		return fpcp.getFlowUsers(fi,fp,bomanager);
	}

	@Override
	public String reasgnTask(String taskSerialNo,
			String reasgnUserID,String reasgnOrgID, String reason, String userID,
			String orgID) throws Exception {
		//���ʹ���ⲿ���̣��÷���������Ե������ṩ�Ľӿ�
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.flow.FLOW_TASK");
		int r = bom.createQuery("update O set UserID=:UserID,OrgID=:OrgID where TaskSerialNo=:TaskSerialNo and TaskState in(:TaskState1,:TaskState2,:TaskState3) ")
			.setParameter("UserID", reasgnUserID)
			.setParameter("OrgID", reasgnOrgID)
			.setParameter("TaskSerialNo", taskSerialNo)
			.setParameter("TaskState1", FlowHelper.TASKSTATE_AVY)
			.setParameter("TaskState2", FlowHelper.TASKSTATE_HANDUP)
			.setParameter("TaskState3", FlowHelper.TASKSTATE_RUNNING)
			.executeUpdate();
		
		if(r >= 1)
		{
			return "true@������ɳɹ���";
		}
		else 
		{
			bomanager.rollback();
			return "false@�������ʧ�ܣ�����δ�ҵ��ñ������ñ�����״̬����ȷ��";
		}
	}

	@Override
	public BusinessObject queryMultiPcsTodoTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, boolean countFlag, String userID,
			String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return FlowHelper.queryMultiPcsTask(taskContext,businessContext,startNum,pageNum,new String[]{FlowHelper.TASKSTATE_RUNNING},countFlag,userID,orgID,bomanager);
	}
	


	@Override
	public BusinessObject queryMultiPcsAvlTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, boolean countFlag, String userID,
			String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return FlowHelper.queryMultiPcsAvlTask(taskContext,businessContext,startNum,pageNum,new String[]{FlowHelper.TASKSTATE_AVY},countFlag,userID,orgID,bomanager);
	}

	@Override
	public BusinessObject queryMultiPcsFinishedTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, boolean countFlag, String userID,
			String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return FlowHelper.queryMultiPcsTask(taskContext,businessContext,startNum,pageNum,new String[]{FlowHelper.TASKSTATE_FININSHED},countFlag,userID,orgID,bomanager);
	}

	@Override
	public BusinessObject queryMultiPcsHangUpTask(
			BusinessObject taskContext, BusinessObject businessContext,
			int startNum, int pageNum, boolean countFlag, String userID,
			String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return FlowHelper.queryMultiPcsTask(taskContext,businessContext,startNum,pageNum,new String[]{FlowHelper.TASKSTATE_HANDUP},countFlag,userID,orgID,bomanager);
	}
	
	@Override
	public BusinessObject queryMultiPcsAllTask(BusinessObject taskContext,
			BusinessObject businessContext, int startNum, int pageNum,
			boolean countFlag, String userID, String orgID) throws Exception {
		//�����ⲿ���̿������̽ӿڴ��棬Ϊ�˲�Ӱ��ǰ�˵��ã��������ݽṹ��������淽���ķ��ؽṹ
		return FlowHelper.queryMultiPcsTask(taskContext,businessContext,startNum,pageNum,new String[]{FlowHelper.TASKSTATE_AVY,FlowHelper.TASKSTATE_HANDUP,FlowHelper.TASKSTATE_FININSHED,FlowHelper.TASKSTATE_RUNNING},countFlag,bomanager);
	}


	@Override
	public String deleteInstance(String flowSerialNo, String userID, String orgID) throws Exception {
		List<BusinessObject> fos = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",flowSerialNo);
		if(fos==null || fos.isEmpty()) return "true@��ҵ���Ѿ���ɾ������ˢ��ҳ�档";
		String flowObjectType = (String)BusinessObjectHelper.getMaxValue(fos,"ObjectType");
		
		String className = FlowConfig.getFlowObjectType(flowObjectType).getString("Script");
		Class<?> c = Class.forName(className);
		IData fd = (IData)c.newInstance();
		for(BusinessObject fo:fos)
		{
			fd.cancel(fo.getString("ObjectNo"), bomanager);
		}
		bomanager.deleteBusinessObjects(fos);
		
		
		//�ӿڿ��������
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", flowSerialNo);
		if(fi == null) return "true@��ҵ���Ѿ���ɾ������ˢ��ҳ�档";
		bomanager.deleteBusinessObject(fi);
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",flowSerialNo);
		bomanager.deleteBusinessObjects(fts);
		
		String businessTable = FlowConfig.getFlowCatalog(fi.getString("FlowNo"), fi.getString("FlowVersion")).getString("BusinessTable");
		List<BusinessObject> bts = bomanager.loadBusinessObjects(businessTable, "FlowSerialNo=:FlowSerialNo","FlowSerialNo",flowSerialNo);
		bomanager.deleteBusinessObjects(bts);
		
		bomanager.updateDB();
		return "true@ɾ���ɹ���";
	}


	@Override
	public String finishInstance(String flowSerialNo, String userID, String orgID) throws Exception {
		//ϵͳ�ڴ���
		List<BusinessObject> fos = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo","FlowSerialNo",flowSerialNo);
		if(fos == null || fos.isEmpty()) return "true@��ҵ���Ѿ�����ֹ����ˢ��ҳ�档";
		String flowObjectType = (String)BusinessObjectHelper.getMaxValue(fos,"ObjectType");
		
		String className = FlowConfig.getFlowObjectType(flowObjectType).getString("Script");
		Class<?> c = Class.forName(className);
		IData fd = (IData)c.newInstance();
		for(BusinessObject fo:fos)
		{
			fd.finish(fo.getString("ObjectNo"), bomanager);
		}
		
		//����ϵͳ�⴦��ӿڲ���
		BusinessObject fi = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_INSTANCE", flowSerialNo);
		if(FlowHelper.FLOWSTATE_ARTIFICIALEND.equals(fi.getString("FlowState"))) return "true@��ҵ���Ѿ�����ֹ����ˢ��ҳ�档";
		fi.setAttributeValue("FlowState", FlowHelper.FLOWSTATE_ARTIFICIALEND);
		bomanager.updateBusinessObject(fi);
		
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo and TaskState in(:TaskState)","FlowSerialNo",flowSerialNo,"TaskState",new String[]{FlowHelper.TASKSTATE_AVY,FlowHelper.TASKSTATE_HANDUP,FlowHelper.TASKSTATE_RUNNING});
		for(BusinessObject ft:fts)
		{
			ft.setAttributeValue("TaskState", FlowHelper.TASKSTATE_ARTIFICIALEND);
			bomanager.updateBusinessObject(ft);
		}
		bomanager.updateDB();
		return "true@��ֹ�ɹ���";
	}
}
