package com.amarsoft.app.flow.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
/**
 * 
 * @author T-zhangwl
 * 功能：判断该任务是否为影像作业
 */
public class DeterExistImage {
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

	public String Determine(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String flowSerialNo = (String)inputParameter.getValue("FlowSerialNo");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list1 = bomanager.loadBusinessObjects("jbo.flow.FLOW_MODEL", " (FlowNo,FlowVersion) in (select FO.flowno,FO.flowversion from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo =:FlowSerialNo) and O.PhaseType = '0020'", "FlowSerialNo", flowSerialNo);
		if(list1.size() > 0)
			return "true";
		else
			return "false";
	}
}
