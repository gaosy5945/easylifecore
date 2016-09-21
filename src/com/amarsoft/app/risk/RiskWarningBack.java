package com.amarsoft.app.risk;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskWarningBack {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx){
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager){
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public void updateAfterDoFlag(JBOTransaction tx) throws JBOException{
		
		String flowSerialNo = (String)inputParameter.getValue("FLOWSERIALNO");
		String taskSerialNo = (String)inputParameter.getValue("TASKSERIALNO");
		
		BizObjectManager bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		
		String sql = " select * from o,jbo.flow.FLOW_OBJECT fo where o.serialno = fo.objectno and "
				   + " fo.objecttype = 'jbo.al.RISK_WARNING_SIGNAL01' and fo.flowserialno =:flowSerialNo ";
		BizObject boRWS = bmRWS.createQuery(sql)
							   .setParameter("flowserialno", flowSerialNo)
							   .setParameter("taskSerialNo", taskSerialNo)
							   .getSingleResult(true);
		if(boRWS != null){
			
			boRWS.setAttributeValue("AFTERDOFLAG", "2");
			bmRWS.saveObject(boRWS);
		}
	}
}
