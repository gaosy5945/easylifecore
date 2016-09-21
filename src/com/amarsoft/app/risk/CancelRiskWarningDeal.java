package com.amarsoft.app.risk;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CancelRiskWarningDeal{
	
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
	
	public void deleteRWO(JBOTransaction tx) throws JBOException{
		
		String serialNo = (String)inputParameter.getValue("SerialNo");
		
		BizObjectManager bmRWO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
		bmRWO.createQuery("delete from O  where signalserialno =:signalserialno")
			.setParameter("signalserialno", serialNo)
			.executeUpdate();
	}
}
