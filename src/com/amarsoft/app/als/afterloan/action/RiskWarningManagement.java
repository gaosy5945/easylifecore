package com.amarsoft.app.als.afterloan.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class RiskWarningManagement {
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
	//获取预警解除 的原预警信号编号
	public String getYRiskSerialNo(JBOTransaction tx) throws JBOException{
		
		String ySerialNo ="";
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
		BizObject boFO = bmFO.createQuery("SignalSerialNo =:SignalSerialNo and ObjectType = 'jbo.al.RISK_WARNING_SIGNAL'")
							 .setParameter("SignalSerialNo", serialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			ySerialNo = boFO.getAttribute("ObjectNo").getString();
		}
		return ySerialNo;
	}
	
	//获取预警处理措施
	public String getDealMethod(JBOTransaction tx) throws JBOException{
		
		String dealMethod ="";
		String flowSerialNo = (String)inputParameter.getValue("FlowSerialNo");
		String sql = "select DealMethod from o,jbo.flow.FLOW_OBJECT fo where fo.ObjectNo = o.serialNo and fo.ObjectType = 'jbo.al.RISK_WARNING_SIGNAL' and "
				   + " fo.flowSerialNo =:flowSerialNo";
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		BizObject boFO = bmFO.createQuery(sql)
							 .setParameter("flowSerialNo", flowSerialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			dealMethod = boFO.getAttribute("DealMethod").getString();
		}
		return dealMethod;
	}
	
	//获取Business_contract 表的 检查频率
	public String getCheckFrequency(JBOTransaction tx) throws JBOException{
		
		String checkFrequency ="";
		String flowSerialNo = (String)inputParameter.getValue("FlowSerialNo");
		String sql = "select o.checkfrequency from o,jbo.app.BUSINESS_DUEBILL bd,jbo.al.RISK_WARNING_OBJECT rwo,jbo.flow.FLOW_OBJECT fo where "
				   + " rwo.ObjectType = 'jbo.app.BUSINESS_DUEBILL' and fo.objecttype = 'jbo.al.RISK_WARNING_SIGNAL' and fo.objectno = rwo.signalserialno and "
				   + " rwo.ObjectNo = bd.SerialNo and bd.ContractSerialno = o.Serialno and fo.flowserialno =:flowserialno";
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject boFO = bmFO.createQuery(sql)
							 .setParameter("flowSerialNo", flowSerialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			checkFrequency = boFO.getAttribute("CheckFrequency").getString();
		}else{
			checkFrequency="";
		}
		return checkFrequency;
	}
	
	//通过Risk_Warning_Signal流水号获取 Flow_Object 的  flowSerialNo
	public String getFlowSerialNo(JBOTransaction tx) throws JBOException{
		
		String flowSerialNo ="";
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT");
		BizObject boFO = bmFO.createQuery("objectType = 'jbo.al.RISK_WARNING_SIGNAL' and objectNo =:objectNo")
							 .setParameter("objectNo", serialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			flowSerialNo = boFO.getAttribute("FlowSerialNo").getString();
		}
		return flowSerialNo;
	}

	//通过Risk_Warning_Signal流水号获取 Acct_Loan 的  PutoutSerialNo
	public String getPutoutSerialNo(JBOTransaction tx) throws JBOException{
		
		String putoutSerialNo ="";
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
		BizObject boFO = bmFO.createQuery(" O.serialno in (select RWO.ObjectNo from jbo.al.RISK_WARNING_OBJECT RWO where RWO.ObjectType = 'jbo.acct.ACCT_LOAN' and RWO.SignalSerialNo =:SignalSerialNo) ")
							 .setParameter("SignalSerialNo", serialNo)
							 .getSingleResult(false);
		if(boFO != null){
			
			putoutSerialNo = boFO.getAttribute("PutoutSerialNo").getString();
		}
		return putoutSerialNo;
	}
}
