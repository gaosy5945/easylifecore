package com.amarsoft.app.als.customer.common.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

public class IndCustomerBasicInfoProcess extends ALSBusinessProcess implements
		BusinessObjectOWUpdater {

	public List<BusinessObject> update(BusinessObject ba,
			ALSBusinessProcess businessProcess) throws Exception {
		String customerID = ba.getKeyString();
		String certType = ba.getString("CertType");
		String certID = ba.getString("CertID");
		String customerNameTemp = ba.getString("CustomerName");
		//去掉录入客户姓名时出现的空格
		String customerName = customerNameTemp.trim();
		String engNameTemp = ba.getString("EnglishName");
		String englishName = engNameTemp.toUpperCase();
		
		this.bomanager.updateBusinessObject(ba);

		// 保存customer_info表
		BusinessObject CI = ba
				.getBusinessObject("jbo.customer.CUSTOMER_INFO");
		CI.setAttributeValue("ENGLISHNAME", englishName);
		CI.setAttributeValue("CUSTOMERNAME",customerName);
		this.bomanager.updateBusinessObject(CI);
		this.bomanager.updateDB();
		
		//个人客户姓名修改，同步更新所有涉及客户姓名字段的表
		CustomerNameChange CNC = new CustomerNameChange();
		CNC.changeIndCustomerName(customerID, customerName, this.bomanager.getTx());
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		// 修改客户信息时,调用修改接口
		String flag = "1";
		//ECIFAlterInstance.queryAlterECIFCustomer(customerID, certType, certID,customerName, flag, this.bomanager.getTx());
		// 调用小微专营标识接口
		try{
			//SMInstance.queryAlterSMCustomer(customerID, this.bomanager.getTx());
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
