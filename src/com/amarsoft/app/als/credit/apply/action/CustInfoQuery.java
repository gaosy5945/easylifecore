package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.action.CreateCustomerInfo;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class CustInfoQuery {
	private JSONObject inputParameter;
	private String BirthDay = "";
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

	public String getCertInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		return this.getCertInfo(customerID);
	}
	
	public String getCertInfo(String customerID) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject cust = bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerID);
		if(cust == null) throw new Exception("客户"+customerID+"未找到！");
		String certType = cust.getString("CertType");
		if(certType == null) certType="";
		String certID = cust.getString("CertID");
		if(certID == null) certID="";
		String customerName = cust.getString("CustomerName");
		if(customerName == null) customerName="";
		String sReturn = certType+"@"+certID+"@"+customerName;
		return "true@"+sReturn;
	}
	
	public String addCustomer(JBOTransaction tx) throws Exception{
		this.tx=tx;
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String certType = (String)inputParameter.getValue("CertType");
		String certIDTemp = (String)inputParameter.getValue("CertID");
		String customerName = (String)inputParameter.getValue("CustomerName");
		String orgID = (String)inputParameter.getValue("OrgID");
		String userID = (String)inputParameter.getValue("UserID");
		String certID = certIDTemp.replace(" ", "");
		
		return this.addCustomer(certType,certID,customerName,orgID,userID);
	}
	
	public String addCustomer(String certType,String certID,String customerName,String orgID,String userID) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		certID = certID.replace(" ", "");
		List<BusinessObject> boList = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", "CertType=:CertType and CertID=:CertID", "CertType",certType,"CertID",certID);
		if(boList != null && boList.size() > 0) {
			String customerid = boList.get(0).getString("CustomerID");
			CreateCustomerInfo CCI = new CreateCustomerInfo();
			String result = "SUCCEED";
			CCI.SelectCustomerBelong(customerid, orgID, userID, DateHelper.getBusinessDate(), tx);
			return result;
		}else{
			BusinessObject ci = BusinessObject.createBusinessObject("jbo.customer.CUSTOMER_INFO");
			ci.setAttributeValue("CustomerName", customerName);
			ci.setAttributeValue("CertType", certType);
			ci.setAttributeValue("CertID", certID);
			ci.setAttributeValue("IssueCountry", "CHN");
			ci.setAttributeValue("InputOrgID", orgID);
			ci.setAttributeValue("InputUserID", userID);
			ci.setAttributeValue("InputDate", DateHelper.getBusinessDate());
			ci.setAttributeValue("Status", "02");
			ci.generateKey();
			String customerID = "PL"+ci.getKeyString();
			ci.setAttributeValue("CustomerID", customerID);
			
			if("1".equals(certType) || "6".equals(certType) || "C".equals(certType)){
				int certIDLength = certID.length();
				if(certIDLength == 18){
					String BirthDayTemp = certID.substring(6,14);
					BirthDay = BirthDayTemp.substring(0, 4)+"/"+BirthDayTemp.substring(4, 6)+"/"+BirthDayTemp.substring(6, 8);
				}else{
					String BirthDayTemp = "19"+certID.substring(6, 12);
					BirthDay = BirthDayTemp.substring(0, 4)+"/"+BirthDayTemp.substring(4, 6)+"/"+BirthDayTemp.substring(6, 8);
	
				}
			}
			
			if(certType.length() == 1){
				BusinessObject ii = BusinessObject.createBusinessObject("jbo.customer.IND_INFO");
				ii.setAttributeValue("CustomerID", customerID);
				ii.setAttributeValue("BirthDay", BirthDay);
				ii.setAttributeValue("Country", "CHN");
				ii.setAttributeValue("InputOrgID", ci.getString("InputOrgID"));
				ii.setAttributeValue("InputUserID", ci.getString("InputUserID"));
				ii.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				this.businessObjectManager.updateBusinessObject(ii);
				
				BusinessObject CD = BusinessObject.createBusinessObject("jbo.customer.CUSTOMER_IDENTITY");
				CD.setAttributeValue("CustomerID", customerID);
				CD.setAttributeValue("CertType", ci.getString("CertType"));
				CD.setAttributeValue("CertID", ci.getString("CertID"));
				CD.setAttributeValue("IssueCountry", "CHN");
				CD.setAttributeValue("InputOrgID", ci.getString("InputOrgID"));
				CD.setAttributeValue("InputUserID", ci.getString("InputUserID"));
				CD.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				this.businessObjectManager.updateBusinessObject(CD);
				
				CreateCustomerInfo CCI = new CreateCustomerInfo();
				CCI.SelectCustomerBelong(customerID, ci.getString("InputOrgID"), ci.getString("InputUserID"), DateHelper.getBusinessDate(), tx);
				
				//ECIFInstance.queryCustomer(customerID, ci.getString("CertType"), ci.getString("CertID"), customerName, tx);
				
				ci.setAttributeValue("CustomerType", "03");
			}else if(certType.length() == 4){
				BusinessObject ei = BusinessObject.createBusinessObject("jbo.customer.ENT_INFO");
				ei.setAttributeValue("CustomerID", customerID);
				ei.setAttributeValue("InputOrgID", ci.getString("InputOrgID"));
				ei.setAttributeValue("InputUserID", ci.getString("InputUserID"));
				ei.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				this.businessObjectManager.updateBusinessObject(ei);
				
				BusinessObject CD = BusinessObject.createBusinessObject("jbo.customer.CUSTOMER_IDENTITY");
				CD.setAttributeValue("CustomerID", customerID);
				CD.setAttributeValue("CertType", ci.getString("CertType"));
				CD.setAttributeValue("CertID", ci.getString("CertID"));
				CD.setAttributeValue("IssueCountry", "CHN");
				CD.setAttributeValue("InputOrgID", ci.getString("InputOrgID"));
				CD.setAttributeValue("InputUserID", ci.getString("InputUserID"));
				CD.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				this.businessObjectManager.updateBusinessObject(CD);
				
				CreateCustomerInfo CCI = new CreateCustomerInfo();
				CCI.SelectCustomerBelong(customerID, ci.getString("InputOrgID"), ci.getString("InputUserID"), DateHelper.getBusinessDate(), tx);
				
				if("2020".equals(certType)){
					//ECIFInstance.queryEntCustomer(customerID, ci.getString("CertID"), customerName, tx);
				}
				
				ci.setAttributeValue("CustomerType", "01");
			}else{throw new Exception("客户证件类型"+certType+"不存在");}
			
			this.businessObjectManager.updateBusinessObject(ci);
			
			this.businessObjectManager.updateDB();
			return "true@"+customerID;
	}
	}
}