package com.amarsoft.app.als.afterloan.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskWarningPointBackView {

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
		
	public String getFlowPar(JBOTransaction tx) throws JBOException{
		
		String flowSerialNo ="";
		String serialNo = (String)inputParameter.getValue("SerialNo");
		
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT");
		BizObject boFO = bmFO.createQuery("OBJECTNO =:OBJECTNO")
							 .setParameter("OBJECTNO", serialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			 flowSerialNo = boFO.getAttribute("FLOWSERIALNO").getString();
		}
		
		return flowSerialNo;
	}
}
