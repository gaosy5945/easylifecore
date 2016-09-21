package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ChangeApplicant {
	private JSONObject inputParameter;

	private BizObjectManager bizObjectManager;

	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public BizObjectManager getBizObjectManager() throws JBOException, SQLException{
		return bizObjectManager;
	}

	public void setBizObjectManager(BizObjectManager bizObjectManager) {
		this.bizObjectManager = bizObjectManager;
	}

	public String changeApplicantInfo(JBOTransaction tx) throws Exception{
		try{
			if("true".equals(copyApplicantInfo(tx)))
				return this.insertApplicantInfo(tx);
			else
				return "false";
		}
		catch(Exception ex){
			if(tx != null) tx.rollback();
			throw ex;
		}	
	}
	
	public String copyApplicantInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		String transSerialNo = (String)inputParameter.getValue("TransSerialNo");
		return this.copyApplicantInfo(objectType, objectNo, transSerialNo);
	}
	
	public String copyApplicantInfo(String objectType,String objectNo,String transSerialNo) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
		tx.join(bom);	
		BizObjectQuery boq = bom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		boq.setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType);
		
		List<BizObject> boList = boq.getResultList(false);
		if(boList!=null)
		{
			for(BizObject bo:boList)
			{				
				BizObjectQuery bq = bom.createQuery("ObjectNo=:ObjectNo and APPLICANTID=:ApplicantId and ObjectType='jbo.acct.ACCT_TRANSACTION'");
				bq.setParameter("ObjectNo", transSerialNo).setParameter("ApplicantId", bo.getAttribute("APPLICANTID").getString());
				BizObject boo = bq.getSingleResult(false);
				if (boo !=null) {
					continue;
				}
				BizObject bo1 = bom.newObject();
				BizObject bo2 = bom.newObject();
				bo1.setAttributesValue(bo);
				bo2.setAttributesValue(bo);
				bo1.setAttributeValue("SerialNo", null);
				bo2.setAttributeValue("SerialNo", null);
				bo1.setAttributeValue("ObjectType", "jbo.acct.ACCT_TRANSACTION");
				bo2.setAttributeValue("ObjectType", "jbo.acct.ACCT_TRANSACTION");
				bo1.setAttributeValue("ObjectNo", transSerialNo);
				bo2.setAttributeValue("ObjectNo", transSerialNo);
				
				bo1.setAttributeValue("STATUS", "03");
				bo2.setAttributeValue("STATUS", "01");
				bo1.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
				bo2.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
				
				bom.saveObject(bo1);
				bom.saveObject(bo2);
			}
		}	
		return "true";
	}
	public String insertApplicantInfo(JBOTransaction tx) throws Exception{

		this.tx=tx;
		String transSerialNo = (String)inputParameter.getValue("TransSerialNo");
		String customerId = (String)inputParameter.getValue("CustomerId");
		String customerName = (String)inputParameter.getValue("CustomerName");
		String userId = (String)inputParameter.getValue("UserId");
		String orgId = (String)inputParameter.getValue("OrgId");
		
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
		tx.join(bom);
		BizObject ba = bom.newObject();
		ba.setAttributeValue("ObjectType","jbo.acct.ACCT_TRANSACTION");
		ba.setAttributeValue("ObjectNo", transSerialNo);
		ba.setAttributeValue("APPLICANTID",customerId);
		ba.setAttributeValue("APPLICANTNAME",customerName);
		ba.setAttributeValue("INPUTORGID",orgId);
		ba.setAttributeValue("INPUTUSERID",userId);
		ba.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("STATUS", "01");
		bom.saveObject(ba);		
		return "true";
	}
}
