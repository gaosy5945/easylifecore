package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �ͻ���У�������
 * @author Administrator
 *
 */
public class CustomerOperate {
	/**
	 * У��ͻ��Ƿ���ڡ������Ѿ��Ǻ������ͻ�
	 * ���ص�һ������ Ϊ 1 ʱ �Ѿ��Ǻ������ͻ� 2 ʱ ���Ѿ����ڵĶԹ��ͻ� 3 ʱ �����ڴ˿ͻ�
	 * @return
	 * @throws JBOException
	 */
	public String customerAction() throws JBOException{
		
		String returnValue = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
		BizObjectManager bmc = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_PARTNER);
		BizObject bo = bm.createQuery("certtype=:CertType and certID=:CertID").setParameter("CertType", certType)
		.setParameter("CertID", certID).getSingleResult(false);
		if(bo!=null){
			//�ͻ�����
			BizObject boc = bmc.createQuery("Customerid=:customerid")
							.setParameter("customerid", bo.getAttribute("CustomerID").getString())
							.getSingleResult(false);
			if(boc!=null){
				//����������
				returnValue = "1@";
			}else{
				//�ͻ����� ������������������
				BizObjectManager bme = JBOFactory.getBizObjectManager(CustomerConst.ENT_INFO);
				BizObject entbo = bme.createQuery("Customerid=:customerid")
				.setParameter("customerid", bo.getAttribute("CustomerID").getString())
				.getSingleResult(false);
				returnValue = "2@"+entbo.getAttribute("OrgNature").getString()+"@"
					+ bo.getAttribute("CustomerID").getString() + "@"
					+ bo.getAttribute("CustomerName").getString() + "@"
					+ bo.getAttribute("CustomerType").getString();
			}
		}else{
			//�¿ͻ�
			returnValue = "3@";
		}
		return returnValue;
	}
	
	public String removePartner() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_INFO);
		BizObject bo = bm.createQuery("" +
				"customerid=:customerID ")
				.setParameter("customerID", customerID)
				.getSingleResult(false);
		if(bo!=null) return "2";//�Ѿ����ڴ˹���
		
		BizObjectManager bmc = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_PARTNER);
		bmc.createQuery("delete from o where customerid =:customerid").setParameter("customerid", customerID)
			.executeUpdate();	
		return "1";
	}
	public String getCertID() {
		return certID;
	}
	public void setCertID(String certID) {
		this.certID = certID;
	}
	public String getCertType() {
		return certType;
	}
	public void setCertType(String certType) {
		this.certType = certType;
	}
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	private String certID;
	private String certType;
	private String customerID;
}
