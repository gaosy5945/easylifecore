package com.amarsoft.app.als.afterloan.action;

import java.sql.SQLException;

import org.apache.commons.lang.StringUtils;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskGetIsWarning {

	//参数
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
		//三色预警详情页面 是否预警字段	
	public String getIsWarning(JBOTransaction tx) throws JBOException{
		
		String isWarning ="";
		String flowSerialNo = (String)inputParameter.getValue("FlowSerialNo");
		String sql = "select IsWarning from O,jbo.flow.FLOW_OBJECT fo where O.serialno = fo.objectno and fo.objecttype = 'jbo.al.RISK_WARNING_SIGNAL' and fo.flowserialno =:flowserialno";
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		BizObject boFO = bmFO.createQuery(sql)
							 .setParameter("flowSerialNo", flowSerialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			isWarning = boFO.getAttribute("IsWarning").getString();
		}
		return isWarning;
	}
	//获取预警解除原因字段信息
	public String getDenyReason(JBOTransaction tx) throws JBOException{
		String flag = "0";
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		BizObject boFO = bmFO.createQuery("SerialNo=:SerialNo")
				 .setParameter("SerialNo", serialNo)
				 .getSingleResult(false);
		if(boFO != null){
			String denyReason = boFO.getAttribute("DENYREASON").getString();
			if(StringUtils.isBlank(denyReason)){
				flag = "0";
			}else{
				flag = "1";
			}
		}
		return flag;
	}
}
