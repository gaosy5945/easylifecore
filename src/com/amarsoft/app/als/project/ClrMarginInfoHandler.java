package com.amarsoft.app.als.project;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;

public class ClrMarginInfoHandler extends ALSBusinessProcess
implements BusinessObjectOWUpdater{
	public List<BusinessObject> update(BusinessObject clrMarginInfo,ALSBusinessProcess businessProcess) throws Exception {
		//�ж�����clr_margin_info���������Ǹ���
		clrMarginInfo.generateKey();
		String clrMarginInfoSerialNo=clrMarginInfo.getKeyString();
		this.bomanager.updateBusinessObject(clrMarginInfo);
		
		//����clr_margin_wasteBook��
		BusinessObject acountInfo = clrMarginInfo.getBusinessObject("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		acountInfo.generateKey();
		acountInfo.setAttributeValue("ObjectType", "jbo.guaranty.CLR_MARGIN_INFO");
		acountInfo.setAttributeValue("ObjectNo", clrMarginInfoSerialNo);
		this.bomanager.updateBusinessObject(acountInfo);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(clrMarginInfo);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}
}
