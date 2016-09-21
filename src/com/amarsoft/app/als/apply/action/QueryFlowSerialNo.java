package com.amarsoft.app.als.apply.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class QueryFlowSerialNo {
private JSONObject inputParameter;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	public String queryFlowSerialNo(JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(bm);
		String ApplySerialNo = (String)inputParameter.getValue("ApplySerialNo");
		BizObject fo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.app.BUSINESS_APPLY'").setParameter("ObjectNo",ApplySerialNo).getSingleResult(true);
		String FlowSerialNo = "";
		if(fo != null){
			FlowSerialNo = fo.getAttribute("FlowSerialNo").toString();
		}
		return FlowSerialNo;
	}
}
