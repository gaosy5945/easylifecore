package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-03
Tester:
Describe: --检查调查报告是否生成
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
Output Param:

HistoryLog:
Modify: 核算 2015/12/10
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
		//自动获得传入的参数值
 		if(customerName == null) customerName = "";
		if(loanCardNo == null) loanCardNo = "";
		
		//返回标志
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
