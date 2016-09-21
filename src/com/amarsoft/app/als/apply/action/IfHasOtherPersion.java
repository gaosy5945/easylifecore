package com.amarsoft.app.als.apply.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.interdata.IData;
import com.amarsoft.app.workflow.processdata.GetCurOrgAuthorize;
import com.amarsoft.app.workflow.processdata.GetCurUserAuthorize;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 判断本机构是否存在其他有权审批人
 * @author 张万亮
 */
public class IfHasOtherPersion{
	private String taskSerialNo;
	private String flowSerialNo;
	private String phaseNo;
	private String userID;
	private String orgID;
	
	
	
	public String getTaskSerialNo() {
		return taskSerialNo;
	}



	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}



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



	public String run(JBOTransaction tx) throws Exception {
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo", "FlowSerialNo",flowSerialNo).get(0);
		BusinessObject ft = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_TASK", taskSerialNo);
		//获取业务对象
		String className = FlowConfig.getFlowObjectType(fo.getString("ObjectType")).getString("Script");//获取取数逻辑
		Class<?> c = Class.forName(className);
		IData data = (IData)c.newInstance();
		
		List<BusinessObject> boList = data.getFlowObjects(fo.getString("ObjectType"), bomanager, "FlowSerialNo",flowSerialNo);
		for(BusinessObject bo:boList)
		{
			data.transfer(bo);
		}
		BusinessObject para = BusinessObject.createBusinessObject();
		String phaseActionType = "",phaseAction = "",phaseAction1 = "",phaseAction2 = "";
		if(ft != null ){
			para.setAttributes(ft);
			para.setAttributes(fo);
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
		}
		para.setAttributeValue("CurUserID", userID);
		para.setAttributeValue("CurOrgID", orgID);
		para.setAttributeValue("PhaseActionType", phaseActionType);
		para.setAttributeValue("PhaseAction", phaseAction);
		para.setAttributeValue("PhaseAction1", phaseAction1);
		para.setAttributeValue("PhaseAction2", phaseAction2);

		GetCurUserAuthorize bb = new GetCurUserAuthorize();
		String bs = bb.process(boList, bomanager, "", "1", para);
		String ss = "0";
		if("0".equals(bs)){
			GetCurOrgAuthorize aa = new GetCurOrgAuthorize();
			ss = aa.process(boList, bomanager, "", "1", para);
		}
		String approveModel="";
		String approveTaskSerialNo = "";
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo = :FlowSerialNo and PhaseNo in(:PhaseNo)  order by TaskSerialNo desc", "FlowSerialNo",flowSerialNo,"PhaseNo",FlowHelper.getFlowPhase(FlowConfig.getFlowCatalog(fo.getString("FlowNo"), fo.getString("FlowVersion")).getString("FlowType"), "0050").split(","));
		
		if(!fts.isEmpty())
		{
			approveTaskSerialNo = fts.get(0).getString("TaskSerialNo");
			String phaseActionrr = fts.get(0).getString("PhaseAction");
			if(phaseActionrr != null && !"".equals(phaseActionrr))
			{
				Item itemrr = CodeCache.getItem("BPMPhaseAction", phaseActionrr);
				approveModel = itemrr.getAttribute1();
			}
		}
		String flag = "";
		if(("03".equals(approveModel) || "04".equals(approveModel) || "05".equals(approveModel)))
		{
			List<BusinessObject> ftts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "select count(1) as v.cnt from O where FlowSerialNo = :FlowSerialNo and PhaseNo in(:PhaseNo) and TaskSerialNo > :ApproveTaskSerialNo and TaskSerialNo<>:TaskSerialNo", "FlowSerialNo",flowSerialNo,"ApproveTaskSerialNo", approveTaskSerialNo,"TaskSerialNo", taskSerialNo,"PhaseNo",FlowHelper.getFlowPhase(FlowConfig.getFlowCatalog(fo.getString("FlowNo"), fo.getString("FlowVersion")).getString("FlowType"), "0060").split(","));
			if(ftts.isEmpty())
			{
				int cnt = ftts.get(0).getInt("cnt");
				if(cnt < 1) flag = "1";
			}
		}
		return ss+"@"+flag;
		
	}
}
