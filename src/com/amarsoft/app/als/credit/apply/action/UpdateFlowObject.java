package com.amarsoft.app.als.credit.apply.action;


import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 当退回到扫秒岗时清空FLOW_OBJECT中的TREEDATA字段
 * @author 张万亮
 *
 */
public class UpdateFlowObject{
	
	private String flowSerialNo;
	
	public String getFlowSerialNo() {
		return flowSerialNo;
	}

	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}

	public String update(JBOTransaction tx) throws Exception{
		//根据FlowSerialNo清空FLOW_OBJECT的TREEDATA字段
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(bam);
		bam.createQuery("UPDATE O SET TREEDATA = '' WHERE FlowSerialNo = :FlowSerialNo")
		.setParameter("FlowSerialNo", flowSerialNo).executeUpdate();
		return "true";
	}
}
	

