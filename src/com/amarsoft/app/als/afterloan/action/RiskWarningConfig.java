package com.amarsoft.app.als.afterloan.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskWarningConfig {

	//²ÎÊý
		private JSONObject inputParameter;

		private BusinessObjectManager businessObjectManager;
		
		public void setInputParameter(JSONObject inputParameter) {
			this.inputParameter = inputParameter;
		}
		
		private JBOTransaction tx;

		public void setTx(JBOTransaction tx) {
			this.tx = tx;
		}
		
		public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
			this.businessObjectManager = businessObjectManager;
			this.tx = businessObjectManager.getTx();
		}
		
		private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
			if(businessObjectManager==null)
				businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
			return businessObjectManager;
		}
		
	public void setConfigStatus(JBOTransaction tx) throws JBOException{
		
		String signalID = (String)inputParameter.getValue("SignalID");
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_CONFIG");
		BizObject boFO = bmFO.createQuery("SIGNALID=:SIGNALID")
							 .setParameter("SIGNALID", signalID)
							 .getSingleResult(true);
		if(boFO != null){
			
			boFO.setAttributeValue("STATUS", 0);
			bmFO.saveObject(boFO);
		}
	}
}
