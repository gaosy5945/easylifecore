package com.amarsoft.app.als.customer.model;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;

/**
 * �ͻ�֤������
 * <li>�����ͻ�֤���Ļ�����Ϣ
 * @author 
 *
 */
public class CustomerCert {

	private BizObjectManager bm;
	private BizObject boCustomerCert;

	/**
	 * ��ʼ���ͻ�֤��
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	
	public CustomerCert(JBOTransaction tx,String serialNo) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IDENTITY);
		if(tx!=null){
			tx.join(bm);
		}
		if(!StringX.isEmpty(serialNo)){
			boCustomerCert=bm.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(tx!=null);
		}
	}
	
	/**
	 * �����ͻ�֤��
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	public void newCustomerCert(Map<String, String> map) throws JBOException{
		if(boCustomerCert==null){
			boCustomerCert = bm.newObject();
			boCustomerCert.setAttributesValue(map);
			bm.saveObject(boCustomerCert);
			
		}
	}
	
	/**
	 * ��ÿͻ�֤������
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerCert;
	}
	
	/**
	 * ��ÿͻ�֤��������
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerCert.getAttribute(attributeIndex);
	}
	
	/**
	 * ��������
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerCert.setAttributeValue(attributeName, value);
		
	}

	/**
	 * ����ͻ�֤����Ϣ
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerCert);
	}

}
