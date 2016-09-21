package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class KeyCustomer extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		BusinessObject apply = BusinessObject.createBusinessObject(); 
		for(int i=0;i<this.getAttributes().getKeys().length;i++){
			String key = this.getAttributes().getKeys()[i].toString();
			Object value = this.getAttribute(key);
			apply.setAttributeValue(key, value);
		}
		//客户唯一性判断
		SqlObject so = new SqlObject("select CONCAT(CustomerID,'@',CustomerName,'@',CustomerType,'@',IssueCountry) as Customer from CUSTOMER_INFO where CertType = :CertType and CertID =:CertID ");
		so.setParameter("CertType", apply.getString("CertType"));
		String CertIDTemp = apply.getString("CertID");
		String CertID = CertIDTemp.replaceAll(" ", "");
		so.setParameter("CertID", CertID);
		String customer = Sqlca.getString(so);
		
		if(customer == null)  customer = "";
		
		return customer;
	}		
}
