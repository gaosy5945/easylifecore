package com.amarsoft.app.workflow.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;


/**
 * 判断该任务是否签署意见
 * @author 张万亮
 */
public class CheckOpinion{
	private String flowSerialNo;
	private String taskSerialNo;
	private String phaseNo;
	
	
	
	public String getFlowSerialNo() {
		return flowSerialNo;
	}



	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}



	public String getTaskSerialNo() {
		return taskSerialNo;
	}



	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}



	public String getPhaseNo() {
		return phaseNo;
	}



	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}



	public String run(JBOTransaction tx) throws Exception {
		boolean flag = true;
		
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo", "FlowSerialNo",flowSerialNo).get(0);
		
		String op = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), phaseNo).getString("OpnTemplateNo");
		if(!StringX.isEmpty(op)){
			BusinessObject ft = bomanager.keyLoadBusinessObject("jbo.flow.FLOW_TASK",  taskSerialNo);
			if(!StringX.isEmpty(ft.getString("UpdateTime"))){
				flag = true;
			}else{
				flag = false;
			}
		}else{
			flag = true;
		}
		if(flag){
			return "true";
		}else{
			return "false";
		}
	}
}
