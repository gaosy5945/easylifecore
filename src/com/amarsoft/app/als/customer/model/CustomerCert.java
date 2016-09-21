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
 * 客户证件对象
 * <li>包含客户证件的基本信息
 * @author 
 *
 */
public class CustomerCert {

	private BizObjectManager bm;
	private BizObject boCustomerCert;

	/**
	 * 初始化客户证件
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
	 * 新增客户证件
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
	 * 获得客户证件对象
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerCert;
	}
	
	/**
	 * 获得客户证件表属性
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerCert.getAttribute(attributeIndex);
	}
	
	/**
	 * 设置数据
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerCert.setAttributeValue(attributeName, value);
		
	}

	/**
	 * 保存客户证件信息
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerCert);
	}

}
