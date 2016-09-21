package com.amarsoft.app.workflow.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class QueryFlowType {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private JBOTransaction tx;
	
	public JSONObject getInputParameter() {
		return inputParameter;
	}
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	public BusinessObjectManager getBusinessObjectManager() {
		return businessObjectManager;
	}
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
	}
	public JBOTransaction getTx() {
		return tx;
	}
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	
	/**
	 * 根据流程实例编号，取出流程的FlowType。
	 * 20150520
	 * @author bhxiao
	 * */
	public String getFlowType(JBOTransaction tx)throws Exception{
		
		String flowSerialNo = (String) inputParameter.getValue("FlowSerialNo");
		String phaseNo = (String) inputParameter.getValue("PhaseNo");
		
		BizObjectManager fo = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(fo);
		BizObjectQuery queryfo = fo.createQuery(" FlowSerialNo=:FlowSerialNo ");
		queryfo.setParameter("FlowSerialNo", flowSerialNo);
		BizObject foInfo = queryfo.getSingleResult(false);
		
		String flowNo = foInfo.getAttribute("FlowNo").toString();
		String flowVersion = foInfo.getAttribute("FlowVersion").toString();
		
		BusinessObject flowcataInfo = FlowConfig.getFlowCatalog(flowNo, flowVersion);
		String flowType = flowcataInfo.getString("FlowType");
		
		BusinessObject flowModelInfo = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo);
		String phaseType = flowModelInfo.getString("PhaseType");
		
		return flowType+"@"+phaseType;
	}
}
