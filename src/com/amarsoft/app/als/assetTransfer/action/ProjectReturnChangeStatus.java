package com.amarsoft.app.als.assetTransfer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ProjectReturnChangeStatus {
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
	public String updateStatus(JBOTransaction tx) throws JBOException{
		String flowSerialNo = (String)inputParameter.getValue("flowSerialNo");
		String phaseOpinion = (String)inputParameter.getValue("PhaseOpinion");
		String sql = "select O.objectno from O where O.objecttype = 'jbo.prj.PRJ_BASIC_INFO' and O.flowserialno =:flowserialno";
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT");
		tx.join(bmFO);
		BizObject boFO = bmFO.createQuery(sql)
							 .setParameter("flowSerialNo", flowSerialNo)
							 .getSingleResult(false);
		String projectStatus = "";
		if("accept".equals(phaseOpinion)){
			projectStatus = "01";
		}else if("investigate_branch".equals(phaseOpinion) || "investigate_level1".equals(phaseOpinion)){
			projectStatus = "0201";
		}
		if(boFO == null){
			return "0";
		}else{
			JBOFactory.getFactory().getManager("jbo.prj.PRJ_BASIC_INFO")
			.createQuery("update O set O.status = :projectStatus where serialno = :SerialNo")
			.setParameter("projectStatus", projectStatus)
			.setParameter("SerialNo", boFO.getAttribute("objectno").getString())
			.executeUpdate();
			return "1";
		}
	}
}
