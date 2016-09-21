package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.customer.partner.model.CustomerPartner;
import com.amarsoft.app.als.sys.function.model.FunctionBizlet;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;

public class BizNewPartnerAction extends FunctionBizlet{

	@Override
	public boolean run(JBOTransaction tx, BusinessObject parameterPool)
			throws Exception {
		//保存合作方客户关联关系
		String customerID = parameterPool.getString("CustomerID");
		CustomerPartner cp = new CustomerPartner(customerID, tx);
		BizObject bo = cp.getBo();
		String boCustomerID = bo.getAttribute("CustomerID").getString();
		if(boCustomerID != null){
			this.setOutputParameter("Result", "FAIl");
			this.setOutputParameter("Message", "合作方客户已经存在");
			return true;
		}
		bo.setAttributesValue(parameterPool);
		bo.setAttributeValue("CustomerID", customerID);
		cp.save();
		this.setOutputParameter("Result", "SUCCESS");
		this.setOutputParameter("Message", "合作方客户已经存在");
		this.setOutputParameter("CustomerID", customerID);
		 //this.setMessage("SUCCESS@新增合作方客户成功!@"+customerID);
		return true;
	}

}
