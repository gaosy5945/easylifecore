package com.amarsoft.app.als.customer.model;

import java.util.HashMap;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * 客户联系电话对象
 * <li>包含客户联系电话的基本信息
 * @author 
 *
 */
public class CustomerTel {

	private BizObjectManager bm;
	private BizObject boCustomerTel;

	/**
	 * 初始化客户联系电话
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	
	public CustomerTel(JBOTransaction tx,String serialNo) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TEL);
		if(tx!=null){
			tx.join(bm);
		}
		if(serialNo!=null){
			boCustomerTel=bm.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(tx!=null);
		}else{
			
		}
	}
	
	public CustomerTel(JBOTransaction tx,String customerID,String telType) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TEL);
		if(tx!=null){
			tx.join(bm);
		}
		boCustomerTel=bm.createQuery("CustomerID=:customerID and TelType=:telType and IsNew='1'")
					.setParameter("customerID", customerID).setParameter("telType", telType).getSingleResult(tx!=null);
	}
	
	/**
	 * 新增客户联系电话
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	public void newCustomerTel(HashMap<String,String> map) throws JBOException{
		if(boCustomerTel==null){
			boCustomerTel = bm.newObject();
			boCustomerTel.setAttributesValue(map);
			bm.saveObject(boCustomerTel);
			
		}
	}
	
	/**
	 * 获得客户联系电话对象
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerTel;
	}
	
	/**
	 * 获得客户联系电话表属性
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerTel.getAttribute(attributeIndex);
	}
	
	/**
	 * 设置数据
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerTel.setAttributeValue(attributeName, value);
		
	}

	/**
	 * 保存客户联系电话信息
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerTel);
	}

}
