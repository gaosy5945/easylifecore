package com.amarsoft.app.als.assetTransfer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ProjectSubmitJudgeAsset {
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
	public String getIsAsset(JBOTransaction tx) throws JBOException{
		String flowSerialNo = (String)inputParameter.getValue("flowSerialNo");
		String sql = "select serialno from O,jbo.flow.FLOW_OBJECT fo where O.projectserialno = fo.objectno and fo.objecttype = 'jbo.prj.PRJ_BASIC_INFO' and fo.flowserialno =:flowserialno";
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.prj.PRJ_ASSET_INFO");
		tx.join(bmFO);
		BizObject boFO = bmFO.createQuery(sql)
							 .setParameter("flowSerialNo", flowSerialNo)
							 .getSingleResult(false);
		if(boFO == null){
			return "0";
		}
		return "1";
	}
}
