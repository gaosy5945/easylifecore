package com.amarsoft.app.lending.bizlets;
/*
Author: --�����Ŷ� 2015-12-09
Tester:
Describe: --���ɶ������Ƿ��޸�
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
*/

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCustomerName{
	private String customerName;
	private String certID;
	
	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCertID() {
		return certID;
	}

	public void setCertID(String certID) {
		this.certID = certID;
	}

	public String  checkCustomerName(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bom);
		//�Զ���ô���Ĳ���ֵ
		if(customerName == null) customerName = "";
		if(certID == null) certID = "";
		String flag = "";//���ر�־
		
		String sSql = " select CustomerName from O where CertID =:CertID ";
		BizObjectQuery boq = bom.createQuery(sSql).setParameter("CertID", certID);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = boq.getResultList(false);
		String existCustomerName = (bos!=null)?bos.get(0).getAttribute("CustomerName").getString():"";
		
		if(existCustomerName.equals(""))
			flag = "Only";
		else{
			flag = existCustomerName.equals(customerName)?"Only":"Many";
		}
		return flag;
	}
}
