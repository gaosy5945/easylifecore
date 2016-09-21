package com.amarsoft.app.als.afterloan.action;

import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class RiskWarningThreeSubmitDeal {
	
	private String serialNo;
	private String status;
	private String flag;  //1表示预警发起2表示预警解除

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void updateThreeWarningSubmitStatus(JBOTransaction tx) throws Exception{

		BizObjectManager  bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		BizObject boRWS = bmRWS.createQuery("SERIALNO=:SERIALNO").setParameter("SerialNo", serialNo).getSingleResult(true);
		boRWS.setAttributeValue("status", status);
		boRWS.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
		bmRWS.saveObject(boRWS);
	}
	
	public void updateCustomerInfoCSTLevel(JBOTransaction tx) throws JBOException{
		
			JBOTransaction txNew = null;
			txNew = JBOFactory.createJBOTransaction();
		
			BizObjectManager  bmTemp = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
			BizObject boTemp = bmTemp.createQuery("SignalSerialNo=:SerialNo and ObjectType='jbo.acct.ACCT_LOAN' ").setParameter("SerialNo", serialNo).getSingleResult(false);
			String ObjectNo = boTemp.getAttribute("ObjectNo").getString();
			
			BizObjectManager  bmAL = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
			BizObject boAL = bmAL.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ObjectNo).getSingleResult(false);
			String CustomerID = boAL.getAttribute("CustomerID").getString();
			
			BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL", txNew);
			BizObjectQuery boq = bom.createQuery("select SignalLevel from O,jbo.al.RISK_WARNING_OBJECT RWO WHERE RWO.OBJECTNO in (select AL.SerialNo from jbo.acct.ACCT_LOAN AL where AL.CustomerID='"+CustomerID+"') AND RWO.ObjectType='jbo.acct.ACCT_LOAN' and RWO.SignalSerialNo=O.SerialNo and O.Status='3' and SignalLevel is not null order by SignalLevel");
			List<BizObject> SignalLevelList = boq.getResultList(false);
			String SignalLevel = "";
			int temp = 6 ;
			
			if(SignalLevelList != null && !SignalLevelList.isEmpty()){
				for(BizObject SignalLevelObject:SignalLevelList){
					if(temp>Integer.parseInt(SignalLevelObject.getAttribute("SignalLevel").getString()))
						temp = Integer.parseInt(SignalLevelObject.getAttribute("SignalLevel").getString());
					if(temp == 1) break;
				}
			}else{
				BizObjectManager  bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
				BizObject boRWS = bmRWS.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo).getSingleResult(false);
				SignalLevel = boRWS.getAttribute("SignalLevel").getString();
				if("2".equals(flag)) SignalLevel = "";
			}
			if(temp != 6){
				SignalLevel = String.valueOf(temp);
			}
			
			
			BizObjectManager bmCI = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boCI = bmCI.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID).getSingleResult(true);
			boCI.setAttributeValue("CSTRiskLevel", SignalLevel);
			bmCI.saveObject(boCI);
	}
	
	public void updateRWSStatus(JBOTransaction tx) throws JBOException{
		//更新原纪录中status
		BizObjectManager bmRWO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
		BizObject botemp = bmRWO.createQuery("SIGNALSERIALNO=:SIGNALSERIALNO and ObjectType='jbo.al.RISK_WARNING_SIGNAL'").setParameter("SIGNALSERIALNO",serialNo ).getSingleResult(true);
		String ObjectNo = botemp.getAttribute("OBJECTNO").toString();
		
		BizObjectManager bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
		BizObject bo = bmRWS.createQuery("SERIALNO=:SERIALNO").setParameter("SerialNo",ObjectNo ).getSingleResult(true);
		bo.setAttributeValue("STATUS", "5");
		bmRWS.saveObject(bo);
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
