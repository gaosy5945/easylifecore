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
		//ȥ��¼��ͻ�����ʱ���ֵĿո�
		String customerName = customerNameTemp.trim();
		String engNameTemp = ba.getString("EnglishName");
		String englishName = engNameTemp.toUpperCase();
		
		this.bomanager.updateBusinessObject(ba);

		// ����customer_info��
		BusinessObject CI = ba
				.getBusinessObject("jbo.customer.CUSTOMER_INFO");
		CI.setAttributeValue("ENGLISHNAME", englishName);
		CI.setAttributeValue("CUSTOMERNAME",customerName);
		this.bomanager.updateBusinessObject(CI);
		this.bomanager.updateDB();
		
		//���˿ͻ������޸ģ�ͬ�����������漰�ͻ������ֶεı�
		CustomerNameChange CNC = new CustomerNameChange();
		CNC.changeIndCustomerName(customerID, customerName, this.bomanager.getTx());
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ba);
		// �޸Ŀͻ���Ϣʱ,�����޸Ľӿ�
		String flag = "1";
		//ECIFAlterInstance.queryAlterECIFCustomer(customerID, certType, certID,customerName, flag, this.bomanager.getTx());
		// ����С΢רӪ��ʶ�ӿ�
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
