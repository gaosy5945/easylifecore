package com.amarsoft.app.als.credit.approve.action;

import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 将申请基本信息及其关联信息复制到批复中
 * @author xjzhao
 *
 */
public class AddApproveInfo{
	
	private String userID;
	private String orgID;
	private String applySerialNo;
	private String taskSerialNo;
	private String phaseNo;
	private String flowSerialNo;
	
	public String getFlowSerialNo() {
		return flowSerialNo;
	}

	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}

	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getTaskSerialNo() {
		return taskSerialNo;
	}

	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}

	/**
	 * 生成批复信息并返回新批复流水
	 * @param tx
	 * @throws Exception
	 */
	public String createContract(JBOTransaction tx) throws Exception{
		//生成批复基本信息
		BizObjectManager bapm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		tx.join(bapm);
		BizObjectQuery bapq = bapm.createQuery("ApplySerialNo=:ApplySerialNo and TaskSerialNo=:TaskSerialNo");
		bapq.setParameter("ApplySerialNo", applySerialNo);
		bapq.setParameter("TaskSerialNo", taskSerialNo);
		BizObject bap = bapq.getSingleResult(false);
		if(bap == null)
		{
				BizObjectQuery bapq1 = bapm.createQuery("ApplySerialNo=:ApplySerialNo and TaskSerialNo in(select FT.TaskSerialNo from jbo.flow.FLOW_TASK FT where FT.FlowSerialNo=:FlowSerialNo "
						+ "and FT.PhaseNo not like '%doublereg_level%') order by SerialNo desc,TaskSerialNo desc");
				bapq1.setParameter("ApplySerialNo", applySerialNo);
				bapq1.setParameter("FlowSerialNo", flowSerialNo);
				bapq1.setParameter("PhaseNo", phaseNo);
				bapq1.setParameter("UserID", userID);
				BizObject bap1 = bapq1.getSingleResult(false);
				if(bap1==null)
				{
				//查询申请基本信息
				BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
				tx.join(bam);
				BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
				baq.setParameter("ApplySerialNo", applySerialNo);
				BizObject ba = baq.getSingleResult(false);
				if(ba == null ) throw new Exception("未找到对应申请信息，请检查配置信息！");
				
				bap = bapm.newObject();
				bap.setAttributesValue(ba);
				bap.setAttributeValue("SerialNo", null);
				bap.setAttributeValue("ApplySerialNo", applySerialNo);
				bap.setAttributeValue("TaskSerialNo", taskSerialNo);
				bap.setAttributeValue("InputOrgID", orgID);
				bap.setAttributeValue("InputUserID", userID);
				bap.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				bap.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				bapm.saveObject(bap);
				this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), ba.getAttribute("SerialNo").getString(), bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString());
				this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), ba.getAttribute("SerialNo").getString(), bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString());
			}
			else
			{
				bap = bapm.newObject();
				bap.setAttributesValue(bap1);
				bap.setAttributeValue("SerialNo", null);
				bap.setAttributeValue("ApplySerialNo", applySerialNo);
				bap.setAttributeValue("TaskSerialNo", taskSerialNo);
				bap.setAttributeValue("InputOrgID", orgID);
				bap.setAttributeValue("InputUserID", userID);
				bap.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				bap.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				bapm.saveObject(bap);
				this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", bap1.getBizObjectClass().getRoot().getAbsoluteName(), bap1.getAttribute("SerialNo").getString(), bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString());
				this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", bap1.getBizObjectClass().getRoot().getAbsoluteName(), bap1.getAttribute("SerialNo").getString(), bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString());
			}
		}
		return bap.getAttribute("SerialNo").getString();
	}
	
	
	
	private void copyRelative(JBOTransaction tx,String copyObject,String fromObjectType,String fromObjectNo,String toObjectType,String toObjectNo) throws Exception{
		BizObjectManager m = JBOFactory.getBizObjectManager(copyObject);
		tx.join(m);
		BizObjectQuery q = m.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo");
		q.setParameter("ObjectType", fromObjectType);
		q.setParameter("ObjectNo", fromObjectNo);
		List<BizObject> boList = q.getResultList(false);
		if(boList!=null)
		{
			for(BizObject bo:boList)
			{
				BizObject newBo = m.newObject();
				newBo.setAttributesValue(bo);
				newBo.setAttributeValue("SerialNo", null);
				newBo.setAttributeValue("ObjectType", toObjectType);
				newBo.setAttributeValue("ObjectNo", toObjectNo);
				m.saveObject(newBo);
			}
		}
	}
}
