package com.amarsoft.app.als.customer.partner.model;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ���Գ�ʼ���������ͻ�
 * @author Administrator
 *
 */
public class CustomerPartner{
	private BizObject bo;//CUSTOMER_PARTNER
	private JBOTransaction tx;
	private BizObjectManager bm;
	private CustomerInfo customerInfo;
	
	/**
	 * ��ʼ���������ͻ�
	 * @param customerID
	 * @param tx
	 * @throws JBOException
	 */
	public CustomerPartner(String customerID,JBOTransaction tx) throws JBOException{
		initManager();
		if(tx!=null){
			this.tx = tx;
			this.tx.join(bm);
		}
		this.customerInfo = new CustomerInfo(tx, customerID);
		BizObject ppbo = bm.createQuery("customerID=:CustomerID").setParameter("CustomerID", customerID).getSingleResult(true);
		if(ppbo==null) ppbo = bm.newObject();
		this.bo = ppbo;
	}
	
	/**
	 * ��ʼ��������
	 */
	private void initManager() throws JBOException{
		bm = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_PARTNER);
	}
	
	/**
	 * ��������
	 * @throws JBOException 
	 * 
	 */
	public void save() throws JBOException{
		bm.saveObject(bo);
	}
	/**
	 * ��ȡ�ͻ�����
	 * @return
	 * @throws JBOException
	 */
	public String getCustomerName() throws JBOException{
		return customerInfo.getAttribute("CustomerName").getString();
	}
	/**
	 * ��ȡ����������
	 * @return
	 * @throws JBOException
	 */
	
	public String getPartnerType() throws JBOException{
		return bo.getAttribute("PartnerType").getString();
	}
	/**
	 * ��ʼ��������ϵ
	 * @param tx
	 * @param bo
	 */
	public void initRelative(JBOTransaction tx , BizObject bo){
		BizObjectManager bm;
		try {
			bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_RELATIVE);
			tx.join(bm);
			
			BizObject boRelative = bm.newObject();
			boRelative.setAttributeValue("ObjectType", bo.getAttribute("ProjectType"));
			boRelative.setAttributeValue("ObjectNo", bo.getAttribute("SerialNo"));
			boRelative.setAttributeValue("AccessoryType", "Customer");
			boRelative.setAttributeValue("AccessoryNo", bo.getAttribute("CustomerID"));
			boRelative.setAttributeValue("AccessoryName", getCustomerName());
			bm.saveObject(boRelative);
		} catch (JBOException e) {
			ARE.getLog().error("������Ŀ������ϵ����");
			e.printStackTrace();
		}
	}

	public BizObject getBo() {
		return bo;
	}

	public void setBo(BizObject bo) {
		this.bo = bo;
	}
}
