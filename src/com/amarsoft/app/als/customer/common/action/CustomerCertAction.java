package com.amarsoft.app.als.customer.common.action;

import java.util.HashMap;

import com.amarsoft.app.als.customer.model.CustomerCert;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * �ͻ�����ģ��-�ͻ�֤������
 * @author lyin 20140418
 *
 */
public class CustomerCertAction{
	private String customerID;
	private String certType;
	private String certID;
	private String issueCountry;
	private String status;
	private String idExpiry;
	private String cnidRegCity;
	private String userID;
	private String orgID;
	private String serialNo;
	private String customerCertFlag;
	
	/**
	 * ���֤���Ƿ��ظ�
	 * @return
	 * @throws Exception 
	 */
	public String checkCert(JBOTransaction tx) throws Exception{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IDENTITY);
		tx.join(bom);
		int iResult = bom.createQuery("CertType=:certType and CertID=:certID and IssueCountry=:issueCountry ")
						.setParameter("certType", certType).setParameter("certID", certID).setParameter("issueCountry", issueCountry).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	/**
	 * ���֤����Ϣ
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public CustomerInfo getCustomerInfo(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IDENTITY);
		tx.join(bom);
		BizObject boResult = bom.createQuery("CertType=:certType and CertID=:certID and IssueCountry=:issueCountry ")
							   .setParameter("certType", certType).setParameter("certID", certID).setParameter("issueCountry", issueCountry).getSingleResult(true);
		String customerId="";
		if(boResult!=null){
			customerId=boResult.getAttribute("CustomerID").getString();
			CustomerInfo ci=new CustomerInfo(tx,customerId);
			return ci;
		}else{
			CustomerInfo ci=new CustomerInfo(tx,this.issueCountry,this.certType,this.certID);
			return ci;
		}
	}
	
	/**
	 * �����ͻ�֤��
	 * @return
	 * @throws Exception 
	 */
	public String addCustomerCert(JBOTransaction tx) throws Exception{
		//���֮ǰ�����͵�֤���Ƿ�Ϊ��֤��
		String checkResult = checkCustomerCert(tx);		
		
	   //������֤��ǰ����֮ǰ�����͵�֤����Ϊ��Ч�����֮ǰ�����͵�֤��Ϊ��֤���򽫸�֤������Ϊ����֤�������������ĸ�����֤������Ϊ��֤��������ֻ����֤��״̬Ϊ��Ч��Update��֤�����ͱ�����½���֤������һ�£�
	   BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_IDENTITY);
	   tx.join(m);
	   BizObjectQuery bq = m.createQuery("update O set Status=:status,CustomerCertFlag=:customerCertFlag where CustomerID=:customerID and CertType=:certType");
	   bq.setParameter("customerID",customerID).setParameter("certType", certType).
	   setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_2).
	   setParameter("customerCertFlag", "true".equals(checkResult)?CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2:CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
	   bq.executeUpdate();	
	   
	   CustomerCert cc = new CustomerCert(tx,"");
	   //����֤����Ϣ
	   HashMap<String,String> map = new HashMap<String,String>();
	   map.put("CUSTOMERID", customerID);
	   map.put("CERTTYPE", certType);
	   map.put("CERTID", certID);
	   map.put("ISSUECOUNTRY", issueCountry);
	   map.put("IDEXPIRY", idExpiry);
	   map.put("CNIDREGCITY", cnidRegCity);
	   map.put("INPUTUSERID",userID);
	   map.put("INPUTORGID",orgID);
	   map.put("INPUTDATE",DateHelper.getBusinessDate());
	   map.put("STATUS",CustomerConst.CUSTOMER_IDENTITY_STATUS_1);
	   map.put("CUSTOMERCERTFLAG", "true".equals(checkResult)?CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1:CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
       
	   cc.newCustomerCert(map);

	   //���¿ͻ���Ϣ��
	   if("true".equals(checkResult)){
		   updateCustomerInfo(tx,customerID,certID,certType);
	   }
	   return "true";
	}
	
	/**
	 * ����֤����������Ч֤�����Ƿ�����֤��
	 * @return
	 * @throws Exception 
	 */
	public String checkCustomerCert(JBOTransaction tx) throws Exception{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IDENTITY);
		tx.join(bom);
		int iResult = bom.createQuery("CustomerID=:customerID and CertType=:certType and Status=:status and CustomerCertFlag=:customerCertFlag ")
						.setParameter("customerID", customerID).setParameter("certType", certType).
						setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1).setParameter("customerCertFlag", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	
	
	/**
	 * ��ѡ��֤������Ϊ��֤��
	 * @return
	 * @throws Exception 
	 */
	public String setMainCert(JBOTransaction tx) throws Exception{
	   BizObjectManager bm = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_IDENTITY);
	   tx.join(bm);
	   BizObjectQuery bq1 = bm.createQuery("update O set CustomerCertFlag=:customerCertFlag where CustomerID=:customerID and CustomerCertFlag='1' ");
	   bq1.setParameter("customerID",customerID).setParameter("customerCertFlag", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
	   bq1.executeUpdate();
       
	   BizObjectQuery bq2 = bm.createQuery("update O set CustomerCertFlag=:customerCertFlag where SerialNo=:serialNo ");
	   bq2.setParameter("serialNo",serialNo).setParameter("customerCertFlag", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1);
	   bq2.executeUpdate();
	   
	   //���¿ͻ���Ϣ��
	   updateCustomerInfo(tx,customerID,certID,certType);
	   return "true";
	}

	/**
	 * ����Customer_Info���֤�����ͺ�֤�����
	 * @return
	 * @throws Exception 
	 */
	public void updateCustomerInfo(JBOTransaction tx,String customerID,String certID,String certType) throws Exception{
		CustomerInfo ci = new CustomerInfo(tx,customerID);
		ci.setAttribute("CertType", certType);
		ci.setAttribute("CertID", certID);
		ci.saveObject();
	}
	
	/**
	 * ����Ѵ��ڸ�����֤��״̬
	 * @return
	 * @throws Exception 
	 */
	public String existCertStatus(JBOTransaction tx) throws Exception{
	   //��������֤���Ƿ��Ѵ�����Ч��֤��
	   String result = "false";
	   String customerCertFlag = "";
	   BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_IDENTITY);
	   tx.join(m);
	   BizObject bo = m.createQuery("CustomerID=:customerID and CertType=:certType and Status=:status ")
				.setParameter("customerID", customerID).setParameter("certType", certType).
				setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1).getSingleResult(false);
	  if(bo!=null){
		  customerCertFlag=bo.getAttribute("CustomerCertFlag").getString();
		  if(CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1.equals(customerCertFlag)){
			  result = "true_1";
		  }else{
			  result = "true_2";
		  }
	  }
	  return result;
	}
	
	/**
	 * ����֤��״̬��Ч
	 * @return
	 * @throws Exception 
	 */
	public String updateCertStatus(JBOTransaction tx) throws Exception{
	   BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_IDENTITY);
	   tx.join(m);
	   BizObjectQuery bq = m.createQuery("update O set Status=:status,CustomerCertFlag=:customerCertFlag where CustomerID=:customerID and CertType=:certType");
	   bq.setParameter("customerID",customerID).setParameter("certType", certType).
	   setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_2).
	   setParameter("customerCertFlag", "1".equals(customerCertFlag)?CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2:CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
	   bq.executeUpdate();	
	   
	   BizObjectQuery bq1 = m.createQuery("update O set Status=:status,CustomerCertFlag=:customerCertFlag where SerialNo=:serialNo");
	   bq1.setParameter("customerID",customerID).setParameter("serialNo", serialNo).
	   setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1).
	   setParameter("customerCertFlag", "1".equals(customerCertFlag)?CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1:CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
	   bq1.executeUpdate();	
	   
	   //���¿ͻ���Ϣ��
	   if("1".equals(customerCertFlag)){
		   updateCustomerInfo(tx,customerID,certID,certType);
	   }
	   
	   return "true";
	}
	
	/**
	 * ����֤��״̬ʧЧ
	 * @return
	 * @throws Exception 
	 */
	public String setCertStatus(JBOTransaction tx) throws Exception{
	   CustomerCert cc = new CustomerCert(tx,serialNo);
	   cc.setAttribute("Status", CustomerConst.CUSTOMER_IDENTITY_STATUS_2);
	   cc.saveObject();
	   return "true";
	}
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCertID() {
		return certID;
	}

	public void setCertID(String certID) {
		this.certID = certID;
	}

	public String getIssueCountry() {
		return issueCountry;
	}

	public void setIssueCountry(String issueCountry) {
		this.issueCountry = issueCountry;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getIdExpiry() {
		return idExpiry;
	}

	public void setIdExpiry(String idExpiry) {
		this.idExpiry = idExpiry;
	}

	public String getCnidRegCity() {
		return cnidRegCity;
	}

	public void setCnidRegCity(String cnidRegCity) {
		this.cnidRegCity = cnidRegCity;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getMainFlag() {
		return customerCertFlag;
	}

	public void setMainFlag(String customerCertFlag) {
		this.customerCertFlag = customerCertFlag;
	}
	
	
	
}