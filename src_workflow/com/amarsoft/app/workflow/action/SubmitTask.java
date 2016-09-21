package com.amarsoft.app.workflow.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 调用流程引擎提交任务并返回后继任务列表接口
 * @author 张万亮
 */
public class SubmitTask{
	private String taskSerialNo;
	private String flowSerialNo;
	private String userID;
	private String orgID;
	private String phaseOpinion;
	private String phaseUsers;
	
	
	
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



	public String getPhaseOpinion() {
		return phaseOpinion;
	}



	public void setPhaseOpinion(String phaseOpinion) {
		this.phaseOpinion = phaseOpinion;
	}



	public String getPhaseUsers() {
		return phaseUsers;
	}



	public void setPhaseUsers(String phaseUsers) {
		this.phaseUsers = phaseUsers;
	}



	public String run(JBOTransaction tx) throws Exception {
		
		if(StringX.isEmpty(phaseOpinion)) return "false@未选择下一阶段流程节点。";
		
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		
		String[] phases = phaseOpinion.split("/");
		String[] phaseUs = phaseUsers.split("#");
		for(String phase:phases)
		{
			BusinessObject phaseBO = BusinessObject.createBusinessObject("Phase");
			phaseBO.setAttributeValue("ID", phase);
			for(String phaseU:phaseUs)
			{
				if(phaseU.split(":")[0].equals(phase))
				{
					phaseBO.setAttributeValue("Count", phaseU.split(":")[1]);
					if(phaseU.split(":").length == 3)
					{
						for(String d : phaseU.split(":")[2].split("@"))
						{
							BusinessObject user = BusinessObject.createBusinessObject("jbo.sys.USER_INFO");
							user.setAttributeValue("USERID", d.split("\\$")[0]);
							user.setAttributeValue("ORGID", d.split("\\$")[1]);
							phaseBO.appendBusinessObject("jbo.sys.USER_INFO", user);
						}
					}
				}
			}
			
			ls.add(phaseBO);
		}
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		return fm.submitTask(taskSerialNo, ls, userID, orgID);
	}
	
	
}
