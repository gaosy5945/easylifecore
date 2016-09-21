package com.amarsoft.app.als.credit.apply.action;


import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ���˻ص�ɨ���ʱ���FLOW_OBJECT�е�TREEDATA�ֶ�
 * @author ������
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
		//����FlowSerialNo���FLOW_OBJECT��TREEDATA�ֶ�
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(bam);
		bam.createQuery("UPDATE O SET TREEDATA = '' WHERE FlowSerialNo = :FlowSerialNo")
		.setParameter("FlowSerialNo", flowSerialNo).executeUpdate();
		return "true";
	}
}
	

