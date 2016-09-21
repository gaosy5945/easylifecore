package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --�����鱨���Ƿ�����
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
Modify: ���� 2015/12/10
*/

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;


public class CheckLoanCardNo 
{
	private String customerName;
	private String loanCardNo;
	
	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getLoanCardNo() {
		return loanCardNo;
	}

	public void setLoanCardNo(String loanCardNo) {
		this.loanCardNo = loanCardNo;
	}

	public String  checkLoanCardNo(JBOTransaction tx) throws Exception{
		//�Զ���ô���Ĳ���ֵ
 		if(customerName == null) customerName = "";
		if(loanCardNo == null) loanCardNo = "";
		
		//���ر�־
		String flag = "";
		String existCustomerName ="";
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO", tx)
		.createQuery("select CustomerID from O " +
				"where  substr(LoanCardNo,1,16) = '"+loanCardNo.substring(0,16)+"' ");
		@SuppressWarnings("unchecked")
		List<BizObject> bos=query.getResultList(false);
		 
		if(bos!=null && bos.size()>0){
			existCustomerName = bos.get(0).getAttribute("CustomerID").toString();
		}
 
		if(existCustomerName == null) existCustomerName = "";
		
		if(existCustomerName.equals(""))
			flag = "Only";
		else
			flag =existCustomerName.equals(customerName)?"Only":"Many";
		
		return flag;
	}
}
