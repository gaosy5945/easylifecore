package com.amarsoft.app.als.customer.partner.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * @author ckxu
 * 描述：这个类用于建立合作运营商和协议之间的关联关系(用途专一),2016年1月12日
 * 
 * */
public class ProjectCommProvider {
	private String customerID;
	private String prjSerialNo;
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	public String getPrjSerialNo() {
		return prjSerialNo;
	}
	public void setPrjSerialNo(String prjSerialNo) {
		this.prjSerialNo = prjSerialNo;
	}
	public String establishProjectCommRela(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE", tx);
		//判断当前的项目和引入的运营商之间的关联关是是否存在，然后再加入关联关系
		@SuppressWarnings("unchecked")
		List<BizObject> list = bom.createQuery("RelativeType = '06' and ProjectSerialNo=:prjSerialNo and ObjectType='jbo.customer.CUSTOMER_INFO' and ObjectNo=:objectNo")
		.setParameter("prjSerialNo", prjSerialNo)
		.setParameter("objectNo", customerID)
		.getResultList(false);
		if(list==null || list.isEmpty()){
			BizObject bo = bom.newObject();
			bo.setAttributeValue("ProjectSerialNo", prjSerialNo);
			bo.setAttributeValue("ObjectNo", customerID);
			bo.setAttributeValue("ObjectType", "jbo.customer.CUSTOMER_INFO");
			bo.setAttributeValue("RelativeType", "06");
			bom.saveObject(bo);
			return "true";
		}
		return "false";
	}
}
