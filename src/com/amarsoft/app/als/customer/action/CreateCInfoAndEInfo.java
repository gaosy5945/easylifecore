package com.amarsoft.app.als.customer.action;

/**
 * 1、对CUSTOMER_INFO表进行新增操作，并返回生成的customerid
 * 2、将CI返回的customerid赋值给ENT_INFO，并作新增操作
 * 3、返回customerid给校验客户证件编号页面
 * @author 柳显涛
 *
 */

import java.util.HashMap;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CreateCInfoAndEInfo {
	private JSONObject inputParameter;
	private HashMap<String , Object> data;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setData(HashMap<String , Object> map){
		this.data = map;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public String CreateCustomerAddInfo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String customerName = (String)data.get("CustomerName");
		String countryCode = (String)data.get("CountryCode");
		String certID = (String)data.get("CertID");
		String certType = (String)data.get("CertType");
		String inputOrgID = (String)data.get("InputOrgID");
		String inputUserID = (String)data.get("InputUserID");
		String inputDate = (String)data.get("InputDate");	
		String customerID = CreateCustomerAddCInfo(customerName,countryCode,certID,certType,inputOrgID,inputUserID,inputDate,tx);
		CreateCustomerInfo createCB = new CreateCustomerInfo();
		createCB.CreateCustomerCertInfo(customerID, certID, certType, countryCode, inputOrgID, inputUserID, inputDate, tx);
		CreateCustomerAddEInfo(customerID,inputOrgID,inputUserID,inputDate,tx);
		//ECIFInstance.queryEntCustomer(customerID, certID, customerName, tx);
		
		return "true@"+customerID+"@"+customerName;
	}
	public String CreateCustomerAddCInfo(String customerName,String countryCode,String certID,String certType,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERNAME", customerName);
		bo.setAttributeValue("ISSUECOUNTRY", countryCode);
		bo.setAttributeValue("CERTID", certID);
		bo.setAttributeValue("CUSTOMERTYPE", "01");
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		bo.setAttributeValue("STATUS", "02");
		bm.saveObject(bo);
		bo.setAttributeValue("CustomerID", "PL"+bo.getAttribute("CustomerID").getString());
		bm.saveObject(bo);
		
		String customerid = bo.getAttribute("CustomerID").toString();
		return customerid;
	}
	public String CreateCustomerAddEInfo(String customerID,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
}
