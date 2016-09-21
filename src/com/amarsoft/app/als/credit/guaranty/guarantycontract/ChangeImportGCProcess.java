package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;

public class ChangeImportGCProcess extends ALSBusinessProcess 
			implements BusinessObjectOWUpdater{
	public List<BusinessObject> update(BusinessObject guarantyContract,
			ALSBusinessProcess businessProcess) throws Exception {
		this.bomanager.updateBusinessObject(guarantyContract);
		
		BusinessObject	applyRelative = guarantyContract.getBusinessObject("jbo.app.CONTRACT_RELATIVE");
		applyRelative.generateKey();
		applyRelative.setAttributeValue("ObjectType",guarantyContract.getBizClassName());
		applyRelative.setAttributeValue("ObjectNo",guarantyContract.getKeyString());
		
		this.bomanager.updateBusinessObject(applyRelative);
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyContract);
		if("Y".equals(this.asPage.getParameter("ChangeFlag"))){	
		}
		//this.bomanager.updateDB();
		return result;
	}


	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


}
