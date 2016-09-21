package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ClassifyAdjustInfo {
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getFlowSerialNo(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(bom);
		BizObjectQuery bq = bom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		bq.setParameter("ObjectNo", this.serialNo);
		bq.setParameter("ObjectType", "jbo.al.CLASSIFY_RECORD");
		BizObject bo = bq.getSingleResult(false); 
		if(bo == null ) return "false";

		return bo.getAttribute("FlowSerialNo").toString();		
	}

}
