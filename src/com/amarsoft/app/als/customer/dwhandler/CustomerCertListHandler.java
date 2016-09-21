package com.amarsoft.app.als.customer.dwhandler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CustomerCertListHandler extends CommonHandler{

	public String checkResult="";
	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("InputUserID",curUser.getUserID());
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());
		bo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("Status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1);
	}
	
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("UpdateUserID",curUser.getUserID());
		bo.setAttributeValue("UpdateOrgID", curUser.getOrgID());
		bo.setAttributeValue("UpdateDate",DateHelper.getBusinessDate());
	}
	
	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		String customerID = bo.getAttribute("CustomerID").toString();
		String certType = bo.getAttribute("certType").toString();
		checkResult = checkCustomerCert(tx,customerID,certType);
	    
		//������֤��ǰ����֮ǰ�����͵�֤����Ϊ��Ч�����֮ǰ�����͵�֤��Ϊ��֤���򽫸�֤������Ϊ����֤�������������ĸ�����֤������Ϊ��֤��������ֻ����֤��״̬Ϊ��Ч��Update��֤�����ͱ�����½���֤������һ�£�
	    BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_IDENTITY);
	    tx.join(m);
	    BizObjectQuery bq = m.createQuery("update O set Status=:status,CustomerCertFlag=:CustomerCertFlag where CustomerID=:customerID and CertType=:certType");
	    bq.setParameter("customerID",customerID).setParameter("certType", certType).
	    setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_2).
	    setParameter("customerCertFlag", "true".equals(checkResult)?CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2:CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_2);
	    bq.executeUpdate();			
	}
	
	 /**
	  * �統ǰ֤������Ϊ��֤�������������Customer_Info���֤�����ͺ�֤�����
	  */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {	    
	    if("true".equals(checkResult)){
			String customerID = bo.getAttribute("CustomerID").toString();
			String certType = bo.getAttribute("certType").toString();
			String certID = bo.getAttribute("CertID").toString();
			CustomerInfo ci = new CustomerInfo(tx,customerID);
			ci.setAttribute("CertType", certType);
			ci.setAttribute("CertID", certID);
			ci.saveObject();
		   }	    
		
	}
	
	/**
	 * ����֤����������Ч֤�����Ƿ�����֤��
	 * @return
	 * @throws Exception 
	 */
	public String checkCustomerCert(JBOTransaction tx,String customerID,String certType) throws Exception{
		String result = "false";
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IDENTITY);
		tx.join(bom);
		int iResult = bom.createQuery("CustomerID=:customerID and CertType=:certType and Status=:status and CustomerCertFlag=:customerCertFlag ")
						.setParameter("customerID", customerID).setParameter("certType", certType).
						setParameter("status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1).setParameter("customerCertFlag", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
}
