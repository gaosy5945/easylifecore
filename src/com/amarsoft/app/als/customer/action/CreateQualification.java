package com.amarsoft.app.als.customer.action;
/**
 * @柳显涛
 * 资质信息中向CUSTOMER_CERTIFICATE中新增数据，更新ENT_INFO和CUSTOMER_LIST的相关字段
 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CreateQualification {
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
	public void AddQualification(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		String wbCrtCustomer = (String)inputParameter.getValue("wbCrtCustomer");
		String certName = (String)inputParameter.getValue("certName");
		String certType = (String)inputParameter.getValue("certType");
		String validDate = (String)inputParameter.getValue("validDate");
		String listType = (String)inputParameter.getValue("listType");
		String remark = (String)inputParameter.getValue("remark");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputDate = (String)inputParameter.getValue("InputDate");
		
		CreateCustomerCertificate(customerID,certName,certType,validDate,inputOrgID,inputUserID,inputDate);
		UpdateCustomerEntInfo(customerID,wbCrtCustomer);
		UpdateCustomerList(customerID,listType,remark);

	}
	public String CreateCustomerCertificate(String customerID,String certName,String certType,String validDate,String inputOrgID,String inputUserID,String inputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_CERTIFICATE");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CUSTOMERID", customerID);
		bo.setAttributeValue("CERTNAME", certName);
		bo.setAttributeValue("CERTTYPE", certType);
		bo.setAttributeValue("VALIDDATE", validDate);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTDATE", inputDate);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
	public String UpdateCustomerEntInfo(String customerID,String wbCrtCustomer) throws Exception {
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
		tx.join(bm);
		
		bm.createQuery("update O set WBCRTCUSTOMER=:wbCrtCustomer,UPDATEDATE=:updateDate Where customerID=:customerID")
		  .setParameter("wbCrtCustomer", wbCrtCustomer).setParameter("updateDate", DateHelper.getBusinessDate()).setParameter("customerID", customerID).executeUpdate();

		return "SUCCEED";
	}
	public String UpdateCustomerList(String customerID,String listType,String remark) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(bm);
		
		bm.createQuery("update O set LISTTYPE=:listType,REMARK=:remark,UPDATEDATE=:updateDate Where customerID=:customerID")
		  .setParameter("listType", listType).setParameter("remark", remark).setParameter("updateDate", DateHelper.getBusinessDate()).setParameter("customerID", customerID).executeUpdate();

		return "SUCCEED";
	}	
	
	public void UpdateQualification(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		String wbCrtCustomer = (String)inputParameter.getValue("wbCrtCustomer");
		String certName = (String)inputParameter.getValue("certName");
		String certType = (String)inputParameter.getValue("certType");
		String validDate = (String)inputParameter.getValue("validDate");
		String listType = (String)inputParameter.getValue("listType");
		String remark = (String)inputParameter.getValue("remark");
		
		UpdateCustomerEntInfo(customerID,wbCrtCustomer);
		UpdateCustomerList(customerID,listType,remark);
		UpdateCustomerCertificate(customerID,certName,certType,validDate);

	}
	public String UpdateCustomerCertificate(String customerID,String certName,String certType,String validDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_CERTIFICATE");
		tx.join(bm);
		
		bm.createQuery("update O set CERTNAME=:certName ,CERTTYPE=:certType, VALIDDATE=:validDate Where customerID=:customerID")
		  .setParameter("certName", certName).setParameter("certType", certType).setParameter("validDate", validDate).setParameter("customerID", customerID)
		  .executeUpdate();

		return "SUCCEED";
	}

	
	
	
}
