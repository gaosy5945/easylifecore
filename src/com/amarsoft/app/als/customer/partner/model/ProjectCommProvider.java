package com.amarsoft.app.als.customer.partner.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * @author ckxu
 * ��������������ڽ���������Ӫ�̺�Э��֮��Ĺ�����ϵ(��;רһ),2016��1��12��
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
		//�жϵ�ǰ����Ŀ���������Ӫ��֮��Ĺ��������Ƿ���ڣ�Ȼ���ټ��������ϵ
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
