package com.amarsoft.app.als.customer.model;

import java.util.HashMap;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * 客户联系地址对象
 * <li>包含客户联系地址的基本信息
 * @author 
 *
 */
public class CustomerAddress {

	private BizObjectManager bm;
	private BizObject boCustomerAddress;

	/**
	 * 初始化客户联系地址
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
		if("".equals(addType)){//检查该客户联系地址中是否有通讯地址
			boCustomerAddress=bm.createQuery("ObjectNo=:customerID and ObjectType='jbo.app.PUB_ADDRESS_INFO'")
					.setParameter("customerID", customerID).getSingleResult(tx!=null);
		}else{//检查该客户联系地址中是否存在最新的该类型地址
			boCustomerAddress=bm.createQuery("ObjectNo=:customerID and IsNew='1' and addressType=:addressType")
					.setParameter("customerID", customerID).setParameter("addressType", addType).getSingleResult(tx!=null);
		}

	}
	
	
	/**
	 * 新增客户联系地址
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
	 * 获得客户联系地址对象
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerAddress;
	}
	
	/**
	 * 获得客户联系地址表属性
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerAddress.getAttribute(attributeIndex);
	}
	
	/**
	 * 设置数据
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerAddress.setAttributeValue(attributeName, value);
		
	}

	/**
	 * 保存客户联系地址信息
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerAddress);
	}

}
