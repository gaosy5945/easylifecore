package com.amarsoft.app.als.customer.model;

import java.util.HashMap;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * �ͻ���ϵ��ַ����
 * <li>�����ͻ���ϵ��ַ�Ļ�����Ϣ
 * @author 
 *
 */
public class CustomerAddress {

	private BizObjectManager bm;
	private BizObject boCustomerAddress;

	/**
	 * ��ʼ���ͻ���ϵ��ַ
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	
	public CustomerAddress(JBOTransaction tx,String serialNo) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_ADDRESS);
		if(tx!=null){
			tx.join(bm);
		}
		if(serialNo!=null){
			boCustomerAddress=bm.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(tx!=null);
		}else{
			
		}
	}
	
	public CustomerAddress(JBOTransaction tx,String customerID,String addType) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_ADDRESS);
		if(tx!=null){
			tx.join(bm);
		}
		if("".equals(addType)){//���ÿͻ���ϵ��ַ���Ƿ���ͨѶ��ַ
			boCustomerAddress=bm.createQuery("ObjectNo=:customerID and ObjectType='jbo.app.PUB_ADDRESS_INFO'")
					.setParameter("customerID", customerID).getSingleResult(tx!=null);
		}else{//���ÿͻ���ϵ��ַ���Ƿ�������µĸ����͵�ַ
			boCustomerAddress=bm.createQuery("ObjectNo=:customerID and IsNew='1' and addressType=:addressType")
					.setParameter("customerID", customerID).setParameter("addressType", addType).getSingleResult(tx!=null);
		}

	}
	
	
	/**
	 * �����ͻ���ϵ��ַ
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	public void newCustomerAddress(HashMap<String,String> map) throws JBOException{
		if(boCustomerAddress==null){
			boCustomerAddress = bm.newObject();
			boCustomerAddress.setAttributesValue(map);
			bm.saveObject(boCustomerAddress);
			
		}
	}
	
	/**
	 * ��ÿͻ���ϵ��ַ����
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerAddress;
	}
	
	/**
	 * ��ÿͻ���ϵ��ַ������
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerAddress.getAttribute(attributeIndex);
	}
	
	/**
	 * ��������
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerAddress.setAttributeValue(attributeName, value);
		
	}

	/**
	 * ����ͻ���ϵ��ַ��Ϣ
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerAddress);
	}

}
