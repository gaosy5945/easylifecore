package com.amarsoft.app.als.customer.common.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

public class EntCustomerBasicInfoProcess extends ALSBusinessProcess implements BusinessObjectOWUpdater{
	
	public List<BusinessObject> update(BusinessObject ba, ALSBusinessProcess businessProcess) throws Exception {
		String serialNo=ba.getKeyString();
		if(StringX.isEmpty(serialNo)){
			ba.generateKey();
		}
		this.bomanager.updateBusinessObject(ba);
		
		//保存customer_info表
		BusinessObject CI = ba.getBusinessObject("jbo.customer.CUSTOMER_INFO");
		String customerID = ba.getString("CustomerID");
		String customerNameTemp = ba.getString("CustomerName"); 
		//去掉录入客户姓名时出现的空格
		String customerName = customerNameTemp.trim();
		CI.setAttributeValue("CustomerName", customerName);
		
		this.bomanager.updateBusinessObject(CI);
		
		//个人客户姓名修改，同步更新所有涉及客户姓名字段的表
		CustomerNameChange CNC = new CustomerNameChange();
		CNC.changeEntCustomerName(customerID, customerName, this.bomanager.getTx());
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
}
